{ pkgs, ... }: {

  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-python.python
      ms-python.debugpy
      jdinhlife.gruvbox
      anthropic.claude-code
    ];
  };
}
