view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
    drill_fields: [products.category,products.brand]
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: time_between_ordered_and_delivered {
    type: duration_day
    sql_start: ${created_date};;
    sql_end: ${delivered_date};;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }


  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
  }

  #------ Maire's Case Study Part 0 Metrics -------#

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format:"$#.00;($#.00)"
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    value_format:"$#.00;($#.00)"
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${sale_price} ;;
    value_format:"$#.00;($#.00)"
  }

  measure: total_gross_revenue {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: status
      value: "Complete"
    }
    value_format:"$#.00;($#.00)"
  }

  measure: total_gross_margin {
    type: number
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
    value_format:"$#.00;($#.00)"
    drill_fields: [products.brand,products.category]
  }

  measure: average_gross_margin {
    type: average
    sql: ${sale_price} - ${inventory_items.cost} ;;
    value_format:"$#.00;($#.00)"
    filters: {
      field: status
      value: "Complete"
    }
  }

  measure: gross_margin_percent {
    type: number
    sql: ${total_gross_margin}/${total_gross_revenue} ;;
    value_format: "#.00%"
  }

  measure: number_of_returns {
    type: count
    filters: {
      field: status
      value: "Returned"
      }
    }

    measure: average_count_items_per_sale {
      type: number
      sql: ${count}/${users.count} ;;
    }

#need to cast integer values as floats in order to deliver decimal results
  measure: item_return_rate {
    type: number
    sql: (1.0*${number_of_returns})/${count} ;;
    value_format: "#.00%"
  }

  measure: count_of_customers_with_returns {
    type: count_distinct
    sql:  ${user_id};;
    filters: {
      field: status
      value: "Returned"
    }
    drill_fields: [users.traffic_source]
  }

  measure: total_user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

#need to cast integer values as floats in order to deliver decimal results

  measure: customer_return_percent {
    type: number
    sql: 1.0*${count_of_customers_with_returns}/${total_user_count} ;;
    value_format:"#.00%"
  }

  measure: average_spend_per_customer {
    type: number
    sql: ${total_sale_price}/${users.count} ;;
    value_format:"$#.00;($#.00)"
    drill_fields: [users.gender,users.age_buckets,users.traffic_source]
  }

#---- Maire's Case Study Part 2 Metrics ----
# Total Revenue Yesterday
#Total Number of New Users Yesterday
#Gross Margin % over the Past 30 Days
#Average Spend per Customer over the Past 30 Days

  measure: total_revenue_yesterday  {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: created_date
      value: "yesterday"
    }
    value_format:"$#.00;($#.00)"
  }

  measure: total_gross_revenue_past_month {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: created_date
      value: "last 30 days"
    }
    filters: {
      field: status
      value: "Complete"
    }
    value_format:"$#.00;($#.00)"
  }

  measure: total_revenue_past_month {
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: created_date
      value: "last 30 days"
    }
    value_format:"$#.00;($#.00)"
    drill_fields: [users.gender,users.age_buckets,users.traffic_source]
  }

  measure: total_revenue_per_day_past_90_days {
    type: sum
    sql: ${sale_price}/90 ;;
    filters: {
      field: created_date
      value: "last 90 days"
    }
    value_format:"$#.00;($#.00)"
  }

  measure: total_gross_margin_past_month {
    type: number
    sql: ${total_gross_revenue_past_month} - ${inventory_items.total_cost_past_month} ;;
    value_format:"$#.00;($#.00)"
  }

  measure: gross_margin_percent_past_month {
    type: number
    sql: ${total_gross_margin_past_month}/${total_gross_revenue_past_month} ;;
    value_format: "#.00%"
  }

  measure: average_spend_per_customer_past_month {
    type: number
    sql: ${total_revenue_past_month}/${users.count} ;;
    value_format:"$#.00;($#.00)"
    drill_fields: [users.gender,users.age_buckets,users.traffic_source]
  }

  measure: average_delivery_duration_in_days {
    type: average
    sql: ${time_between_ordered_and_delivered} ;;
    value_format: "#"
    drill_fields: [users.gender,users.age_buckets,users.traffic_source]
  }

  #Month-to-date Dimension
  dimension: is_before_mtd {
    type: yesno
    sql: |
    (EXTRACT(DAY FROM ${TABLE}.created_at) < EXTRACT(DAY FROM GETDATE())
    OR
    (
    EXTRACT(DAY FROM ${TABLE}.created_at) = EXTRACT(DAY FROM GETDATE()) AND
    EXTRACT(HOUR FROM ${TABLE}.created_at) < EXTRACT(HOUR FROM GETDATE())
    )
    OR
    (
    EXTRACT(DAY FROM ${TABLE}.created_at) = EXTRACT(DAY FROM GETDATE()) AND
    EXTRACT(HOUR FROM ${TABLE}.created_at) <= EXTRACT(HOUR FROM GETDATE()) AND
    EXTRACT(MINUTE FROM ${TABLE}.created_at) < EXTRACT(MINUTE FROM GETDATE())
    )
    );;

  }

  # Including Brand info

  measure: brand_percent_of_total_margin {
    type: percent_of_total
    sql: ${total_gross_margin};;
  }

  measure: brand_percent_of_total_revenue {
    type: percent_of_total
    sql: ${total_gross_revenue};;
  }

  measure: percent_of_total_revenue{
    type: percent_of_total
    sql: ${total_sale_price} ;;
    value_format: "0.00\%"
  }

  measure: percent_of_total_sales_volume {
    type: percent_of_total
    sql: ${count} ;;
  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
