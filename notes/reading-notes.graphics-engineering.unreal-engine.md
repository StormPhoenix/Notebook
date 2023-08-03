---
id: w7ut3rkfww9seb5zozr4yfh
title: Unreal Engine
desc: ''
updated: 1691032881540
created: 1688384455522
tags:
  - graphics-engineering
  - unrealengine
---

#### Unreal Engine API 研究

1. RHICmdList.ImmediateFlush(EImmediateFlushType);
2. FTaskGraphInterface::Get().ProcessThreadUntilIdle(ENamedThreads);
3. FTaskGraphInterface::Get().WaitUntilTasksComplete(FGraphEventArray, ENamedThreads);

多阶段资源加载性能分析：https://imzlp.com/posts/22655/


参考：
https://zhuanlan.zhihu.com/p/38881269
https://www.google.com/search?q=waituntiltaskcompletes+unreal&rlz=1C1GCEU_zh-HK__1015__1015&oq=WaitUntilTaskComplete&aqs=chrome.1.69i57j0i512.9671j0j7&sourceid=chrome&ie=UTF-8

#### Unreal Engine Profile 总结

- Unreal Engine 中 Tick 工作方式，关注 FTickFunctionTask https://zhuanlan.zhihu.com/p/511580780
- Tick 小结：https://blog.ch-wind.com/ue4-tick-note/

#### Unreal Engine 使用 tips

https://www.unrealdirective.com/tips

比如Dumpticks，给了个优化方法，让结果更可读。
https://www.unrealdirective.com/tip/dumpticks
Console Variables Editor，可视化的配置
https://www.unrealdirective.com/tip/the-console-variables-editor-plugin
Actor Palette，可以跨Level复制Actor
https://www.unrealdirective.com/tip/the-actor-palette

了解 FScenePrimitiveOctree 的原理，检查 Dynamic Shadow Setup

https://www.uecosmic.com/article/25

# 资源管理
UE 资源管理：引擎打包资源分析 https://imzlp.com/posts/22570/

[Cook单个资产](https://www.google.com/search?q=ue4+cook%E5%8D%95%E4%B8%AA%E8%B5%84%E6%BA%90&newwindow=1&sxsrf=APwXEdevoQxk42zK8XAfi3yCd3LdtrJ-bw%3A1687354094986&ei=7vqSZM3gO6WF2roPwdurGA&oq=UE+%E7%83%98%E5%9F%B9&gs_lcp=Cgxnd3Mtd2l6LXNlcnAQARgCMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADMgoIABBHENYEELADSgQIQRgAUABYAGC3BmgBcAF4AIABAIgBAJIBAJgBAMABAcgBCg&sclient=gws-wiz-serp)

Cook 单个资产 https://zhuanlan.zhihu.com/p/336404977

# HX 引擎 DISM 实现
HXPgcInstancedStaticMeshComponent.cpp && HISM
DynamicInstancedStaticMeshComponent.cpp

这两个都继承了 UInstancedStaticMeshComponent，创建的网格代理也继承了 FInstancedStaticMeshSceneProxy，所以直接参考这个两个的实现。
- UInstancedStaticMeshComponent
- FInstancedStaticMeshSceneProxy

# UE Render Thread 消耗时间的几个阶段

判断可见性 -> 收集 Dynamic 物件 -> 收集 Shadow 物件 -> 收集 Shadow 物件的 Dynamic shadow setup

FSceneRenderer::BeginInitDynamicSHadows
- GatherShadowPrimitives
- STAT_ShadowSceneOctreeTraversal
- GatherShadowPrimitives

Dynamic shadow setup
- STAT_Shadow_GatherDynamicMeshElements ->STAT_HierarchicalInstancedStaticMeshSceneProxy_GetMeshElements

# 通读 UE 渲染管线整个流程
1. https://zhuanlan.zhihu.com/p/36675543
2. 这个很重要，从源码讲起：https://scahp.tistory.com/
3. 剖析 UE 渲染体系：https://www.cnblogs.com/timlly/p/13512787.html
4. Using Compute Shaders in Unreal Engine 4 https://medium.com/realities-io/using-compute-shaders-in-unreal-engine-4-f64bac65a907#5ff3
5. 定义 FVertexFactory 用到的两个宏到底做了什么？https://medium.com/realities-io/creating-a-custom-mesh-component-in-ue4-part-1-an-in-depth-explanation-of-vertex-factories-4a6fd9fd58f2#9d1d
6. https://zhuanlan.zhihu.com/p/339732645

# GamePlay 部分
1. Game Feature 是什么？

# UE 卡通渲染
https://zhuanlan.zhihu.com/p/559373782

# StringTable
StringTable 不存在时的懒加载机制，参考 FText 的构造参数 EStringTableLoadingPolicy

TextHistory Line 2637: FStringTableRegistry::Get().FindStringTable(TableId)

本地化功能参考：
https://blog.csdn.net/l346242498/article/details/72911539/
https://www.bilibili.com/video/BV1cL411D71J/?vd_source=fe2b354520b868ba69b2aedcab7cfe16

csv - po 文件转化、导入 UE 
https://www.youtube.com/watch?v=RkVJ4VDY9_Q

[[reading-notes.graphics-engineering.unreal-engine.公司内网文章文档]]

# Cook 和 Uncooked 的机制


LogMaterial: Error: Tried to access an uncooked shader map ID in a cooked application

LogMaterial: Warning: Invalid shader map ID caching shaders for 'MI_YanWei_liShi_hair2', will use default material.

LogMaterial: Can't compile MI_YanWei_liShi_hair2 with cooked content, will use default material instead

LogMaterial: Warning: [AssetLog] /Game/HXAssets/Standardfile/sequence/mesh/MI_YanWei_liShi_hair2.MI_YanWei_liShi_hair2: Failed to compile Material for platform SF_VULKAN_ES31_ANDROID, Default Material will be used in game.

LogMaterial: Error: Tried to access an uncooked shader map ID in a cooked application

LogMaterial: Warning: Invalid shader map ID caching shaders for 'MI_YanWei_shiBing_hair', will use default material.

LogMaterial: Can't compile MI_YanWei_shiBing_hair with cooked content, will use default material instead

LogMaterial: Warning: [AssetLog] /Game/HXAssets/Standardfile/sequence/mesh/MI_YanWei_shiBing_hair.MI_YanWei_shiBing_hair: Failed to compile Material for platform SF_VULKAN_ES31_ANDROID, Default Material will be used in game.

#todolist
# 会用 UE  
EngineMemoryWarningHandler 检查当前内存占用大小的
GCurrentTextureMemorySize
GCurrentRendertargetMemorySize
ENQUEUE_RENDER_COMMAND

# 蓝图和 C++ 
https://mp.weixin.qq.com/s/9SY9uf-s3L1vG1Jp7LKkeg

# 从 0 开始搭建引擎

https://www.zhihu.com/question/611627029/answer/3117592990

# UE 引擎 + Prefab
