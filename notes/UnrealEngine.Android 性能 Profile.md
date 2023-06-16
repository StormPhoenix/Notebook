---
id: jjhcri1iube4g69pcgpmyp8
title: Android 性能 Profile
desc: ''
updated: 1686906811552
created: 1686903844365
---

测试 Case: 迅速转动视角，帧率下降四五帧。

#### RenderThread Insight

DeleteSceneRenderer

- 物件从场景中删除所用耗时增加
FScene_RemovePrimitiveSceneInfos 用时增多，3.1 ms

- 动态物件增多，动态创建的 Mesh 耗时增多
FSceneRenderer_GatherDynamicMeshElements 8.3 ms

- 有新物件进入，准备每个 Pass 所需指令用时增加
多个 MeshDrawCommandPassSetupTask 并行执行，10 个左右 Pass 分布在 4 个后台线程。Render Thread 等待上述 Task 执行完毕（同时后台会处理一些 CharactorMesh0 之类的任务）。


测试 Case：静止不动

#### RenderThread Insight

- CPU 处理任务太多

RenderThread 只有等后台的 MeshDrawCommandPassSetupTask 执行完，才会提交绘制。UnrealInsight 显示当后台 Task 被执行完毕的时候，RenderThread 依旧处于较长的等待时间，说明 CPU 在忙于其他任务。