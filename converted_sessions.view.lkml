view: converted_sessions {
  derived_table: {
    sql: SELECT e1.session_id, e1.user_id FROM public.events e1
      RIGHT JOIN (select session_id from public.events where event_type LIKE 'Purchase') e2 on e1.session_id=e2.session_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: sessions_count {
    type: count_distinct
    sql: ${session_id} ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  measure: average_events_per_session_with_purchase {
    type: number
    sql: 1.0*${count}/${sessions_count} ;;
    value_format: "#.0"
  }

  set: detail {
    fields: [session_id, user_id]
  }
}
