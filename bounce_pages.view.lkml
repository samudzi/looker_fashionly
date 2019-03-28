view: bounce_pages {
  derived_table: {
    sql: select e1.user_id, e1.session_id,event_type from public.events e1
      join
      (
      select session_id, max(sequence_number) as seqmax
      from public.events
      group by session_id
      ) e2
      on e1.session_id = e2.session_id and e2.seqmax = e1.sequence_number
       ;;

      persist_for: "48 hours"
      indexes: ["session_id"]
      distribution_style: all
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
    primary_key: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: event_type {
    type: string
    sql: ${TABLE}.event_type ;;
  }

  measure: count_sessions_without_purchase {
    type: count_distinct
    sql: ${session_without_purchase} ;;
  }

  dimension: session_without_purchase {
    type: yesno
    sql: ${event_type} <> "Purchase";;
  }

  set: detail {
    fields: [session_id, event_type]
  }
}
