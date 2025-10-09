## Gestión de Acrónimos y Siglas

**REGLA CRÍTICA:** Nunca definir acrónimos dentro del documento principal.

### Política de Acrónimos:

1. **Todos los acrónimos deben definirse ÚNICAMENTE en el archivo `Capitulos/Siglas.tex`** (Glosario de Siglas)
   
2. **En el contenido del documento:**
   - ❌ NUNCA escribir: "Redes Neuronales Artificiales (RNA)"
   - ❌ NUNCA escribir: "RNA (Redes Neuronales Artificiales)"
   - ❌ NUNCA redefinir un acrónimo que ya existe
   - ✅ SIEMPRE usar directamente el acrónimo: "RNA"

3. **Flujo de trabajo:**
   - Paso 1: Agregar la definición al glosario en `Capitulos/Siglas.tex`
   - Paso 2: Usar únicamente el acrónimo en todo el documento
   - Paso 3: El lector consultará el glosario si necesita la definición completa

4. **Al editar o generar contenido:**
   - Verificar que no se incluyan definiciones inline de acrónimos
   - Si se encuentra un nuevo término que necesita acrónimo, agregarlo primero al glosario
   - Reemplazar cualquier definición inline existente con solo el acrónimo

### Ejemplo:

**❌ Incorrecto:**
```latex
Las Redes Neuronales Espinosas (SNN) son un tipo de red neuronal...
Más adelante: Las SNN tienen la ventaja de...
```

**✅ Correcto:**
```latex
% En Capitulos/Siglas.tex:
\newacronym{snn}{SNN}{Spiking Neural Networks}

% En el documento:
Las SNN son un tipo de red neuronal...
Las SNN tienen la ventaja de...
```

---

## Notas adicionales:
- Esta regla es especialmente importante cuando se trabaja con LLMs, ya que tienden a redefinir acrónimos repetidamente
- El tutor revisará cuidadosamente el uso correcto de acrónimos
- El glosario de siglas debe aparecer antes de la introducción del documento

