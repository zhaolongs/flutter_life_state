import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'abs_life.dart';
import 'observer_route.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/7/22.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572

///lib/app/base/base_life_state.dart
/// Flutter 中的 Widget  生命周期，并且通过 State 来体现。
///视图显示的各个阶段（即视图的BaseLifeState 生命周期）
///应用从启动到退出所经历的各个状态（App 的BaseLifeState 生命周期）
///
/// App 的BaseLifeState 生命周期，则定义了 App 从启动到退出的全过程。
///createState 是 StatefulWidget 里创建 State 的方法，当要创建新的 StatefulWidget 的时候，
///会立即执行 createState，而且只执行一次，createState 必须要实现：
///[WidgetsBinding] 提供了单次 Frame 绘制回调，以及实时 Frame 绘制回调两种机制，来分别满足不同的需求：
///[RouteAware]定义了路由观察者的回调
///[StateLiveState] 定义了生命周期函数
abstract class BaseLifeState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, RouteAware,StateLiveState {

  ///是否将要移除当前的Widget
  bool isDidPop = false;
  ///是否执行过 onWillDestory 回调
  bool isStop = false;
  ///当前页面是否可见可操作标识
  bool currentMounted = false;
  ///当前页面是否有焦点
  bool currentFocus = true;

  /// createState 是在创建 StatefulWidget 的时候会调用，
  /// initState 是 StatefulWidget 创建完后调用的第一个方法，而且只执行一次，
  /// 类似于 Android 的 onCreate、iOS 的 viewDidLoad()，
  /// 所以在这里 View 并没有渲染，但是这时 StatefulWidget 已经被加载到渲染树里了，
  /// 这时 StatefulWidget 的 mount的值会变为 true，直到 dispose调用的时候才会变为 false
  /// 此方法中i sk 可以使用[BuildContext]
  @override
  void initState() {
    super.initState();
    ///生命周期方法回调
    onWillCreat();
    ///绑定监听
    WidgetsBinding.instance.addObserver(this);
    ///单次 Frame 绘制回调，通过 addPostFrameCallback 实现。
    ///它会在当前 Frame 绘制完成后进行回调，并只会回调一次，如果要再次监听则需要再设置一次。
    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
  }
  ///lib/app/base/base_life_state.dart
  ///WidgetsBinding的绘制完成的一次性回调
  void postFrameCallback(Duration timeStamp) {
    ///生命周期方法回调
    onCreat();
    onStart();
    onResumed();
    debugPrint(" BaseLifeState 生命周期 单次 Frame 绘制回调");
    ///记录当前Widget的的状态
    currentMounted = mounted;
    ///添加一个焦点监听
    FocusScope.of(context).addListener(focusScopeListener);
    ///在第一次绘制完成时再添加实时回调的监听
    addPersistentFrameCallbackFunction();

  }
  ///lib/app/base/base_life_state.dart
  ///当前 Widget 获取焦点的监听
  ///当前的 Widget 的焦点有变化时都会回调些方法
  void focusScopeListener() {
    if(context==null){
      return;
    }
    ///判断当前是否有焦点
    /// 当被dialog挡住时，虽然可见，但是不可操作
    bool isFirstFocus = FocusScope.of(context).isFirstFocus;
    debugPrint(" BaseLifeState 生命周期 FocusScope $isFirstFocus");
    ///上一次的焦点与本次的焦点状态不一样时
    ///进行修改并回调相应的生命周期函数
    if(currentFocus!=isFirstFocus){
      currentFocus = isFirstFocus;
      if(isFirstFocus){
        ///从无焦点 -> 有焦点
        onResumed();
      }else{
        ///从有焦点到 ->无焦点
        ///isDidPop为true时代表当前的Widget要被移除
        if(isDidPop){
          onStop();
        }else{
          onPause();
        }
      }
    }
  }


