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
; (Paso 3: aqui reservaremos el espacio)
; ------------------------------------------------------------
section .bss
    ; 'resq 1' reserva espacio para 1 numero entero de 64 bits
    ; (8 bytes). Aqui guardaremos los valores mientras corre el programa.

    a:          resq 1      ; el numero del que buscamos el inverso
    p:          resq 1      ; el modulo
    resultado:  resq 1      ; donde quedara el inverso calculado


; ------------------------------------------------------------
; SECCION .text
; Aqui va el CODIGO: las instrucciones que ejecuta el programa.
; Cada modulo (funcion) vivira en esta seccion.
; (Pasos 4 en adelante: aqui escribiremos los modulos)
; ------------------------------------------------------------
section .text
    global main             ; 'main' es el punto de entrada (lo usa gcc)

main:
    ; Por ahora 'main' esta vacio: solo termina el programa.
    ; En el Paso 4 le pondremos su stack frame y la logica.
    mov     rax, 0          ; codigo de salida 0 (todo bien)
    ret                     ; regresar (terminar el programa)
