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
