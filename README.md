# Flutter WebApp Example (鸿蒙版)

这是一个使用 Flutter 构建的简单 WebApp 项目，旨在帮助开发者快速实现一个加载网页的移动应用。它集成了 `webview_flutter` 插件，用于加载网页，并通过 `connectivity_plus` 插件检测网络连接状态，提供以下功能：

1. 加载指定的网页。
2. 处理系统返回按钮，用于返回网页的上一页。
3. 当设备无网络连接时显示“无网络连接”的提示页面。
4. 沉浸式状态栏设计，状态栏颜色为白色，图标为深色。

---

## 功能特性

- **网页加载**：通过 WebView 加载指定的网页内容。
- **状态栏设计**：实现沉浸式状态栏，颜色白色，图标为深色。
- **无网络提示**：在无网络连接时显示提示页面，并提供“重试”按钮。
- **返回按钮处理**：支持返回 WebView 的上一页，而不是直接退出应用。

---

## 运行效果

- **正常加载网页**：
  - 显示指定的网址内容。
- **无网络提示**：
  - 显示无网络连接的占位页面。
- **返回按钮功能**：
  - 在网页内导航时，按系统返回按钮可返回到上一页。
  - 如果已经在首页，则退出应用。

---

## 环境要求

- **Flutter SDK**：3.22.0 或更高版本
- **Dart**：3.4.0 或更高版本
- **开发环境**：VS Code
- **支持平台**：HarmonyOS Next(API12+)

---

## 如何运行项目

按照以下步骤运行项目：

### 0. 配置鸿蒙Flutter开发环境

参见 [开源鸿蒙仓库](https://gitee.com/openharmony-sig/flutter_flutter)。

### 1. 克隆代码仓库

```bash
git clone https://github.com/your-repo/flutter-webapp-example.git
cd flutter-webapp-example
```

### 2. 安装依赖

确保 Flutter 环境已配置，然后运行以下命令安装依赖：

```bash
flutter pub get
```

### 3. 修改目标网址

在 `WebAppScreen` 的 `initState` 方法中，找到以下代码：

```dart
..loadRequest(Uri.parse('https://flutter.dev'));
```

将 `'https://flutter.dev'` 替换为你希望加载的目标网址，例如：

```dart
..loadRequest(Uri.parse('https://yourwebsite.com'));
```

### 4. 构建应用

使用以下命令构建应用：

```bash
flutter build hap --release
```

---

## 主要依赖

以下是项目的核心依赖及其功能：

1. **[webview_flutter](https://pub.dev/packages/webview_flutter)**：
   - 用于在应用中嵌入网页。
2. **[connectivity_plus](https://pub.dev/packages/connectivity_plus)**：
   - 检测设备的网络连接状态。

### `pubspec.yaml` 中的依赖声明

```yaml
dependencies:
  flutter:
    sdk: flutter
  webview_flutter: （鸿蒙仓库）
  connectivity_plus: （鸿蒙仓库）
```

---

## 代码结构

```
webapp/
├── lib/
│   ├── main.dart          # 应用入口文件
├── pubspec.yaml           # 项目依赖配置文件
```

### 主要文件说明

#### `main.dart`

应用的核心逻辑，包括以下功能：

1. **WebView 加载网页**：
   - 使用 `webview_flutter` 的 `WebViewController` 和 `WebViewWidget` 来加载网页内容。

2. **无网络提示**：
   - 使用 `connectivity_plus` 检测网络状态，无网络时显示占位页面。

3. **返回按钮处理**：
   - 使用 `WillPopScope` 捕捉返回事件，并通过 WebView 的 `canGoBack` 和 `goBack` 方法返回上一页。

---

## 如何自定义

### 1. 修改加载的网页地址

在 `main.dart` 文件中，找到以下代码：

```dart
..loadRequest(Uri.parse('https://flutter.dev'));
```

将 `https://flutter.dev` 替换为你的目标网址。

---

### 2. 自定义无网络提示页面

无网络时显示的占位页面在 `_buildNoConnectionScreen` 方法中定义：

```dart
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
```

你可以根据需要修改图标、文字或按钮设计。

---

### 3. 自定义状态栏样式

状态栏的样式通过以下代码设置：

```dart
SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // 状态栏背景颜色
    statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
  ),
);
```

- **状态栏背景颜色**：修改 `statusBarColor`。
- **状态栏图标颜色**：
  - `Brightness.dark`：深色图标（适合浅色背景）。
  - `Brightness.light`：浅色图标（适合深色背景）。

---

## 常见问题

### 1. **无法加载网页**

- 检查目标网址是否可以正常访问。
- 确保设备已连接到网络。

### 2. **无网络时没有提示**

确保已安装 `connectivity_plus` 插件，并正确配置以下代码：

```dart
Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  setState(() {
    _isConnected = result != ConnectivityResult.none;
  });
});
```

### 3. **状态栏覆盖 WebView 内容**

确保在 `Scaffold` 的 `body` 中使用了 `SafeArea`：

```dart
body: SafeArea(
  child: WebViewWidget(controller: _controller),
),
```

---

## 贡献指南

欢迎提交 issue 或 pull request，帮助改进项目！

1. Fork 本项目。
2. 创建你的分支：`git checkout -b feature/my-feature`。
3. 提交更改：`git commit -m "Add some feature"`。
4. 推送到分支：`git push origin feature/my-feature`。
5. 提交 Pull Request。

---

## 许可证

本项目遵循 Apache 许可证，详情请参考 [LICENSE](LICENSE)。
