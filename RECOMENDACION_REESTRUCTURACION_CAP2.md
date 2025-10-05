# Recomendación de Reestructuración: Capítulo 2, Sección 2.5 (SNNs)

## El Problema (en palabras simples)

Tu tutor tiene razón en algo crucial: **nadie en el tribunal va a saber qué es una SNN**. Y tu sección actual (2.5-SNN.tex) no lo explica. Son solo 12 líneas que hablan de "inspiración biológica", "STDP" y "hardware neuromórfico", pero nunca responden a la pregunta básica: *¿qué demonios es una SNN?*

Piénsalo así: es como si escribieras sobre motores de hidrógeno sin explicar primero qué es un motor. Después, en la sección 2.7, empiezas a comparar el consumo energético de SNNs vs ANNs... pero el lector todavía no sabe qué diferencia hay entre ellas más allá de "una consume menos".

## Lo que necesitas hacer

Transformar la sección 2.5 de **12 líneas superficiales** a **una sección didáctica completa** que construya el conocimiento desde cero.

---

## Estructura Propuesta para 2.5-SNN.tex

### **2.5.1 - ¿Qué es una Red Neuronal de Impulsos?**

**Objetivo:** Que alguien sin conocimientos previos entienda el concepto básico.

**Contenido específico:**

1. **Párrafo introductorio (el "hook")**
   - Las redes neuronales que conocemos (ANNs) procesan información con números continuos: un valor de 0.87, otro de 0.34, etc.
   - Las SNNs funcionan diferente: usan pulsos o "picos" de actividad, igual que las neuronas reales del cerebro.
   - Analogía útil: La diferencia entre un termostato analógico (que ajusta la temperatura gradualmente) y uno digital que solo enciende/apaga.

2. **Diferencia fundamental con ANNs**
   - Crear una **tabla visual comparativa**:
   
   | Aspecto | ANN Tradicional | SNN |
   |---------|----------------|-----|
   | **Comunicación entre neuronas** | Valores continuos (0.0 - 1.0) | Pulsos discretos (spike/no spike) |
   | **Información temporal** | No importa el momento exacto | El TIEMPO del spike es información |
   | **Activación** | Cada neurona procesa en cada paso | Solo procesa cuando recibe un spike |
   | **Inspiración** | Matemática abstracta | Neuronas biológicas reales |

3. **Diagrama conceptual simple**
   - Mostrar visualmente: 
     - ANN: neurona A (0.7) → neurona B (0.4) → neurona C (0.9)
     - SNN: neurona A (spike en t=3) → neurona B (spike en t=5) → neurona C (no spike)

---

### **2.5.2 - Componentes básicos de una SNN**

**Objetivo:** Explicar las piezas fundamentales, una por una.

**Contenido específico:**

#### **A) La neurona de impulsos (modelo LIF)**

"La neurona más común en SNNs se llama LIF (Leaky Integrate-and-Fire). El nombre suena complicado, pero el concepto es sencillo:"

- **Integrate (Integrar):** La neurona acumula señales eléctricas que recibe (voltaje de membrana)
- **Leaky (Con fuga):** El voltaje va decayendo con el tiempo si no recibe más señales
- **Fire (Dispara):** Cuando el voltaje supera un umbral, la neurona emite un spike y se reinicia

**Ecuación básica (explicada paso a paso):**

```
V(t+1) = V(t) × decay + Σ(spikes_recibidos × pesos)

Si V(t+1) ≥ threshold → SPIKE! (y V se reinicia a V_rest)
```

Donde:
- `V(t)` = voltaje de la membrana neuronal en el instante t
- `decay` = factor de decaimiento (ej: 0.95 significa que pierde 5% por paso)
- `threshold` = umbral de disparo (ej: -50 mV)
- `V_rest` = voltaje de reposo al que vuelve después de disparar (ej: -65 mV)

**Diagrama temporal:**
```
Voltaje (mV)
    -40 |         spike! ⚡️
        |        /|
    -50 |-threshold--------
        |       / |
    -60 |------   |
        |     /   |
    -65 |----     -------- (reset)
        |_________________
           tiempo →
```

#### **B) Las sinapsis (conexiones entre neuronas)**

"Cuando una neurona dispara un spike, este viaja a través de sinapsis hacia otras neuronas. Cada sinapsis tiene un peso que amplifica o reduce el impacto:"

- **Peso positivo (excitatorio):** Aumenta el voltaje de la neurona receptora → más probable que dispare
- **Peso negativo (inhibitorio):** Disminuye el voltaje → menos probable que dispare

