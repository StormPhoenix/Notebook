---
id: wry5zchspuiqht0an6b6nzy
title: todo list
desc: ''
updated: 1687342173639
created: 1686918547118
---

#### Unreal Engine API 研究

1. RHICmdList.ImmediateFlush(EImmediateFlushType);
2. FTaskGraphInterface::Get().ProcessThreadUntilIdle(ENamedThreads);
3. FTaskGraphInterface::Get().WaitUntilTasksComplete(FGraphEventArray, ENamedThreads);

多阶段资源加载性能分析：https://imzlp.com/posts/22655/


参考：
https://zhuanlan.zhihu.com/p/38881269
https://www.google.com/search?q=waituntiltaskcompletes+unreal&rlz=1C1GCEU_zh-HK__1015__1015&oq=WaitUntilTaskComplete&aqs=chrome.1.69i57j0i512.9671j0j7&sourceid=chrome&ie=UTF-8

#### Unreal Engine Profile 总结

- Unreal Engine 中 Tick 工作方式，关注 FTickFunctionTask https://zhuanlan.zhihu.com/p/511580780
- Tick 小结：https://blog.ch-wind.com/ue4-tick-note/

#### Unreal Engine 使用 tips

https://www.unrealdirective.com/tips

比如Dumpticks，给了个优化方法，让结果更可读。
https://www.unrealdirective.com/tip/dumpticks
Console Variables Editor，可视化的配置
https://www.unrealdirective.com/tip/the-console-variables-editor-plugin
Actor Palette，可以跨Level复制Actor
https://www.unrealdirective.com/tip/the-actor-palette

了解 FScenePrimitiveOctree 的原理，检查 Dynamic Shadow Setup
