## Solución 
### Step 2.
Scan con exact value y next value. Cheat engine guarda en las address las posiciones de memoria estáticas de color negro, de esta manera esa posición nunca va a cambiar.
### Step 3.
En caso de un valor inicial desconocido, unicamente se cambia el primer scan a tipo de búsqueda a Unknown initial value, posterior a ello, solo vamos jugando con las opciones que ofrece cheat engine como buscar un valor que se decrementa o que cambia, hasta rastrear la posición de memoria, en este caso, vuelve a ser una posición de memoria estática.
### Step 4.
Este ejercicio solo cambia en que la búsqueda debe hacerse bajo los parámetros que estamos tratando con valores de tipo flotande y doubles. Por lo que sigue siendo de fácil resolución ya que solo hay que cambiar el value type.
### Step 5.
Este ejercicio entra ya en aspectos mas complejos de Cheat Engine. Simula, que cada vez que se reinicia una partida (Como puede ser que se carga una partida guardada) La información de una posición de memoria cambia y por ende no afectamos realmente el valor de la posición. La solución consta de varios pasos, una vez localizada la posición de memoria de donde se guarda la vida, le damos click derecho en las address ya guardadas y nos fijamos que tenemos 2 opciones con las teclas F5 y F6.
- Find out what accesses this address.
- Find out what writes to this address.

El primero significa quien accede en modo solo lectura o bien para extraer alguna información, y el segundo quien sobre escribe información en esa posición.
Para la solución de este ejercicio, nos solventamos en la segunda opción, quien sobre escribe y si hacemos click en el change value del programa, nos aparece la ejercicio de la linea de cogido en ASM que esta funcionando en este momento.
Nos fijamos en la instrucción la cual dice:
```asm
00426C12 - 89 10  - mov [eax],edx
```
Esto quiere decir: mueve el valor de edx en la posición de eax. EDX y EAX son registro para sistemas de 32bits mientras que mov es la instrucción en ASM.

Si nos fijamos en el cuadro inferior indica que valor es cada uno donde (en mi caso):
```asm
EAX=01733080
EDX=00000243
```
Donde EAX es la posición donde actualmente se guarda la vida y EDX es su valor, puesto que si usamos la calculadora de windows y transformamos el valor 243 de hex a decimal arroja como resultado: 579, que es justo el valor actual en mi programa.

La solución aquí radica en que esta linea de código esta molestando, por ende debemos sustituirlo por una instrucción NOP que en asm indica no haga nada.

Para ellos damos click derecho en la instrucción y indicamos remplazar por NOP, o bien desde el show disassembler lo mismo, damos click en la instrucción y reemplazamos por NOP.
### Step 6.
Para los punteros, entramos en un aspecto mas avanzado y común de la vida real en los videojuegos, los punteros, un tipo de variable en la cual se apunta a otra variable y envía el contenido a ella. En este ejercicio aunque podemos modificar el valor, al cambiar de puntero, perdemos la posición de memoria donde anteriormente estaba la vida. Cambiar de puntero se aplica mas a los casos donde se reinicia el juego o carga partida, suele ser un caso por mucho mas común que el anterior del step 5.

Para este caso tenemos el puntero mas simple posible, es decir un puntero de un solo nivel. En la realidad los punteros suelen ser de muchísimos niveles, pero por algo empezamos.

La resolución aquí es bastante simple, una vez encontramos la posición donde se guarda la vida debemos buscar el valor que guarda esa posición de memoria, por lo que por ejemplo, en mi caso indica `016E7F78` esa posición es el address de mi vida y en algun lugar del programa algo debe guardar esa address, por lo que realizamos una segunda búsqueda pero activamos donde dice `hex` de manera tal que indicamos que buscamos esa hexadecimal, en mi caso unicamente aparece un resultado, el cual es nuestra respuesta. La agregamos a la lista y si hacemos click en su address nos damos cuenta que arroja mas alla de un hex. En mi caso indica: `"Tutorial-i386.exe"+2566B0` Esto contiene mucha información por si mismo, es decir de donde nace y que información esta enviando.

Copiamos todo ello y vamos al boton en la misma lista que dice: "add Address manually". Como ya sabemos que tratamos con un puntero, activamos donde dice pointer y en la parte inferior copiamos el valor del puntero y damos ok.

De esta manera, la dirección:  `"Tutorial-i386.exe"+2566B0` En nuestra lista es nuestro puntero y la dirección que hemos agregado activando el pointer es el valor que esta transfiriendo el puntero. Ese es el que modificamos y al reiniciar el programa, sin importar que pase, esa ubicación nunca cambiara.
### Step 7.
La inyección de código es otro aspecto importante en el gamehacking, inyectar un código que modifica otro. Tenemos un programa el cual al hacer click nos golpea una vez, nos exigen que al hacer click en vez de perder vida, sume 2 puntos. Se hace la misma formula de siempre y una vez agregada a la lista de address, se hace click derecho sobre ella y accedemos a `Find out what writes to this address.` Dentro, damos al botón click y vemos la posición de memoria que nos esta afectando nuestra vida, por lo que entramos en show dissambler para ver el código original en ASM.
```asm
sub dword ptr [ebx+000004A4],01
```
La instrucción SUB significa restar y vemos al final el 01 que indica el valor a restar.  Podemos solucionar este ejercicio muy fácilmente modificando esta instrucción directamente cambiando el el `sub` por `add` que indica una sumar, y modificamos el 01 por 02.

Sin embargo, resolvamos esto por la manera dificil usando el code injector integrando en cheat engine. Para ellos desde la ventana del Memory View vamos al menu `Tools` -> `auto Assamble` (ctrl + A para los amigos) Se nos abrirá un editor de código. Cheat engine tiene integrado algunos templates de utilidad, por lo que en este editor vamos el menu `Template` -> `code injection`.

No debemos confundirnos con la lectura ni verla demasiado complicada, observemos dos secciones importantes de momento. `originalcode:` Donde se ejecuta el código original y `newmem:` Donde se ejecutara nuestra inyección de código. Si ya lo abras supuesto, la solución aquí seria agregar un código que sume dos en newmen y eliminar el código de original. Para ello solo copiamos y pegamos en newmen el código original y cambiamos sub por add y el 01 por 02, mientras tanto en originalcode solo agregamos // para que quede comentada la linea.. Esto resuelve el ejercicio, solo damos ejecutar y el código quedara inyectado. El código queda así:

```asm
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
```
### Step 8.
