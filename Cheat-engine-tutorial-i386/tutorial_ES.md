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

De esta manera, la dirección: `"Tutorial-i386.exe"+2566B0` En nuestra lista es nuestro puntero y la dirección que hemos agregado activando el pointer es el valor que esta transfiriendo el puntero. Ese es el que modificamos y al reiniciar el programa, sin importar que pase, esa ubicación nunca cambiara.

### Step 7.

La inyección de código es otro aspecto importante en el gamehacking, inyectar un código que modifica otro. Tenemos un programa el cual al hacer click nos golpea una vez, nos exigen que al hacer click en vez de perder vida, sume 2 puntos. Se hace la misma formula de siempre y una vez agregada a la lista de address, se hace click derecho sobre ella y accedemos a `Find out what writes to this address.` Dentro, damos al botón click y vemos la posición de memoria que nos esta afectando nuestra vida, por lo que entramos en show dissambler para ver el código original en ASM.

```asm
sub dword ptr [ebx+000004A4],01
```

La instrucción SUB significa restar y vemos al final el 01 que indica el valor a restar. Podemos solucionar este ejercicio muy fácilmente modificando esta instrucción directamente cambiando el el `sub` por `add` que indica una sumar, y modificamos el 01 por 02.

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

Para el paso 8, entramos un tema de los mas comunes en los videojuegos, es casi una norma que esto siempre lo veremos y siempre ocurrira para algún valor, los punteros multinivel, mas concretamente, aunque el propio tutorial lo dice, es de 4 niveles. En este ejercicio se usara la siguiente plantilla.

```asm
Address = Value = ?

base ptr -> address + offset4 = address

base ptr -> address + offset3 = address

base ptr -> address + offset2 = address

static base -> address + offset1 = address
```

Paso a explicar paso a paso como llenarla, se entiende que la primera linea `address value = ?` Es la posición actual de memoria, lo iré haciendo de acuerdo a los datos que me salen a mi en este momento, pero si sigues este tut, lo mas probable es que te aparezcan otros números de otra manera a ti.

Empecemos, primero busquemos el valor como de costumbre y su posición de memoria, una vez encontramos empezamos a llenar la plantilla

```asm
Address = Value = 018A3678
```

Como abra pasado contigo, si intentamos buscar que posición de memoria tiene a `018A3678` no encontramos nada, de esa manera entendemos que es un puntero multinivel. Click derecho y buscamos que tipo de dato accede `find out what accesses this address` Al activar el boton de cambiar valor en el programa, arroja dos lineas

```asm
0042843E - 89 46 18  - mov [esi+18],eax
00428449 - 8B 46 18  - mov eax,[esi+18]
```

En este caso vemos la persistencia del esi+18 que se repite, este 18 se representa como 0x18 y es un offset. Un offset es un salto o una distancia entre dos posiciones de memoria, entendemos ademas por el mov, que se esta moviendo cierta información a esi+offset. Seguimos llenando la plantilla y en la siguiente linea nos da de esta manera.

```asm
base ptr -> address + 0x18 = 018A3678
```

Si cambiamos el valor de la igualdad, restamos 018A3678-18 nos da como resultado `18A 3660` y de ahí obtienes el valor del addres que falta. De hecho, en realidad si nos fijamos en el propio valor que incorpora cheat engine en ESI, dentro de la pantalla de accesses this address tiene ese mismo valor

```asm
base ptr -> 18A3660 + 0x18 = 018A3678
```

Solo falta tener el base ptr, que es el puntero en si, ya en este punto esta mucho mas fácil, porque en realidad debemos entender que, el valor del base ptr es el address sin la suma del offset, es decir, existe una posición de memoria (ESI en este caso) que se le suma un offset. Entonces para este caso, debemos buscar que posición de memoria tiene contenido a 18A3660. Lo buscamos de la manera tradicional en cheat engine y obtenemos 0182BC20. De esta manera finalmente podemos llenar la primera fila de nuestra plantilla he iniciando la segunda fila, de esta manera

```asm
Address = Value = 018A3678
0182BC20 -> 18A3660 + 0x18 = 018A3678
base ptr -> address + offset3 = 0182BC20
```

Lo siguiente sera repetir el mismo procedimiento las veces que sean necesarias, en un videojuego real, suele ser mas difícil ya que hay punteros multinivel con cantidades increíbles de saltos en la memoria (he visto hasta 30 pero seguro hay mas). Por lo que este es un procedimiento que hay que hacerse con mucha paciencia y probando enorme cantidad de veces.

Para ir avanzando un poco mas rápido, simplemente se repite el procedimiento y vemos en la segunda linea el offset es 0, por o que el address permanece igual, así que buscamos ese nuevo valor en el siguiente puntero, quedando asi.

```asm
Address = Value = 018A3678
0182BC20 -> 18A3660 + 0x18 = 018A3678
0184B264 -> 0182BC20 + 0 = 0182BC20
base ptr -> address + offset2 = 0184B264
```

Repite nuevamente el proceso, para esta tercera iteración me da el offset 14, por lo que repitiendo el mismo proceso, me arroja los siguientes resultados.

