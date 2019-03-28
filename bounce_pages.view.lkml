view: bounce_pages {
  derived_table: {
    sql: select e1.session_id,event_type from public.events e1
      join
      (
      select session_id, max(sequence_number) as seqmax
      from public.events
      group by session_id
      ) e2
      on e1.session_id = e2.session_id and e2.seqmax = e1.sequence_number
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

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  set: detail {
    fields: [session_id, event_type]
  }
}
