---
id: 57wtylur090ehnikh8v4aw6
title: Graphics Engineering
desc: ''
updated: 1690507663739
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

基于 deferred shading 的两个新方法：
- Deferred lighting
- Tile-based deferred shading

参考：https://learnopengl-cn.github.io/05%20Advanced%20Lighting/08%20Deferred%20Shading/# 动态地形 

# 动态地形
https://blog.csdn.net/yinhun2012/article/details/122211918
https://blog.csdn.net/yinhun2012/article/details/122382905

Tessellation
https://docs.unity3d.com/510/Documentation/Manual/SL-SurfaceShaderTessellation.html
