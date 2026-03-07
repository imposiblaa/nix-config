{ pkgs, ... }: {

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-python.python
      ms-python.debugpy
      ms-python.pylint
      jdinhlife.gruvbox
    ];
  };
}
