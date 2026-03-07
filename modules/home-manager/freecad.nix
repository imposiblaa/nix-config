{ pkgs, ... }: 
let
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.scikit-learn
    ps.debugpy
  ]);  
  vscodeSettings = pkgs.writeText "vscode-settings.json" (builtins.toJSON {
    "python.analysis.extraPaths" = [
      "${pkgs.freecad}/lib"
      "${pkgs.freecad}/Mod/Fem"
    ];
  });
in {
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
      echo "$0 $@" >> /tmp/freecad-wrapper-debug.log
      case "$1" in
        --version|-V)
          exec ${pythonEnv}/bin/python --version ;;
        -c)
          exec ${pythonEnv}/bin/python "$@" ;;
        --for-server)
          exec ${pythonEnv}/bin/python "$@" ;;
        /nix/store/*)
          exec ${pythonEnv}/bin/python "$@" ;;
      esac

      export OMP_NUM_THREADS=16
      export CCX_NPROC_EQUATION_SOLVER=16
      export CCX_NPROC_RESULTS=16
      ulimit -s unlimited
      MODULES="-M ${pythonEnv}/lib/${pkgs.python3.libPrefix}/site-packages"

      if [[ -n "$FREECAD_DEBUG" ]]; then
        BOOTSTRAP=$(mktemp /tmp/freecad-debug-XXXX.py)
        cat > "$BOOTSTRAP" <<EOF
      import os
      os.environ["DEBUGPY_LOG_DIR"] = "/tmp/debugpy-logs"
      os.makedirs("/tmp/debugpy-logs", exist_ok=True)

      import sys
      sys.executable = "$0"

      import debugpy
      debugpy.listen(("localhost", 5678))

      print("Debugger is ready to attach")
      debugpy.wait_for_client()

      def on_disconnect():
        import os, signal
        os.kill(os.getpid(), signal.SIGTERM)

      debugpy.on_disconnect(on_disconnect)

      import runpy
      runpy.run_path(sys.argv[1])
      EOF
        trap "rm -f $BOOTSTRAP" EXIT
        echo "Running FreeCADCmd in multithreaded mode!"
        exec ${pkgs.freecad}/bin/FreeCADCmd $MODULES "$BOOTSTRAP" "$@"
      else
        exec ${pkgs.freecad}/bin/FreeCADCmd $MODULES "$@"
      fi
    '')
    (writeShellScriptBin "fccmd-vs-setup" ''
      mkdir -p .vscode
      cp ${vscodeSettings} .vscode/settings.json
    '')
    
    freecad
    calculix-ccx
    gmsh
  ];
}
