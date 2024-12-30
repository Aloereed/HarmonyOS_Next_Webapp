import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbox',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebAppScreen(),
    );
  }
}

class WebAppScreen extends StatefulWidget {
  const WebAppScreen({Key? key}) : super(key: key);

  @override
  State<WebAppScreen> createState() => _WebAppScreenState();
}

class _WebAppScreenState extends State<WebAppScreen> {
  late final WebViewController _controller;
  bool _isConnected = true; // 网络状态

  @override
  void initState() {
    super.initState();

    // 设置状态栏颜色为白色，图标颜色为深色
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // 状态栏背景颜色
        statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
      ),
    );

    // 初始化网络监听
    _checkNetworkConnection();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });

    // WebView 初始化
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 启用 JavaScript
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('Page loading: $url');
          },
          onPageFinished: (url) {
            debugPrint('Page loaded: $url');
          },
          onWebResourceError: (error) {
            debugPrint('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://flutter.dev')); // 加载初始网页
  }

  /// 检查网络连接状态
  Future<void> _checkNetworkConnection() async {
    final connectivityStatus = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityStatus != ConnectivityResult.none;
    });
  }

  /// 返回按钮处理
  Future<bool> _handleWillPop() async {
    if (await _controller.canGoBack()) {
      // 如果 WebView 可以返回上一页
      await _controller.goBack();
      return false; // 不退出应用
    }
    return true; // 退出应用
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleWillPop, // 处理返回按钮
      child: Scaffold(
        backgroundColor: Colors.white, // 背景颜色与状态栏一致
        body: SafeArea( // 使用 SafeArea 避免内容被状态栏覆盖
          child: _isConnected
              ? WebViewWidget(controller: _controller) // 显示 WebView
              : _buildNoConnectionScreen(), // 显示无网络提示
        ),
      ),
    );
  }

  /// 无网络连接时的占位界面
  Widget _buildNoConnectionScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            '无网络连接',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkNetworkConnection,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}
