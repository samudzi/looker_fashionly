connection: "thelook_events_redshift"

# include all the views
include: "*.view"

datagroup: samudzi_sandbox_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: samudzi_sandbox_default_datagroup

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}


explore: user_orders_detailed {
  join: order_items {
    sql_on: ${order_items.user_id} = ${user_orders_detailed.user_id} ;;
    relationship: one_to_many
    type: left_outer
  }
  join: users {
    #fields: [-users.id]
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_orders_detailed.user_id} ;;
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }
  join: products {
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  }

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: many_to_many
    required_joins: [users]
  }

  join: converted_sessions {
    type: left_outer
    sql_on: ${converted_sessions.user_id} = ${users.id} ;;
    relationship: many_to_one
    required_joins: [users]
  }
}
