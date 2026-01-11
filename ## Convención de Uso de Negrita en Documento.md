## Convención de Uso de Negrita en Documentos LaTeX

**REGLA CRÍTICA:** Minimizar el uso de negrita para mantener un estilo académico limpio y profesional.

### ✅ USAR NEGRITA EN:

1. **Encabezados de tablas:**
   ```latex
   \textbf{Modelo} & \textbf{Precisión} & \textbf{Recall} & \textbf{F1}
   ```

2. **Fila de totales en tablas resumen:**
   ```latex
   \textbf{TOTAL} & \textbf{18} & \textbf{10.260,00€}
   ```

3. **Términos en listas de definición** (formato término: explicación):
   ```latex
   \begin{itemize}
       \item \textbf{SNN original (A--B)}: implementación base del trabajo previo.
       \item \textbf{IOPS}: KPI de servicios de infraestructura.
       \item \textbf{Resumen}: La arquitectura híbrida muestra mejoras...
   \end{itemize}
   ```

4. **Parámetros técnicos en listas explicativas:**
   ```latex
   \begin{itemize}
       \item \textbf{threshold}: Umbral de disparo de las neuronas LIF.
       \item \textbf{decay}: Constante de tiempo de decaimiento.
   \end{itemize}
   ```

### ❌ NO USAR NEGRITA EN:

1. **Texto corrido/párrafos principales:**
   - ❌ "Inicialmente nos centraremos en hacer una \textbf{revisión bibliográfica} exhaustiva..."
   - ✅ "Inicialmente nos centraremos en hacer una revisión bibliográfica exhaustiva..."

2. **Títulos y subtítulos de secciones** (ya tienen formato propio con \section, \subsection, etc.)

3. **Énfasis en el texto:** Usar cursiva (\textit{}) en su lugar

4. **Nombres propios de datasets, modelos o frameworks** fuera de listas

### Razón:

El uso excesivo de negrita en documentos académicos distrae y da una apariencia menos profesional. La negrita debe reservarse para elementos estructurales (tablas, listas de definiciones) donde ayuda a la legibilidad, no para énfasis general en el texto.