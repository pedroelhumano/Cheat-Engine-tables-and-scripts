alloc(newmem,2048)
label(returnhere)
label(originalcode)
label(exit)

// CodeInjection para la version 3.6 del tutorial de cheat Engine
// Si usas otra version es posible que falle
// Otra opción es solo agregar la sección del newmem y originalcode nuevo a tu script.

newmem:
add dword ptr [ebx+000004A4],02

originalcode:
//sub dword ptr [ebx+000004A4],01

exit:
jmp returnhere

"Tutorial-i386.exe"+27B13:
jmp newmem
nop 2
returnhere:
