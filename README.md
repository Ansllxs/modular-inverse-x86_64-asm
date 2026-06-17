# Inverso Multiplicativo Modular en x86_64 (NASM)

Proyecto 1 — IC3101 Arquitectura de Computadoras — Grupo 3 — Primer semestre 2026

**Integrantes:**
- Angie Mariela Alpízar Porras
- Julio César Quirós Vargas

## Descripción

Programa en ensamblador **x86_64** (sintaxis Intel, NASM) que calcula el
**inverso multiplicativo modular** de un número entero en un campo ℤ_p.

Dados dos enteros `a` y `p`, el programa encuentra un entero `b` tal que:

```
(a * b) mod p = 1
```

Si ese `b` existe, se le llama el inverso de `a` módulo `p`. Para calcularlo se
usa el **Algoritmo Extendido de Euclides**. Si `mcd(a, p) != 1`, el inverso no
existe.

Ejemplo: el inverso de 3 módulo 7 es 5, porque `3 * 5 = 15` y `15 mod 7 = 1`.

## Reglas del proyecto (rúbrica)

- El programa debe estar dividido en **módulos**, cada uno una función o
  procedimiento con su propio **stack frame**.
- Los parámetros y los valores de retorno se pasan **por la pila**, NO por los
  registros generales.
- **No** se permiten variables globales.
- Para entrada/salida se pueden usar funciones de C (`printf`, `scanf`).

## Requisitos para compilar

- `nasm` (ensamblador)
- `gcc` (para enlazar y disponer de la biblioteca de C: `printf` / `scanf`)

En Ubuntu / WSL:

```bash
sudo apt update
sudo apt install nasm gcc
```

## Cómo compilar y ejecutar

```bash
# 1. Ensamblar: genera el archivo objeto (.o)
nasm -f elf64 inverso.asm -o inverso.o

# 2. Enlazar con gcc (para usar printf/scanf de C)
gcc -no-pie inverso.o -o inverso

# 3. Ejecutar
./inverso
```

## División del trabajo (módulos)

El programa se compone de 8 módulos. Cada uno es una función con su stack frame.

### Parte 1 — Angie Mariela Alpízar Porras (interfaz, E/S y control)

| Módulo              | Qué hace                                                       |
|---------------------|----------------------------------------------------------------|
| `main`              | Orquesta: leer datos → calcular → imprimir resultado.          |
| `leerDatos`         | Muestra mensajes y lee `a` y `p` con `scanf`.                  |
| `imprimirResultado` | Imprime "El inverso de a módulo p es: <n>" con `printf`.       |
| `ajustarPositivo`   | Deja el resultado en el rango positivo (`x mod p`).            |

### Parte 2 — Julio César Quirós Vargas (la matemática)

| Módulo              | Qué hace                                                       |
|---------------------|----------------------------------------------------------------|
| `euclidesExtendido` | Núcleo: calcula `x`, `y` y `mcd` a partir de `a` y `p`.        |
| `inversoModular`    | Usa Euclides; decide si existe inverso (`mcd == 1`).          |
| `imprimirError`     | Imprime "El número no tiene inverso multiplicativo modular".   |
| `validarDatos`      | Valida los datos de entrada antes de calcular.                 |

## Flujo de trabajo con Git

El trabajo es secuencial: primero se sube la base (Parte 1) y luego el
compañero construye encima (Parte 2).

```bash
# Traer los últimos cambios antes de empezar a trabajar
git pull

# Después de hacer cambios
git add .
git commit -m "Mensaje describiendo el cambio"
git push
```

## Casos de prueba

| a | p | Resultado esperado                                |
|---|---|---------------------------------------------------|
| 3 | 7 | El inverso de 3 módulo 7 es: 5                     |
| 4 | 8 | El número no tiene inverso multiplicativo modular |
