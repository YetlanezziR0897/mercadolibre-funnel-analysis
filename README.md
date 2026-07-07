# 🛍️ MercadoLibre: Análisis de Embudo de Conversión y Retención

## 🎯 Objetivo / Pregunta de Negocio
¿En qué etapa del proceso de compra se pierden más usuarios y qué tan bien los retenemos a lo largo del tiempo?  
Este proyecto analiza el comportamiento de usuarios en un embudo de conversión de 8 meses (ene–ago 2025) para 10 países de Latinoamérica, identificando oportunidades de optimización y retención.

---

## 📂 Datos
| Dataset | Fuente | Contenido |
|---|---|---|
| `mercadolibre_events` | TripleTen / Practicum | Eventos de comportamiento de usuario en el funnel de compra (select_item, add_to_cart, begin_checkout, add_shipping_info, add_payment_info, purchase) |
| `mercadolibre_retention` | TripleTen / Practicum | Registro de actividad recurrente por usuario: signup_date, day_after_signup, active, country |

**Período analizado:** 2025-01-01 al 2025-08-31  
**Países:** Argentina, Bolivia, Brazil, Chile, Colombia, Ecuador, Mexico, Paraguay, Peru, Uruguay

---

## ⚙️ Proceso

### 1. Análisis de Embudo de Conversión (SQL)
- Construcción del funnel general con tasas de conversión acumuladas por etapa
- Segmentación del funnel por país para identificar variaciones geográficas
- Uso de `COUNT(DISTINCT CASE WHEN ...)` para evitar conteo doble de usuarios por etapa

### 2. Análisis de Retención por País (SQL)
- Conteo de usuarios activos acumulados en D7, D14, D21 y D28
- Conversión a porcentajes usando `NULLIF` para evitar divisiones por cero

### 3. Análisis de Cohortes (SQL)
- Asignación de cohorte mensual de registro con `DATE_TRUNC` y `TO_CHAR`
- CTEs para estructurar el análisis en etapas claras y legibles
- Cálculo de retención por cohorte y periodo (D7 → D28)

### 4. Resumen Ejecutivo (Google Sheets)
- Consolidación de resultados en tablas de embudo general y por país
- Visualización de retención por cohorte y por país
- Informe ejecutivo con contexto, hallazgos e implicaciones de negocio

---

## 📊 Insights Clave

1. **El mayor punto de abandono está en "Agregar al carrito":** La conversión cae de 76.9% en "Select Item" a solo 11.1% en "Add to Cart" — una pérdida del 65.8% de usuarios en una sola etapa. Esta es la mayor oportunidad de optimización del funnel.

2. **Grandes diferencias de conversión por país:** Uruguay lidera con 4.5% de conversión final a compra. Brasil (0.7%), Ecuador (0%) y Colombia (0%) muestran conversiones muy bajas o nulas en la etapa de compra, lo que sugiere problemas específicos por región (métodos de pago, logística, confianza del usuario).

3. **La retención cae drásticamente después de la primera semana:** D7 se mantiene en 85%+ en todos los países, pero cae a 50-55% en D14, 22-25% en D21 y apenas 2-3% en D28. Esto indica que los usuarios se enganchan inicialmente pero no regresan a largo plazo — oportunidad clara para campañas de reactivación a partir de D14.

4. **El comportamiento de retención es consistente entre cohortes:** Todas las cohortes mensuales (ene–ago 2025) muestran un patrón similar de caída, con excepción de agosto que tiene datos parciales.

---

## 💡 Recomendación / Siguiente Paso
Si esto fuera una tarea laboral real:
- **Priorizar la optimización de "Add to Cart":** Mejorar la página de producto, claridad de precios e imágenes. Un incremento del 5% en esta etapa tendría el mayor impacto en todo el funnel.
- **Estrategias diferenciadas por país:** Brasil, Ecuador y Colombia necesitan atención urgente — investigar barreras de pago, costos de envío y confianza del usuario en estas regiones.
- **Campaña de reactivación a D14:** Implementar notificaciones push o emails personalizados antes del D14, cuando la retención aún está en 50%. Esperar hasta D28 es demasiado tarde (retención < 3%).

---

## 🔗 Enlaces
- 📊 [Resumen Ejecutivo (Google Sheets)](https://docs.google.com/spreadsheets/d/)
- 💾 [Queries SQL del proyecto](./mercadolibre_analysis.sql)

---

## 🛠️ Herramientas Utilizadas
`SQL` · `PostgreSQL` · `Google Sheets` · `CTEs` · `Window Functions`

---

## 📁 Estructura del Repositorio
```
mercadolibre-funnel-analysis/
├── README.md                        ← Este archivo
├── mercadolibre_analysis.sql        ← Todas las queries del proyecto
└── Proyecto_4_Resumen_Ejecutivo.xlsx ← Resultados y tablas finales
```

---

## 👩‍💻 Sobre mí
Soy Yetlanezzi Robles, Data Analyst con más de 7 años de experiencia en operaciones retail. Actualmente completando mi certificación en Análisis de Datos en TripleTen.

📩 yetlanezziroblescano@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/yetlanezzi-analyst)  
🌐 [Portfolio](https://yetlanezzir0897.github.io)
