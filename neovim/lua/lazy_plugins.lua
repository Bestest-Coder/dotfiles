
-- -- automatically recompiles plugins on write to this file
-- vim.cmd([[
-- augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerCompile
-- augroup end
-- ]])

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- use 'wbthomason/packer.nvim'

    {'ryanoasis/vim-devicons'},

    {'nvim-treesitter/nvim-treesitter', build = ':TSUpdate'},

    {'vim-airline/vim-airline',
        config = function()
            vim.cmd([[
let g:airline#extensions#tabline#enabled = 1

let g:airline#extensions#term#enabled = 1
let g:airline#extensions#tabline#ignore_bufadd_pat = "defx|gundo|nerd_tree|startify|tagbar|undotree|vimfilfer"
let g:airline#extensions#branch#enabled = 1

let g:airline#extensions#tabline#fnamemod = ":t"

let g:airline_powerline_fonts = 1
            ]])
        end
    },

    {'neoclide/coc.nvim',
        branch = 'release',
        config = function()
            vim.cmd([[
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
            ]])
        end
    },

    -- use {'sakhnik/nvim-gdb', run = ':!./install.sh}

    {'sheerun/vim-polyglot'},

    {'octol/vim-cpp-enhanced-highlight',
        ft = {'c', 'cpp'}
    },

    {'jackguo380/vim-lsp-cxx-highlight',
        ft = {'c', 'cpp'}
    },

    {'tpope/vim-fugitive', cmd = 'Git'},

    {'puremourning/vimspector', lazy = true},

    {'nvim-lua/plenary.nvim'},

    {'nvim-telescope/telescope.nvim',
        config = function() 
            vim.cmd([[
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope man_pages<cr>
nnoremap <leader>ft <cmd>Telescope treesitter<cr>
            ]])
        end
    },

    {'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end,
        keys = 'gcc'
    },

    -- {'joshdick/onedark.vim',
    --     config = function() vim.cmd([[colorscheme onedark]]) end
    -- },
    {'navarasu/onedark.nvim',
        config = function()
            vim.cmd([[colorscheme onedark]])
            require('onedark').setup({
                    style = 'deep',
                    term_colors = false
            })
        end,
    },

    {'junegunn/fzf',
        build = 'fzf#install()',
        config = function() vim.api.nvim_create_autocmd("FileType", {
                pattern = {"fzf"},
                command = "tnoremap <buffer> <Esc> <Esc>"
            })
        end
    },

    {'lukas-reineke/indent-blankline.nvim',
        --after = 'onedark.vim',
        main = ibl,
        config = function()
            vim.cmd([[
highlight indentHighlight1 guifg=#e06c75
highlight indentHighlight2 guifg=#e5c07b
highlight indentHighlight3 guifg=#98c739
highlight indentHighlight4 guifg=#56b6c2
highlight indentHighlight5 guifg=#61afef
highlight indentHighlight6 guifg=#c768dd
]])
        local hooks = require "ibl.hooks"
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "indentHighlight1", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "indentHighlight2", { fg = "#E5C07B" })
            vim.api.nvim_set_hl(0, "indentHighlight3", { fg = "#98C739" })
            vim.api.nvim_set_hl(0, "indentHighlight4", { fg = "#56B6C2" })
            vim.api.nvim_set_hl(0, "indentHighlight5", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "indentHighlight6", { fg = "#C768DD" })
        end)
        require('ibl').setup({
            indent = {
                highlight = {"indentHighlight1", "indentHighlight2", "indentHighlight3", "indentHighlight4","indentHighlight5","indentHighlight6"},
                char = "⇒",
                },
                scope = {
                    enabled = true,
                    show_start = true,
                    char = "⇒",
                }
            })
    end
    },

    { "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
        },
        config = function()

            require('neo-tree').setup({
                        close_if_last_window = true,
                        enable_git_status = true,
                        enable_diagnostics = true,
                        open_files_do_not_replace_types = { "trouble", "qf" },
                        sort_case_insensitive = false,
                    })
            vim.api.nvim_create_autocmd("VimEnter",{
                command = [[Neotree show]]
            })
        end
    },
    { "lervag/vimtex",
        config = function()
            vim.cmd([[
                let g:vimtex_view_enabled = 1
                let g:vimtex_view_method = 'zathura'
            ]])
        end
    },
    --{ "startup-nvim/startup.nvim",
    --    config = function()
    --        require("startup").setup(require("startup_nvim"))
    --    end
    --}
})

--
-- -- comment setup
-- require('Comment').setup()
--
-- -- configure theme
-- vim.cmd([[colorscheme onedark]])
--
-- -- airline config
-- vim.cmd([[
-- let g:airline#extensions#term#enabled = 1
-- let g:airline#extensions#tabline#ignore_bufadd_pat = "defx|gundo|nerd_tree|startify|tagbar|undotree|vimfilfer"
-- ]])
--
-- -- syntastic config
-- vim.cmd([[
-- let g:syntastic_always_populate_loc_list = 1
-- let g:syntastic_auto_loc_list = 1
-- let g:syntastic_check_on_open = 1
-- let g:syntastic_check_on_wq = 0
-- let g:airline#extensions#syntastic#enabled = 1
-- let g:syntastic_quiet_messages = { "type": "style" }
--
-- let g:airline#extensions#branch#enabled = 1
--
-- let g:airline#extensions#tabline#enabled = 1
-- let g:airline#extensions#tabline#fnamemod = ":t"
--
-- let g:airline_powerline_fonts = 1
--
-- ]])
--
-- -- coc config
-- vim.cmd([[
-- if has('nvim')
--     inoremap <silent><expr> <c-space> coc#refresh()
-- else
-- inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"
-- nnoremap <leader>cd <cmd>CocDiagnostics<CR>
-- ]])
--
-- -- fzf config
-- vim.api.nvim_create_autocmd("FileType", {
--         pattern = {"fzf"},
--         command = "tnoremap <buffer> <Esc> <Esc>"
-- })
--
-- -- blankline config
-- vim.cmd([[
-- highlight indentHighlight1 guifg=#e06c75
-- highlight indentHighlight2 guifg=#e5c07b
-- highlight indentHighlight3 guifg=#98c739
-- highlight indentHighlight4 guifg=#56b6c2
-- highlight indentHighlight5 guifg=#61afef
-- highlight indentHighlight6 guifg=#c768dd
-- let g:indent_blankline_char_highlight_list = ["indentHighlight1", "indentHighlight2", "indentHighlight3",
--             \"indentHighlight4","indentHighlight5","indentHighlight6"]
-- let g:indent_blankline_char = "⇒"
-- let g:indent_blankline_show_current_context = 1
-- let g:indent_blankline_show_current_context_start = 1
-- ]])
--
-- -- telescope config
-- vim.cmd([[
-- nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>
-- nnoremap <leader>fm <cmd>Telescope man_pages<cr>
-- nnoremap <leader>ft <cmd>Telescope treesitter<cr>
-- ]])
--
-- -- Neotree config
-- require('neo-tree').setup({
--             \ close_if_last_window = true,
--             \ enable_git_status = true,
--             \ enable_diagnostics = true,
--             \ open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
--             \ sort_case_insensitive = false,
--             \ })
-- autocmd VimEnter * Neotree show
