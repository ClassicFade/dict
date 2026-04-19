set completeopt=menuone,noinsert,noselect
set shortmess+=c
set updatetime=300 
set nowildmenu 
set cedit=
let s:last_complete_time = 0 
let g:min_completion_length = 3
let s:completion_timer = -1 

set complete =.,w,b,u,t,k
autocmd FileType python setlocal dictionary=~/.config/nvim/dict/python.txt
autocmd FileType c setlocal dictionary=~/.config/nvim/dict/c.txt 
autocmd FileType vim setlocal omnifunc=syntaxcomplete#Complete


highlight Pmenu ctermbg=7 ctermfg=8
highlight PmenuSel ctermbg=12 ctermfg=15

inoremap <Up> <Up>
inoremap <Left> <Left>
inoremap <Down> <Down>
inoremap <Right> <Right>

let s:just_closed = 0 
let s:last_word = ""

function! s:check_complete()
	if pumvisible()
		return
	endif

    if exists('b:autocomplete_blocked') && b:autocomplete_blocked
        return 
    endif 

	let line = getline('.')
	let col = col('.') - 1

	if col == 0
		return ''
	endif

	let char = line[col-1]

	if char =~ '[a-zA-Z0-9_]'
		let word = matchstr(line[:col-1], '[a-zA-Z_][a-zA-Z0-9_]*$')
		if len(word) >= 0 && word != s:last_word 
            		let s:last_word = word 
			call feedkeys("\<C-n>", 'n')
		endif
	endif
		
endfunction

autocmd TextChangedI * call s:check_complete()

function! s:smart_tab()
	if pumvisible()
		return "\<C-n>"
	else
		return "\<Tab>"
	endif
endfunction

function! s:smart_s_tab()
	if pumvisible()
		return "\<C-p>"
	else
		return "\<S-Tab>"
	endif
endfunction

function! s:smart_enter()
	if pumvisible()
        	call feedkeys("\<C-y>", 'n')
        	let line = getline('.')
        	let col = col('.') - 1 
        	if col > 0 && line[col-1] !~ '[.(]'
            		return "\<Space>"
        	endif 
		return ""
    	else 
        	return "\<CR>"
	endif
endfunction 



function! s:smart_escape()
	if pumvisible()
        call feedkeys("\<C-e>", 'n')
        let s:just_closed = 1 
		return ""
	else
		return "\<Esc>"
	endif
endfunction

function! s:prevent_autocomplete()
    if s:just_closed
    	let s:just_closed = 0 
        let b:autocomplete_blocked = 1
        call timer_start(1000, function('s:enable_autocomplete'))
    endif 
endfunction 

function! s:enable_autocomplete(timer)
    let b:autocomplete_blocked = 0 
endfunction

function! s:after_escape()
    if s:just_closed
    	let s:just_closed = 0 
    endif 
endfunction 
autocmd CursorMovedI * call s:prevent_autocomplete()


"function! s:HandleCompletion()
"    let line = getline('.')
"    let col = col('.')
"    let before_cursor = strpart(line, 0, col)
"
"    if before_cursor =~ '()$'
"        call search('(', 'b')
"        call feedkeys("\<Right>", 'n')
"    elseif before_cursor =~ '(...)$'
"        call search('(', 'b')
"        call feedkeys("\<Right>", 'n')
"    endif 
"endfunction 
"autocmd CompleteDone * call s:HandleCompletion()

inoremap <expr> <Tab> <SID>smart_tab()
inoremap <expr> <S-Tab> <SID>smart_s_tab()
inoremap <expr> <Esc> <SID>smart_escape()



syntax on
filetype plugin indent on
set pumheight=15
set number
set lazyredraw 
set synmaxcol=200
set regexpengine=1 
set autoindent
set smartindent
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
