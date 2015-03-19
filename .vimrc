" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

"カラーテーマを設定
colorscheme molokai
syntax on

" 行番号を表示
set number

" taglistの設定
let Tlist_Show_One_File = 1
let Tlist_Use_Right_Window = 1
let Tlist_Exit_OnlyWindow = 1
let tlist_php_settings='php;f:function'
let Tlist_Ctags_Cmd = '/usr/local/Cellar/ctags/5.8/bin/ctags'
set tags+=~/.tags

" tabキーの設定
set tabstop=4
"set autoindent
set expandtab
set shiftwidth=4

" 自動インデントOFF
set noautoindent

" 改行で自動コメントアウトを無効にする
setlocal formatoptions-=r
setlocal formatoptions-=o
autocmd FileType * setlocal formatoptions-=ro

" タイトルをウィンドウ枠に表示
set title

" ルーラーを表示(ステータスバーにカーソル位置を表示)
set ruler

" 入力中のコマンドをステータスに表示する
set showcmd

" バックアップファイルを作成しない
set nobackup

" スワップファイルを作成しない
set noswapfile

" ビープ音を鳴らさない
set vb t_vb=

" ClipBoardの利用
set clipboard&
set clipboard+=unnamed
set clipboard+=autoselect
set clipboard=unnamed

" 最後までサーチすると先頭に戻る
set wrapscan

" 大文字小文字の区別をしない
set ignorecase

" 検索文字列に大文字があった場合に反映
set incsearch

" 行番号の表示/非表示をマッピング
" (クリップボードが使えないときのコピー用)
nnoremap <silent> non :<C-u>set nonumber<CR>
nnoremap <silent> setn :<C-u>set number<CR>

" マウスを有効に
set mouse=a
set ttymouse=xterm2

" 検索文字をハイライト
set hlsearch

" 最後のカーソル位置を記憶する
if has("autocmd")
  augroup redhat
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead *.txt set tw=78
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
  augroup END
endif

"---------------------------
" Start Neobundle Settings.
"---------------------------
" bundleで管理するディレクトリを指定
set runtimepath+=~/.vim/bundle/neobundle.vim/
 
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
 
" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'
 
" ファイルをtree表示してくれる
NeoBundle 'scrooloose/nerdtree'

" Gitを便利に使う
NeoBundle 'tpope/vim-fugitive'
 
" Rails向けのコマンドを提供する
NeoBundle 'tpope/vim-rails'

" Ruby向けにendを自動挿入してくれる
NeoBundle 'tpope/vim-endwise'

" コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'

" インデントに色を付けて見やすくする
"NeoBundle 'nathanaelkane/vim-indent-guides'

" ログファイルを色づけしてくれる
NeoBundle 'vim-scripts/AnsiEsc.vim'

" 行末の半角スペースを可視化
NeoBundle 'bronson/vim-trailing-whitespace'

call neobundle#end()
 
" Required:
filetype plugin indent on
 
" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
NeoBundleCheck

"-------------------------
" End Neobundle Settings.
"-------------------------

" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow

" ステータス行に現在のgitブランチを表示する
set statusline+=%{fugitive#statusline()}

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1

""""""""""""""""""""""""""""""
" 全角スペースの表示
""""""""""""""""""""""""""""""
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 挿入モード時、ステータスラインの色を変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction
""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" 自動的に閉じ括弧を入力
""""""""""""""""""""""""""""""
"imap { {}<LEFT>
"imap [ []<LEFT>
"imap ( ()<LEFT>
""""""""""""""""""""""""""""""

" ファイルを指定せずにvimを起動したらNERDTreeを起動する
autocmd vimenter * if !argc() | NERDTree | endif

" 行末の無駄なスペースを削除する
autocmd BufWritePre * :%s/\s\+$//ge
