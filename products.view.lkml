view: products {
  sql_table_name: public.products ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    drill_fields: [category,inventory_items.product_name]
    link: {
      label: "Brand Website"
      url: "https://www.google.com/search?q=%{{value}}%"
    }
    link: {
      label: "Brand Facebook Page"
      url: "https://www.facebook.com/search/str/{{value}}/keywords_search"
    }
    link: {
      label: "Drill Dashboard"
      url: "/dashboards/SuQrBgIHC57ReTha7zEPFf?Brand=={{ _filters['products.brand'] | url_encode }}"
    }
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [brand]
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
