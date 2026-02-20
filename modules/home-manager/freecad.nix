{ pkgs, ... }: {

  home.packages = with pkgs; [
    (writeShellScriptBin "freecad-gpu" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __NK_LAYER_NV_optimus=NVIDIA_only
      export QT_QPA_PLATFORM=xcb
      exec freecad "$@"
    '')
    freecad
  ];
}
