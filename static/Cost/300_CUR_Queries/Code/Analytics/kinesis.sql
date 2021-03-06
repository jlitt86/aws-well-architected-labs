SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
  SPLIT_PART(line_item_resource_id,':',6) as split_line_item_resource_id,
  product_product_name,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16, 8))) AS sum_line_item_unblended_cost
FROM 
  ${table_Name} 
WHERE
  year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
  AND product_product_name IN ('Amazon Kinesis','Amazon Kinesis Firehose','Amazon Kinesis Analytics','Amazon Kinesis Video')
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
GROUP BY
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_resource_id,
  product_product_name
ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost DESC;