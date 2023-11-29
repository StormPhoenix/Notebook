---
id: qub0x7uk3swf97dl0vn93mm
title: Camer
desc: ''
updated: 1701233038955
created: 1701228157255
---

# 3C 相机开发
## Controller 朝向
Pawn 的朝向和 Controller 的指向(ControlRotation) 有关系，先明确 Controller 的指向如何确定：

(1) AI Controller
Pawn 的正面朝向会跟随 AI Controller 的指向，而 AI Controller 的指向有三种方式确定：
* 如果设置了 Controller 聚焦到某个物体 Actor/Object/Position 等，Controller 指向将永远指向该物体
* 如果设置了 bSetControlRotationFromPawnOrientation 选项，Controller 的朝向由 Pawn 确定
* 否则，AI Controller 的朝向将不变

上述三种方式相互互斥.

(2) Player Controller
因为 Player Controller 控制的是玩家操控角色，它的朝向直接影响玩家看到的画面，所以影响 Player Controller 指向的因素主要是相机.
* 当 Player Controller 开始处理角色时，朝向由 Pawn 的朝向决定
* PlayerCameraManager 负责处理类似于震屏之类的效果，这类效果可通过相机抖动来实现，因此会每帧更新 PlayerController 的旋转矩阵。
* 鼠标移动将作为视角偏移修改 Player Controller 朝向

## Pawn 的朝向

## 相机朝向

