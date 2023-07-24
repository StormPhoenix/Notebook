---
id: 7n7bxhe0z3mrj72e596d9s6
title: Coroutine
desc: ''
updated: 1690163391661
created: 1689920547615
---

Unity 中的 Coroutine 提供了将一个任务拆分到多帧运行的机制。例如一个 for 循环 10，如果不希望它在一帧中执行完，而是在之后的 10 帧中每帧执行一个 loop，就可以使用 coroutine。

**Example**

普通 for-loop
```c++
void Fade()
{
    Color c = renderer.material.color;
    for (float alpha = 1f; alpha >= 0; alpha -= 0.1f)
    {
        c.a = alpha;
        renderer.material.color = c;
    }
}
```

采用 Coroutine

```c++
IEnumerator Fade() 
{
    Color c = renderer.material.color;
    for (float alpha = 1f; alpha >= 0; alpha -= 0.1f)
    {
        c.a = alpha;
        renderer.material.color = c;
        yield return null;
    } 
}

// 调用 Coroutine
void Update() 
{
    if (Input.GetKeyDown("f"))
    {
        StartCoroutine(Fade());
    }
}
```

Unity Coroutine 的执行分为两个地方：（1）第一次执行 Coroutine 到第一次出现 yield 之间的代码发生在调用 StartCoroutine 的位置；（2）第一次从 yield 恢复运行到 Coroutine 运行完的代码发生在 main-loop 循环中的 DelayedCallManager 的地方，参考 [Analyzing coroutines](https://docs.unity3d.com/Manual/Coroutines.html)。

**Memory Pressure**

Unity Coroutine 在 main-loop 中执行时需要记住 Coroutine 代码中的局部变量和上一次代码执行位置，因此它需要保存分配的堆栈。

# Coroutine 实现

Unity coroutine 的使用案例中经常出现 `IEnumerator` 作为 coroutine 函数返回值，那么 coroutine 的核心就是 `IEnumerator` 是如何实现的，`yield` 是怎么构造 `IEnumerator` 的。先看 `IEnumerator` 接口定义：

```c++
public interface IEnumerator
{
    object Current {get:}
    bool MoveNext();
    void Reset();
}
```

也就是说 `yield` 构造的对象必须实现上述两个接口函数 `MoveNext()` 和 `Rest()`。在看一个使用 `yield` 的简单例子：

```c++
class TestCoroutine
{
    static IEnumerator GetCounter() 
    {
        for (int count = 0; count < 10; count ++)
        {
            yield return count;
        }
    }
}

StartCoroutine(TestCoroutine.GetCounter());
```

这段代码原本想实现的功能是：递增 `count`，在每一帧将 `count` 作为返回值返回出去，总共执行 10 次。由于是代码是跨帧调用的，那么通过上文可知 `yield` 至少要实现实现两个功能：
- 保存代码中所有临时变量`count`；
- 保存循环执行完毕条件；
- 保存每次 return 后重执行的代码位置；

把 `yield` 编译之后的代码展开，得到如下结果：

#todolist

```c++
inline TestCoroutine 
{
    
}
```

可以发现，`yield return count` 实际上是创建实现了 `IEnumerator` 接口的类，for 循环代码段被编译到 `MoveNext()` 函数，该函数每次调用就相当于执行了一次 for 循环，并且：
1. `switch` 和 `<>1__state` 联合判断 for 循环是否执行完毕，没完成则执行后面的函数体；
2. `<>2__current` 保存每次 `count` 的值；
3. `<count>5__1` 等价于原始代码中的 `count` 变量。

参考：[Unity的协程Coroutine实现原理和C#的IEnumerator、IEnumeratable、yield 介绍](https://blog.csdn.net/PresleyGo/article/details/97800918)

# StartCoroutine 分析
#todolist

- https://dev.twsiyuan.com/2017/05/unity-coroutine.html