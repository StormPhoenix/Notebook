---
id: 57wtylur090ehnikh8v4aw6
title: Graphics Engineering
desc: ''
updated: 1696907547660
created: 1689136596785
tags:
  - graphics-engineering
---

https://flaxengine.com/

http://www.gamelook.com.cn/2023/07/520218

Position-based Dynamic


# G-Buffer
Deferred Shading 目的是为了渲染带有大量光源的场景。先计算出场景的几何信息，在考虑光照计算，把光照计算计算阶段推迟到了管线末尾计算。因此 deferred shading 能够降低多光源渲染压力的真正原因是：

- 推迟 lighing pass，不用每个光源遍历每个物体渲染
- Light volume，只渲染收到光照影响的物体

#todolist 研究清楚 OpenGL 教程里说的 Tile-based deferred shading 具体指什么
基于 deferred shading 的两个新方法：
- Deferred lighting
- Tile-based deferred shading

参考：https://learnopengl-cn.github.io/05%20Advanced%20Lighting/08%20Deferred%20Shading/# 动态地形 

# 动态地形
https://blog.csdn.net/yinhun2012/article/details/122211918
https://blog.csdn.net/yinhun2012/article/details/122382905

Tessellation
https://docs.unity3d.com/510/Documentation/Manual/SL-SurfaceShaderTessellation.html

# 多线程渲染
#todolist

Unity 多线程渲染
https://zhuanlan.zhihu.com/p/591218281

UE 多线程渲染
https://zhuanlan.zhihu.com/p/583406953

# Unity
1. Catlikecoding tutorials https://catlikecoding.com/unity/tutorials/
2. Unity 渲染管线，自定义 Scriptable Rendering Pipeline (SRP), Tile Base / Cluster Forward + 管线
- URP(Universal Render Pipeline)
- SRP(Scriptable Rendering Pipeline)


----
- [Object Management](https://catlikecoding.com/unity/tutorials/object-management/)
- [Precedual Grid](https://catlikecoding.com/unity/tutorials/procedural-grid/)
- [Custom SRP](https://catlikecoding.com/unity/tutorials/custom-srp/)
  - [Custom Render Pipeline](https://catlikecoding.com/unity/tutorials/custom-srp/custom-render-pipeline/) 

## Zhihu
----
- [(教程汇总+持续更新)Unity从入门到入坟——收藏这一篇就够了](https://zhuanlan.zhihu.com/p/151238164)
- [Unity SRP自定义渲染管线-系列教程（转载）](https://zhuanlan.zhihu.com/p/106275450)

- [Unity URP/SRP 渲染管线浅入深出【匠】](https://zhuanlan.zhihu.com/p/353687806)
- [ILRuntime作者林若峰分享：次世代手游渲染怎么做](313298603)
- [Render pipeline feature comparison](https://docs.unity3d.com/2021.3/Documentation/Manual/render-pipelines-feature-comparison.html)

# Unreal Engine
## 地形自动生成 
https://zhuanlan.zhihu.com/p/346745928