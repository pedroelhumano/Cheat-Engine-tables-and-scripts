alloc(newmem,2048)
label(returnhere)
label(originalcode)
label(exit)

newmem: //Funciona en la version 3.6 del tutorial
cmp [ebx+10], 1
jne originalcode
fldz
jmp originalcode+5

originalcode:

mov [ebx+04],eax
fldz 

exit:
jmp returnhere

"Tutorial-i386.exe"+28E89:
jmp newmem
returnhere:

