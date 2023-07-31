---
id: 40fbsadl5ep9pewp7r6x2o4
title: Asset Bundle
desc: ''
updated: 1690339893599
created: 1690285945110
---

https://zhuanlan.zhihu.com/p/38122862 

- 卸载 AssetBundle，存在 Object Duplicate 的情况，因为 AssetBundle 被卸载时没有卸载从 AssetBundle 加载到内存的 GameObject

https://blog.csdn.net/u014361280/article/details/107831653

- AssetBundle 之间存在依赖关系，Unity 不替你处理依赖关系，所以在加载一个 AssetBundle 时，需要用于自己判断需要依赖哪些其他 AssetBundle 


AssetBundle\Prefab\目录 

为什么一个 assetbundle.prefab 路径对应多个 obj 呢？

AssetDataBase 加载(Only editor)
https://www.jianshu.com/p/78afb4f71749