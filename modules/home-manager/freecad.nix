{ pkgs, ... }: {

  home.packages = with pkgs; [
    (writeShellScriptBin "freecad-gpu" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __NK_LAYER_NV_optimus=NVIDIA_only
      export QT_QPA_PLATFORM=xcb

      export OMP_NUM_THREADS=16
      export CCX_NPROC_EQUATION_SOLVER=16
      export CCX_NPROC_RESULTS=16
      ulimit -s unlimited
      exec freecad "$@"
    '')
    (writeShellScriptBin "fccmd-mt" ''
      export OMP_NUM_THREADS=16
      export CCX_NPROC_EQUATION_SOLVER=16
      export CCX_NPROC_RESULTS=16
      ulimit -s unlimited
      echo "Running FreeCADCmd in multithreaded mode!"
      exec FreeCADCmd "$@"
    '')
    freecad
    calculix-ccx
    gmsh
  ];
}
