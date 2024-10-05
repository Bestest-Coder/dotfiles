" all plugins and plugin config
call plug#begin(stdpath('data'),'/plugged')

" Icons
Plug 'ryanoasis/vim-devicons'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" airline status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Autocompletion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" file tree
"Plug 'preservim/nerdtree'
"Plug 'johnstef99/vim-nerdtree-syntax-highlight'

" GDB integration
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }

" Syntastic
" Plug 'vim-syntastic/syntastic'

" Syntax Highlighting/Language packs
Plug 'sheerun/vim-polyglot'

" C/C++ better highlighting
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jackguo380/vim-lsp-cxx-highlight'

" git integration
Plug 'tpope/vim-fugitive'

" debugger
Plug 'puremourning/vimspector'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Commenting
Plug 'numToStr/Comment.nvim'

"-----Themes-----
Plug 'joshdick/onedark.vim'
Plug 'rileytwo/kiss'
Plug 'josegamez82/starrynight'

" sudo save
Plug 'lambdalisue/suda.vim'

" airline
Plug 'vim-airline/vim-airline'

" Rust autocomplete
Plug 'rust-lang/rust.vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" indetation characters
Plug 'lukas-reineke/indent-blankline.nvim'

" firenvim
Plug 'glacambre/firenvim', { 'do': {_ -> firenvim#install(0)}}

" funny cellular automation
Plug 'eandrju/cellular-automaton.nvim'

"Neotree
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-tree/nvim-web-devicons'

call plug#end()

" ---- Comment setup ----
lua require('Comment').setup()

"---- set theme from downloaded ----
let g:onedark_config = {
    \ 'style': 'deep',
\}
colorscheme onedark

" -----airline config------
"let g:airline#extensions#term#enabled = 1

" let terminal buffers appear in tabline
"let g:airline#extensions#tabline#ignore_bufadd_pat = "defx|gundo|nerd_tree|startify|tagbar|undotree|vimfilfer"

"-------Syntastic Stuff ---------
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_quiet_messages = { "type": "style" }
" let g:syntastic_cpp_checkers = ['GCC']

"let g:airline#extensions#branch#enabled = 1

"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#fnamemod = ":t"

"let g:airline_powerline_fonts = 1

"let g:airline#extensions#nerdtree_statusline = 1


"-------COC config--------
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
else
    inoremap <silent><expr> <c-@> coc#refresh()
endif


inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

nnoremap <silent> K :call ShowDocumentation()<CR>
autocmd CursorHold * silent call CocActionAsync('highlight')

inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
nnoremap <leader>cd <cmd>CocDiagnostics<CR>

" -----fzf config-----
if has("nvim")
    " Escape inside a FZF terminal window should exit the terminal window
    " rather than going into the terminal's normal mode.
    autocmd FileType fzf tnoremap <buffer> <Esc> <Esc>
endif

"---indent_blankline config---
highlight indentHighlight1 guifg=#e06c75
highlight indentHighlight2 guifg=#e5c07b
highlight indentHighlight3 guifg=#98c739
highlight indentHighlight4 guifg=#56b6c2
highlight indentHighlight5 guifg=#61afef
highlight indentHighlight6 guifg=#c768dd
let g:indent_blankline_char_highlight_list = ["indentHighlight1", "indentHighlight2", "indentHighlight3",
            \"indentHighlight4","indentHighlight5","indentHighlight6"]
let g:indent_blankline_char = "⇒"
let g:indent_blankline_show_current_context = 1
let g:indent_blankline_show_current_context_start = 1

"------firenvim------
let g:firenvim_config = {
    \ 'localSettings': {
        \ '.*' : {
            \ 'takeover': 'never'
        \ }
    \ }
    \ }

"----telescope-----
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>
nnoremap <leader>ft <cmd>Telescope treesitter<cr>

" -----NERDTree config-----
" change current working directory to home and refresh NERDTree display
command! Backhome :cd ~ "| NERDTreeCWD

"-----NeoTree-----
lua require('neo-tree').setup({
            \ close_if_last_window = true,
            \ enable_git_status = true,
            \ enable_diagnostics = true,
            \ open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
            \ sort_case_insensitive = false,
            \ })
autocmd VimEnter * Neotree show
" automatically open NERDTree on start, and close when NERDTree is only open
" buffer
"autocmd VimEnter * if !exists('g:started_by_firenvim') |  NERDTree | wincmd p | endif
"autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
