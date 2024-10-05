" the base/core config changes for vim and nvim
"runtime! **/plugins.vim
lua require('lazy_plugins')
runtime! **/personal.vim
runtime! **/binary.vim

" ----- preferred settings ----
set termguicolors
syntax on
set signcolumn=yes

" add tab and eol symbols
set list
set listchars=tab:⇒\ " ignore
set expandtab
set tabstop=4
set shiftwidth=4

" mouse support
set mouse=a

set relativenumber

"----some basic commands---
command! W :execute ':w !sudo tee % > /dev/null' | :edit!

command! Ccf let @+=expand("%:p")

" ---- some personal useful mappings ----
" lets Esc be used to exit terminal mode
"tnoremap <Esc> <C-\><C-n>

" use ctrl + i in html files to start editing end of inside tag
autocmd! FileType html nnoremap <C-i> vit<Esc>a


"----------Buffer to Tab------
" This allows buffers to be hidden if you've modified a buffer
" This is almost a must if you wish to use buffers in this way.
set hidden

" let terminal buffers appear in tabline
" let g:airline#extensions#tabline#ignore_bufadd_pat = "defx|gundo|nerd_tree|startify|tagbar|undotree|vimfilfer"

" To open a new empty buffer
" This replcaes :tabnew which I used to bind to this mapping
nmap <leader>T :enew<CR>

" Move the the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp<bar>sp<bar>bn<bar>bd<CR>
" closes buffer with force (I'm an idiot and try and edit read only files)
nmap <leader>bQ :bp<bar>sp<bar>bn<bar>bd!<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" ----- useful auto commands -----
" augroup Binary
"     au!
"     au BufReadPre  *.bin let &bin=1
"     au BufReadPost *.bin if &bin | %!xxd
"     au BufReadPost *.bin set ft=xxd | endif
"     au BufWritePre *.bin if &bin | %!xxd -r
"     au BufWritePre *.bin endif
"     au BufWritePost *.bin if &bin | %!xxd
"     au BufWritePost *.bin set nomod | endif
" augroup END

" augroup xxd
"     au!
"     au BufReadPre  xxd let &bin=1
"     au BufReadPost xxd xxd if &bin | %!xxd | endif
"     au BufReadPost xxd endif
"     au BufWritePre xxd if &bin | %!xxd -r
"     au BufWritePre xxd endif
"     au BufWritePost xxd if &bin | %!xxd
"     au BufWritePost xxd set nomod | endif
" augroup END


" :terminal use ALT+h,j,k,l
augroup TerminalNav
    au!
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-j> <C-\><C-N><C-w>j
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    inoremap <A-h> <C-\><C-N><C-w>h
    inoremap <A-j> <C-\><C-N><C-w>j
    inoremap <A-k> <C-\><C-N><C-w>k
    inoremap <A-l> <C-\><C-N><C-w>l
    nnoremap <A-h> <C-w>h
    nnoremap <A-j> <C-w>j
    nnoremap <A-k> <C-w>k
    nnoremap <A-l> <C-w>l
augroup END

" vimtex
augroup VimTeX
  autocmd!
  autocmd BufReadPre /path/to/project/*.tex
        \ let b:vimtex_main = '/path/to/project/main.tex'
augroup END

" opens a nix develop shell
command! Ndterm :term nix develop
