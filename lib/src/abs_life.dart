import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/7/24.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
///lib/app/base/abs_life.dart
/// Widget 的完整生存期会在 [onCreate]调用和[onDestroy]调用之间发生
///
///[onCreate]方法 在 [State]的initState方法中调用，一般在这个方法中初始化一些数据
/// 在此方法中 State与 BuildContext还未绑定好，所以是不可使用context的
///
/// [onWillCreat]方法  在页面可见时回调，也就是页面的第一帧绘制完毕后回调
///   类似Android中的onCreat方法
///   类似iOS中ViewController的 viewDidLoad 方法
///
///[onStart]方法 在[onWillCreat]之后回调
///   类似Android的Activity的onStart方法
///   类似iOS中ViewController的 viewWillAppear
///
///[onResumed]方法在[onStart]方法后执行，页面有焦点时的回调
///   类似Android的Activity的onResumed方法
///   类似iOS中ViewController的viewDidAppear
///
///[onPause]方法在页面失去焦点时的回调
///   类似Android的Activity的onPause方法
///   类似iOS中ViewController的 viewWillDisappear
///
///[onStop]方法在页面不可见时的回调
///   类似Android的Activity的onStop方法
///   类似iOS中ViewController的 viewDidDisappear
///
///
///[onWillDestory]方法在页面即将销毁时调用 context 可用，一般在这里进行解绑操作
///只会调用一次
///
///[onDestory]方法在页面销毁时回调 context 已解绑 不可使用
///类似Android的Activity的onDestory
/// 类似iOS中ViewController的  dealloc
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