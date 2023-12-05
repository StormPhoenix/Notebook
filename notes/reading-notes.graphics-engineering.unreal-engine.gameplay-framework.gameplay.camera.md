---
id: qub0x7uk3swf97dl0vn93mm
title: Camera
desc: ''
updated: 1701753976266
created: 1701228157255
---

# Unreal Engine 相机开发基础

https://zhuanlan.zhihu.com/p/34897458

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
* 鼠标移动产生的角度增量，将用于修改 Player Controller 朝向。

## Pawn 的朝向
Pawn 的朝向有三个 bool 选项影响：bUseControllerRotationPitch、bUseControllerRotationYaw 和 bUseControllerRotationRoll，分别用于控制 Pawn 的 Pitch、Yaw 和 Roll，代表是否由 Controller 控制 Pawn 的朝向。当任意一选项为 true 时，Pawn 的对应朝向分量将和 Controller 保持一致。

不同应用场景设置不一样，由 AI 控制的 Pawn 会将 bUseControllerRotationYaw 设置为 true，允许 AI Controller 控制 Pawn 的朝向；由玩家控制的 Pawn，如果是第三视角，则三个选项全置为 false，这将允许用户操控 Pawn 往任意方向移动而 Controller 和相机的朝向保持不变。

## 相机朝向

相机朝向由 UCameraComponent 决定。每帧相机视角会调用 UCameraComponent::GetCameraView() 函数获取相机 location、rotation 和 FOV。相机位置 location 和 rotation 又是和 UCameraComponent 紧密相关的，在 UE 中相机位置、旋转通过弹簧臂 USpringArmComponent 计算得到。SpringArm 控制相机到控制的角色（Pawn）之间的距离，顾名思义弹簧臂控制的距离是动态了，这通常用于相机避障。

对于相机旋转，则由上文提到的 Controller 控制。Controller 内部有一个 ControlRotation 矩阵来决定相机旋转角度。当我们鼠标四周移动时，修改的就是这个 ControlRotation。

# Lyra 项目中的相机设计

首先 Lyra 屏蔽了弹簧臂对相机的控制，而是用相机堆栈 (Camera Stack) 中的 Camera Mode 来决定镜头位置和角度，这儿涉及到了两个概念：Camera Stack 和 Camera Mode。

## Camera Mode
Camera Mode 取代了弹簧臂的功能，例如相机位姿、避障，但又不仅于此。

（1）计算相机位置、旋转

（2）相机避障

（3）运动插值
* 相机位置远离角色插值
* 相机位置靠近角色插值

## Camera Stack
多 Camera Mode 混合。每个 Camera Mode 计算的相机位姿结果做混合，按照不同的混合权重得到一个混合的相机位姿，那么混合权重由什么决定？