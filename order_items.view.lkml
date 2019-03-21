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

  measure: item_return_rate {
    type: number
    sql: ${number_of_returns} ;;
    value_format: "#.00%"
  }

  measure: count_of_customers_with_returns {
    type: count_distinct
    sql:  ${user_id};;
    filters: {
      field: status
      value: "Returned"
    }
  }

  measure: total_user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: customer_return_percent {
    type: number
    sql: ${count_of_customers_with_returns}/${total_user_count} ;;
    value_format:"#.00%"
  }

  measure: average_spend_per_customer {
    type: number
    sql: ${total_sale_price}/${users.count} ;;
    value_format:"$#.00;($#.00)"
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
