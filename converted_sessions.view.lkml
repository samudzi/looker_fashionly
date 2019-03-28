view: converted_sessions {
  derived_table: {
    sql: SELECT e1.session_id, e1.user_id FROM public.events e1
      RIGHT JOIN (select session_id from public.events where event_type LIKE 'Purchase') e2 on e1.session_id=e2.session_id
      WHERE event_type LIKE 'Purchase'
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  set: detail {
    fields: [session_id, user_id]
  }
}
