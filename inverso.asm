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
; (Paso 2: aqui escribiremos los mensajes)
; ------------------------------------------------------------
section .data


; ------------------------------------------------------------
; SECCION .bss
; Aqui se RESERVA espacio en memoria para variables que todavia
; no tienen valor (se llenan mientras corre el programa),
; por ejemplo los numeros 'a' y 'p' que escribe el usuario.
; (Paso 3: aqui reservaremos el espacio)
; ------------------------------------------------------------
section .bss


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
