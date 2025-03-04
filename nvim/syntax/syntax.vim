augroup syntax
au  BufNewFile,BufReadPost *.lmp so ~/.vim/syntax/lammps.vim
au  BufNewFile,BufReadPost in.* so ~/.vim/syntax/lammps.vim
au  BufNewFile,BufReadPost *.in so ~/.vim/syntax/lammps.vim
au  BufNewFile,BufReadPost *.lammps so ~/.vim/syntax/lammps.vim

au  BufNewFile,BufReadPost *.plumed so ~/.vim/syntax/plumedf.vim
augroup END
