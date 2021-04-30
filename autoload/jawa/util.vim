" ClassName returns the name of the top level class of the given Java file
"
" Args:
"   file (str): a path to a Java file
function! jawa#util#ClassName(file)
  call s:assertJavaFile(a:file)

  return fnamemodify(a:file, ":t:r")
endfunction

" PackageName returns the name of package in which this java file belongs
"
" Args:
"   file (str): a path to a Java file
function! jawa#util#PackageName(file)
  call s:assertJavaFile(a:file)

  try
    let relativized = s:relativize(fnamemodify(a:file, ":h"), "src/main/java")
  catch
    let relativized = s:relativize(fnamemodify(a:file, ":h"), "src/test/java")
  endtry

  return substitute(relativized, "/", ".", "g")
endfunction

function! s:assertJavaFile(file)
  if !s:isJavaFile(a:file)
    throw "Not a java file: " . a:file
  endif
endfunction
" relativize constructs a relative path between a given file and a given path
"
" If path is completely contained in file, this function will assume that everything that comes
" before also matches. For example, if file is 'a/b/c/d/myfile' and path 'b/c', it will assume path
" was in fact 'a/b/c' and return 'd/myfile'
"
" Args:
"   file (str): a path to a file
"   path (str): a path to relativize file against
function! s:relativize(file, path)
  if a:file !~ '^.*' . a:path . '.*$'
    throw a:file . " cannot be relativized against " . a:path
  endif

  let relativized = substitute(a:file, '.*' . a:path . '/', "", "")
  return relativized
endfunction

" isJavaFile returns true if file points to a Java file
"
" Args:
"   file (str): a path to a file
function! s:isJavaFile(file)
  return a:file =~ "\\.java$"
endfunction

" EchoSuccess colors msg to signify success
"
" Args:
"   msg (str): a message to echo
function! jawa#util#EchoSuccess(msg)
  call s:echo(a:msg, 'Function')
endfunction

" EchoError colors msg to signify failure
"
" Args:
"   msg (str): a message to echo
function! jawa#util#EchoError(msg)
  call s:echo(a:msg, 'ErrorMsg')
endfunction

" EchoWarning colors msg to signify something went wrong
"
" Args:
"   msg (str): a message to echo
function! jawa#util#EchoWarning(msg)
  call s:echo(a:msg, 'WarningMsg')
endfunction

" echo msg with the color given by the highlight group hi
"
" Args:
"   msg (str): a message to echo
"   hi (str): a string representation of a highlight group
function! s:echo(msg, hi)
  " because hi is a string but echohl takes a variable as argument, use execute
  execute "echohl " . a:hi
  echo "jawa.vim: " . a:msg
  echohl None
endfunction

" mvCurrent moves the current buffer to a given destination
"
" Args:
"   destination (str): where to move the current buffer
function! jawa#util#MvCurrent(destination)
  let source = @%
  silent execute "saveas " . a:destination
  silent execute "!rm " . source
  " The previous buffer now point towards the one we removed
  bwipeout #
  redraw!
endfunction

" CurrentFile returns the current file 
function! jawa#util#CurrentFile()
  return expand("%")
endfunction

" CurrentFile returns the directory of the current file 
function! jawa#util#CurrentDirectory()
  return expand("%:p:h")
endfunction
