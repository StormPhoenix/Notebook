---
id: kpdolholylns5ns3uw6mypq
title: 渲染流程中的数据组织框架
desc: ''
updated: 1688101346267
created: 1688092844232
---

# FVertexFactory
作用：
- 绑定 Shader 
- 绑定顶点数据 VertexBuffer 
- 其他需要绑定数据

## 渲染数据 Vertex Buffer
FVertexStreamComponent: 定义顶点格式，GPU 侧需要这个来确定如何读取顶点数据。
FRHIShaderResourceView: 保存实际的顶点数据。

以上由 FLocalVertexFactory::FDataType (或者其子类) 封装。

## 网格数据到渲染数据的绑定
示例：RenderData->VertexBuffer