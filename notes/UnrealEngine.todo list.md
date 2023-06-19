---
id: wry5zchspuiqht0an6b6nzy
title: todo list
desc: ''
updated: 1687174533843
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


