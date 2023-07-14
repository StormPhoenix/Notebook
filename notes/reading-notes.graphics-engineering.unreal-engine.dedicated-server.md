---
id: pt6j4jlvumei3xzob2u98de
title: Dedicated Server
desc: ''
updated: 1689334411981
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

# 区分服务器代码和客户端代码

到底是服务器还是客户端代码，要从两个维度区分：
- Network Role：所有 Actor 都具备的属性。(1) 描述 Actor 与当前主机的控制状态；(2) 某台机器上 Actor Role = Authority，则该 Actor 需要复制到其他机器。这相当于引入了 Actor - Actor 副本 概念。
- Network Mode：当前网络运行模式，也是由每个 Actor 各自判断

掌握 Networkd Role 和 Network Mode 的意义后，很容易就能推导出代码应由服务器还是客户端执行。

## Network Role

本机如何知道特定 Actor 状态是不是由自己负责更新？

https://docs.unrealengine.com/5.2/en-US/actor-role-and-remoterole-in-unreal-engine/

谁对 Actor 有控制权？ROLE_Authority

谁来复制 Actor 到其他机器？RemoteRole = ROLE_Authority, Role = ROLE_SimulatedProxy

如果 Actor 不被客户端本机 Controller 控制(ROLE_SimulatedProxy)，那 Actor 的作用只是用来接收 Server 的状态同步

如果 Actor 被客户端本机 Controller 控制(ROLE_AutonomousProxy)，那 Actor 就是升级版的 ROLE_SimulatedProxy，因为它还受客户端本机 Controller 控制。

## Network Mode 
指网络交互模式

# 关卡切换
加载新地图时，要销毁旧场景、旧 Actor，创建新场景、新 Actor，那么客户端和服务器之间的游戏状态又是怎么同步的呢？

切换到另一个地图之前，要不要切换服务器呢？如果要切换新服务器，那就是非无缝切换，否则就是无缝切换。

#todolist 切换到新地图之前，有哪些 Actor/Controller 需要留存呢？

考虑到不同地图加载存在时间开销，需要迅速加载一个过渡地图让客户端等着。

参考：https://docs.unrealengine.com/5.2/zh-CN/travelling-in-multiplayer-in-unreal-engine/

讲了关卡切换过程中简单的调用流程，核心思路：采用状态图管理当前关卡状态，然后轮询(Tick())状态，根据查到的状态进行不同的操作。
https://zhuanlan.zhihu.com/p/60622022

弄这么多状态的原因，我猜测是地图切换的种类太多了，文章里写了四种，但实际上不同的切换对应到底层设计的就是状态转换过程。

UE 提供的三个 RPC 切换函数：
- UEngine::Browse 断开连接，阻塞式切换 
- UWorld::ServerTravel : 带着所有客户端转移到新地图
- APlayerController::ClientTravel : 转到新服务器

后两个底层切换函数内部调用 Browse()，这个会重置客户端和服务器的连接，是所谓非无缝切换，如果要实现无缝切换，只能让服务器调用 ServerTravel，依次对 Client 调用 ClientTravel，设置属性 UseSeamlessTravel 为 True，避免内部调用 Browse()，而是调用 FSeamlessTraverHandler::StartTravel() 来轮询客户端新地图是否有加载完毕。FSeamlessTraverHandler::StartTravel 调用过程中并不会销毁 NetDriver，所以连接不会断开。

核心函数：FSeamlessTraverHandler::StartTravel()

参考：https://blog.csdn.net/u012999985/article/details/78484511


## 关卡切换时保留的函数

# 编辑器上的运行和部署发布

#todolist

UnrealEngine 教程上部署时分别构建了 Server 和 Client 版本，但是 github 上的 fps 项目在编辑器里面直接启动了CS，并没有做两次构建

----

RPC 相关 

#todolist 没看懂类型
- RPC 类型 ：Server\Client\NetMulticast 
- 可靠性 ： 能不能保证该 RPC 一定能执行成功(通过多次调用实现来保证成功)

## Unreal Engine 中的 Dedicated Server 与客户端的特点
- 客户端和服务器的代码写在一起，依据当前机器是 Server 还是 Client 来选择执行 #todolist 补充示例
- 游戏状态共享机制：游戏状态存储在服务器，部分游戏状态存储只与特定客户端共享、部分游戏状态是服务器和多个客户端共享

** 客户端和服务器的代码写在一起，那么哪些代码是 Server 执行？哪些代码是 Client 执行？**
### UE 任意对象的控制权
控制权如何定义
- Role: 描述机器本地对象由谁控制，有三种取值 ROLE_AutonomousProxy、ROLE_SimulatedProxy、ROLE_Authority
- RemoteRole: 描述机器本地对象对应的远程对象由谁控制，取值同上

UE 中对象由谁控制？
- ROLE_Authority : 完全由 Server 控制
- ROLE_SimulatedProxy : 
- ROLE_AutonomousProxy

### UE 任意对象的所有者 Owner

链接：

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
# Article (2)

https://www.cnblogs.com/timy/p/10201818.html

高性能网络库：ACE，libuv，RakNet

----

# Article (3)

#todolist
[[proxy.unrealengine.Tutorial#networking-in-basic---simple-replication-example]]

## 属性的同步

属性添加 `ReplicatedUsing` 宏，当属性同步后被修改，触发回调函数 `OnFuncationCall` 执行(由 `ReplicatedUsing` 修饰的回调函数仅在客户端执行)
```c++
UPROPERTY(ReplicatedUsing = OnFuncationCall)
float Property;

UFUNCTION()
void OnFuncationCall();
```

如果要在蓝图里设置 `ReplicatedUsing`，对应的选项是 `RepNotify`。

## 设置 RPC 函数 

向服务器发起 RPC
```c++
UFUNCTION(Server, Reliable, WithValidation)
void RpcFunc();

// 判断：是否要执行 RpcFunc()
bool RpcFunc_Validate();

// RpcFunc 函数具体实现
void RpcFunc_Implementation();
```

#todolist 为什么不能直接实现 RpcFunc() ? 猜测因为 UE 要自动做反射

项目参考：https://github.com/dawnarc/ue4_fps_game/tree/master

----

# Article (4)
#todolist
https://www.cnblogs.com/timy/p/10201818.html
分别编译打包 Client、Server 版本

# Article (5)

#todolist
https://docs.unrealengine.com/5.2/zh-CN/networking-and-multiplayer-in-unreal-engine/

