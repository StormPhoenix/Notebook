---
id: pt6j4jlvumei3xzob2u98de
title: Dedicated Server
desc: ''
updated: 1689525514519
created: 1689158325296
tags:
  - unrealengine
---

#todolist

教程 ：

https://www.cnblogs.com/timy/p/10201818.html

https://github.com/dawnarc/ue4_fps_game/tree/master

https://km.woa.com/articles/show/520809?kmref=search&from_page=1&no=8

https://docs.unrealengine.com/5.2/zh-CN/multiplayer-programming-quick-start-for-unreal-engine/

----

UE 中网络交互模式分类两种：分布式、CS 式两种，其目的都是为了机器之间能互相通信，同步游戏状态。

https://docs.unrealengine.com/5.2/zh-CN/networking-overview-for-unreal-engine/

# 同步游戏状态概述

多台机器互相连接在一起，共同玩一场游戏，这就需要每台机器上的游戏状态是相同的。所以 UE 网络交互的目的就是：同步不同机器上的游戏状态，UE 给出的方案是：当一台机器上的对象发生变化时，就复制该对象到其他机器。

不同的网络交互模式下，复制的形式也不相同：

1. CS 模式
   1. 游戏状态的更新实际发生在服务器上，而不是客户端；
   2. 客户端负责提供游戏输入；服务器负责处理客户端输入；服务器把发生改变的对象复制到客户端；
   3. 特点：专属服务器(dedicated server)，服务器处理所有消息，带宽高，客户端只和服务端通信，带宽低
2. 分布式模式
   1. 每台机器既是服务器，又是客户端；
   2. 每台机器既负责把自身改变状态的对象复制到其他机器，也负责接收其他机器复制过来的对象。
   3. 特点：监听服务器(listen server)，每个机器要接收其他机器的消息，带宽高；


因为需要复制对象，所以要考虑网络带宽不能承受较大的带宽量，在设计层面上需要对对象仔细区分类别：
- 仔细划分需要复制的信息类别(游戏交互、美术效果，私人玩家信息)，不同类型的信息与不同机组相关联
- 最小化必要信息复制量，减少带宽。例如：确定客户端 Actor 是否要复制到服务器(不在玩家身边、距离过远被裁剪、带宽不足时优先复制哪个 Actor)

# RPC 调用
网络通信除了涉及到对象复制来同步游戏状态，还有远程进程调用 RPC。

使用 RPC 必然需要弄清楚：谁发起调用，谁负责执行？执行结果有没有返回？是否可靠？

调用 RPC 的目的之一是为了修改对象状态，那么就要求负责执行 RPC 的 Actor 是可复制的，这样 Server 和 Client 才能知道某个特定 Actor 在对方机器里面是存在的，能够负责 RPC 的实现。

## 谁调用？谁执行

- Server
- Client
- Multicast

## 可靠性
- Reliable \ Unreliable

#todolist 如果 Client 调用了 Client 类型的 RPC 会怎样？

----
# 如何配置 Actor 可复制

- 要复制哪些属性 (Replicated)
- 当前应不应该复制 (Relevancy)
- 先复制谁 (Priority)
- 复制给谁？什么时候复制？(DOREPLIFETIME_CONDITION)

https://docs.unrealengine.com/5.2/zh-CN/conditional-property-replication-in-unreal-engine/

## 如果要复制整个对象呢 FNetworkGUID

## 如果要复制 Actor 引用的其他 UObject 子对象呢
https://docs.unrealengine.com/5.2/zh-CN/replicated-subobjects-in-unreal-engine/

## 100 名玩家 + 5000 个 Actor 的对局引起的性能问题

## Replication Graph 用于优化服务器性能
https://zhuanlan.zhihu.com/p/90427525

## Iris Replication 用于优化服务器性能
Iris 期望 clien 能够做更多的工作，不要让服务器处理一切。

https://dev.epicgames.com/community/learning/tutorials/Xexv/unreal-engine-experimental-getting-started-with-iris

https://zhuanlan.zhihu.com/p/618566686

# RPC 由哪一台机器执行？Actor 复制到哪一台机器？
此处又涉及到所有权链条(Owner connection)概念，又能引申出
- 服务器调用 Client RPC 时，是哪台机器执行执行 RPC ?
- 服务器触发 Actor 复制时，要把 Actor 复制到哪台 Client 机器？

IsLocallyControlled()

# Online Beacons 轻量级连接

----
# 区分服务器代码和客户端代码

到底是服务器还是客户端代码，要从两个维度区分：
- Network Role：所有 Actor 都具备的属性。(1) 描述 Actor 与当前主机的控制状态；(2) 某台机器上 Actor Role = Authority，则该 Actor 需要复制到其他机器。这相当于引入了 Actor - Actor 副本 概念。
- Network Mode：当前网络运行模式，也是由每个 Actor 各自判断

掌握 Networkd Role 和 Network Mode 的意义后，很容易就能推导出代码应由服务器还是客户端执行。

## Network Role

