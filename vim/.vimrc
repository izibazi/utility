if version >= 704
	set regexpengine=1
endif
" 参考サイト
" http://vimblog.hatenablog.com/entry/vimrc_set_recommended_options
" .vimrcが存在するする時点でnocompatibleが成されているのと同じらしいが。
set nocompatible

set helplang=ja,en
" 文字コード設定 
set enc=utf-8 bomb
set fenc=utf-8 bomb
set fencs=utf-8,iso-2022-jp,euc-jp,cp932

"
" 画面表示の設定
" 
set wrapmargin=0
set textwidth=0
set nu " 行番号表示
set ruler " 画面右下に現在のカーソル列表示.
set list " 不可視文字表示
" 不可視文字の表示記号指定
set listchars=tab:--,eol:↲,extends:❯,precedes:❮
" set cursorcolumn " カーソル位置の列色を変える
set cursorline " カーソル行の背景色を変える
set cmdheight=2 " メッセージ表示欄を2行確保
set showmatch " 対応する括弧を強調
set helpheight=999 " ヘルプを画面いっぱいに開く
" ビープの代わりにビジュアルベル（画面フラッシュ）を使う
set visualbell
" コマンドライン補完するときに補完候補を表示する
set wildmenu
" 全角スペースの強調
highlight zenkakuda ctermbg=7
call matchadd("zenkakuda", '\%u3000')

" 列の強調 ルーラー的に表示する
set colorcolumn=80

"
" タブの設定
"
set tabstop=2
set shiftwidth=2
set autoindent
" http://vim-jp.org/vimdoc-ja/indent.html
set cino=(0

"
" 検索/置換の設定
"
set hlsearch " 検索文字列をハイライト
set incsearch " インクリメンタルサーチ
" set ignorecase " 大文字小文字を無視
" set smartcase " 大文字と小文字が混在した場合のみ大文字小文字を区別
" set wrapscan " 最後尾まで検索したら次の検索で先頭に戻る
" set gdefault " 置換時のgオプションをデフォルトで有効にする

"
" 動作環境との統合関連の設定
"
" osのクリップボードをYunk, Put可能にする
" macのデフォルトvimだと機能しない
" set clipboard=unnamed,unnamedplus
" マウスの入力を受け入れる
set mouse=a

"
" カーソル移動関連
"
set whichwrap=b,s,h,l,<,>,[,] " 行頭、行末の左右移動で行をまたぐ
set scrolloff=3 " 上下3行の視界を確保
" 下記2つ動いている??
set sidescrolloff=16 " 左右のスクロール時の視界を確保
set sidescroll=1 "左右のスクロールは1文字づつ
" 行の移動を表示行に変更.(実際の行ではなくて)
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

"
" ファイル処理関連の設定
"
set confirm " 保存されていないファイルの保存確認
set autoread " 外部でファイルが変更された場合に読み直す
set nobackup " ファイル保存時にバックアップファイルを作らない
set noswapfile " ファイル編集中にスワップファイルを作らない

" NeoBundle 設定

" Vim初回起動時のみ実行
if has('vim_starting')
 set runtimepath+=~/.vim/bundle/neobundle.vim
 call neobundle#rc(expand('~/.vim/bundle'))
endif 

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
NeoBundle has('lua') ? 'Shougo/neocomplete.vim' : 'Shouge/neocompletecache.vom'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'matchit.zip'
NeoBundle 'surround.vim'
NeoBundle 'tell-k/vim-browsereload-mac'
" NeoBundle 'taichouchou2/vim-javascript'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'szw/vim-tags'
NeoBundleLazy 'nosami/Omnisharp', {
\   'autoload': {'filetypes': ['cs']},
\   'build': {
\     'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
\     'mac': 'xbuild server/OmniSharp.sln',
\     'unix': 'xbuild server/OmniSharp.sln',
\   }
\ }
NeoBundleLazy 'OrangeT/vim-csharp', { 'autoload': { 'filetypes': [ 'cs', 'csi', 'csx' ] } }
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'scrooloose/syntastic.git'
" neocomplete
" if neobundle#is_installed('neocomplete')
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_igonre_case = 1
	let g:neocomplete#enable_smart_case = 1
	" C#用設定
	" https://github.com/OmniSharp/omnisharp-vim/wiki/Example-NeoComplete-Settings
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.cs = '.*[^=\);]'
" endif

" Unite
nnoremap <silent> ,uu :<C-u>Unite file_mru buffer<CR>

" NERDTree
" 隠しファイルの表示
let NERDTreeShowHidden = 1
let NERDTreeIgnore = ['\.meta$']
" vim起動時に自動的にNERDTreeも起動
autocmd VimEnter * execute 'NERDTree'
" Comment
NeoBundle 'tomtom/tcomment_vim'
" Indent
" インデントに色を付けて見やすくする
" NeoBundle 'nathanaelkane/vim-indent-guides'
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=16
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=0
" let g:indent_guides_enable_on_vim_startup=1
" let g:indent_guides_guide_size=1

" Color schemes
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'tomasr/molokai'

" JSON
NeoBundle 'JSON.vim'
au! BufRead,BufNewFile *.json set filetype=json
"au! BufRead,BufNewFile *.txt set filetype=json

NeoBundle 'mattn/emmet-vim'
" emmet展開ショートカット
" let g:user_emmet_leader_key = '<c-e>'
let g:user_emmet_expandabbr_key = '<c-e>'

filetype plugin indent on
filetype plugin on

" ColorScheme
" カラースキームによっては下記の設定が必要.
" 256色表示
" set t_Co=16
" set t_Co=256 
" set background=dark
let g:hybrid_use_iTerm_colors = 1
autocmd ColorScheme * highlight Search ctermbg=124 guifg=Black guibg=#333333
" autocmd ColorScheme * highlight Comment ctermbg=0 guifg=Black guibg=#008800
" let g:hybrid_use_Xresources = 1
" let g:hybrid_use_iTerm_colors = 1
colorscheme hybrid
":"colorscheme ir_black
" colorscheme molokai
" colorscheme mustang 
syntax on

" F5でコマンド履歴を開く
:nnoremap <F5> <CR>q:
" F6で検索履歴を開く
:nnoremap <F6> <CR>q/

" デフォルトの設定を無効に
:nnoremap q: <NOP>
:nnoremap q/ <NOP>
:nnoremap q? <NOP>

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
" inoremap < <><LEFT>

" 7.4で、delキーが効かない対応
set backspace=indent,eol,start

" exエディタの無効
noremap Q <NOP>

" tagsジャンプの時に複数ある時は一覧表示                                        
nnoremap <C-]> g<C-]> 

