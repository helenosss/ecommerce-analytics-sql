# ecommerce-analytics-sql

This repository contains a SQL-based analytical project focused on user account creation, email activity and behavioral metrics in an e-commerce database (BigQuery).

## Project Overview

The goal of the analysis is to explore:
- the dynamics of account creation,
- user engagement with email communication (sent, opened, clicked messages),
- differences in user behavior based on country, send interval, verification status and subscription status.

Data is aggregated by the following dimensions:  
`date`, `country`, `send_interval`, `is_verified`, `is_unsubscribed`.

## Metrics Calculated

### Account metrics
- **account_cnt** – number of newly created accounts  
- **total_country_account_cnt** – total accounts created per country  
- **rank_total_country_account_cnt** – ranking of countries by total account count  

### Email metrics
- **sent_msg** – number of emails sent  
- **open_msg** – number of emails opened  
- **visit_msg** – number of link visits  
- **total_country_sent_cnt** – total emails sent per country  
- **rank_total_country_sent_cnt** – ranking of countries by total sent emails  

## SQL Script Description

The SQL script includes:
- the use of CTEs to separate logical parts of the query,
- separate calculation of account and email metrics due to differing date logic,
- window functions for country-level ranking,
- a final `UNION` to combine both datasets,
- filtering to retain only the top-10 countries by account or email activity.

The full SQL query is provided in the file `ecommerce_metrics.sql`.

## Visualisation

A Looker Studio visualisation was created using the results of the SQL query.  
It presents:
- total accounts by country,
- total sent emails by country,
- country rankings,
- daily dynamics of sent emails.
  
The screenshots of the diagrams are available in the repository.

### Created accounts by countries
![created_accounts_by_countries](https://raw.githubusercontent.com/helenosss/ecommerce-analytics-sql/main/created_accounts_by_countries.png)

### Sent messages by countries
![sent_messages_by_countries](https://raw.githubusercontent.com/helenosss/ecommerce-analytics-sql/main/sent_messages_by_countries.png)

### Country ranking by created accounts
![country_account_rank_map](https://raw.githubusercontent.com/helenosss/ecommerce-analytics-sql/main/country_account_rank_map.png)

### Country ranking by sent messages
![country_sent_messages_rank_map](https://raw.githubusercontent.com/helenosss/ecommerce-analytics-sql/main/country_sent_messages_rank_map.png)

### Sent emails dynamics
![sent_emails_dynamics](https://raw.githubusercontent.com/helenosss/ecommerce-analytics-sql/main/sent_emails_dynamics.png)
