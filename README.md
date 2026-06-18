# Inverso Multiplicativo Modular en x86_64 (NASM)

Proyecto 1 · IC3101 Arquitectura de Computadoras · Grupo 3 · Primer semestre 2026

**Integrantes**
- Angie Mariela Alpízar Porras
- Julio César Quirós Vargas

## Descripción

Programa en ensamblador **x86_64** (sintaxis Intel, NASM) que calcula el
**inverso multiplicativo modular** de un entero en un campo ℤ_p.

Dados dos enteros `a` y `p`, busca un entero `b` tal que `(a * b) mod p = 1`.
Se calcula con el **Algoritmo Extendido de Euclides**; si `mcd(a, p) != 1`, el
inverso no existe.

> Ejemplo: el inverso de 3 módulo 7 es 5, porque `3 * 5 = 15` y `15 mod 7 = 1`.

## Estado del proyecto

**Parte 1 · Angie (interfaz, E/S y control) — completada**
- [x] `main` — orquesta: leer datos → calcular → imprimir
- [x] `leerDatos` — lee `a` y `p` con `scanf`
- [x] `imprimirResultado` — muestra "El inverso de a modulo p es: <n>"
- [x] `ajustarPositivo` — deja el resultado en el rango `0..p-1`

**Parte 2 · Julio (la matemática) — pendiente**
- [ ] `validarDatos` — valida los datos de entrada
- [ ] `euclidesExtendido` — núcleo: calcula `x`, `y` y `mcd`
- [ ] `inversoModular` — usa Euclides y decide si existe inverso (`mcd == 1`)
- [ ] `imprimirError` — muestra "El numero no tiene inverso multiplicativo modular"

## Notas para Julio

Las 4 funciones de la Parte 2 ya están creadas en `inverso.asm` como **moldes
vacíos** (buscá el banner `PARTE 2`). Cada una tiene un comentario `TODO` con su
contrato (qué recibe por la pila y qué debe devolver). Solo falta la lógica.

Reglas que hay que respetar (valen nota):
- Cada módulo usa su propio **stack frame** (`push rbp` / `mov rbp, rsp` / `leave` / `ret`).
- La comunicación entre módulos es **solo por la pila**: nada de variables
  globales ni de pasar valores por los registros generales.
- `inverso.asm` ya compila tal cual; al rellenar las funciones debe seguir compilando.

## Cómo compilar y ejecutar

Requiere `nasm` y `gcc` (en Ubuntu/WSL: `sudo apt install nasm gcc`).

```bash
nasm -f elf64 inverso.asm -o inverso.o
gcc -no-pie inverso.o -o inverso
./inverso
```

## Flujo de trabajo con Git

```bash
git pull                 # traer lo último antes de empezar
git add .
git commit -m "Mensaje del cambio"
git push
```

## Casos de prueba

| a | p | Resultado esperado                                |
|---|---|---------------------------------------------------|
| 3 | 7 | El inverso de 3 modulo 7 es: 5                    |
| 4 | 8 | El numero no tiene inverso multiplicativo modular |
