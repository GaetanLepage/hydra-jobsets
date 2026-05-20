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
    uutils-coreutils = allSystems;
    gpu-burn = linuxSystems;

    zed-editor = linuxSystems;
    neovim = allSystems;

    nixl = linuxSystems;
    exo = allSystems;
    mujoco = allSystems;
    vllm = allSystems;
  };

  python = {
    torch = allSystems;
    torchaudio = allSystems;
    torchvision = allSystems;
    torchrl = allSystems;
    torch-cluster = allSystems;
    tensordict = allSystems;
    vllm = allSystems;
    executorch = allSystems;

    jax = allSystems;
    equinox = allSystems;
    lineax = allSystems;
    optuna = allSystems;

    tinygrad = allSystems;
    dm-control = allSystems;

    fastexcel = allSystems;
    lancedb = allSystems;
    ray = allSystems;

    wandb = allSystems;

    deep-gemm = linuxSystems;
    deep-ep = linuxSystems;
    nixl = linuxSystems;
    xformers = linuxSystems;
    cuda-bindings = linuxSystems;
    nvidia-cutlass = linuxSystems;
  };
}
