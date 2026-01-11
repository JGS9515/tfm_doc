---
marp: true
theme: default
paginate: true
backgroundColor: #fff
style: |
  section {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  h1, h2 {
    color: #1a5f7a;
  }
  table {
    font-size: 0.8em;
  }
  img {
    max-height: 450px;
  }
  .columns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
  }
---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _backgroundColor: #1a5f7a -->
<!-- _color: white -->

# Modelos de Inteligencia Artificial Sostenible para Mantenimiento Predictivo

## Trabajo Fin de Máster

**Autor:** Javier González Santos  
**Director:** Prof. D. Ángel Miguel García  
**Máster en Ingeniería Informática**

*Escuela Politécnica Superior de Jaén*

---

## Índice

1. **Motivación** — El problema de la detección de anomalías
2. **Objetivos** — Metas del proyecto
3. **Estado del Arte** — SNNs y arquitecturas existentes
4. **Metodología** — Arquitectura híbrida SNN-CNN
5. **Preprocesamiento** — Flujo de datos reproducible
6. **Resultados Experimentales** — IOPS y CalIt2
7. **Discusión** — Análisis e implicaciones
8. **Conclusiones y Trabajos Futuros**

---

## Motivación

### El desafío de la detección de anomalías

- Problema **transversal**: monitorización de redes, mantenimiento predictivo, infraestructuras críticas
- Los datos crecen **exponencialmente** → necesidad de procesamiento eficiente
- Anomalías: picos inusuales, cambios bruscos de tendencia, alteraciones periódicas

### Limitaciones de los enfoques tradicionales

- Deep learning convencional: buen rendimiento pero **alto consumo energético**
- Escalabilidad limitada en **dispositivos edge** con recursos restringidos
- Necesidad de procesamiento en **tiempo real**

> 💡 **Propuesta**: SNNs como alternativa eficiente que imita la dinámica cerebral

---

## Objetivos del Proyecto

| Código | Objetivo | Estado |
|--------|----------|--------|
| **O1** | Revisión bibliográfica de SNNs para detección de anomalías | ✅ Sí |
| **O2** | Diseño de arquitecturas SNN optimizadas | ✅ Sí |
| **O3** | Implementación de modelos sostenibles (eficiencia energética) | ⚠️ Parcial |
| **O4** | Validación en datasets reales de mantenimiento predictivo | ✅ Sí |
| **O5** | Comparación con modelos tradicionales | ✅ Sí |

**Objetivo destacado (O2):** Arquitectura híbrida SNN-CNN con optimización bayesiana automatizada (Optuna TPE)

---

## Estado del Arte — Redes Neuronales de Impulsos

### ¿Qué diferencia a las SNNs de las ANNs tradicionales?

| Aspecto | ANN Tradicional | SNN |
|---------|-----------------|-----|
| Comunicación | Valores continuos (0.0 - 1.0) | Impulsos discretos |
| Información temporal | El momento no importa | El **tiempo** del impulso es información |
| Activación | Todas las neuronas procesan siempre | Solo procesa al recibir impulso |
| Operaciones | Multiplicaciones intensivas | Sumas y comparaciones |

### Modelo neuronal LIF (Leaky Integrate-and-Fire)

$$V(t+1) = V(t) + \alpha \big(V_{\text{rest}} - V(t)\big) + I_{\text{entrada}}(t)$$

Si $V(t+1) \geq V_{\text{threshold}}$ → la neurona **dispara** y se reinicia

---

## Estado del Arte — Ejemplo de Neurona LIF

<div class="columns">
<div>

### Dinámica del modelo LIF

1. **Integración:** La neurona acumula señales eléctricas recibidas
2. **Fuga:** El voltaje decae gradualmente si no hay entradas
3. **Disparo:** Al superar el umbral, emite un impulso y se reinicia

### Parámetros clave

- $V_{\text{rest}} = -65$ mV (voltaje de reposo)
- $V_{\text{threshold}} = -50$ mV (umbral de disparo)
- $\alpha = 0.2$ (factor de fuga)

</div>
<div>

![w:500](Imagenes/Ejemplo%20ilustrativo%20de%20una%20neurona%20LIF.png)

</div>
</div>

---

## Estado del Arte — Arquitectura SNN Base

<div class="columns">
<div>

### Modelo bicapa A–B (punto de partida)

- **Capa A (entrada):** 39 neuronas, codificación por cuantiles
- **Capa B (procesamiento):** 100 neuronas LIF, conexiones recurrentes
- **Aprendizaje:** STDP modificado con penalización bidireccional

### Limitaciones identificadas

- Sin extracción de características jerárquicas
- Sensibilidad a hiperparámetros (ajuste manual)
- Rendimiento limitado ante ruido

</div>
<div>

![w:400](Imagenes/Diagrama%20de%20capas%20de%20SNN%20Base.png)

</div>
</div>

---

## Metodología — Arquitectura Híbrida SNN-CNN

<div class="columns">
<div>

### Capa convolucional C