Role 告诉了本地游戏某个 Actor 是不是由自己控制。在网路交互模式下，Role 有两个类别：Role 和 RemoteRole
- Role：本地 Actor 和本机之间的控制关系
- RemoteRole：本地 Actor 对应的远程 Actor 在远程机器(一般是服务器)上的控制关系。

Network Role 取值有三种：
- ROLE_Authority : 完全由 Server 控制
- ROLE_SimulatedProxy
- ROLE_AutonomousProxy：升级版的 ROLE_SimulatedProxy，但由本机 PlayerController 控制，可以向服务器提交 RPC。

参考：https://docs.unrealengine.com/5.2/en-US/actor-role-and-remoterole-in-unreal-engine/

## Network Mode 
指网络交互模式，表示当前机器是以什么角色来运行代码的，有三种：
- 独立运行，即当前机器只运行自己的游戏，不和其他机器做网络交互。
- 作为服务器运行。
- 作为客户端运行。

了解网络交互模式的意义时，制作多人交互游戏时，通过判断当前程序以什么模式运行，来定义程序的行为。

## Owner Chain
ROLE_AutonomousProxy 提到了 Actor 由 PlayerController 控制，这一点是通过 UE 中的所有者链(Owner chain)来控制的。

每个 Actor 有一个 Owner 属性指向另外一个 Acotr，不同 Actor 通过 Owner 属性引用构成链条即为：Owner chain。一个 Actor 的 Owner chain 的最初始节点如果是 PlayerControl，那么代表这个 Actor 由 PlayerController 控制。

----
# 关卡切换
两个概念：无缝切换、非无缝切换。
- 无缝切换：客户端进入新地图不需要断开服务器。
- 非无缝切换：客户端进入新地图需要断开服务器。

UE 提供的三个 RPC 切换函数：
- UEngine::Browse 断开连接，阻塞式切换 
- UWorld::ServerTravel : 带着所有客户端转移到新地图
- APlayerController::ClientTravel : 转到新服务器

后两个底层切换函数内部调用 Browse()，这个会重置客户端和服务器的连接，是非无缝切换，如果要实现无缝切换，只能让服务器调用 ServerTravel，依次对 Client 调用 ClientTravel，并设置属性 UseSeamlessTravel 为 True，避免内部调用 Browse()，而是调用 FSeamlessTraverHandler::StartTravel() 来轮询客户端新地图是否有加载完毕。FSeamlessTraverHandler::StartTravel 调用过程中并不会销毁 NetDriver，所以连接不会断开。

核心函数：FSeamlessTraverHandler::StartTravel()

参考：
- https://zhuanlan.zhihu.com/p/60622022
- https://blog.csdn.net/u012999985/article/details/78484511
- https://docs.unrealengine.com/5.2/zh-CN/travelling-in-multiplayer-in-unreal-engine/
----
# 编辑器上的运行和部署发布
参考 lyra 部署文档： https://docs.unrealengine.com/5.2/zh-CN/setting-up-dedicated-servers-in-unreal-engine/

## 部署服务器

首先了解一下 Build.cs 与 Target.cs 的区别，Build.cs 用来构建库文件，Target.cs 用来构建可执行文件。
详细解释参考 https://unrealcommunity.wiki/build.cs-hv582z08

1. 修改 Target.cs。设置 Target 的 Type 属性为 TargetType.Server，执行构建该 Target
2. 在编辑器中 Cook 服务器的资产。

## 部署客户端

1. 修改 Target.cs。设置 Target 的 Type 属性为 TargetType.Client，执行构建该 Target。
2. 在编辑器中 Cook 客户端资产。

----
## Unreal Engine 对象同步机制
几个问题要解决：

Q1. 要同步哪些属性。远程需要控制的；不能是依据被删除的；依据对象自身设置的同步条件

Q2. 多久同步一次。设置同步间隔 NetUpadteTime。

Q3. 先同步哪个对象？再同步哪个对象。按照优先级配置，可节约带宽；对象距离我多近？对象在不在视锥之内的后同步？

Q4. 怎么同步对象？把对象状态保存起来存到 buffer，Tick 时比较对象和 buffer 中的状态是否一致，如果不一致则放到 list 里发送出去。

## RPC 调用
类型：
- Server Call Client
- Client Call Server(Run on Server): 客户端调用，服务器执行
- Server Multi-cast

## 对象同步和 RPC 调用的机制
- 可靠机制
- 丢包重传

# NetProfiler

流量检测软件

## 关注点
- 短时间流量激增，某些数据不会去复制了，客户端长时间不会收到属性同步
- 数组同步，当数组长度发生改变，UE 会尝试同步所有数组元素，所以最好使用定长数组
- 精心确定对象同步时机。对象的同步不需要很频繁；可设置同步时机；对象同步频率也可以调低下；
- 精心确定对象同步范围。UStruct 不是所有属性需要同步；

# QA 
- UE 没有办法保证属性同步顺序强依赖。
- 可复制对象 & 专属链接 有什么关系

----

项目参考：https://github.com/dawnarc/ue4_fps_game/tree/master

