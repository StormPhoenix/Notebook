---
id: 882z253bip79z759q61qu4a
title: UE 性能分析总结
desc: ''
updated: 1688130257725
created: 1687155541006
tags:
  - unrealengine
---

-> [Unreal Engine 性能分析](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/)

-> https://zhuanlan.zhihu.com/p/514263195

# Unreal Frontend

# Unreal Insight Profile

[Unreal Insights in unreal engine](https://docs.unrealengine.com/5.2/en-US/unreal-insights-in-unreal-engine/)

Unreal Insight 是新一代 UE Profile 工具，比 Stat 更强大。在 UE 中如果使用了如下标签：

- TRACE_CPUPROFILER_EVENT_SCOPE(Name)
- TRACE_BOOKMARK(Name)
- Stat 标签，如 SCOPE_CYCLE_COUNTER(Name)
  
这些标签记录的数据会通过 TCP 连接被 UnrealInsights 程序监听，显示到面板上，供用户分析性能瓶颈。

## Profile 数据收集

UE 提供了一套宏模板让用户自定义标签来分析性能瓶颈区域

### 自定义 Trace 标签

- TRACE_CPUPROFILER_EVENT_SCOPE(Name)

  帧面板中展示的每一小段时间消耗，都在源码中对应一段 Trace 标签。用户在源码中添加 TRACE_CPUPROFILER_EVENT_SCOPE(Name) 宏来自定义 Trace 标签，用来查看目标函数在每帧调用耗时。由用户自定义的 Name，可在 Unreal Insight 中显示。

- TRACE_CPUPROFILER_EVENT_SCOPE_TEXT(Name)

  功能同 TRACE_CPUPROFILER_EVENT_SCOPE(Name)，区别在于 Name 可以动态变化。比如将当前函数内某个字符串变量作为 Name。

- SCOPE_CYCLE_COUNTER(StatName)

  功能同 TRACE_CPUPROFILER_EVENT_SCOPE()，也可以在 Unreal Insight 展示帧时间消耗

- TRACE_CPUPROFILER_EVENT_SCOPE_TEXT_ON_CHANNEL(Name, Channel)
  
  自定义 Trace 标签属于哪个 Channel。

### 用 Channel 过滤不同类别 Trace

Channel 的作用是只显示某些类别的 Trace 标签。上文中通过宏  TRACE_CPUPROFILER_EVENT_SCOPE 定义的 Trace 标签默认归属于 CpuChannel 类别。
  ```
  #define TRACE_CPUPROFILER_EVENT_SCOPE(Name) \
        TRACE_CPUPROFILER_EVENT_SCOPE_ON_CHANNEL(Name, CpuChannel)
  ```
展开宏发现内部间接调用了 TRACE_CPUPROFILER_EVENT_SCOPE_ON_CHANNEL，其 Channel 参数默认为 CpuChannel。由此可知，如果希望将自定义的 Trace 标签归类于某个 Channel，可以使用 TRACE_CPUPROFILER_EVENT_SCOPE_ON_CHANNEL(Name, Channel) 宏。

- UE_TRACE_CHANNEL_DEFINE
- SCOPED_NAMED_EVENT_TEXT
- SCOPED_NAMED_EVENT
  宏展开后可以发现它间接调用了 TRACE_CPUPROFILER_EVENT_SCOPE，并新增了 FScopedNamedEventStatic 变量。

## 实现原理
### Unreal Insights 
### Trace 

TRACE_CPUPROFILER_EVENT_SCOPE_ON_CHANNEL_STR 展开得到两个变量：__CpuProfilerEventSpecIdXXX，__CpuProfilerEventScopeXXX，前者 uint32 类型，为 Trace 的 ID，后者类型为 FCpuProfilerTrace::FEventScope。检查 FEventScope 的实现，如下

```
struct FEventScope 
{
    FEventScope(uint32 InSpecId, const Trace::FChannel& Channel) // 构造函数
        : bEnabled(Channel | CpuChannel) // 如果 -trace 包含 cpu 或自定义的 channel，则 bEnabled 为 true
    {
        if (bEnabled) {
            OutputBeginEvent(InSpecId);
        }
    }

    ~FEventScope() 
    {
        if (bEnabled)
        {
            OutputEndEvent();
        }
    }

    bool bEnabled;
}
```

发现 FEventScope 在被定义的作用域里创建、销毁时会判断 bEnabled 调用 OutputBeginEvent()、OutputEndEvent() 函数，而 bEnabled 指当前是否要启用该 Trace 标签，代码中的实现是：

```
bEnabled(Channel | CpuChannel)
```

这说明，只要 -trace 包含 cpu，则通过 TRACE_CPUPROFILER_EVENT_SCOPE_XXX 宏来定义的 trace 标签都会输出到 Unreal Insights。

TODO

-> [Unreal Insights](https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Overview/)

内存分析

## LLM

- LLM_SCOPE_BYNAME
定义在函数里，用于在 Unreal Insight 里追踪目标函数内分配的内存是否有被回收。

### Android Studio Profile

-> https://www.cnblogs.com/kekec/p/16318648.html


TODO 参考：
（重点参考）Unreal Insight 原理分析 https://zhuanlan.zhihu.com/p/458086085

Unreal Frontend 用法 https://docs.unrealengine.com/4.27/zh-CN/TestingAndOptimization/PerformanceAndProfiling/Profiler/

Unreal Insight Trace 介绍 https://docs.unrealengine.com/4.26/zh-CN/TestingAndOptimization/PerformanceAndProfiling/UnrealInsights/Reference/Trace/

Unreal Insight 用法 
https://zhuanlan.zhihu.com/p/444191961
https://zhuanlan.zhihu.com/p/511148107