- **Arquitectura A–B–C:** Capa convolucional tras B
- **Kernels configurables:**
  - Gaussiano (suavizado)
  - Laplaciano (detección de bordes)
  - Mexican Hat (supresión lateral)
  - Box (promediado simple)

</div>
<div>

### Modos de procesamiento

| Modo | Descripción |
|------|-------------|
| `direct` | Impulsos de C |
| `weighted_sum` | $0.3B + 0.7C$ |
| `max` | Máximo entre B y C |

</div>
</div>

---

## Metodología — Diagrama de Arquitectura

![Flujo de datos y arquitectura SNN](Imagenes/Diagrama%20SNN.png)

**Flujo:** Señal temporal → Codificación por cuantiles → Capa A → Capa B (LIF+STDP) → Capa C (Convolucional) → Decisión dual

---

## Metodología — Detalle de la Capa Convolucional

![Arquitectura detallada SNN](Imagenes/Arquitectura%20detallada%20SNN.png)

**Procesamiento en capa C:** Los impulsos de la capa B se procesan con kernels adaptativos (Gaussiano, Laplaciano, Mexican Hat, Box) para extraer características temporales locales antes de la decisión final.

---

## Metodología — Optimización con Optuna

### Parámetros optimizados automáticamente

<div class="columns">
<div>

**Parámetros neuronales:**
- `threshold` ∈ [-65, -50] mV
- `decay` ∈ [80, 150]
- `nu1`, `nu2` ∈ [-0.5, 0.5]

</div>
<div>

**Parámetros convolucionales:**
- `kernel_size` ∈ [3, 9] (impares)
- `sigma` ∈ [0.5, 3.0]
- `norm_factor` ∈ [0.1, 1.0]

</div>
</div>

### Configuración experimental
- **100 pruebas** por configuración
- **3 tamaños de red:** 100, 200 y 400 neuronas
- **Métrica objetivo:** Maximizar F1-score
- **Integración MLOps:** Weights & Biases

---

## Metodología — Preprocesamiento

### Flujo reproducible

1. **Particionado 50/50** temporal (sin shuffle)
2. **Cuantización dinámica** por cuantiles expandidos
3. **Expansión de etiquetas** para compensar desbalanceo
4. **Segmentación en ventanas** de longitud T=250

![Codificación y preprocesado de la señal](Imagenes/Codificación%20y%20preprocesado%20de%20la%20señal%20(2).png)

---

## Datasets Utilizados

| Característica | IOPS | CalIt2 |
|----------------|------|--------|
| **Dominio** | Métricas de infraestructura | Flujo de personas en edificio |
| **% Anomalías** | 1.92% (muy desbalanceado) | 24.80% (moderado) |
| **Desafío principal** | Desbalanceo extremo | Variabilidad temporal |

### Justificación
- Representan escenarios **reales** de mantenimiento predictivo
- Permiten evaluar robustez ante **diferentes niveles de desbalanceo**

---

## Resultados — Dataset IOPS

### Mejora de 4.6x sobre modelo base

| Modelo | N | Precisión | Recall | **F1** | MSE |
|--------|---|-----------|--------|--------|-----|
| SNN (A–B) | 100 | 0.049 | 0.078 | 0.060 | 0.643 |
| SNN (A–B) | 400 | 0.054 | 0.073 | 0.062 | 0.581 |
| **SNN (A–B–C)** | 100 | 0.163 | 0.725 | **0.277** | 0.142 |
| SNN (A–B–C) | 400 | 0.079 | 0.121 | 0.096 | 0.600 |

### Observaciones clave
- Kernels óptimos: `mexican_hat`, `laplacian`
- Procesamiento preferido: `weighted_sum`, `max`
- **Tendencia inversa:** n_100 > n_200 > n_400 (sobreajuste en redes grandes)

---

## Resultados — Dataset CalIt2

### Rendimiento estable y robusto

| Modelo | N | Precisión | Recall | **F1** | MSE |
|--------|---|-----------|--------|--------|-----|
| SNN (A–B) | 100 | 0.160 | 0.472 | 0.239 | 0.790 |
| **SNN (A–B–C)** | 100 | 0.263 | 1.000 | **0.416** | 0.737 |
| **SNN (A–B–C)** | 200 | 0.264 | 1.000 | **0.417** | 0.734 |
| **SNN (A–B–C)** | 400 | 0.264 | 0.994 | **0.417** | 0.730 |

### Observaciones clave
- **Recall ≈ 100%** → estrategia conservadora (detecta todas las anomalías)
- Kernels óptimos: `mexican_hat`, `gaussian` (tamaño 5-7)
- Procesamiento preferido: `direct`
- **Estabilidad:** F1 constante independientemente del tamaño de red

---

## Resultados — Comparación con Baselines TSFEDL

| Modelo | **F1 (IOPS)** | **F1 (CalIt2)** |
|--------|---------------|-----------------|
| SNN (A–B) | 0.062 | 0.239 |
| **SNN (A–B–C)** | **0.277** | **0.417** |
| TSFEDL-OhShuLih | 0.436 | 0.704 |
| TSFEDL-KhanZulfiqar | 0.410 | 0.704 |
| TSFEDL-ZhengZhenyu | 0.412 | 0.704 |
| TSFEDL-WeiXiaoyan | 0.380 | 0.679 |

