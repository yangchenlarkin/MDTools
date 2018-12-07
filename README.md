## 简介
MDTools是一个工具集合，目前开源了五个工具：

1.任务管理模块MDTask

2.一款轻量级的观察者模块MDListener

3.可以实现“协议默认实现”的模块MDProtocolImplementation

4.面向切面工具MDAspects

5.模块管理框架MDModuleManager

## 安装

你可以一次安装所有模块：

    pod 'MDTools', '~>0.0.4'

也可以单独安装子模块:

    pod 'MDTools/MDTask', '~>0.0.4'

    pod 'MDTools/MDListener', '~>0.0.4'

    pod 'MDTools/MDProtocolImplementation', '~>0.0.4'

    pod 'MDTools/MDAspects', '~>0.0.4'

    pod 'MDTools/MDModuleManager', '~>0.0.4'

## 1.MDTask

MDTask是一组工具，可以对任务进行并发、顺序执行，并且并发任务组、顺序任务组也可以作为一个任务，与其他任务（组）重新组成并发、顺序任务组。

[MDTask文档](https://github.com/yangchenlarkin/MDTools/wiki/MDTask)

## 2.MDListener

MDListener是一个轻量级的观察者管理模块，MDListener在消息通知机制上采取的策略是，被观察者通过协议定义观察者接受消息的方法，观察者实现方法来接受消息。

[MDListener文档](https://github.com/yangchenlarkin/MDTools/wiki/MDListener)

## 3.MDProtocolImplementation

MDProtocolImplementation能实现对协议的默认实现，遵循这类协议的类，可以不用实现这些协议的方法，而直接调用这些方法。如果这些类实现了协议中的某些方法，调用这些方法时将会执行类自己的实现，而非默认实现。

[MDProtocolImplementation文档](https://github.com/yangchenlarkin/MDTools/wiki/MDProtocolImplementation)


## 4.MDAspects

MDAspects是一系列面向切面的方法。他是NSObject的分类。可以在类实例方法的执行前、执行后添加一些逻辑。只需要引用头文件NSObject+Aspects.h即可。

[MDAspects文档](https://github.com/yangchenlarkin/MDTools/wiki/MDAspects)

## 5.MDModuleManager

ModuleManager是一款处理界面模块化的架构。他具备高度封装、业务逻辑高度分离等特性，还能使得界面间跳转逻辑单独分离，从而达到界面功能高度复用，无需为流程的改动、增减而重写界面代码的效果。

[MDModuleManager文档](https://github.com/yangchenlarkin/MDTools/wiki/MDModuleManager)

**项目作者：[xup48](https://github.com/xup48) 、 [剑川道长](https://github.com/yangchenlarkin)**
