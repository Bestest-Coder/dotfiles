" command to open init.vim from anywhere
command! Initvim :e ~/.config/nvim/init.vim
command! Initvimf :cd ~/.config/nvim | :e init.vim

command! I3config :cd ~/.config/i3

aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end

" switch current working directory to current year of classes
command! Classes :cd ~/Documents/2023-2024 Classes

" return to home directory
command! Backhome :cd ~
