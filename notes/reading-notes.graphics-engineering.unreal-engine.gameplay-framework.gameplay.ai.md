---
id: 265b68hfujmt7ppxht554gk
title: Ai
desc: ''
updated: 1701636415688
created: 1699327810201
---

# Gameplay AI

## 设计原则

（1）AI 设计上决策与行为分离。
* 高效复用。在行为树内，如果两处地方需要同一段逻辑，则把这段逻辑包装成子树来调用。
* 分离逻辑。降低设计复杂度，将问题以大化小。决策逻辑负责复杂的条件检测，行为逻辑用来解决具体行为表现。

（2）具体行为采用行为队列
* 对于一个行为序列，采用队列形式保存。
* 加入到行为队列的“行为”，要保存执行条件参数。也就是说：不要在加入队列之前判断“行为”要不要执行，而是队列轮到“行为”时开始决定要不要执行。

[浅谈只狼AI设计——以狮子猿为例（2）架构篇](https://km.woa.com/group/29321/articles/show/554954)

## 现有方案

### AI 设计工具

（1）寻路系统
* https://docs.unrealengine.com/4.27/zh-CN/InteractiveExperiences/ArtificialIntelligence/NavigationSystem/

（2）AI 行为树架构
* https://km.woa.com/articles/show/398120

（2）环境感知
* 环境查询系统
  * https://km.woa.com/articles/show/445903?kmref=search&from_page=1&no=2
  * https://docs.unrealengine.com/5.2/zh-CN/environment-query-system-quick-start-in-unreal-engine/
* 环境感知组件：AI Perception system
  * https://km.woa.com/articles/show/435540

以 AI 自动攻击怪物为例，行为树负责具体的攻击行为，攻击哪个怪属于决策部分，要有一个高层的决策模块来影响行为树的调用。UE 给出样例是：用 AIPerceptionComponent 感知某个具体 Actor，调用“行为树” + “EQS”执行追逐 Actor 行为。

（3）AI 调试

（4）UE 行为树编辑器扩展
* 方便查找引用 https://km.woa.com/articles/show/446348

### 团队 AI 案例
#### 看门狗 - https://zhuanlan.zhihu.com/p/463560068
##### (1) 设计思路：Bottom up + Top down == Middle out。
* Bottom up：由个体 AI 依据自身感知做决定。好处是面对突发事件反映快，但难以做到全局同步
* Top down：全局状态控制群体 AI，缺点是个体 AI 难以对突发事件进行响应

采用两者结合方法：既有全局控制也有个体即时反映。

##### (2) AI 的组成部分
包括：动作（Action）+ 行为（Behavior）+ 策略（Strategy），后者包含前者。这部分和 UE 的行为树类似，动作代表跑、转身、跳这类基础动作；行为表示由基础动作组合而成的 BT Task（Behavior Tree Task）；而策略代表 BT （Behavior Tree），依据状态执行不同的 BT Task。

但仅仅用 Action、BT Task、BT 来描述 AI 组成模型似乎是不够的。策略触发的行为不一定是固定的某个行为，而是某一类行为，实际运行要根据配置执行这类行为的特定行为（BT Task、BT Tree 的可配置化 Modular 模块化）。

##### (3) Top down
从上层控制群体行为。上层 AI 管理会依据一系列不同的条件为 AI 配置策略，策略直接影响 AI 的行为。
##### (4) Bottom up
从下层影响个体 AI 的行为。下层影响 AI 的方式是外界刺激事件（Incident），例如 NPC 正在行走，此时发生敌人攻击，那么 NPC 该如何操作？看门狗采用了反映矩阵（状态转移表），定义状态转移概率，设计个体 AI 的反应行为。

新的问题是 AI 完成了反应行为之后要不要继续之前的行为？我们定义一个名词 Branch，NPC 每执行的不同行为都称之为一个 Branch，这样构成的模型就是 AI 在不同 Branch 之间切换。例如：NPC 正在行走，这是 Branch A，突然遇到敌人，依据反映矩阵 NPC 决定战斗，于是触发了战斗行为 Branch B，即由 Branch A -> B。当 NPC 战斗胜利后会重新回到行走状态，于是看门狗设计了一个分支存储队列，用于 AI 恢复之前的分支行为。

#### Days Gone - https://zhuanlan.zhihu.com/p/444035812

Days Gone 采用的设计思路和上个案例类似，我认为也是 Bottom up + Top down 

**（1）上层如何控制**
控制基本单位：小队，一个小队就是一个群体 AI。
控制的标准是什么：战线 + 信心值 + 角色

* 战线由战场敌我位置布局决定，战线又决定了小队成员的站位。
* 信心值决定了小队的战斗决定：战斗、撤退、推进。
* 角色，即对应个体 AI 的具体行为，小队成员的角色由小队 AI 分配 

**（2）下层如何控制**
* 角色控制：小队 AI 为成员分配了角色，一个角色相当于一个行为树。例如狙击手角色，倾向于在某个位置不动；突击手角色倾向于包抄；掩护角色倾向于前线守线。

* AI 行为优先级：
1. 高优先级行为。炸弹落到附近，AI 会跳出扮演角色行为树，躲避炸弹
2. 角色行为树
3. 保底行为。个体 AI 没有触发高优先级行为，也没有扮演角色时的默认行为

#### 战神 - https://zhuanlan.zhihu.com/p/412839232

战神解决了怪物团队 AI 问题。
##### 谁是主攻击怪物
主攻怪物代表发动攻击，其余怪物休息。用 Aggressive 得分选择主攻怪物

##### 怪物如何站位

影响因素：（1）玩家攻击区域；（2）怪物“私人空间”；（3）Non-Aggressive 状态敌人站位。

## 项目组 AI 战斗设计思路

### 团队 AI
（1）AI 控制种类：团队控制与个体控制。团队控制共享团队信息。
（2）战斗区域。控制战斗状态 <-> 休息状态的切换
（3）战斗站位，影响因素包括很多
  * Cone 战斗区域确定角色站位；
  * 团队控制 AI 确定角色站位；
  * 团队成员叠的太密集，则

### 角色 AI 
（1）... ...


### 怪物 AI 
怪物 AI 没有团队控制（也可以有）

# 操控多人切换
ref: https://forums.unrealengine.com/t/is-it-possible-to-use-both-ai-controller-and-player-controller-with-the-same-pawn/347004/2

Pawn 挂载的 UInputComponent 组件用来绑定输入输出映射。Player 创建时初始化 InputComponent 的输入映射关系(FGHeroComponent::InitializePlayerInput())，将某个 InputAction 绑定到某个函数(参考 DEFINE_BIND_ACTION 宏)，后续出现按键事件时，EnhancedInputSystem 就去查找这个绑定函数处理。

* UFGHeroComponent 绑定 PlayerController 的按键映射
具体到 Lyra 项目，有一个 HeroComponent 继承了 IGameFrameworkInitStateInterface 接口，当项目初始化时触发 HeroComponent 的初始化动作，用户在这个接口内处理 EnhancedInputComponent 的事件绑定，将 IA 绑定到 EnhancedInputSystem。而 HeroComponent 又是挂载到 Pawn 上的，从 Lyra 代码来看，只要一个 Controller 只要持有了 Pawn，那么 Pawn 上挂载的 HeroComponent 就会去给 Pawn 上的 InputComponet 绑定按键映射。

不同游戏的 AI 设计分析：[[reading-notes.graphics-engineering.unreal-engine.gameplay-framework.gameplay.ai.ai-design-analysis]]