view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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

  dimension: user_lessthan_90_days {
    type: yesno
    sql: DATEPART(DAY, CURRENT_TIMESTAMP) - DATEPART(DAY, ${created_date}) =< 90 ;;
  }

  dimension: age_buckets {
    type: tier
    tiers: [15,26,36,51,66]
    style: integer
    sql: ${age} ;;
  }


  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  #Month-to-date Dimension
  dimension: is_before_mtd {
    type: yesno
    sql:
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

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }

  measure: total_number_new_users_yesterday {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: created_date
      value: "yesterday"
    }
  }
}
