# Flink 作业设计评审检查清单

本清单用于阶段 0 手工 Harness 闭环，聚焦 Flink CDC 实时作业设计评审。所有条目均适用于 mock / 脱敏样例。

1. **CDC insert/update/delete 语义是否完整**
   - 确认 insert、update、delete 三类变更是否都有明确输入格式、处理逻辑和下游结果。

2. **before/after 字段口径是否说明**
   - 确认 CDC 事件是否包含 before/after，以及 SQL 使用的是变更前值、变更后值，还是仅使用 after。

3. **主键语义是否明确**
   - 确认 source 主键、业务主键、sink upsert 主键是否一致；若不一致，需要说明映射和冲突处理策略。

4. **event_time 字段是否可靠**
   - 确认 event_time 来源、精度、时区、空值策略，以及是否能表达源端真实变更顺序。

5. **watermark 策略是否合理**
   - 确认 watermark 延迟阈值、迟到数据处理方式，以及该策略是否匹配业务可接受延迟。

6. **乱序、迟到、重复事件是否有处理策略**
   - 确认同一主键下乱序 update/delete、迟到事件、重复 CDC 事件是否会覆盖正确状态或造成重复输出。

7. **补数、冲正、撤销是否与实时流隔离或标识**
   - 确认补数数据是否进入同一 topic，冲正和撤销是否有独立 op_type 或标识，避免历史数据覆盖实时状态。

8. **下游 upsert 语义是否可落地**
   - 确认 sink connector、key format、value format、delete/tombstone 语义，以及下游是否按主键执行 upsert/delete。

9. **状态和 TTL 是否满足业务语义**
   - 确认作业是否依赖 keyed state、join state、去重 state；TTL 是否会导致迟到 update/delete 无法正确处理。

10. **字段、表、topic 口径是否完整**
    - 确认字段含义、表名、topic 名、分区策略、数据格式、枚举值、空值含义是否齐全，是否存在口径缺失。

11. **异常数据和未知 op_type 是否有保护**
    - 确认空主键、非法金额、未知 op_type、缺失 after、脏 JSON 等异常输入是否有过滤、旁路或告警策略。

12. **上线前测试场景是否覆盖关键路径**
    - 至少覆盖 insert、update、delete、乱序 update/delete、迟到事件、重复事件、补数混入、冲正、撤销、sink delete。

13. **人工确认项是否明确记录**
    - 对无法仅凭材料判断的事项，记录需要人工确认的 owner、问题、期望答案、确认结论和评审日期。
