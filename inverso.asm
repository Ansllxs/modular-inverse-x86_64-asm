; ============================================================
; Proyecto 1 - Inverso Multiplicativo Modular
; IC3101 Arquitectura de Computadoras - Grupo 3
; Integrantes:
;   - Angie Mariela Alpizar Porras
;   - Julio Cesar Quiros Vargas
; Ensamblador: NASM (sintaxis Intel) - x86_64
; ============================================================

; ------------------------------------------------------------
; SECCION .data
; Aqui van los datos que YA tienen un valor desde el inicio,
; por ejemplo los mensajes de texto que se muestran al usuario.
; ------------------------------------------------------------
section .data
    ; Mensajes que se le muestran al usuario.
    ; 'db' = "define byte": guarda texto byte por byte.
    ; El 0 del final es OBLIGATORIO: marca el fin del texto (lo
    ; necesitan printf y scanf de C para saber donde termina).
    ; El numero 10 es el salto de linea (tecla Enter).

    msg_pedir_a:    db  "Ingrese el numero a: ", 0
    msg_pedir_p:    db  "Ingrese el modulo p: ", 0
    msg_resultado:  db  "El inverso de a modulo p es: %ld", 10, 0

    ; Formato para leer un numero entero con scanf (%ld = entero largo).
    formato_num:    db  "%ld", 0


; ------------------------------------------------------------
; SECCION .bss
; Aqui se RESERVA espacio en memoria para variables que todavia
; no tienen valor (se llenan mientras corre el programa),
; por ejemplo los numeros 'a' y 'p' que escribe el usuario.
; ------------------------------------------------------------
section .bss
    ; A proposito esta VACIA.
    ; La regla del proyecto prohibe variables globales: los numeros
    ; a, p y el resultado se guardan como variables LOCALES dentro del
    ; stack frame de cada modulo, y se comunican por la pila.


; ------------------------------------------------------------
; SECCION .text
; Aqui va el CODIGO: las instrucciones que ejecuta el programa.
; Cada modulo (funcion) vivira en esta seccion.
; ------------------------------------------------------------
section .text
    global main             ; 'main' es el punto de entrada (lo usa gcc)
    extern printf           ; funcion de C para imprimir en consola
    extern scanf            ; funcion de C para leer del teclado

; ============================================================
; main: ordena todo el programa.
;   1. leer a y p
;   2. calcular el inverso (modulo de Julio)
;   3. si no existe inverso -> mensaje de error
;      si existe -> dejarlo positivo e imprimirlo
;
; Variables LOCALES (dentro del stack frame de main):
;   [rbp-8]  = a          [rbp-32] = mcd  (para saber si hay inverso)
;   [rbp-16] = p          [rbp-40] = resultado (inverso ya positivo)
;   [rbp-24] = x          (inverso "crudo", puede salir negativo)
; ============================================================
main:
    push    rbp             ; guardar el rbp del que nos llamo
    mov     rbp, rsp        ; rbp marca el inicio de NUESTRO stack frame
    sub     rsp, 48         ; reservar espacio para las variables locales

    ; (1) Leer a y p. Le pasamos a leerDatos las DIRECCIONES
    ;     donde queremos que guarde cada numero (por la pila).
    lea     rax, [rbp-8]    ; direccion de a
    push    rax
    lea     rax, [rbp-16]   ; direccion de p
    push    rax
    call    leerDatos
    add     rsp, 16         ; sacar los 2 parametros de la pila

    ; (2) Calcular el inverso (lo hace el modulo de Julio).
    ;     Le pasamos a y p (valores) y las direcciones de x y mcd.
    push    qword [rbp-8]   ; a
    push    qword [rbp-16]  ; p
    lea     rax, [rbp-24]   ; direccion de x
    push    rax
    lea     rax, [rbp-32]   ; direccion de mcd
    push    rax
    call    inversoModular
    add     rsp, 32

    ; (3) Solo existe inverso si mcd(a, p) == 1
    mov     rax, [rbp-32]   ; traer mcd
    cmp     rax, 1
    jne     main_no_existe  ; si mcd != 1, no hay inverso

    ; (4) Dejar el resultado positivo: resultado = x mod p (positivo)
    push    qword [rbp-24]  ; x
    push    qword [rbp-16]  ; p
    lea     rax, [rbp-40]   ; direccion de resultado
    push    rax
    call    ajustarPositivo
    add     rsp, 24

    ; (5) Mostrar el resultado.
    push    qword [rbp-40]  ; el inverso ya positivo
    call    imprimirResultado
    add     rsp, 8
    jmp     main_fin

main_no_existe:
    call    imprimirError   ; "El numero no tiene inverso..."

main_fin:
    mov     rax, 0          ; codigo de salida 0 (todo bien)
    leave                   ; deshacer el stack frame (rsp = rbp; pop rbp)
    ret                     ; terminar el programa


; ============================================================
; leerDatos: muestra los mensajes y lee a y p del usuario.
; Parametros (recibidos por la pila):
;   [rbp+24] = direccion donde guardar a
;   [rbp+16] = direccion donde guardar p
; No devuelve nada: escribe los numeros en esas direcciones.
; ============================================================
leerDatos:
    push    rbp
    mov     rbp, rsp
    and     rsp, -16        ; alinear la pila a 16 bytes (lo exigen printf/scanf)

    ; --- pedir y leer a ---
    lea     rdi, [msg_pedir_a]  ; 1er argumento de printf: el mensaje
    xor     rax, rax            ; rax = 0 (printf lo requiere por los varargs)
    call    printf

    lea     rdi, [formato_num]  ; 1er argumento de scanf: "%ld"
    mov     rsi, [rbp+24]       ; 2do argumento: la direccion de a
    xor     rax, rax
    call    scanf

    ; --- pedir y leer p ---
    lea     rdi, [msg_pedir_p]
    xor     rax, rax
    call    printf

    lea     rdi, [formato_num]
    mov     rsi, [rbp+16]       ; la direccion de p
    xor     rax, rax
    call    scanf

    leave
    ret