```asm
Address = Value = 018A3678
0182BC20 -> 18A3660 + 0x18 = 018A3678
0184B264 -> 0182BC20 + 0 = 0182BC20
018CB5DC -> 184B250 + 0x14 = 0184B264
static base -> address + offset1 = 018CB5DC
```

En esta ultima iteración, sabemos (porque asi nos lo dice el ejercicio) que sera el ultimo nivel del puntero, nuevamente repetimos el proceso, me arroja como valor en el offset 0C, y queda así.

```asm
Address = Value = 018A3678
0182BC20 -> 18A3660 + 0x18 = 018A3678
0184B264 -> 0182BC20 + 0 = 0182BC20
018CB5DC -> 184B250 + 0x14 = 0184B264
static base -> 18CB5D0 + 0C = 018CB5DC
```

Si buscamos esta posición de memoria, nos da como resultado que el static base es `"Tutorial-i386.exe"+2566E0` Este es el resultado que estábamos buscando!! es justo donde se inicia el puntero y no cambiara nunca por lo que este puntero es valido para cualquier persona, finalmente hemos llenado la plantilla.

```asm
Address = Value = 018A3678
0182BC20 -> 18A3660 + 0x18 = 018A3678
0184B264 -> 0182BC20 + 0 = 0182BC20
018CB5DC -> 184B250 + 0x14 = 0184B264
"Tutorial-i386.exe"+2566E0 -> 18CB5D0 + 0C = 018CB5DC
```

Sin embargo, esta es la posición de memoria, y no el valor que buscamos, por lo que ahora necesitamos el valor, es decir, lo que transfiere este puntero, nuevamente al igual que el paso 6 vamos a "add Address manually` seleccionamos pointer y ademas damos click donde dice add offset, en total debemos tener 4 cuatro campos que fue el caso para este ejercicio. Se ve muy similar a la plantilla que tenemos, por lo que ahora solo debemos llenar los campos en base a la plantilla.

Con esto, finalizamos el ejercicio, bastante complejo pero muy apegado a la realidad de los punteros en desafíos reales. Debemos tildar con 5000 el valor y asi pasamos el paso final el step 9.

### Step 9.

En este paso controlamos al equipo 1 y el equipo 2 es nuestro enemigo. Al hacer autoplay invariablemente nuestro equipo será derrotado. Tenemos que encontrar la manera de derrotar al equipo dos al lograr hacer el autoplay.

Lo primero, debemos encontrar las posiciones de vida de los 4 jugadores. En este caso todos son valores de tipo float. Vamos a ver qué escribe sobre esta posición de memoria, nos retorna un mov y luego accedemos al desensamblador para ver el memory viewer.

En este punto hacer un NOP no sirve porque la función de bajar vida a los jugadores, todas utilizan la misma, por lo que si lo hacemos, no bajará nuestra vida, pero tampoco la de nuestros enemigos.

Como en la propia instrucción del ejercicio nos indica que es código compartido, muy probablemente tengamos en una estructura de datos los datos de la vida de nuestros personajes. Para poder hacer una desestructura vamos desde el memory Viewer -> Tools -> Dissect Data Structures.

Una vez allí debemos agregar todas las direcciones de memoria de nuestros cuatro personajes. También podemos personalizar un poco más esta tabla de estructuras y separarlos por grupos. Una vez agregadas las direcciones de memoria actuales de nuestros cuatro personajes les restamos 4 a cada posición de memoria, el motivo es que si nos fijamos cuando accedimos a la sección donde indicaba qué instrucción escribe sobre nuestra posición de memoria, indicaba `mov [ebx+04]`, eax. Ese 04 indica un offset, por lo que en teoría al restarlo nos debería indicar un puntero.

Si hemos hecho todo correctamente, se activará una estructura de datos en la cual al revisar podemos ver varios datos de interés, como la vida, el nombre, pero sobre todo en el offset 0x10 veremos un valor que indica 1 para nuestros personajes y 2 para el otro equipo. Si bien en estricto rigor no sabemos por qué el programador hizo esto, para nosotros esto puede representar fácilmente el Team 1 y 2. Este dato es el que usaremos para crear un script que nos permita saltar.

De nuevo en el Memory Viewer vamos a: Tools -> Auto Assemble, integramos un code injection y agregamos el siguiente código:

```asm
alloc(newmem,2048)
label(returnhere)
label(originalcode)
label(exit)

newmem: //Funciona en la versión 3.6 del tutorial
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
```

De esta manera se evalúa el offset de la posición 10 es 1 (es decir, el equipo 1), luego en jne que significa `jump not equal` (salta si no es igual) al originalCode. En otras palabras, si el código lo que hace es evaluar si estamos en el team 2, si es así, pues el código sigue su curso normal, en cambio, si estamos en el team 1, no hace el mov, hace el fldz que es necesario ya que estaba antes y luego retorna al originalcode+5. El offset de 5 no es tampoco un número al azar, sino que en el memory view, luego de ejecutar el fldz, la siguiente instrucción tiene un offset de 5 con respecto al mov. De esta manera, solo indicamos "sigue tu curso normal" y así hemos resuelto el paso 9 del tutorial.