  ///lib/app/base/base_life_state.dart
  ///在页面的每帧绘制完成后添加的实时
  void addPersistentFrameCallbackFunction() {
    ///实时 Frame 绘制回调，则通过 addPersistentFrameCallback 实现。
    ///这个函数会在每次绘制 Frame 结束后进行回调，可以用作 FPS 检测。
    WidgetsBinding.instance.addPersistentFrameCallback((Duration timeStamp) {
      debugPrint(
          " BaseLifeState 生命周期 实时 Frame 绘制回调 "); //  每帧都回调
      if (currentMounted != mounted) {
        if (mounted) {
          ///当前Widget可见
          onStart();
          onResumed();
        } else {
          ///当前Widget不可见
          if(!isDidPop){
            onPause();
            onStop();
          }
        }
        currentMounted = mounted;
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    debugPrint(' BaseLifeState 生命周期 reassemble');
  }


  ///lib/app/base/base_life_state.dart
  ModalRoute _modalRoute;
  /// 当 StatefulWidget 第一次创建的时候，
  /// didChangeDependencies方法会在 initState方法之后立即调用，
  /// State 对象的依赖关系发生变化后
  /// 所以 didChangeDependencies有可能会被调用多次。
  /// 此方法中可以使用[BuildContext]
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 订阅 routeObserver，之后就会尝试调用抽象类 RouteAware 的方法
    if(_modalRoute==null){
      _modalRoute =ModalRoute.of(context);
      routeObserver.subscribe(this,_modalRoute);
    }
    if(isDidPop&&!isStop){
      isStop=true;
      ///移除焦点监听
      FocusScope.of(context).removeListener(focusScopeListener);
      onPause();
      onStop();
      onWillDestory();
    }
  }

  ///lib/app/base/base_life_state.dart
  ///App切后台，再切回来
  ///I/flutter (15758): AppLifecycleState.inactive
  ///I/flutter (15758): AppLifecycleState.paused
  ///I/flutter (15758): AppLifecycleState.resumed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('BaseLifeState 生命周期 $state');
    switch (state) {
      case AppLifecycleState.resumed:

        /// App从后台切回来
        /// 可见的，并能响应用户的输入
        onStart();
        onResumed();
        break;
      case AppLifecycleState.inactive:
        /// App切从显示切后台，回调的第一个方法
        /// 处在不活动状态，无法处理用户响应
        break;
      case AppLifecycleState.paused:

        /// App切从显示切后台，回调的第二个方法
        /// 不可见并不能响应用户的输入，但是在后台继续活动中
        onPause();
        onStop();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  ///系统窗口改变回调 如键盘弹出 屏幕旋转等
  @override
  void didChangeMetrics() {
    debugPrint('BaseLifeState 生命周期 didChangeMetrics');
    super.didChangeMetrics();
  }

  ///手机系统文本缩放系数改变里回调这里
  @override
  void didChangeTextScaleFactor() {
    super.didChangeTextScaleFactor();
  }

  ///手机系统屏幕亮度发生改变时回调
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
  }

  ///语言环境发生改变时回调这里
  @override
  void didChangeLocales(List<Locale> locale) {
    super.didChangeLocales(locale);
  }

  ///内存警告回调
  @override
  void didHaveMemoryPressure() {
    super.didHaveMemoryPressure();
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('BaseLifeState 生命周期 deactivate');
  }

  @override
  void dispose() {
    ///注销
    WidgetsBinding.instance.removeObserver(this);
    ///解除订阅
    routeObserver.unsubscribe(this);
    onDestory();
    super.dispose();
    debugPrint('BaseLifeState 生命周期 dispose');
  }

  @override
  void didPush() {
    // 当前页面入栈
    debugPrint("BaseLifeState 生命周期 didPush");
  }

  @override
  void didPopNext() {
    // 当前路由的下个路由出栈，且当前页面显示
    debugPrint("BaseLifeState 生命周期 didPopNext");
    onStart();
  }

  @override
  void didPop() {
    super.didPop();
    debugPrint("BaseLifeState 生命周期 didPop");
    isDidPop=true;
  }

  ///当前页面调用 Navigator的push方法打开新的路由页面的回调
  @override
  void didPushNext() {
    super.didPushNext();
    debugPrint("BaseLifeState 生命周期 didPushNext");
    onStop();
  }


}
