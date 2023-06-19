---
id: 882z253bip79z759q61qu4a
title: UE 性能分析总结
desc: ''
updated: 1687156368952
created: 1687155541006
---

### Unreal Insight 的使用

性能开销

##### Trace
- TRACE_CPUPROFILER_EVENT_SCOPE
在目标函数中添加 'TRACE_CPUPROFILER_EVENT_SCOPE' 宏，可在 Unreal Insight 中展示目标函数消耗的时间

- TRACE_CPUPROFILER_EVENT_SCOPE_TEXT(自定义 text)
功能同上，但这个宏的标签是动态自定义的。

##### Channel

- UE_TRACE_CHANNEL_DEFINE 
相当于一个开关，用于控制 Unreal Insight 里面可以看到哪些 Trace 标签。

参考：[Unreal Insight](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/)

内存开销

##### LLM

- LLM_SCOPE_BYNAME
定义在函数里，用于在 Unreal Insight 里追踪目标函数内分配的内存是否有被回收。
