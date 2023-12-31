---
id: 6uyp521qc2npimrhkq9kunj
title: Slate UI
desc: ''
updated: 1689137172820
created: 1686831231691
tags:
  - umg
  - slate
  - unrealengine
---

[[UMG 最佳实践 |proxy.unrealengine.slate-framework#best-practices]]

# UE 组件

[[组件用法|proxy.unrealengine.slate-framework#widget-usage]]

## ListView

ListView 功能的运行需要两个对象：
- ListEntry：ListView 的每个 Item 组件
- ListItem：ListView 的数据对象，需要继承 IUserObjectListEntry 接口。

设置到 ListView 的数据，需要实现 IUserObjectListEntry 接口，为了方便，会直接让 ListEntry 来实现。也就是说 ListEntry 本身既是组件又是数据。

 IUserObjectListEntry 接口包含几个常用方法 
- OnListItemObjectSet：当 item 数据被传入 List Entry 时触发，用户需实现该方法来设置自身的 UI 状态。
- OnItemSelectionChanged：当 item 选中状态被改变时触发。

ListView 的相关接口
- OnItemSelectionChanged：ListView 管理的 item 被选中时触发

ListViewWidget 和 ListEntryWidget 配合使用需要设置属性面板中的 List entries 选项，将 List 和 Entry 关联起来。

### 接口调用顺序
1. ListView 创建：
forloop(ListEntry::OnListItemObjectSet => ListView::OnEntryInitialized) 
=> ListView::OnEntryGenerated

2. ListView 选中某个 item
=> ListEntry::OnItemSelectionChanged 选中状态为 true
=> ListEntry::OnItemSelectionChanged 选中状态为 false
=> ListView::OnItemSelectionChanged 选中状态为 true

3. ListView 滑动过程中 ListEntry 消失
=> ListView::OnEntryReleased

## Layout
可作为容器填充子 Widget，负责管子 Widget 布局。布局组件有多种，包括：Canvas Planel、Overlay Slot、Vertical Box、Horizontal Box。

每个添加到布局组件中的子 Widget，都会新增一个 Slot 属性项，用来定义子 Widget 在 UI 上的位置。因此只要重点关注 Slot 就可以了。

### Canvas Planel
新增 Slot (Canvas Planel Slot)，这种情况下要定义好子 Widget 的 Anchor、Size、Position、Alignment，就能确认子 Widget 的大小。

Anchor：子组件的对齐方式（左上、右上、居中等）
ZOrder：当子 Widget 们存在重叠时，ZOrder 决定绘制顺序

### Overlay 
新增 Slot (Overlay Slot)，子组件只有两种对齐模式：Vertical Alignment 和 Horizontal Alignment。

### Vertical Box
新增 Slot (Vertical Box Slot)，让子组件垂直布局，水平方向采用 Horizontal Alignment，相当于 Overlay 在垂直方面的特化。
子组件的 Size 有两种决定方式：Auto 和 Fill。
- Auto：子组件自己决定大小
- Fill：子组件在水平、垂直方向上填充 Vertical Box，其中垂直方向上需要设置填充比例，用来和其他子组件划分 Vertical Box 空间。
此外还有一个 Alignment 属性用来决定子组件在 Vertical Box 里面的对齐方式。这里需要注意 Size 和 Alignment 之间的区别：Size 是你从容器中获得的空间，Alignment 决定空间的分配。

### Horizontal Box
Horizontal Box 让子组件水平布局，垂直方向采用 Vertical Alignment，相当于 Overlay 在水平方面的特化，其余用法同 Vertical Box。

### Size Box
Size Box 设置了固定 Size 限制了子组件大小。一些子组件的大小可能不符合用户的期望，这类组件可以在外层套上 Size Box 容器来限制大小
新增 Slot (Size Box Slot)，可设置属性包括：Padding、Horizontal\Vertical Alignment。

# 参考
- [Slate 架构](https://docs.unrealengine.com/5.0/en-US/understanding-the-slate-ui-architecture-in-unreal-engine/)
- [EpicGames 分享：UI 优化](https://www.sohu.com/a/137852384_204824)
- [UE4.25 Slate 类图及渲染调用关系](https://www.cnblogs.com/hggzhang/p/16480489.html)
- [Slate 渲染调用流程 - 合批优化 - Stat 统计](https://zhuanlan.zhihu.com/p/529040584)
- [CSDN 文章合集](https://blog.csdn.net/qq_21919621/article/details/108574372)
- [RetainerBox 优化](https://zhuanlan.zhihu.com/p/532401520)
- [FSlateDrawElement 介绍](https://arcecho.github.io/2017/09/18/Slate%E8%BF%9B%E9%98%B6%E5%BA%94%E7%94%A8%E4%B9%8BFSlateDrawElement/)
- [用 InvalidationBox 优化](https://blog.51cto.com/u_15075510/3795050)

#todolist
- [UMG ViewModel](https://docs.unrealengine.com/5.2/zh-CN/umg-viewmodel)
- [Slate 中的 TAttribute](https://zhuanlan.zhihu.com/p/465410846)