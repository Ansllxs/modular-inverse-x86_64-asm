; ============================================================
; Proyecto 1 - Inverso Multiplicativo Modular
; Arquitectura de Computadoras
;
; Programa en ensamblador x86-64 usando MASM en Visual Studio.
; El programa lee dos enteros a y p, y calcula el inverso
; multiplicativo modular de a modulo p, si existe.
;
; El calculo se hace con el algoritmo extendido de Euclides.
; Los datos se pasan entre procedimientos usando la pila.
;
;Integrantes del proyecto:
; Julio Quirós Vargas
; Fabiola González Gómez
; Angie Alpizar Porras
; Jose Gabriel Marin Aguilar
; ============================================================

option casemap:none

includelib ucrt.lib
includelib vcruntime.lib
includelib legacy_stdio_definitions.lib

EXTERN printf:PROC
EXTERN scanf:PROC

PUBLIC main

.data
msg_pedir_a    db "Ingrese el numero a: ", 0
msg_pedir_p    db "Ingrese el modulo p: ", 0
formato_num    db "%lld", 0

msg_resultado  db "El inverso de %lld modulo %lld es: %lld", 13, 10, 0
msg_error      db "El numero no tiene inverso multiplicativo modular", 13, 10, 0

; ============================================================
; PARTE 1: Entrada, salida y control general
; Incluye:
;   main
;   leerDatos
;   imprimirResultado
;   imprimirError
;   ajustarPositivo
; ============================================================

; -------------------------------------------------------------
; main
; Variables locales:
;   [rbp-8]  = a
;   [rbp-16] = p
;   [rbp-24] = x
;   [rbp-32] = mcd
;   [rbp-40] = resultado positivo
; -------------------------------------------------------------
.code
main PROC
    push rbp
    mov rbp, rsp
    sub rsp, 80

    ;leerDatos(&a, &p)
    lea rax, [rbp-8]
    push rax
    lea rax, [rbp-16]
    push rax
    call leerDatos
    add rsp, 16

    ;inversoModular(a, p, &x, &mcd)
    push QWORD PTR [rbp-8]
    push QWORD PTR [rbp-16]
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-32]
    push rax
    call inversoModular
    add rsp, 32

    ;si mcd != 1, no existe inverso
    mov rax, QWORD PTR [rbp-32]
    cmp rax, 1
    jne main_no_existe

    ;ajustarPositivo(x, p, &resultado)
    push QWORD PTR [rbp-24]
    push QWORD PTR [rbp-16]
    lea rax, [rbp-40]
    push rax
    call ajustarPositivo
    add rsp, 24

    ;imprimirResultado(a, p, resultado)
    push QWORD PTR [rbp-8]
    push QWORD PTR [rbp-16]
    push QWORD PTR [rbp-40]
    call imprimirResultado
    add rsp, 24

    jmp main_fin

main_no_existe:
    call imprimirError

main_fin:
    xor eax, eax
    leave
    ret
main ENDP


; -------------------------------------------------------------
; leerDatos
; Parametros por pila:
;   [rbp+24] = direccion donde guardar a
;   [rbp+16] = direccion donde guardar p
; -------------------------------------------------------------
leerDatos PROC
    push rbp
    mov rbp, rsp
    and rsp, -16

    ;printf("Ingrese el numero a: ")
    mov rcx, OFFSET msg_pedir_a
    sub rsp, 32
    call printf
    add rsp, 32

    ;scanf("%lld", &a)
    mov rcx, OFFSET formato_num
    mov rdx, QWORD PTR [rbp+24]
    sub rsp, 32
    call scanf
    add rsp, 32

    ;printf("Ingrese el modulo p: ")
    mov rcx, OFFSET msg_pedir_p
    sub rsp, 32
    call printf
    add rsp, 32

    ;scanf("%lld", &p)
    mov rcx, OFFSET formato_num
    mov rdx, QWORD PTR [rbp+16]
    sub rsp, 32
    call scanf
    add rsp, 32

    leave
    ret
leerDatos ENDP


