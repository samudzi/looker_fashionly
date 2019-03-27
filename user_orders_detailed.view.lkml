view: user_orders_detailed {
  derived_table: {
    persist_for: "48 hours"
    distribution_style: even
    sortkeys: ["user_id"]
    sql: SELECT
        user_id
        , COUNT(DISTINCT order_id) AS lifetime_orders
        , SUM(sale_price) AS lifetime_revenue
        , MIN(NULLIF(created_at,0)) AS first_order_date
        , MAX(NULLIF(created_at,0)) AS latest_order_date
        , COUNT(DISTINCT DATE_TRUNC('month', NULLIF(created_at,0))) AS number_of_distinct_months_with_orders
      FROM ORDER_ITEMS
      GROUP BY user_id;;
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: lifetime_orders_tiered {
    type: tier
    tiers: [1,2,3,6,10]
    style: integer
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_revenue_tiered {
    type: tier
    tiers: [0,5,20,50,100,500,1000,10000]
    style: integer
    sql: ${lifetime_revenue};;
    value_format: "$#.00;($#.00)"
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: days_since_latest_order{
    type: duration_day
    sql_start: ${latest_order_date};;
    sql_end: CURRENT_DATE;;
  }

  dimension: is_active {
    type: yesno
    sql: ${days_since_latest_order} < 90 ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }


  measure: total_lifetime_orders {
    type: sum
    sql: ${lifetime_orders} ;;
    drill_fields: [detail*]
  }

  measure: average_lifetime_orders {
    type: average
    sql: ${lifetime_orders} ;;
    drill_fields: [detail*]
  }

  measure: total_lifetime_revenue {
    type: sum
    sql: ${lifetime_revenue} ;;
    drill_fields: [detail*]
    value_format: "$#,##0.00;($#,##0.00)"
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${lifetime_revenue} ;;
    drill_fields: [detail*]
    value_format: "$#,##0.00;($#,##0.00)"
  }

  measure: average_days_since_latest_order{
    type: average
    sql: ${days_since_latest_order} ;;
    value_format: "0"
  }

  measure: active_user_count {
    type: count_distinct
    sql: ${is_active} ;;
    filters: {
      field: is_active
      value: "Yes"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      user_id,
      lifetime_orders,
      lifetime_revenue,
      first_order_time,
      latest_order_time,
      number_of_distinct_months_with_orders
    ]
  }
}
