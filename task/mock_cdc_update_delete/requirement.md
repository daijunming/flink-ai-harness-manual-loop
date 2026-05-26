# mock_cdc_update_delete Requirement

## mock_task_background

本任务用于阶段 0 手工 Harness 闭环，围绕 mock CDC update/delete 实时处理进行材料验证。

业务对象为 `mock_order`，上游通过 `mock_cdc_order_events` 持续产生 mock CDC 事件，包含新增、更新、删除三类变更。候选 SQL 需要将变更处理为下游可消费的 `mock_order_state`。

## mock_task_goal

验证以下材料是否足以支撑人工评审：

- mock 任务包是否能描述清楚输入、输出和边界；
- mock 检查清单是否能发现 CDC update/delete 风险；
- mock Prompt 是否能引导模型输出结构化评审结果；
- mock 结构化输出是否便于人工审核；
- mock 评估记录是否能沉淀评审依据。

## mock_processing_requirement

候选 SQL 应实时消费 `mock_cdc_order_events`，并输出 `mock_order_state`。

期望逻辑：

- `mock_op = 'c'` 时写入新的 mock 订单状态；
- `mock_op = 'u'` 时更新已有 mock 订单状态；
- `mock_op = 'd'` 时删除或标记删除对应 mock 订单状态；
- 同一个 `mock_order_id` 的多次变更应按 `mock_event_time` 和 mock 事件顺序处理；
- 输出应能支撑下游判断 mock 订单的当前状态。

## mock_scope_limits

- 本任务仅使用 mock / 脱敏样例；
- 不接生产系统；
- 不调用模型 API；
- 不要求候选 SQL 可直接上线；
- 允许候选 SQL 中保留可评审风险，用于验证人工评审流程。

## mock_acceptance_focus

人工评审重点关注：

- CDC delete 是否被正确传播；
- update 是否可能被乱序事件覆盖；
- 主键、去重和幂等语义是否清楚；
- 字段空值、缺失字段、异常 `mock_op` 是否有处理策略；
- sink 表是否表达了 mock 当前状态或 mock 删除状态。