Ejemplo:
```
Neurona A dispara → spike viaja por sinapsis con peso +0.5 → 
Neurona B recibe +0.5 en su voltaje
```

#### **C) Codificación de información**

"Vale, pero... ¿cómo convertimos datos normales (temperatura, velocidad, valores de sensores) en spikes?"

**Dos métodos principales:**

1. **Rate Coding (codificación por frecuencia):**
   - Valor alto → muchos spikes en poco tiempo
   - Valor bajo → pocos spikes dispersos
   - Ejemplo: Temperatura 30°C → 30 spikes en 100ms, Temperatura 10°C → 10 spikes en 100ms

2. **Temporal Coding (codificación temporal):**
   - El momento exacto del spike codifica información
   - Valores altos → spike temprano
   - Valores bajos → spike tardío
   - Ejemplo: Temperatura 30°C → spike en t=5, Temperatura 10°C → spike en t=25

---

### **2.5.3 - Cómo aprenden las SNNs: STDP**

**Objetivo:** Explicar el mecanismo de aprendizaje sin asumir conocimientos previos.

**Contenido específico:**

"Las ANNs aprenden con backpropagation, calculando gradientes y ajustando pesos. Las SNNs usan algo diferente y más biológico: STDP (Spike-Timing-Dependent Plasticity)."

#### **El principio básico**

La regla de STDP es simple:

> **"Las neuronas que disparan juntas, se conectan juntas"**

Pero con un matiz temporal importante:

- Si la neurona A dispara **ANTES** que la neurona B → **refuerza la conexión** A→B
  - Interpretación: "A ayudó a que B disparara, esa conexión es útil"
  
- Si la neurona A dispara **DESPUÉS** que la neurona B → **debilita la conexión** A→B
  - Interpretación: "A no contribuyó, esa conexión no sirve"

**Ventana temporal:**
```
Cambio de peso
      |
  +nu |    •   (A antes que B: refuerza)
      |   / \
    0 |--/---\----------
      |       \  •  (A después de B: debilita)
  -nu |        \_/
      |________________
        -20  0  +20
        Δt (ms)
```

**Parámetros clave:**
- `nu1` y `nu2`: tasas de aprendizaje (controlan qué tan rápido cambian los pesos)
- Valores típicos: -0.1 a +0.1

**Por qué STDP es poderoso:**
- No necesita backpropagation (computacionalmente muy caro)
- Es biológicamente plausible (así aprenden las neuronas reales)
- Funciona con aprendizaje no supervisado

---

### **2.5.4 - Arquitectura típica de una SNN**

**Objetivo:** Mostrar cómo se organizan las piezas.

**Contenido específico:**

"Ahora que conoces las piezas, veamos cómo se ensamblan."

#### **Estructura básica (ejemplo para detección de anomalías)**

```
[DATOS] → [CODIFICACIÓN] → [CAPA A] → [CAPA B] → [DECODIFICACIÓN] → [DECISIÓN]
          ↓                 ↓          ↓
     Convierte a       Entrada     Procesamiento
     spikes            (ej: 39     (ej: 100
                       neuronas)    neuronas LIF)
```

**Desglose:**

1. **Datos de entrada:**
   - Serie temporal: [34.5, 35.1, 34.8, 36.2, ...]
   
2. **Codificación a spikes:**
   - Se dividen en rangos (cuantiles)
   - Cada rango corresponde a una neurona de entrada
   - Ejemplo: Si valor = 35.1 está en el rango [35-36] → neurona #5 dispara un spike

3. **Capa A (entrada):**
   - 39 neuronas (una por cuantil en este ejemplo)
   - Reciben spikes codificados
   - Transmiten a la siguiente capa

4. **Capa B (procesamiento):**
   - 100 neuronas LIF
   - Conexión fully-connected desde A
   - Conexiones recurrentes dentro de B (neuronas B se comunican entre sí)
   - Aprenden patrones mediante STDP

5. **Decodificación:**
   - Se cuentan los spikes de la capa B durante un tiempo T
   - Comportamiento normal → patrón típico de spikes
   - Anomalía → patrón inusual de spikes

6. **Decisión de anomalía:**
   - Si `total_spikes > umbral` → ANOMALÍA detectada
   - Umbral típico: `media + 2×desviación_estándar`

**Diagrama visual completo:**
[Aquí incluir tu diagrama "Flujo de datos y arquitectura SNN" existente, pero ahora el lector entenderá qué está viendo]

---

### **2.5.5 - ¿Qué se necesita para diseñar una SNN?**

**Objetivo:** Lista práctica de decisiones de diseño.

**Contenido específico:**

"Si quisieras crear tu propia SNN desde cero, tendrías que decidir:"

