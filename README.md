# MDTools

注意：运行demo需要首先执行：
```
pod install
```

MDTools是一个工具集合，目前开源了任务管理模块和一个轻量级的观察者模块

#### 安装方法

你可以一次安装所有模块：

    pod 'MDTools', '~>0.0.2'

也可以单独安装子模块:

    pod 'MDTools/MDTask', '~>0.0.2'

    pod 'MDTools/MDListener', '~>0.0.2'

#### MDTask

MDTask是一组工具，可以对任务进行并发、顺序执行，并且并发任务组、顺序任务组也可以作为一个任务，与其他任务（组）重新组成并发、顺序任务组。

[MDTask使用教程](https://github.com/yangchenlarkin/MDTools/wiki/MDTask)

#### MDListener

MDListener是一个轻量级的观察者管理模块，MDListener在消息通知机制上采取的策略是，被观察者通过定义协议，来决定观察者接受消息的方法，观察者通过实现这些方法，来接受消息。

[MDListener使用教程](https://github.com/yangchenlarkin/MDTools/wiki/MDListener)