; -------------------------------------------------------------
; imprimirResultado
; Parametros por pila:
;   [rbp+32] = a
;   [rbp+24] = p
;   [rbp+16] = resultado
; -------------------------------------------------------------
imprimirResultado PROC
    push rbp
    mov rbp, rsp
    and rsp, -16

    mov rcx, OFFSET msg_resultado
    mov rdx, QWORD PTR [rbp+32]     ; a
    mov r8,  QWORD PTR [rbp+24]     ; p
    mov r9,  QWORD PTR [rbp+16]     ; resultado

    sub rsp, 32
    call printf
    add rsp, 32

    leave
    ret
imprimirResultado ENDP


; -------------------------------------------------------------
; imprimirError
; No recibe parametros
; -------------------------------------------------------------
imprimirError PROC
    push rbp
    mov rbp, rsp
    and rsp, -16

    mov rcx, OFFSET msg_error

    sub rsp, 32
    call printf
    add rsp, 32

    leave
    ret
imprimirError ENDP

; -------------------------------------------------------------
; ajustarPositivo
; Parametros por pila:
;   [rbp+32] = x
;   [rbp+24] = p
;   [rbp+16] = direccion donde guardar resultado
; -------------------------------------------------------------
ajustarPositivo PROC
    push rbp
    mov rbp, rsp

    mov rax, QWORD PTR [rbp+32]
    cqo
    idiv QWORD PTR [rbp+24]

    ;rdx tiene x mod p
    mov rcx, rdx

    cmp rcx, 0
    jge ajustar_ok

    add rcx, QWORD PTR [rbp+24]

ajustar_ok:
    mov rax, QWORD PTR [rbp+16]
    mov QWORD PTR [rax], rcx

    leave
    ret
ajustarPositivo ENDP

; ============================================================
; PARTE 2: Calculo del inverso modular
; Incluye:
;   validarDatos
;   euclidesExtendido
;   inversoModular
; ============================================================

; -------------------------------------------------------------
; validarDatos
; Parametros por pila:
;   [rbp+32] = a
;   [rbp+24] = p
;   [rbp+16] = direccion donde guardar valido
;              valido = 1 si se puede calcular
;              valido = 0 si no
; -------------------------------------------------------------
validarDatos PROC
    push rbp
    mov rbp, rsp

    ;valido = 0 por defecto
    mov rax, QWORD PTR [rbp+16]
    mov QWORD PTR [rax], 0

    ;p debe ser mayor que 1
    mov rax, QWORD PTR [rbp+24]
    cmp rax, 1
    jle validar_fin

    ;si a es multiplo de p, no tiene inverso
    mov rax, QWORD PTR [rbp+32]
    cqo
    idiv QWORD PTR [rbp+24]

    cmp rdx, 0
    je validar_fin

    ;valido = 1
    mov rax, QWORD PTR [rbp+16]
    mov QWORD PTR [rax], 1

validar_fin:
    leave
    ret
validarDatos ENDP


; -------------------------------------------------------------
; euclidesExtendido
; Calcula x, y y mcd tales que:
;   a*x + p*y = mcd(a,p)
;
; Parametros por pila:
;   [rbp+48] = a
;   [rbp+40] = p
;   [rbp+32] = direccion donde guardar x
;   [rbp+24] = direccion donde guardar y
;   [rbp+16] = direccion donde guardar mcd
;
; Variables locales:
;   [rbp-8]  = old_r
;   [rbp-16] = r
;   [rbp-24] = old_s
;   [rbp-32] = s
;   [rbp-40] = old_t
;   [rbp-48] = t
;   [rbp-56] = q
;   [rbp-64] = residuo
; -------------------------------------------------------------
euclidesExtendido PROC
    push rbp
    mov rbp, rsp
    sub rsp, 64

    ;old_r = a
    mov rax, QWORD PTR [rbp+48]
    mov QWORD PTR [rbp-8], rax

    ;r = p
    mov rax, QWORD PTR [rbp+40]
    mov QWORD PTR [rbp-16], rax

    ;old_s = 1, s = 0
    mov QWORD PTR [rbp-24], 1
    mov QWORD PTR [rbp-32], 0

    ;old_t = 0, t = 1
    mov QWORD PTR [rbp-40], 0
    mov QWORD PTR [rbp-48], 1

