# flutter_life_state

Flutter 生命周期兼听库、Flutter组件生命周期、Widget生命周期

## Getting Started

|**  |你可能需要   |
|--|--|
| [CSDN](https://biglead.blog.csdn.net/)| [网易云课堂教程](https://study.163.com/instructor/1021406098.htm)  |
| [掘金](https://juejin.im/user/712139263459176)| [EDU学院教程](https://edu.csdn.net/lecturer/1555)  |
| [知乎](https://www.zhihu.com/people/zhao-long-90-89/posts)| [Flutter系列文章 ](https://blog.csdn.net/zl18603543572/article/details/93532582)  |
 |[头条同步](https://www.toutiao.com/i6867301274614759948/)  | [百度同步](https://baijiahao.baidu.com/builder/preview/s?id=1676587101499079482) |

*** 

在 Flutter应用程序中，生命周期涉及两个，一个是 Widget 的生命周期，一个是应用程序的生命周期，本文章说明通过 flutter_life_state 依赖库实现在 Flutter 中类似 Android 中Activity的生命周期监听，类似 iOS UIViewController 的生命周期。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200905094755919.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70#pic_center)

#### 1 添加依赖 

[点击查看 flutter_life_state pub仓库 最新版本](https://pub.flutter-io.cn/packages/flutter_life_state)

```java
dependencies:
  flutter_life_state: ^1.0.0
```
当然你也可以[点击查看 github 源码](https://github.com/zhaolongs/flutter_life_state)，在Flutter 中也可通过git方式来引用如下：

```java
dependencies:
	shake_animation_widget:
	      git:
	        url: https://github.com/zhaolongs/flutter_life_state.git

```
然后在人的入口添加 lifeFouteObserver ：

```java

import 'package:flutter_life_state/flutter_life_state.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ... 
      navigatorObservers: [
      lifeFouteObserver
      ],
    );
  }
}
```

然后在使用到的 Widget 页面中导包如下：

```java
import 'package:flutter_life_state/flutter_life_state.dart';
```


#### 2 监听 Widget 页面生命周期 
使用 flutter_life_state 来监听 Widget 的生命周期时，你需要在你的 StatefulWidget 对应的State 继承 BaseLifeState  如下代码清单 2-1 所示：

```java
///代码清单 2-1
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends BaseLifeState<TestPage> {
  @override
  Widget build(BuildContext context) { ...}
}
```
当使用 Navigator.push  方式将上述代码清单 2-1 所示的 TestPage 打开时，会调用 BaseLifeState 的生命周期如下图所示：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200905092429543.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70#pic_center)
当然如果你需要在生命周期中处理你的业务需要，直接复写父类 BaseLifeState 的生命周期函数就好，如下代码清单 2-2所示：

```java
///代码清单 2-2
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends BaseLifeState<TestPage> {
  @override
  Widget build(BuildContext context) {...}

  @override
  void onCreat() {
    super.onCreat();
    print(" A 页面 onCreat");
  }

  @override
  void onDestory() {
    super.onDestory();
    print(" A 页面 onDestory");
  }
}
```


#### 3 BaseLifeState 生命周期概述

BaseLifeState 生命周期回调完全实现了 Android 中Activity、iOS UIViewController 的生命周期，如下源码清单 3-1 所示。

```java
///源码清单 3-1 
class StateLiveState{
  ///页面即将创建时回调
  void onWillCreat(){}
  ///页面创建时的回调 已创建好
  void onCreat(){}
  ///页面可见时回调
  void onStart() {}
  ///页面获取焦点时回调
  void onResumed() {}
  ///页面失去焦点时回调
  void onPause() {}
  ///页面不可见时回调
  void onStop() {}
  ///页面即将销毁时回调
  void onWillDestory(){}
  ///页面销毁
  void onDestory(){}
}
```
Widget 的完整生存期会在 [onCreate]调用和[onDestroy]调用之间发生：

* onWillCreat 方法 一般在这个方法中初始化一些数据，在此方法中 State与 BuildContext还未绑定好，所以是不可使用context的，就如大家平时在 [State]的initState方法中初始化的数据就可以在这个方法回调中进行操作。
* onCreate 方法  在页面可见时回调，也就是页面的第一帧绘制完毕后回调，类似Android中的onCreat方法，类似iOS中ViewController的 viewDidLoad 方法。
* onStart 方法 在[onWillCreat]之后回调，  类似Android的Activity的onStart方法，类似iOS中ViewController的 viewWillAppear 。
* onResumed 方法在[onStart]方法后执行，页面有焦点时的回调，类似Android的Activity的onResumed方法，  类似iOS中ViewController的viewDidAppear 。
* onPause 方法在页面失去焦点时的回调， 类似Android的Activity的onPause方法，类似iOS中ViewController的 viewWillDisappear。
* onStop 方法在页面不可见时的回调，类似Android的Activity的onStop方法，类似iOS中ViewController的 viewDidDisappear。
* onWillDestory 方法在页面即将销毁时调用 context 可用，一般在这里进行解绑操作，只会调用一次。
* onDestory方法在页面销毁时回调 context 已解绑 不可使用，类似Android的Activity的onDestory,类似iOS中ViewController的  dealloc。

#### 4 生命周期使用场景

##### 4.1 页面 A - 页面B - 页面 A 
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200905094111923.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70#pic_center)
##### 4.2  Dialog 弹框
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200905094212529.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70#pic_center)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200905094246850.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3psMTg2MDM1NDM1NzI=,size_16,color_FFFFFF,t_70#pic_center)
