" TODO: clean search pattern and restore cursor
function! jawa#files#Rename(new_class)
  let current_file = jawa#util#CurrentFile()
  let old_class = jawa#util#ClassName(current_file)
  let destination = jawa#util#CurrentDirectory() . '/' . a:new_class . '.java'
  let new_package = jawa#util#PackageName(destination)

  execute '%substitute/\v<' . old_class . '>/' . a:new_class . '/g'
  execute '%substitute/\v^package .+;$/package ' . new_package . ';/'
  call jawa#util#MvCurrent(destination)
endfunction
