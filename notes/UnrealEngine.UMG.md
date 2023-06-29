---
id: 6uyp521qc2npimrhkq9kunj
title: UMG
desc: ''
updated: 1688015647217
created: 1686831231691
---

### 用法
- UI 界面的设计。如何添加 Widget 到画布；UI 布局 layout。
- UI 编辑器功能区介绍。
- Widget 的事件触发。

[UMG 最佳实践](https://docs.unrealengine.com/5.2/en-US/umg-best-practices-in-unreal-engine/)


### UMG Renderer
[虚幻4渲染编程（UI篇）【第一卷：Slate框架综述】](https://zhuanlan.zhihu.com/p/45682313) 检查 UI 产生的 DC
[虚幻5渲染编程 (UI篇)【第一卷: Slate渲染框架并通过为UMG拓展MeshUI了解Slate的图元阶段】](https://zhuanlan.zhihu.com/p/387752531) UE 的 UI 为了编辑器牺牲了太多？

# Widget

## VerticalBox
可作为容器，拥有子节点。

## Image 
常用作背景板、按钮按下前后 UI 状态切换，具体参考 [UMG 组件 - Image](https://zhuanlan.zhihu.com/p/136472896?utm_medium=social&utm_oi=1565688472064749568&utm_psn=1657724344171253760&utm_source=ZHShareTargetIDMore)。

## ListView
参考 UIFaceRoleView
https://zhuanlan.zhihu.com/p/127184008

ListView 功能的运行需要三个对象：
- ListView：UI ListView
- ListEntry：自定义 UI 组件
- ListItem：数据对象，需要继承 IUserObjectListEntry 接口。

一般用户自定义了 ListEntry UI 组件后，为了方便，会直接让其继承 IUserObjectListEntry 接口。

ListViewWidget 需和 ListEntryWidget 配合使用。

ListView 找到 List Entries 选项，设置 ListEntry，将 List 和 Entry 关联起来。

作为 List Entry 的 Widget 需实现 IUserObjectListEntry 接口，该接口包含几个常用方法 
- OnListItemObjectSet：当 item 数据被传入 List Entry 时触发，用户需实现该方法来设置自身的 UI 状态。
- OnItemSelectionChanged：当 item 选中状态被改变时触发。

ListView 的相关接口
- OnItemSelectionChanged：ListView 管理的 item 被选中时触发

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