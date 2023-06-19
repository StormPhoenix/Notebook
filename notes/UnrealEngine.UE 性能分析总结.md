---
id: 882z253bip79z759q61qu4a
title: UE 性能分析总结
desc: ''
updated: 1687197907093
created: 1687155541006
---

-> [Unreal Engine 性能分析](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/)

-> https://zhuanlan.zhihu.com/p/514263195

### Unreal Frontend

### Unreal Insight Profile

Unreal Insight 是新一代 UE Profile 工具，比 Stat 更强大。

1. Unreal Insight 面板布局

- Frame Plane
双击目标标签，可高亮显示所有目标标签，方便查看耗时变化。

- Timer Plane

2. 性能分析

- TRACE_CPUPROFILER_EVENT_SCOPE(自定义名称)

在目标函数中添加 TRACE_CPUPROFILER_EVENT_SCOPE(xxx) 宏，其中 xxx 为用户自定义名称，则可在 Unreal Insight 帧时间面板中查看目标函数的每帧耗时。

- TRACE_CPUPROFILER_EVENT_SCOPE_TEXT(自定义名称)

功能同 TRACE_CPUPROFILER_EVENT_SCOPE(xxx)，区别在于 xxx 可以动态变化。比如将当前函数内某个字符串作为 xxx。

##### 用 Channel 开启/关闭不同类别的 Trace

- UE_TRACE_CHANNEL_DEFINE 
相当于一个开关，用于控制 Unreal Insight 里面可以看到哪些 Trace 标签。

##### SCOPED_NAMED_EVENT_TEXT

TODO

-> [Unreal Insights](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/)

内存分析

##### LLM

- LLM_SCOPE_BYNAME
定义在函数里，用于在 Unreal Insight 里追踪目标函数内分配的内存是否有被回收。

### Android Studio Profile

-> https://www.cnblogs.com/kekec/p/16318648.html


TODO 参考：
（重点参考）Unreal Insight 原理分析 https://zhuanlan.zhihu.com/p/458086085


Unreal Insight Trace 介绍 https://docs.unrealengine.com/4.26/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Reference/Trace/

Unreal Insight 用法 
https://zhuanlan.zhihu.com/p/444191961
https://zhuanlan.zhihu.com/p/511148107

