" switch current working directory to current year of classes
command! Classes :cd ~/Documents/2024-2025 Classes

" return to home directory
command! Backhome :cd ~

" settings for concepts of computer systems files
augroup ccsfiles
    autocmd!
    autocmd BufReadPre *.asm
                \ setlocal expandtab
                \ setlocal tabstop=8
                \ setlocal shiftwidth=8
augroup END
