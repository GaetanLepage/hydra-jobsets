let
  defaults = {
    enabled = 1;
    hidden = false;
    checkinterval = 1800;
    schedulingshares = 1;

    # Number of past eval results to keep.
    # The older ones will be garbage collected.
    keepnr = 500;
    emailoverride = "";
    nixexprinput = "jobsets";
  };

  mkJobset =
    {
      description,
      cudaSupport ? "false",
    }:
    defaults
    // {
      inherit description;
      nixexprpath = "./jobsets.nix";

      inputs = {
        jobsets = {
          type = "git";
          value = "https://github.com/GaetanLepage/hydra-jobsets";
        };

        nixpkgs = {
          type = "git";
          value = "https://github.com/NixOS/nixpkgs.git master";
        };

        cudaSupport = {
          type = "string";
          value = cudaSupport;
        };
      };
    };

  projects = {
    gaetan-jobsets = builtins.mapAttrs (_: mkJobset) {
      normal = {
        description = "Packages without CUDA support";
      };
      cuda = {
        description = "Packages with CUDA support";
        cudaSupport = "true";
      };
    };
  };
in
projects
