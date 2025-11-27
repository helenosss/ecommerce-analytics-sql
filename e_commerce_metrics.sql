WITH
--розрахунок кількості повідомлень
  email_metrics AS (
  SELECT
    DATE_ADD(s.date, INTERVAL es.sent_date day) AS date,
    sp.country,
    a.send_interval,
    a.is_unsubscribed,
    a.is_verified,
    COUNT(DISTINCT es.id_message) AS sent_msg,
    COUNT(DISTINCT eo.id_message) AS open_msg,
    COUNT(DISTINCT ev.id_message) AS visit_msg
  FROM
    `DA.email_sent` es
  LEFT JOIN
    `DA.email_open` eo
  ON
    es.id_message = eo.id_message
  LEFT JOIN
    `DA.email_visit` ev
  ON
    es.id_message = ev.id_message
  JOIN
    `DA.account_session` acs
  ON
    acs.account_id = es.id_account
  JOIN
    `DA.account` a
  ON
    a.id = es.id_account
  JOIN
    `DA.session` s
  ON
    acs.ga_session_id = s.ga_session_id
  JOIN
    `DA.session_params` sp
  ON
    sp.ga_session_id = acs.ga_session_id
  GROUP BY
    date,
    country,
    a.send_interval,
    a.is_unsubscribed,
    a.is_verified),


    --кількість створених акаунтів
  account_metrics AS (
  SELECT
    s.date,
    sp.country,
    a.send_interval,
    a.is_unsubscribed,
    a.is_verified,
    COUNT(DISTINCT acs.account_id) AS account_cnt
  FROM
    `DA.session` s
  JOIN
    `DA.account_session` acs
  ON
    acs.ga_session_id = s.ga_session_id
  JOIN
    `DA.account` a
  ON
    a.id = acs.account_id
  JOIN
    `DA.session_params` sp
  ON
    sp.ga_session_id = acs.ga_session_id
  GROUP BY
    date,
    country,
    a.send_interval,
    a.is_unsubscribed,
    a.is_verified),


    --об'єднання даних про повідомлення і акаунти
  union_all AS (
  SELECT
    date,
    country,
    send_interval,
    is_unsubscribed,
    is_verified,
    0 AS account_cnt,
    sent_msg,
    visit_msg,
    open_msg
  FROM
    email_metrics
  UNION ALL
  SELECT
    date,
    country,
    send_interval,
    is_unsubscribed,
    is_verified,
    account_cnt,
    0 AS sent_msg,
    0 AS visit_msg,
    0 AS open_msg
  FROM
    account_metrics),


    --сумування та групування даних
  grouped_data AS(
  SELECT
    date,
    country,
    send_interval,
    is_unsubscribed,
    is_verified,
    SUM(account_cnt) AS account_cnt,
    SUM(sent_msg) AS sent_msg,
    SUM(visit_msg) AS visit_msg,
    SUM(open_msg) AS open_msg
  FROM
    union_all
  GROUP BY
    date,
    country,
    send_interval,
    is_unsubscribed,
    is_verified ),


    --розрахунок загальних кількостей акаунтів і надісланих повідомлень для кожної країни
  total_by_country AS(
  SELECT
    *,
    SUM(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
    SUM(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt
  FROM
    grouped_data ),


    --рейтинг для країн
  country_rank AS(
  SELECT
    *,
    DENSE_RANK() OVER(ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
    DENSE_RANK() OVER(ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt,
  FROM
    total_by_country )




SELECT
  *
FROM
  country_rank
WHERE
  rank_total_country_account_cnt <= 10
  OR rank_total_country_sent_cnt <= 10
