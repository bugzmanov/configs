let mapleader = "\<Space>"

set nocompatible
filetype off


so ~/.config/nvim/plug.vim
call plug#begin()

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'


" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'spywhere/lightline-lsp'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'chriskempson/base16-vim'
Plug 'mhartington/oceanic-next'

" Fuzzy finder
" Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
" Plug 'simrat39/rust-tools.nvim'
" Plug 'mrcjkb/rustaceanvim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" Plug 'scrooloose/syntastic'
Plug 'neomake/neomake'

" CoC
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'scalameta/coc-metals', {'do': 'yarn install --frozen-lockfile'}
Plug 'scalameta/nvim-metals'

Plug 'vim-test/vim-test'

" Requires https://www.nerdfonts.com/font-downloads
Plug 'kyazdani42/nvim-web-devicons'
" Buffers as tabs
Plug 'romgrk/barbar.nvim'

" Float terminal
Plug 'voldikss/vim-floaterm'

" Tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" plenary: lua functions
Plug 'nvim-lua/plenary.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
Plug 'hrsh7th/cmp-path', {'branch': 'main'}
Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
Plug 'ray-x/lsp_signature.nvim'

" Only because nvim-cmp _requires_ snippets
Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
Plug 'hrsh7th/vim-vsnip'

Plug 'nvim-lua/lsp-status.nvim'
Plug 'bugzmanov/vim-cfr'

Plug 'mikelue/vim-maven-plugin'

" vim-repeat for better . command support
Plug 'tpope/vim-repeat'

Plug 'ziglang/zig.vim'
" 2024 - lsp
" Plug 'williamboman/mason.nvim'    
" Plug 'williamboman/mason-lspconfig.nvim'
call plug#end()

" LSP setup handled via vim.lsp.config

let g:lightline = {
   \ 'active': {
   \   'left': [ [ 'mode', 'paste' ],
   \             [ 'readonly', 'filename', 'modified' ,  'lspstatus'] ],
   \   'right': [ [ 'lineinfo' ], [ 'percent' ],
   \              [ 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_hints', 'linter_ok' ]] 
   \ },
   \ 'component_function': {
   \   'filename': 'LightlineFilename',
   \   'lspstatus': 'LspStatus'
   \ },
   \ 'component_expand': {
   \   'linter_hints': 'lightline#lsp#hints',
   \   'linter_infos': 'lightline#lsp#infos',
   \   'linter_warnings': 'lightline#lsp#warnings',
   \   'linter_errors': 'lightline#lsp#errors',
   \   'linter_ok': 'lightline#lsp#ok',
   \ },
   \ 'component_type': {
   \     'linter_hints': 'right',
   \     'linter_infos': 'right',
   \     'linter_warnings': 'warning',
   \     'linter_errors': 'error',
   \     'linter_ok': 'right',
   \ }
   \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

lua << END
    local lsp_status = require('lsp-status')
    lsp_status.register_progress()

    vim.lsp.config('*', {
        on_attach = lsp_status.on_attach,
        capabilities = lsp_status.capabilities,
    })

    vim.lsp.config('clangd', {
        handlers = lsp_status.extensions.clangd.setup(),
        init_options = {
            clangdFileStatus = true,
        },
    })

    vim.lsp.enable({ 'clangd', 'ghcide', 'rust_analyzer', 'zls' })

    if vim.fn.executable('bash-language-server') == 1 then
        vim.lsp.enable('bashls')
    end
END

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Quick-save
nmap <leader>w :w<CR>

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces

" Sane splits
set splitright
set splitbelow

" Decent wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor


" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault


" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" make j and k move by visual line, not actual line, when text is soft-wrapped
nmap j gj
nmap k gk

" Like idea
nmap L $
nmap H ^
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" search the word by clicking "*"
vnoremap * y <Esc>/<C-r>0<CR>
nnoremap <Esc> :nohlsearch<CR>

" Telescope search
" Using lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>

" Show buffers panel
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fm <cmd>lua require('telescope.builtin').marks()<cr>
nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
lua require('telescope').setup{ defaults = { file_ignore_patterns = {"target", "fuzz/"} } }

" Buffer navigation
nnoremap <Leader>[ :BufferPrevious<CR>
nnoremap <Leader>] :BufferNext<CR>
nnoremap <Leader>q :BufferClose<CR>
nnoremap <Leader>z :BufferClose<CR>



filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set smartindent

nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>

" Terminal stuff  - jump out of terminal mode to normal
if has('nvim')
    tnoremap <C-]> <C-\><C-n> 
endif

" cargo fmt on save 
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'wl-copy'


" Open a file from previous editing position
autocmd BufReadPost *
    \ if expand('%:p') !~# '\m/\.git/' && line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal! g`\"" |
    \ endif

lua require("lsp_signature").setup({
    \			doc_lines = 0,
	  \			handler_opts = {
	  \				border = "none"
	  \			},
	  \		})

" vim-surround conflicts with leap: https://github.com/ggandor/leap.nvim/discussions/38

let g:surround_no_mappings = 1
" Just the defaults copied here.
nmap ds       <Plug>Dsurround
nmap cs       <Plug>Csurround
nmap cS       <Plug>CSurround
nmap ys       <Plug>Ysurround
nmap yS       <Plug>YSurround
nmap yss      <Plug>Yssurround
nmap ySs      <Plug>YSsurround
nmap ySS      <Plug>YSsurround

" The conflicting ones. Note that `<Plug>(leap-cross-window)`
" _does_ work in Visual mode, if jumping to the same buffer,
" so in theory, `gs` could be useful for Leap too...
xmap gs       <Plug>VSurround
xmap gS       <Plug>VgSurround


"
" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
set nofoldenable
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers
set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
set colorcolumn=120 " and give me a colored column
set signcolumn=yes " potentially try set signcolumn=number.
set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.
set shortmess-=F 

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Color schema
" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Or if you have Neovim >= 0.1.5
if (has("termguicolors"))
 set termguicolors
endif

" Theme
syntax enable
colorscheme OceanicNext

highlight LineNr ctermfg=darkgrey

" Vim-test stuff
nmap <silent> <leader>tr :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>tl :TestLast<CR>
let test#strategy = "neovim"

if has('nvim')
  tmap <C-o> <C-\><C-n><C-w>_
endif

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" let g:node_client_debug = 1

" source $HOME/.config/nvim/metals.lua.vim
 source $HOME/.config/nvim/lsp-setup.lua.vim

lua << END

    -- -- Mason Setup
    -- require("mason").setup({
    --     ui = {
    --         icons = {
    --             package_installed = "",
    --             package_pending = "",
    --             package_uninstalled = "",
    --         },
    --     }
    -- })
    -- require("mason-lspconfig").setup()


    -- local rt = require("rust-tools")

    -- rt.setup({
    --   server = {
    --     on_attach = function(_, bufnr)
    --       -- Hover actions
    --       vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    --       -- Code action groups
    --       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    --     end,
    --   },
    -- })

END
