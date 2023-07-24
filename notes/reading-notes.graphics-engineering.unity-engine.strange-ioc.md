---
id: 4s2sfo24h74od78mxwt9sjc
title: Strange IoC
desc: ''
updated: 1690187075279
created: 1690182407589
---

#todolist


```mermaid
classDiagram
    class ContextView {
        +IContext context // 一般用 MVCSContext 初始化
    }
    class Context {
        +Start() // 执行绑定
        #mapBindings()
        #postBindings() 
    }
    class MonoBehaviour
    class ContextView
    class CrossContext {
        +ICrossContextInjectionBinder injectionBinder
        +IDispatcher crossContextDispatcher
    }
    class MVSCContext {
        +ICommandBinder commandBinder 
        +IEventDispatcher dispatcher
        +IMediationBinder mediationBinder
    }

    Context <|-- CrossContext
    CrossContext <|--  MVSCContext 
    IContextView <|-- ContextView
    MonoBehaviour <|-- ContextView
```

![Strange-IoC framework](https://strangeioc.github.io/strangeioc/class-flow.png)

- dispatcher 与 commandBinder 区别：commandBinder 同样会监听 dispatcher 发出的事件，区别在于 commandBinder 每次收到事件会新生成一个 command 来执行代码。

# Attention
- ContexView will be the top of your game hierarchy and everything else will go inside it.
- View 注入的 dispatcher 和 MVSCContext 里的 dispatcher 不能是同一个，否则违反了 View 与 Logic 隔离的理念。