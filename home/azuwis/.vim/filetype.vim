" markdown filetype file
if exists("did_load_filetypes")
	finish
endif
augroup markdown
	autocmd!
	autocmd BufRead,BufNewFile *.md,*.mkd,*.mdwn   setfiletype mkd
	autocmd BufRead *.md,*.mkd,*.mdwn  set ai formatoptions=tcroqn2 comments=n:>
	autocmd BufNewFile *.md,*.mkd,*.mdwn   0r ~/.vim/template/template.mdwn | call TimeNow()
	fun TimeNow()
		if line("$") > 8
			let l = 8
		else
			let l = line("$")
		endif
		exe "1," . l . "g/TMPL-NOW/s/TMPL-NOW/" .
					\ strftime("%Y-%m-%d %H:%M:%S")
	endfun
augroup END
