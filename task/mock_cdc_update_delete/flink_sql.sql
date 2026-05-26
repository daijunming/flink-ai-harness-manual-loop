-- mock_cdc_update_delete candidate SQL
-- This SQL is intentionally reviewable and contains known risks for stage 0.

CREATE TABLE mock_cdc_order_events (
  mock_event_id STRING,
  mock_order_id STRING,
  mock_user_id STRING,
  mock_status STRING,
  mock_amount DECIMAL(18, 2),
  mock_op STRING,
  mock_event_time TIMESTAMP(3),
  mock_ingest_time TIMESTAMP(3),
  WATERMARK FOR mock_event_time AS mock_event_time - INTERVAL '5' SECOND
) WITH (
  'connector' = 'kafka',
  'topic' = 'mock_cdc_order_events',
  'properties.bootstrap.servers' = 'mock-kafka:9092',
  'properties.group.id' = 'mock_cdc_update_delete_group',
  'scan.startup.mode' = 'earliest-offset',
  'format' = 'json'
);

CREATE TABLE mock_order_state (
  mock_order_id STRING,
  mock_user_id STRING,
  mock_status STRING,
  mock_amount DECIMAL(18, 2),
  mock_last_event_id STRING,
  mock_last_event_time TIMESTAMP(3),
  PRIMARY KEY (mock_order_id) NOT ENFORCED
) WITH (
  'connector' = 'upsert-kafka',
  'topic' = 'mock_order_state',
  'properties.bootstrap.servers' = 'mock-kafka:9092',
  'key.format' = 'json',
  'value.format' = 'json'
);

INSERT INTO mock_order_state
SELECT
  mock_order_id,
  mock_user_id,
  mock_status,
  mock_amount,
  mock_event_id,
  mock_event_time
FROM mock_cdc_order_events
WHERE mock_op <> 'd';