#### **1. Arquitectura de capas**
- ¿Cuántas capas? (2, 3, 4...)
- ¿Cuántas neuronas por capa?
- ¿Conexiones fully-connected o convolucionales?
- ¿Conexiones recurrentes?

#### **2. Tipo de neurona**
- LIF básico
- Adaptive LIF (con adaptación dinámica del threshold)
- Izhikevich (más complejo, más realista)

#### **3. Parámetros neuronales**
Cada neurona necesita:
- `threshold` (umbral): típicamente -50 a -65 mV
- `decay` (decaimiento): típicamente 0.8 a 0.99
- `v_rest` (voltaje de reposo): típicamente -65 mV

#### **4. Regla de aprendizaje**
- STDP (más común para no supervisado)
- R-STDP (con recompensas, para reinforcement learning)
- Conversión desde ANN pre-entrenada

#### **5. Codificación de entrada**
- Rate coding
- Temporal coding
- Cuantiles (como en tu caso)

#### **6. Tiempo de simulación**
- Parámetro `T`: ¿cuántos pasos temporales por muestra?
- Compromiso: más tiempo = más precisión, pero más costo computacional
- Típico: 50-250 pasos

#### **7. Hardware/Framework**
- CPU (más lento, más flexible)
- GPU (más rápido, con limitaciones)
- Hardware neuromórfico (Intel Loihi, IBM TrueNorth)
- Frameworks: BindsNET (tu caso), Brian2, Norse, SpikingJelly

**Tabla de ejemplo de configuración:**

| Parámetro | Valor en tu modelo | Explicación |
|-----------|-------------------|-------------|
| Capas | A→B (2 capas) | Simple, eficiente |
| Neuronas capa A | 39 | Determinado por cuantiles |
| Neuronas capa B | 100 | Ajustable, balanceo capacidad/costo |
| Modelo neurona | LIF | Estándar, eficiente |
| Threshold | -50 mV | Ajustado con Optuna |
| Decay | 0.95 | Ajustado con Optuna |
| Aprendizaje | STDP | No supervisado |
| nu1, nu2 | -0.1 a +0.1 | Ajustado con Optuna |
| Tiempo T | 250 | Compromiso precisión/velocidad |

---

### **2.5.6 - Ventajas de las SNNs: Eficiencia energética**

**Objetivo:** Ahora sí puedes hablar de por qué son importantes.

**Contenido específico:**

"Llegados a este punto, entiendes cómo funcionan las SNNs. Ahora la pregunta: **¿por qué usarlas en lugar de ANNs normales?**"

#### **Computación impulsada por eventos**

Las ANNs procesan TODO en cada paso:
```
Paso 1: todas las neuronas calculan → 1000 multiplicaciones
Paso 2: todas las neuronas calculan → 1000 multiplicaciones
Paso 3: todas las neuronas calculan → 1000 multiplicaciones
...
```

Las SNNs solo procesan cuando hay spikes:
```
Paso 1: 10 neuronas disparan → 10 sumas
Paso 2: 15 neuronas disparan → 15 sumas
Paso 3: 5 neuronas disparan → 5 sumas
...
```

**Resultado:** La mayoría del tiempo, la mayoría de las neuronas están "dormidas". Esto ahorra muchísima energía.

#### **Operaciones más simples**

- **ANN:** Cada neurona hace multiplicaciones (`peso × activación`)
- **SNN:** Cada neurona hace sumas (`peso + voltaje_actual`)

Las multiplicaciones consumen ~10 veces más energía que las sumas.

#### **Números reales (mover datos desde 2.7)**

Estudios recientes muestran:
- SNNs consumen **3.5× menos energía** que CNNs equivalentes
- Latencia **3× menor** (responden más rápido)
- Precisión: ~89% (SNN) vs ~92% (CNN) → **trade-off aceptable** para muchas aplicaciones

[Aquí incluir la tabla de comparación de 2.7]

**Casos de uso ideales:**
- Dispositivos IoT con batería limitada
- Edge computing (procesamiento en el dispositivo)
- Sistemas que necesitan respuesta en tiempo real
- Cualquier aplicación donde el consumo energético sea crítico

---

### **2.5.7 - Aplicaciones modernas y arquitecturas híbridas**

**Objetivo:** Mostrar que esto no es solo teoría, se usa en el mundo real.

**Contenido específico:**

[Aquí mover tu contenido actual sobre detección de audio y arquitecturas híbridas SNN-CNN]

Pero ahora tiene sentido porque el lector ya entiende:
- Qué es un spike
- Cómo funcionan las neuronas LIF
- Por qué las SNNs son eficientes
- Cómo se diseñan

