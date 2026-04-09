{ pkgs, ... }: {

  stylix.targets.vscode.enable = false;

  home.packages = [
    pkgs.gradle
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      ms-python.python
      ms-python.debugpy
      jdinhlife.gruvbox
      anthropic.claude-code
      redhat.java
      vscjava.vscode-java-pack
      vscjava.vscode-maven
      vscjava.vscode-java-test
      vscjava.vscode-java-debug
      vscjava.vscode-gradle
      vscjava.vscode-java-dependency
    ];
  };
}
