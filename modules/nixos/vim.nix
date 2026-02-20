{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [ 
    ((vim-full.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = ''
        set backspace=2
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
	set expandtab
        syntax on
        filetype indent on
        set autoindent smartindent
        set number
	set ruler
        set nobackup
	filetype plugin indent on
      '';
    }
  )];

}
