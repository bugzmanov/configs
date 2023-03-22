let mapleader = "\<Space>"

set nocompatible
filetype off


so ~/.config/nvim/plug.vim
call plug#begin()

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'


" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'lokaltog/vim-easymotion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'chriskempson/base16-vim'
Plug 'mhartington/oceanic-next'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
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
" Plug '/Users/rafaelbagmanov/workspace/vim-cfr'
Plug 'bugzmanov/vim-cfr'
" call coc#add_extension(
"   \ 'coc-rust-analyzer',
" \ )

call plug#end()

" if has('nvim')
"     set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
"     set inccommand=nosplit
"     noremap <C-q> :confirm qall<CR>
" end

" Lightline
" let g:lightline = {
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'filename': 'LightlineFilename',
"       \   'cocstatus': 'coc#status'
"       \ },
"       \ }


 let g:lightline = {
       \ 'active': {
       \   'left': [ [ 'mode', 'paste' ],
       \             [ 'lspstatus', 'readonly', 'filename', 'modified' ] ]
       \ },
       \ 'component_function': {
       \   'filename': 'LightlineFilename',
       \   'lspstatus': 'LspStatus'
       \ },
       \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

lua << END
    local lsp_status = require('lsp-status')
    lsp_status.register_progress()

    local lspconfig = require('lspconfig')

    -- Some arbitrary servers
    lspconfig.clangd.setup({
    handlers = lsp_status.extensions.clangd.setup(),
    init_options = {
        clangdFileStatus = true
    },
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities
    })


    lspconfig.ghcide.setup({
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities
    })
    lspconfig.rust_analyzer.setup({
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities
    })

    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-H>", 'copilot#Previous()', { silent = true, expr = true })
    vim.api.nvim_set_keymap("i", "<C-K>", 'copilot#Next()', { silent = true, expr = true })
END

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction


" Use auocmd to force lightline update.
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

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

" Like idea
nmap <C-l> $
nmap <C-h> ^
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p
" map <leader>a :action $SelectAll<CR>
" Remap for do codeAction of selected region
" function! s:cocActionsOpenFromSelected(type) abort
"   execute 'CocCommand actions.open ' . a:type
" endfunction
" xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
" nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

vnoremap * y <Esc>/<C-r>0<CR>
nnoremap <Esc> :nohlsearch<CR>

"
" nnoremap <silent> <space>k  :Denite -resume -cursor-pos=-1 -immediately<CR>
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
" Next buffer in list
nnoremap <Leader>[ :BufferPrevious<CR>

" Previous buffer in list
nnoremap <Leader>] :BufferNext<CR>
nnoremap <Leader>q :BufferClose<CR>
" nmap     <Leader>] :bn<CR>  
" nmap     <Leader>[ :bp<CR>



filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
set smartindent

nnoremap <leader>sv :source ~/.config/nvim/init.vim<CR>

" Terminal stuff 
if has('nvim')
    tnoremap <C-]> <C-\><C-n>
endif

" cargo fmt on save 
let g:rustfmt_autosave = 1
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
" set colorcolumn=80 " and give me a colored column
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

" ============================
"    COC + Coc Metals
" ============================
" source ~/.config/nvim/coc-mappings.vim

" nnoremap <leader> ne  :Denite -resume -cursor-pos=+1 -immediately<CR>
" GoTo code navigation.
" nmap gd <Plug>(coc-definition)
" nmap gD <Plug>(coc-type-definition)
" nmap gs <Plug>(coc-type-definition)
" nmap gi <Plug>(coc-implementation)
" nmap gr <Plug>(coc-references)
" nmap <leader>rr <Plug>(coc-rename)
" nmap <silent> <leader>nw <Plug>(coc-diagnostic-next)
" nmap <silent> <leader>ne <Plug>(coc-diagnostic-next-error)
" nmap <silent> <leader>nw <Plug>(coc-diagnostic-next)
" nmap <silent> <leader>np <Plug>(coc-diagnostic-prev-error)
" nmap <leader>g[ <Plug>(coc-diagnostic-prev)
" nmap <leader>g] <Plug>(coc-diagnostic-next)

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

" inoremap <silent><expr> <Tab>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Help Vim recognize *.sbt and *.sc as Scala files
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" let g:node_client_debug = 1


source $HOME/.config/nvim/metals.lua.vim


