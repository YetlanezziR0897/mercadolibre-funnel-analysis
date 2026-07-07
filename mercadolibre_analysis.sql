-- ============================================================
-- PROYECTO: Análisis de Embudo y Retención — MercadoLibre
-- Herramienta: SQL (PostgreSQL)
-- Periodo: 2025-01-01 al 2025-08-31
-- Autora: Yetlanezzi Robles
-- ============================================================


-- ============================================================
-- PARTE 1: ANÁLISIS DE EMBUDO DE CONVERSIÓN
-- ============================================================

-- Query 1: Embudo general de conversión
-- Objetivo: Calcular la tasa de conversión acumulada por etapa

SELECT
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'select_item'         THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_select_item,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart'         THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_to_cart,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout'      THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_begin_checkout,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_shipping_info'   THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_shipping_info,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_payment_info'    THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_payment_info,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'purchase'            THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_purchase
FROM mercadolibre_events
WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31';


-- Query 2: Embudo de conversión por país
-- Objetivo: Identificar variaciones de conversión por país

SELECT
    country,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'select_item'         THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_select_item,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart'         THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_to_cart,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout'      THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_begin_checkout,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_shipping_info'   THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_shipping_info,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'add_payment_info'    THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_add_payment_info,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN event_name = 'purchase'            THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS conversion_purchase
FROM mercadolibre_events
WHERE event_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY conversion_purchase DESC;


-- ============================================================
-- PARTE 2: ANÁLISIS DE RETENCIÓN POR COHORTES
-- ============================================================

-- Query 3: Conteos acumulados de usuarios activos por país (D7, D14, D21, D28)
-- Objetivo: Contar usuarios activos acumulados por país

SELECT
    country,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) AS users_d7,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) AS users_d14,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) AS users_d21,
    COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) AS users_d28
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;


-- Query 4: Porcentaje de retención por país (D7, D14, D21, D28)
-- Objetivo: Convertir los conteos del Query 3 en porcentajes de retención

SELECT
    country,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d7_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d14_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d21_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d28_pct
FROM mercadolibre_retention
WHERE activity_date BETWEEN '2025-01-01' AND '2025-08-31'
GROUP BY country
ORDER BY country;


-- Query 5: Definir la cohorte de registro por usuario
-- Objetivo: Asignar a cada usuario su cohorte de registro en formato YYYY-MM

SELECT
    user_id,
    MIN(signup_date) AS signup_date,
    TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
FROM mercadolibre_retention
GROUP BY user_id
LIMIT 5;


-- Query 6: Calcular retención por cohorte y periodo (D7, D14, D21, D28)
-- Objetivo: Analizar retención agrupada por mes de registro

-- CTE 1: Asignar cohorte a cada usuario
WITH cohort AS (
    SELECT
        user_id,
        TO_CHAR(DATE_TRUNC('month', MIN(signup_date)), 'YYYY-MM') AS cohort
    FROM mercadolibre_retention
    GROUP BY user_id
),

-- CTE 2: Cruzar actividad con cohorte
activity AS (
    SELECT
        r.user_id,
        c.cohort,
        r.day_after_signup,
        r.active
    FROM mercadolibre_retention AS r
    LEFT JOIN cohort AS c ON c.user_id = r.user_id
    WHERE r.activity_date BETWEEN '2025-01-01' AND '2025-08-31'
)

-- SELECT final: calcular % de retención por cohorte
SELECT
    cohort,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 7  AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d7_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 14 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d14_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 21 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d21_pct,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN day_after_signup >= 28 AND active = 1 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 1) AS retention_d28_pct
FROM activity
GROUP BY cohort
ORDER BY cohort;
