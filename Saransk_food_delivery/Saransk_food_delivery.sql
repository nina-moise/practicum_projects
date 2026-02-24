-- SQL для QL-чатов проекта "Сервис доставки еды в г.Саранске"

-- Задача 1. Расчет DAU. Индикатор
SELECT COUNT(DISTINCT user_id) as dau
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
    AND event = 'order';

-- Задача 1. Расчет DAU. Линейная диаграмма
SELECT log_date,
       COUNT(DISTINCT user_id) AS "Уникальные активные пользователи"
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
  AND event = 'order'
GROUP BY log_date
ORDER BY log_date;

-- Задача 1. Расчет DAU. Таблица
SELECT log_date,
       COUNT(DISTINCT user_id) AS DAU
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
  AND event = 'order'
GROUP BY log_date
ORDER BY log_date;

-- Задача 1. Расчет MAU. Столбчатая диаграмма
SELECT extract(month from log_date) as "Месяц",
       COUNT(DISTINCT user_id) AS MAU
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
  AND event = 'order'
GROUP BY "Месяц"
ORDER BY "Месяц";

-- Задача 2. Расчет Conversion Rate. Индикатор
SELECT ROUND((COUNT(DISTINCT user_id) FILTER (WHERE event = 'order'))/COUNT(DISTINCT user_id)::numeric, 2) AS CR
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск';

-- Задача 2. Расчет Conversion Rate по дням. Линейная диаграмма
SELECT log_date,
       ROUND((COUNT(DISTINCT user_id) FILTER (WHERE event = 'order'))/COUNT(DISTINCT user_id)::numeric, 2) AS CR
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
GROUP BY log_date
ORDER BY log_date;

-- Задача 2. Расчет Conversion Rate. Столбчатая диаграмма по месяцам 
SELECT extract(month from log_date) as "Месяц",
       ROUND((COUNT(DISTINCT user_id) FILTER (WHERE event = 'order'))/COUNT(DISTINCT user_id)::numeric, 3) AS CR
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
GROUP BY "Месяц"
ORDER BY "Месяц";

-- Задача 2. Расчет Conversion Rate. Таблица
SELECT log_date,
       ROUND((COUNT(DISTINCT user_id) FILTER (WHERE event = 'order'))/COUNT(DISTINCT user_id)::numeric, 2) AS CR
FROM rest_analytics.analytics_events AS events
JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
  AND city_name = 'Саранск'
GROUP BY log_date
ORDER BY log_date;

-- Задача 3. Для расчёта среднего чека. Индикатор
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT *,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT  ROUND((SUM(commission_revenue) / COUNT(DISTINCT order_id))::numeric, 2) 
        as "Средний чек"    
FROM orders;

-- Задача 3. Для расчёта среднего чека по дням. Линейная диаграмма
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT *,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT log_date AS "День",
       COUNT(DISTINCT order_id) AS "Количество заказов",
       ROUND(SUM(commission_revenue)::numeric, 2) AS "Сумма комиссии",
       ROUND((SUM(commission_revenue) / COUNT(DISTINCT order_id))::numeric, 2) "Средний чек"
FROM orders
GROUP BY "День"
ORDER BY "День";

-- Задача 3. Для расчёта среднего чека за месяц. Столбчатая диаграмма
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT *,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT extract(month from DATE_TRUNC('month', log_date)) AS "Месяц",
       COUNT(DISTINCT order_id) AS "Количество заказов",
       ROUND(SUM(commission_revenue)::numeric, 2) AS "Сумма комиссии",
       ROUND((SUM(commission_revenue) / COUNT(DISTINCT order_id))::numeric, 2) "Средний чек"
FROM orders
GROUP BY "Месяц"
ORDER BY "Месяц";

-- Задача 3. Для расчёта среднего чека за месяц. Таблица
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT *,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT CAST(DATE_TRUNC('month', log_date) AS date) AS "Месяц",
       COUNT(DISTINCT order_id) AS "Количество заказов",
       ROUND(SUM(commission_revenue)::numeric, 2) AS "Сумма комиссии",
       ROUND((SUM(commission_revenue) / COUNT(DISTINCT order_id))::numeric, 2) "Средний чек"
FROM orders
GROUP BY "Месяц"
ORDER BY "Месяц";

-- Задача 4. Расчет ТОП-3 LTV ресторанов. Линейчатая диаграмма
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT events.rest_id,
          events.city_id,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT --orders.rest_id,
       chain AS "Название сети",
       type AS "Тип кухни",
       ROUND(SUM(commission_revenue)::numeric, 2) AS LTV
FROM orders
JOIN rest_analytics.partners ON orders.rest_id = partners.rest_id AND orders.city_id = partners.city_id
GROUP BY 1, 2 
ORDER BY LTV DESC
LIMIT 3;