euclides_loop:
    cmp QWORD PTR [rbp-16], 0
    je euclides_fin

    ;q = old_r / r
    ;residuo = old_r mod r
    mov rax, QWORD PTR [rbp-8]
    cqo
    idiv QWORD PTR [rbp-16]

    mov QWORD PTR [rbp-56], rax
    mov QWORD PTR [rbp-64], rdx

    ;(old_r, r) = (r, residuo)
    mov rax, QWORD PTR [rbp-16]
    mov QWORD PTR [rbp-8], rax

    mov rax, QWORD PTR [rbp-64]
    mov QWORD PTR [rbp-16], rax

    ;nuevo_s = old_s - q*s
    mov rax, QWORD PTR [rbp-56]
    imul rax, QWORD PTR [rbp-32]

    mov rcx, QWORD PTR [rbp-24]
    sub rcx, rax

    ;old_s = s
    mov rax, QWORD PTR [rbp-32]
    mov QWORD PTR [rbp-24], rax

    ;s = nuevo_s
    mov QWORD PTR [rbp-32], rcx

    ;nuevo_t = old_t - q*t
    mov rax, QWORD PTR [rbp-56]
    imul rax, QWORD PTR [rbp-48]

    mov rcx, QWORD PTR [rbp-40]
    sub rcx, rax

    ;old_t = t
    mov rax, QWORD PTR [rbp-48]
    mov QWORD PTR [rbp-40], rax

    ;t = nuevo_t
    mov QWORD PTR [rbp-48], rcx

    jmp euclides_loop

euclides_fin:
    ;si el mcd sale negativo, se ajusta el signo
    mov rax, QWORD PTR [rbp-8]
    cmp rax, 0
    jge euclides_guardar

    neg rax
    mov QWORD PTR [rbp-8], rax
    neg QWORD PTR [rbp-24]
    neg QWORD PTR [rbp-40]

euclides_guardar:
    ;guardar mcd
    mov rax, QWORD PTR [rbp+16]
    mov rcx, QWORD PTR [rbp-8]
    mov QWORD PTR [rax], rcx

    ;guardar x
    mov rax, QWORD PTR [rbp+32]
    mov rcx, QWORD PTR [rbp-24]
    mov QWORD PTR [rax], rcx

    ;guardar y
    mov rax, QWORD PTR [rbp+24]
    mov rcx, QWORD PTR [rbp-40]
    mov QWORD PTR [rax], rcx

    leave
    ret
euclidesExtendido ENDP


; -------------------------------------------------------------
; inversoModular
; Parametros por pila:
;   [rbp+40] = a
;   [rbp+32] = p
;   [rbp+24] = direccion donde guardar x
;   [rbp+16] = direccion donde guardar mcd
;
; Variables locales:
;   [rbp-8]  = valido
;   [rbp-16] = y
; -------------------------------------------------------------
inversoModular PROC
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ;validarDatos(a, p, &valido)
    push QWORD PTR [rbp+40]
    push QWORD PTR [rbp+32]
    lea rax, [rbp-8]
    push rax
    call validarDatos
    add rsp, 24

    cmp QWORD PTR [rbp-8], 1
    je inverso_calcular

    ;si no es valido, x = 0 y mcd = 0
    mov rax, QWORD PTR [rbp+24]
    mov QWORD PTR [rax], 0

    mov rax, QWORD PTR [rbp+16]
    mov QWORD PTR [rax], 0

    jmp inverso_fin

inverso_calcular:
    ;euclidesExtendido(a, p, &x, &y, &mcd)
    push QWORD PTR [rbp+40]
    push QWORD PTR [rbp+32]

    mov rax, QWORD PTR [rbp+24]
    push rax

    lea rax, [rbp-16]
    push rax

    mov rax, QWORD PTR [rbp+16]
    push rax

    call euclidesExtendido
    add rsp, 40

inverso_fin:
    leave
    ret
inversoModular ENDP

END