### Interpretación
- Los modelos TSFEDL superan a las SNN en F1-score absoluto
- **Sin embargo:** Las SNN ofrecen ventajas potenciales en eficiencia energética
- La brecha se reduce significativamente con la arquitectura híbrida

---

## Discusión — Análisis de Parámetros

### Parámetros más influyentes (según Optuna)

1. **Parámetros neuronales** (mayor impacto):
   - `threshold` ∈ [-66.8, -67.7]
   - `decay` ∈ [73.6, 139.8]

2. **Parámetros de plasticidad:**
   - `nu1`, `nu2`

3. **Parámetros convolucionales** (impacto secundario):
   - `kernel_size`, `sigma`

> La dinámica LIF sigue siendo el **factor clave** del rendimiento

---

## Discusión — Implicaciones Prácticas

### Potencial para aplicaciones reales

✅ **Alto Recall (99.9%)** en CalIt2 → Crucial para evitar fallos no detectados  
✅ **Arquitectura basada en impulsos** → Compatible con hardware neuromórfico  
✅ **Naturaleza dispersa** → Eficiencia en procesamiento edge  

### Limitaciones actuales

⚠️ **Baja precisión** → Requiere post-procesado para reducir falsas alarmas  
⚠️ **Validación energética pendiente** → Solo estimaciones teóricas (MACs)  
⚠️ **Ejecución en CPU** → Sin aceleración GPU por incompatibilidades  

---

## Conclusiones — Contribuciones y Hallazgos

<div class="columns">
<div>

### Principales contribuciones

1. ✅ **Arquitectura híbrida SNN-CNN** con capa convolucional parametrizable
2. ✅ **Flujo de preprocesamiento reproducible** adaptado a SNNs
3. ✅ **Evidencia empírica** de mejora (4.6x en IOPS, F1=0.417 en CalIt2)
4. ✅ **Metodología comparativa** reutilizable

</div>
<div>

### Hallazgos clave

- Los **parámetros neuronales** (`threshold`, `decay`) son los más influyentes
- La **dinámica LIF** sigue siendo el factor clave del rendimiento
- **Optuna** fue fundamental para explorar el espacio de hiperparámetros
- La hibridación **reduce la brecha** con métodos tradicionales

</div>
</div>

---

## Conclusiones — Implicaciones y Limitaciones

<div class="columns">
<div>

### Potencial para aplicaciones reales

✅ **Alto Recall (99.9%)** → Crucial para evitar fallos no detectados  
✅ **Arquitectura basada en impulsos** → Compatible con hardware neuromórfico  
✅ **Naturaleza dispersa** → Eficiencia en edge computing  
✅ **Metodología reproducible** → Base para trabajos futuros  

</div>
<div>

### Limitaciones identificadas

⚠️ **Baja precisión** → Requiere post-procesado  
⚠️ **Validación energética pendiente** → Solo estimaciones teóricas (MACs)  
⚠️ **Ejecución en CPU** → Sin aceleración GPU  
⚠️ **Datasets limitados** → Falta validación en entornos multivariados  

</div>
</div>

### Conclusión principal

> Las arquitecturas híbridas SNN-CNN ofrecen un **equilibrio prometedor** entre rendimiento y eficiencia, posicionándose como alternativa viable para **edge computing** y mantenimiento predictivo en entornos con restricciones energéticas.

---

## Trabajos Futuros

### Líneas prioritarias

| Área | Propuesta |
|------|-----------|
| **Hardware neuromórfico** | Validación en Intel Loihi 2, SpiNNaker 2, BrainScaleS-2 |
| **Métricas energéticas** | Joules/inferencia, mW promedio, latencia por ventana |
| **Optimización multiobjetivo** | F1 + MACs con NSGA-II |
| **Validación cruzada temporal** | Rolling-origin, nested backtesting |
| **Datasets industriales** | Señales de vibración, temperatura, presión |

### Despliegue neuromórfico
- Monitorización de dispersidad
- Re-calibración automática de umbrales
- Empaquetado para microcontroladores SNN nativos

---

<!-- _class: lead -->
<!-- _paginate: false -->
<!-- _backgroundColor: #1a5f7a -->
<!-- _color: white -->

# ¡Gracias por su atención!

## ¿Preguntas?

**Javier González Santos**  
Máster en Ingeniería Informática  
Universidad de Jaén

---

## Referencias Bibliográficas

- Cherdo et al. (2023) — Time series anomaly detection with SNNs
- Kshirasagar et al. (2024) — Auditory cortex-inspired models
- Sanaullah et al. (2024) — Hybrid SNN-CNN architectures
- Vázquez et al. (2024) — Vacuum systems monitoring with SNNs
- Aguilera-Martos et al. (2023) — TSFEDL library

*Ver bibliografía completa en el documento de memoria*

