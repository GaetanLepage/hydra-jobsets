let
  linuxSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
  darwinSystem = [ "aarch64-darwin" ];
  allSystems = linuxSystems ++ darwinSystem;
in
{
  topLevel = {
    uv = allSystems;
    zed-editor = linuxSystems;
    nixl = linuxSystems;
    exo = allSystems;
    mujoco = allSystems;
  };

  python = {
    jax = allSystems;
    lineax = allSystems;

    torch = allSystems;
    torchaudio = allSystems;
    torchvision = allSystems;
    executorch = allSystems;

    tinygrad = allSystems;
    dm-control = allSystems;

    fastexcel = allSystems;
  };
}
