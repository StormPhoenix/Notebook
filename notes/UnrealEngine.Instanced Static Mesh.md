---
id: okl6c28rtydk4fp2811te1q
title: Instanced Static Mesh
desc: ''
updated: 1688101469934
created: 1687971957027
---

# Instanced Static Mesh (ISM) 
逻辑思路：
1. ISM 的用法
2. ISM 工作原理流程
3. ISM 不同工作阶段数据组织、数组之间的传输
4. 优缺点

# ISM 用法
参考：
- https://blog.csdn.net/ljason1993/article/details/122200583

# ISM 运行流程

# GameThread 侧数据组织
UInstancedStaticMeshComponent

1. UInstancedStaticMeshComponent::PerInstanceSMData 实例数据
2. UInstancedStaticMeshComponent::PerInstanceSMCustomData 用户自定义的逐实例数据
3. UInstancedStaticMeshComponent::PerInstanceRenderData (TODO)
4. UInstancedStaticMeshComponent::InstanceDataBuffers (TODO)

# RenderThread 侧数据组织
FInstancedStaticMeshSceneProxy，基类 FStaticMeshSceneProxy

1. FInstancedStaticMeshSceneProxy::InstancedRenderData : FInstancedStaticMeshRenderData 实例数据
2. FStaticMeshSceneProxy::LODModels : FStaticMeshLODResources 网格数据

# GameThread 到 RenderThread 的数据更新
参考：
- https://zhuanlan.zhihu.com/p/339732645

GameThread 侧实例数据的任何变动，都会重新触发 CreateSceneProxy() 创建 RenderThread 侧渲染代理对象(FInstancedStaticMeshSceneProxy)。CreateSceneProxy 内部调用 UInstancedStaticMeshComponent::BuildRenderData 把 PerInstanceSMData 转化成 Buffer 数据 InstanceDataBuffers。

- PerInstanceRenderData => InstancedRenderData
- 设置 LODModels 数据

1. 实例数据：函数 CreateSceneProxy() 创建 FInstancedStaticMeshSceneProxy 作为渲染线程上 ISM 代理，复制实例数据到 FStaticMeshSceneProxy::InstancedRenderData。再调用 SetInstance() 或 SetInstanceXXX() 类函数修改实例数据。
- PerInstanceRenderData
- InstancedRenderData

2. 网格数据：StaticMesh 的相关参数（LOD级别、剔除距离、包围盒信息、网格渲染数据、实例渲染数据）复制到 FInstanceStaticMeshSceneProxy::UserData_AllInstances (参考：FInstancingUserData)

# 顶点渲染数据

ISM 相比 StaticMesh 多出了 Instance 数据，定义在 FInstancedStaticMeshDataType。因此除了绑定顶点数据外，还要绑定实例数据:

PerInstanceRenderData->InstanceBuffer.BindInstanceVertexBuffer(XXX)

## 顶点渲染数据绑定到 VertexFactory

# 着色器 Vertex Shader
1. GetVertexFactoryIntermediates
2. VertexFactoryGetWorldPosition

# TODO
1. StaticMesh 从 GameThread -> RenderThread -> RHIThread -> GPU 整个绘制流程中的数据组织、数据传输以及最终如何绘制的。
2. UE 的[[UnrealEngine.渲染流程中的数据组织框架]](FLocalVertexFactory::FDataType, FVertexStreamComponent, FRHIShaderResourceView)，数据处理函数(ENQUEUE_RENDER_COMMAND)
   1. FInstnacedStaticMeshDataType

3. 文章
   1. https://www.jianshu.com/p/a086bd856634
   2. https://www.cnblogs.com/hont/p/15835353.html