---

## Cambios en otras secciones

### **2.7-Eficiencia_energética.tex**

**Antes:** Hablaba de SNNs sin explicarlas

**Ahora:** Puede asumir que el lector sabe qué son. Cambios sugeridos:

1. **Eliminar o reducir la subsección "Paradigma de eficiencia energética en SNNs"**
   - La parte conceptual ya está en 2.5.6
   - Mantener solo los **números específicos y estudios empíricos**

2. **Reorganizar como "Comparativa cuantitativa"**
   - Estudios de caso específicos
   - Benchmarks de consumo energético
   - Gráficos comparativos

3. **La subsección "Hiperparámetros en SNN" está bien**
   - Pero agregar una referencia: "Como vimos en la sección 2.5.4, una SNN requiere múltiples parámetros..."

### **2.8 Conclusiones.tex**

**Antes:** "La comparación entre las ANN, las SNN..." (pero sin haber explicado SNNs)

**Ahora:** Puede hacer comparaciones con confianza porque el lector tiene el contexto completo.

---

## Plan de Acción Concreto

### **Fase 1: Contenido (lo más importante)**

1. **Reescribir 2.5-SNN.tex completo** con la estructura propuesta arriba
   - Estimado: de 12 líneas → ~200-250 líneas
   - Tiempo estimado: 4-6 horas de escritura concentrada

2. **Crear diagramas explicativos** (esenciales para que sea didáctico):
   - Diagrama: ANN vs SNN (comunicación continua vs spikes)
   - Diagrama: Anatomía neurona LIF (voltaje en el tiempo)
   - Diagrama: STDP (ventana temporal)
   - Tabla: Comparativa ANN vs SNN
   - Tabla: Parámetros de diseño de tu SNN

3. **Reorganizar 2.7** 
   - Mover conceptos básicos a 2.5
   - Dejar solo datos empíricos y comparativas cuantitativas

### **Fase 2: Revisión**

4. **Leer de corrido:** 2.3 (Deep learning) → 2.5 (SNN nuevo) → 2.7 (Eficiencia)
   - ¿Fluye lógicamente?
   - ¿Hay huecos de conocimiento?
   - ¿Algo se explica dos veces?

5. **Test del lector ingenuo:**
   - Dáselo a alguien que no sepa de SNNs (un compañero de otro máster)
   - Si puede entender el Cap 4 (tu modelo) después de leer 2.5, está bien
   - Si se queda perdido, identificar dónde y reforzar

### **Fase 3: Pulido**

6. **Ajustar tono** según las guidelines del notepad
   - Variar longitud de oraciones
   - Evitar "robusto", "innovador", "delve", etc.
   - Usar ejemplos específicos
   - Un toque informal está bien

7. **Referencias bibliográficas:**
   - Agregar citas fundacionales de SNNs (Maass 1997, Gerstner...)
   - Citar los estudios empíricos que menciones

---

## Por qué esto resolverá el problema del tutor

Tu tutor dijo:
> "ningún profesor del departamento (salvo yo) sabe que es una SNN"

Con esta reestructuración:
- ✅ Un profesor de teoría de la computación entenderá: "Ah, es computación basada en eventos"
- ✅ Un profesor de sistemas entenderá: "Ah, optimiza operaciones eliminando multiplicaciones"
- ✅ Un profesor de IA tradicional entenderá: "Ah, es como una ANN pero con comunicación binaria temporal"

**El test final:** Después de leer 2.5, cualquier profesor debería poder:
1. Explicar qué es una SNN en sus propias palabras
2. Identificar las diferencias clave con una ANN
3. Entender por qué tu trabajo usa SNNs (eficiencia energética)
4. Seguir la explicación técnica del Cap 4 sin perderse

---

## Recomendación personal

Empieza por escribir la subsección **2.5.1 (¿Qué es una SNN?)** y **2.5.2 (Componentes básicos)**.

Son las más importantes. Si esas dos están bien, el resto fluye naturalmente.

Y usa analogías. Las analogías son tu mejor amigo cuando explicas conceptos nuevos. Por ejemplo:
- "Una SNN es como código Morse, una ANN es como una transmisión analógica de radio"
- "El threshold de una neurona LIF es como el punto de ebullición del agua: nada pasa hasta que llegas ahí, y entonces... ¡boom!"

La clave es que al leer esto, el tribunal piense: "Este estudiante realmente entiende lo que está haciendo, no solo copió código".

---

**¿Quieres que empiece a escribir el contenido real de la nueva sección 2.5, o prefieres ajustar primero esta estructura propuesta?**
