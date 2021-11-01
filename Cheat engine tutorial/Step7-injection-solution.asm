alloc(newmem,2048)
label(returnhere)
label(originalcode)
label(exit)

newmem: //this is allocated memory, you have read,write,execute access
//place your code here
add dword ptr [ebx+000004A4],02

originalcode:
//sub dword ptr [ebx+000004A4],01

exit:
jmp returnhere

"Tutorial-i386.exe"+278C3:
jmp newmem
nop 2
returnhere: