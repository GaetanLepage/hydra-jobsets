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
    ruff = allSystems;
    ty = allSystems;

    zed-editor = linuxSystems;
    neovim = allSystems;

    nixl = linuxSystems;
    exo = allSystems;
    mujoco = allSystems;
  };

  python = {
    torch = allSystems;
    torchaudio = allSystems;
    torchvision = allSystems;
    executorch = allSystems;

    jax = allSystems;
    equinox = allSystems;
    lineax = allSystems;

    tinygrad = allSystems;
    dm-control = allSystems;

    fastexcel = allSystems;
    lancedb = allSystems;

    wandb = allSystems;

    deep-gemm = linuxSystems;
    deep-ep = linuxSystems;
    nixl = linuxSystems;
    xformers = linuxSystems;
    cuda-bindings = linuxSystems;
  };
}
