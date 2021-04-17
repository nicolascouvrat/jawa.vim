function! jawa#files#Rename(new_class)
  let old_class = jawa#util#ClassName(jawa#util#CurrentFileName())
  execute '%substitute/\v<' . old_class . '>/' . a:new_class . '/g'
  let destination = jawa#util#CurrentDirectory() . '/' . a:new_class . '.java'
  call jawa#util#MvCurrent(destination)
endfunction
