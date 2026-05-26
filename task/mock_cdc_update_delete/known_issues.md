# mock_cdc_update_delete Known Issues

以下风险为阶段 0 手工 Harness 闭环预置，用于验证评审流程是否能识别问题。

1. mock CDC delete 语义未说明：未明确 delete 事件是以 `mock_op = 'd'`、`mock_op_type = 'delete'`、tombstone，还是 before/after 结构表达。
2. SQL 未处理 `mock_op_type = 'delete'` / `mock_op = 'd'`：候选 SQL 使用 `WHERE mock_op <> 'd'` 过滤 delete 事件，删除不会传播到 `mock_order_state`。
3. 未说明 `mock_event_time` / watermark 语义：当前 SQL 设置了 watermark，但任务材料未说明乱序、迟到数据、同一 `mock_order_id` 多事件排序规则。
4. mock 补数数据是否进入同一 topic 未说明：如果 mock 历史补数和 mock 实时 CDC 共用 `mock_cdc_order_events`，可能造成重复、乱序或旧状态覆盖新状态。
5. 下游 upsert 主键语义待确认：`mock_order_state` 使用 `mock_order_id` 作为 `PRIMARY KEY NOT ENFORCED`，但未说明下游是否按该 key 正确执行 upsert/delete。
