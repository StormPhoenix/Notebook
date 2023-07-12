---
id: qoifni239nr9qowj0mwy4vt
title: Vertex Factory
desc: ''
updated: 1689154863566
created: 1689067138535
tags:
  - unrealengine
---

作用：
- 绑定 Shader 
- 绑定顶点数据 VertexBuffer 
- 绑定输入数据布局 Input Layout
- 其他需要绑定数据

前文配置顶点数据已知的操作：
- 创建 FVertexDeclarationRHI
- FVertexDeclarationRHI 设置到 graphics pipeline 

#todolist 复习 FVertexDeclaration 具体写法

# Article Conclusion (1)

参考： [[VertexFactory 相关类概述 | proxy.unrealengine.renderpipeline#vertexfactory-class-overview]]

封装之后相关类：
- FVertexStreamComponent: 封装顶点数据：VertexBuffer, StreamOffset, Offset, Stride 
- FStaticMeshDataType: 封装不同类型的顶点数据(Position, Color, TangentBasis)，用 FVertexStreamComponent 封装.

> FVertexFactory 持有 FStaticMeshDataType 及其子类变量，用于存储顶点数据。如果是自定义 FVertexFactory 类型，甚至可以不用 UE 定义的 FStaticMeshDataType，只要自己定义一些 FVertexStreamComponent、FRHIShaderResourceView 就行了。

- FVertexElement: 描述 FVertexStreamComponent 和着色器的哪个 VertexBuffer 输入对应起来(StreamIndex, AttributeIndex)；然后据此创建 FRHIVertexDecleration
- FRHIVertexDecleration: 描述顶点数据输入布局 input layout：VertexBuffer 对应着色器的第几个输入、VertexBuffer 内部数据类型、Offset、Stride 

> FVertexFactory::InitDeclaration()，输入 FVertexElement 数组，创建 FRHIVertexDecleration

## Conclusion 
- FVertexFactory 存储了顶点数据布局描述、顶点数据与 Shader 输入顶点数据的对应关系(Vertex Data 与 Shader Input Attribute 的连接关系)
- FVertexFactory 负责管理 HLSL 输入数据的布局描述、HLSL 输入顶点数据与 VertexBuffer 对应关系。具体来说就是负责创建 FRHIVertexDecleration
  - FVertexStreamComponent: 描述顶点数据布局
  - FVertexElement: 描述顶点数据与 HLSL 输入的对应关系
  - FRHIVertexDecleration: 由 FVertexStreamComponent + FVertexElement 创建，最终提供给 graphics pipeline 负责描述顶点数据布局
- FVertexFactory 负责控制 UberShader 中的宏，定制需要的 Shader 
- FVertexFactory 的实现相关宏: 
  - DECLARE_TYPE_LAYOUT, 
  - IMPLEMENT_TYPE_LAYOUT, 
  - IMPLEMENT_VERTEX_FACTORY_PARAMETER_TYPE

#todolist FRHIVertexDecleration 会被缓存起来，被 VertexFactory 复用，这是什么意思？参考 FVertexFactory::InitDeclaration()

# Article Conclusion (2)
参考：https://zhuanlan.zhihu.com/p/128656015

相关类：
- FVertexStream: 和 FVertexStreamComponent 结构很类似，不知道有什么作用 #todolist FVertexStream 和 FVertexStreamComponent 区别
- FPrimitiveSceneProxy 持有 UMaterialInterface 和 FXXXVertexFactory，负责材质、顶点数据描述

## 利用 C++ Macro 绑定 HLSL 代码
- IMPLEMENT_MATERIAL_SHADER_TYPE 绑定的是 C++ Shader 和 HLSL 中的参数
- IMPLEMENT_VERTEX_FACTORY_TYPE 绑定的是 C++ VertexFactory 和 HLSL 中的顶点数据

#todolist DECLARE_VERTEX_FACTORY_TYPE(FLocalVertexFactory) 具体如何实现
无论是 Shader 还是 VertexFactory 和 HLSL 做绑定时，都会用宏来控制 UberShader 开关，定制自己的 Shader。

## FRHIResource & FRenderResource & SRV & UAV

#todolist 理解 FRenderResource & FRHIResource
FRenderResource 负责创建释放 FRHIResource

## Conclusion
- FVertexFactory 用 C++ Macro 与 HLSL 绑定在一起，并定制自己的 HLSL 代码
- FPrimitiveSceneProxy 负责创建 FVertexFactory

# Article Conclusion (3)
https://zhuanlan.zhihu.com/p/361322348

[[自定义 MeshComponent Part 1 | proxy.unrealengine.renderpipeline#creating-a-custom-mesh-component-in-ue4-part-1]]

## 相关类
- FVertexStream : 与 FVertexStreamComponent 基本一致，不清楚具体作用
- FVertexInputStream : 也持有顶点数据，StreamIndex，Offset，看起来与 FVertexStreamComponent 没有什么不同。对比 FVertexElement 发现顶点数据的类型不一样。
  - FVertexInputStream 持有 FRHIBuffer* 类型顶点数据
  - FVertexElement、FVertexStreamComponent 持有 FVertexBuffer* 类型顶点数据

  这说明 FVertexBuffer 类型的顶点数据需要转化为 FRHIBuffer 类型才能设置到 GPU 中。

## ush 与 usf 的区别
FVertexFactory 与 HLSL template 绑定后会定制 HLSL 代码，但这个 HLSL 并不真正包含执行代码，而只有一些函数和结构体。其他不同 Pass 的 Shader 会包含(include)生成的 HLSL 文件。所以 FVertexFactory 定制的 HLSL 代码以 *.ush 结尾而不是 *.usf。

## 获取 FVertexFactory 与 Shader HLSL 的映射关系

#todolist 讲清楚是什么映射关系

- DECLARE_VERTEX_FACTORY_TYPE & IMPLEMENT_VERTEX_FACTORY_TYPE
  
  用 C++ Macro 对 FVertexFactory 实现反射。这两个 C++ Macro 实现了对 FVertexFactory 的反射，把 FVertexFactory 的成员变量、成员函数指针存放到了 FVertexFactory::StaticType 变量。

#todolist 

VertexBuffer 排布 https://anteru.net/blog/2016/storing-vertex-data-to-interleave-or-not-to-interleave/

ShaderPermutations https://medium.com/@lordned/unreal-engine-4-rendering-part-5-shader-permutations-2b975e503dd4

Global Uniform Shader https://medium.com/@solaslin/learning-unreal-engine-4-adding-a-global-shader-uniform-1-b6d5500a5161

Shader Debug Workflow https://docs.unrealengine.com/5.2/en-US/shader-debugging-workflows-unreal-engine/

----

# 三个问题

- FVertexFactory 从什么地方接收顶点数据的
- FVertexFactory 如何描述顶点数据的布局
- FVertexFactory 如何向外部接口提供顶点数据

```mermaid
classDiagram
    class FVertexStreamComponent {
        +FVertexBuffer* VertexBuffer
	      +uint32 StreamOffset
	      +uint8 Offset
	      +uint8 Stride = 0;
	      +TEnumAsByte~EVertexElementType~ Type
	      +EVertexStreamUsage VertexStreamUsage 
    }
    class FVertexStream {
        +FVertexBuffer* VertexBuffer
		    +uint32 Offset
		    +uint16 Stride
		    +EVertexStreamUsage VertexStreamUsage 
		    +uint8 Padding
    }
    class FVertexInputStream {
        // 持有 FRHIBuffer 类型的顶点数据，要最终设置到 HLSL Input
        +uint32 StreamIndex
	      +uint32 Offset
	      +FRHIBuffer* VertexBuffer
    }
    class FVertexElement {
        // 描述顶点数据到 HLSL Input 的绑定关系
        +uint8 StreamIndex
	      +uint8 Offset
	      +TEnumAsByte~EVertexElementType~ Type
	      +uint8 AttributeIndex
	      +uint16 Stride
	      +uint16 bUseInstanceIndex
    }
    class FVulkanVertexDeclaration {
        +FVertexDeclarationElementList Elements;
    }
    class FVertexDeclaration
    FVertexDeclaration <|-- FVulkanVertexDeclaration
    FVulkanVertexDeclaration --* FVertexElement
    FVertexStreamComponent <.. FVertexStream
    FVertexStreamComponent <.. FVertexElement
    FVertexStream <.. FVertexInputStream
```

![Vertex Factory Class Overview](https://miro.medium.com/v2/resize:fit:1400/format:webp/1*r2ej5rO4Lmc5oj8PKWPOjQ.jpeg)

## 描述顶点数据布局