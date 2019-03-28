view: events {
  sql_table_name: public.events ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: browser {
    type: string
    sql: ${TABLE}.browser ;;
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

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  dimension: ip_address {
    type: string
    sql: ${TABLE}.ip_address ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: sequence_number {
    type: number
    sql: ${TABLE}.sequence_number ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: uri {
    type: string
    sql: ${TABLE}.uri ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.id, users.first_name, users.last_name]
  }

  measure: count_of_sessions {
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: count_of_events_from_sessions_without_purchase {
    type: number
    sql: ${count}-${converted_sessions.count} ;;
  }

  measure: average_events_per_session {
    type: number
    sql: 1.0*${count}/${count_of_sessions} ;;
    value_format: "#.0"
  }

  measure: average_events_per_session_without_purchase {
    type: number
    sql: 1.0*${count_of_events_from_sessions_without_purchase}/${count_sessions_without_purchase} ;;
  }

  dimension: made_purchase {
    type: yesno
    sql: ${event_type} = 'Purchase' ;;
  }

  measure: count_sessions_without_purchase {
    type: number
    sql: ${count_of_sessions} - ${converted_sessions.sessions_count} ;;
  }

  measure: average_sessions_per_user {
    type: number
    sql: 1.0*${count_of_sessions}/${users.count} ;;
    value_format: "#.0"
  }

  measure: average_sessions_per_user_without_purchase {
    type: number
    sql: 1.0*${count_sessions_without_purchase}/${users.count} ;;
    value_format: "#.0"
  }
}