-- Задача 4. Расчет ТОП-3 LTV ресторанов. Таблица
-- Рассчитываем величину комиссии с каждого заказа, отбираем заказы по дате и городу
WITH orders AS
  (SELECT events.rest_id,
          events.city_id,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск')
SELECT orders.rest_id,
       chain AS "Название сети",
       type AS "Тип кухни",
       ROUND(SUM(commission_revenue)::numeric, 2) AS LTV
FROM orders
JOIN rest_analytics.partners ON orders.rest_id = partners.rest_id AND orders.city_id = partners.city_id
GROUP BY 1, 2, 3
ORDER BY LTV DESC
LIMIT 3;

-- Задача 5. Расчёт ТОП-5 LTV блюд. Таблица
-- Рассчитываем величину комиссии с каждого заказа, фильтруем заказы по дате и городу
WITH orders AS
  (SELECT events.rest_id,
          events.city_id,
          events.object_id,
          revenue * commission AS commission_revenue
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE revenue IS NOT NULL
     AND log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск'), 
-- Рассчитываем два ресторана с наибольшим LTV
top_ltv_restaurants AS
  (SELECT orders.rest_id,
          chain,
          type,
          ROUND(SUM(commission_revenue)::numeric, 2) AS LTV
   FROM orders
   JOIN rest_analytics.partners partners ON orders.rest_id = partners.rest_id AND orders.city_id = partners.city_id 
   GROUP BY 1, 2, 3
   ORDER BY LTV DESC
   LIMIT 2)
SELECT chain AS "Название сети",
       dishes.name AS "Название блюда",
       spicy as "Острое",
       fish as "Рыба",
       meat as "Мясо",
       ROUND(SUM(orders.commission_revenue)::numeric, 2) AS LTV
FROM orders
JOIN top_ltv_restaurants ON orders.rest_id = top_ltv_restaurants.rest_id
JOIN rest_analytics.dishes dishes ON orders.object_id = dishes.object_id
AND top_ltv_restaurants.rest_id = dishes.rest_id
GROUP BY 1, 2, 3, 4, 5
ORDER BY LTV DESC
LIMIT 5;

-- Задача 6. Reatantion Rate в первую неделю. Линейная диаграмма
-- Рассчитываем новых пользователей по дате первого посещения продукта
WITH new_users AS
  (SELECT DISTINCT first_date,
                   user_id
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE first_date BETWEEN '2021-05-01' AND '2021-06-24'
     AND city_name = 'Саранск'),
-- Рассчитываем активных пользователей по дате события
active_users AS
  (SELECT DISTINCT log_date,
                   user_id
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск'),
daily_retention AS
  (SELECT n.user_id,
          first_date,
          log_date::date - first_date::date AS day_since_install
   FROM new_users AS n
   JOIN active_users AS a ON n.user_id = a.user_id
   AND log_date >= first_date)
SELECT day_since_install,
       COUNT(DISTINCT user_id) AS retained_users,
       ROUND((1.0 * COUNT(DISTINCT user_id) / MAX(COUNT(DISTINCT user_id)) OVER (ORDER BY day_since_install))::numeric, 2) AS retention_rate
FROM daily_retention
WHERE day_since_install < 8
GROUP BY day_since_install
ORDER BY day_since_install;

-- Задача 7. Расчет Retention Rate по месяцам. Линейная диаграмма
-- Рассчитываем новых пользователей по дате первого посещения продукта
WITH new_users AS
  (SELECT DISTINCT first_date,
                   user_id
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE first_date BETWEEN '2021-05-01' AND '2021-06-24'
     AND city_name = 'Саранск'),
-- Рассчитываем активных пользователей по дате события
active_users AS
  (SELECT DISTINCT log_date,
                   user_id
   FROM rest_analytics.analytics_events AS events
   JOIN rest_analytics.cities cities ON events.city_id = cities.city_id
   WHERE log_date BETWEEN '2021-05-01' AND '2021-06-30'
     AND city_name = 'Саранск'),
-- Соединяем таблицы с новыми и активными пользователями
daily_retention AS
  (SELECT n.user_id,
          first_date,
          log_date::date - first_date::date AS day_since_install
   FROM new_users AS n
   JOIN active_users AS a ON n.user_id = a.user_id
   AND log_date >= first_date)
SELECT DISTINCT CAST(DATE_TRUNC('month', first_date) AS date) AS "Месяц",
                day_since_install,
                COUNT(DISTINCT user_id) AS retained_users,
                ROUND((1.0 * COUNT(DISTINCT user_id) / MAX(COUNT(DISTINCT user_id)) OVER (PARTITION BY CAST(DATE_TRUNC('month', first_date) AS date)
ORDER BY day_since_install))::numeric, 2) AS retention_rate
FROM daily_retention
WHERE day_since_install < 8
GROUP BY "Месяц", day_since_install
ORDER BY "Месяц", day_since_install; 



