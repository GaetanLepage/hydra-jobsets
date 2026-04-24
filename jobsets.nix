{
  nixpkgs,

  supportedSystems ? [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ],
  # The system evaluating this expression
  currentSystem ? builtins.currentSystem or "x86_64-linux",

  # Hydra passes inputs as strings; parse to boolean
  cudaSupport ? "false",
  ...
}@args:
let
  ##########################################################
  # STEP 1: Initialize release-lib
  ##########################################################

  lib = import "${nixpkgs}/lib";

  nixpkgsConfig = {
    allowUnfree = true;
    cudaSupport = cudaSupport == "true";
    inHydra = true;

    # Don't evaluate duplicate and/or deprecated attributes
    allowAliases = false;
  };

  # Attributes passed to nixpkgs.
  nixpkgsArgs = {
    config = nixpkgsConfig;
    __allowFileset = false;
  };

  mkReleaseLib = import "${nixpkgs}/pkgs/top-level/release-lib.nix";

  release-lib = mkReleaseLib (
    {
      inherit supportedSystems nixpkgsArgs;
      system = currentSystem;
    }
    // lib.intersectAttrs (lib.functionArgs mkReleaseLib) args
  );

  ##########################################################
  # STEP 2: Compute the set of attrpaths to include in the jobset
  ##########################################################

  packages = import ./packages.nix;

  extractRawJobs =
    _packages: prefix:
    lib.concatMapAttrs (
      pname: systems:
      map (system: {
        inherit system;
        path = (lib.optional (prefix != null) prefix) ++ [ pname ];
      }) systems
    ) _packages;

  rawJobs =
    (extractRawJobs packages.topLevel null)
    ++ (extractRawJobs packages.python "python313Packages")
    ++ (extractRawJobs packages.python "python314Packages");

  ##########################################################
  # STEP 3: Build the jobset that will be consumed by Hydra
  ##########################################################

  # Map to:
  #
  # allPackagePlatforms = {
  #   python3Packages.torch = [ "x86_64-linux" "aarch64-linux" ];
  #   python3Packages.foo = [ "x86_64-linux" ];
  #   python3Packages.bar = [ "aarch64-linux" ];
  #   cool = [ "x86_64-linux" "aarch64-linux" ];
  # }
  #
  # thanks to some nix magic by @MattSturgeon (thanks!)

  groupEntries =
    entries:
    lib.pipe entries [
      (lib.groupBy (entry: lib.head entry.path))
      (lib.mapAttrs (_: map (entry: entry // { path = lib.tail entry.path; })))
    ];

  entriesToAttrSet =
    entries:
    lib.mapAttrs (
      _: entries:
      let
        byLeaf = lib.partition (entry: entry.path == [ ]) entries;
      in
      if byLeaf.wrong == [ ] then
        # leaf node
        lib.catAttrs "system" entries
      else if byLeaf.right == [ ] then
        # recursive
        entriesToAttrSet entries
      else
        throw "Conflicting attr paths:${lib.concatMapStrings (entry: "\n- ${entry.path}") entries}"
    ) (groupEntries entries);

  allPackagePlatforms = entriesToAttrSet rawJobs;

  jobs = release-lib.mapTestOn allPackagePlatforms;
in
jobs
