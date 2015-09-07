"----------
" 基本的な設定
"----------
set showtabline=2
set transparency=5
set imdisable
set guioptions-=T
set antialias
set tabstop=4
set number
set nobackup
set visualbell t_vb=
set nowrapscan
set columns=100
set lines=48

" Color Scheme
colorscheme hybrid
syntax on

" 隠しファイル表示
let NERDTreeShowHidden = 1

" 引数なしで実行したとき、NERDTreeを実行する
let file_name = expand("%:p")
if has('vim_starting') &&  file_name == ""
"    autocmd VimEnter * execute 'NERDTree ./'
endif

" 分割ウィンドウ時に移動を行う設定
noremap <C-H> <C-W>h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-L> <C-W>l