" バッファの移動
map <C-N> :bnext<CR>
map <C-P> :bprev<CR>

" カーソル下単語(<cword>)でgrep
nnoremap <F3> :grep <cword> ./*<CR>

" ファイルの詳細表示
nnoremap <C-G> 2<C-G>

" ノーマルモードのリターンキーで空行追加.
" nnoremap <CR> o<ESC>

"
" tablineの表示
"
set showtabline=2
set tabline=%!MyTabLine()
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (i+1) . 'T' 
    let s .= ' ' . (i+1) . (1==getwinvar(i+1,'&modified')?'[+]':'') . ' %{MyTabLabel(' . (i+1) . ')} '
  endfor
  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1 
    let s .= '%=%#TabLine#%999Xclose'
  endif
  return s
endfunction

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1]) 
endfunction

hi TabLine  	 term=bold cterm=bold,underline ctermfg=60
hi TabLineSel  term=reverse cterm=reverse ctermfg=white ctermbg=black
hi TabLineFill term=reverse cterm=reverse ctermfg=233 ctermbg=black

"
" ステータスライン
"
" ステータス行を常に表示
set laststatus=2 
set statusline:%F%m%r%h%w\ [Col:%v]\ [Line:%l/%L\ (%p%%)]\ [Ascii:\%b]\ [Hex:\%02.2B]\ [Format:%{&ff}]\ [Type:%Y] 
" hi StatusLineNC  term=bold cterm=bold,underline ctermfg=60 ctermbg=black
" hi StatusLine  	 term=reverse cterm=reverse ctermfg=white ctermbg=black

" ctag
autocmd FileType php set tags=$HOME/.vim/tags/codeigniter.tags
autocmd FileType javascript set tags=$HOME/.vim/tags/javascript.tags

" 高速化?
" http://superuser.com/questions/402448/vim-configuration-slow-in-terminal-iterm2-but-not-in-macvim
let loaded_matchparen=1 " Don't load matchit.vim (paren/bracket matching)
set noshowmatch         " Don't match parentheses/brackets
set nocursorline        " Don't paint cursor line
set nocursorline        " Don't paint cursor line
set lazyredraw          " Wait to redraw
set scrolljump=8        " Scroll 8 lines at a time at bottom/top
let html_no_rendering=1 " Don't render italic, bold, links in HTML

".{ファイル名}.un~の無効化
set noundofile

" OSの切り分け
if has("unix")
	" source ~/.vim/unix.vimrc
elseif has("mac")
	" source ~/.vim/mac.vimrc
elseif has("win32")
	" source ~/.vim/win.vimrc
endif

" バージョン
if version <= 702
	" source .vim/702.vimrc
else
	" source .vimr/new.vimrc
endif

" ユーザー
if exists("$USER")
	if $USER == 'ishibashi'
		" source ~/.vim/ishibashi.vimrc
	endif
endif

augroup templates
	autocmd!
	autocmd BufNewFile *.html 0r $HOME/.vim/template/template.html
	autocmd BufNewFile *.c 0r $HOME/.vim/template/template.c
augroup END

nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>

" 補完メニューの高さ
" set pumheight=10

" 省略系
" ab __ ________________________________________________________________________________

" ノーマルコードに移動
inoremap jj <Esc>

" プロジェクト固有設定. 
" .vimrc.localをロード
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>

" vimgrep後に、QuickFixを表示する
autocmd QuickFixCmdPost *grep* cwindow
" autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

" ハイライトを消す
noremap <silent> <ENTER> :noh<CR>

" docstringは表示しない
set completeopt-=preview
