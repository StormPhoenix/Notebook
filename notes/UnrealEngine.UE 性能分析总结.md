---
id: 882z253bip79z759q61qu4a
title: UE 性能分析总结
desc: ''
updated: 1687160799340
created: 1687155541006
---

-> [Unreal Engine 性能分析](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/)

-> https://zhuanlan.zhihu.com/p/514263195

### Unreal Insight Profile

##### Unreal Insight 面板布局

- Frame Plane
双击目标标签，可高亮显示所有目标标签，方便查看耗时变化。

- Timer Plane

性能分析

##### SCOPED_NAMED_EVENT_TEXT

TODO

##### 用 Trace 宏自定义 CPU 性能开销

- TRACE_CPUPROFILER_EVENT_SCOPE
在目标函数中添加 'TRACE_CPUPROFILER_EVENT_SCOPE' 宏，可在 Unreal Insight 中展示目标函数消耗的时间

- TRACE_CPUPROFILER_EVENT_SCOPE_TEXT(自定义 text)
功能同上，但这个宏的标签是动态自定义的。

##### 用 Channel 开启/关闭不同类别的 Trace

- UE_TRACE_CHANNEL_DEFINE 
相当于一个开关，用于控制 Unreal Insight 里面可以看到哪些 Trace 标签。

-> [Unreal Insights](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/)

内存分析

##### LLM

- LLM_SCOPE_BYNAME
定义在函数里，用于在 Unreal Insight 里追踪目标函数内分配的内存是否有被回收。

### Android Studio Profile

-> https://www.cnblogs.com/kekec/p/16318648.html
