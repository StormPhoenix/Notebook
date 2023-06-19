---
id: jjhcri1iube4g69pcgpmyp8
title: Android 性能 Profile
desc: ''
updated: 1687173449018
created: 1686903844365
---

HXNext 项目性能 Profile

#### 开关说明

- terrain.visible 0：地形不显示
- foliage.cullall 1：树木不显示
- vege.enable 0：草不显示
- showflag.staticmeshes 0：静态物件不显示
- show PostProcessing 后处理开关

#### Case1：跑动转动的情况，帧率下降 4 5 帧，但对比 Unreal Insight 又没法查出是什么地方有问题。

#### Case2：树林内静止
- 渲染所有物件。
FPS：23~33

- 关闭地形
无较明显变化

- 关闭地形 + 树
无较明显变化

- 关闭地形 + 树 + 草
无明显变化

- 关闭地形 + 树 + 草 + Skeletal Mesh
有 4 ms 左右的的开销，帧率提升

- 关闭地形 + 树 + 草 + Static Mesh
FPS=32左右。

- 关闭地形 + 树 + 草 + Static/Skeletal Mesh
FPS=35左右

测试机型：Xiaomi 13，骁龙 8 Gen 2

测试了不同物件类型对帧率的影响，包括：树、草、地形、Static