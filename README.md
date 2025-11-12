# HarmonyOS 模块化种子工程 (HarmonyOS Seed Project)

## 1. 项目简介

本项目是一个基于 **HarmonyOS ArkTS** 的模块化应用脚手架（Seed Project）。旨在为开发者提供一个功能完备、结构清晰、可高度扩展的 HarmonyOS 应用开发起点。

该脚手架预设了现代应用开发所需的诸多最佳实践，包括但不限于：
- **多模块化架构**：清晰分离业务功能，实现高内聚、低耦合。
- **统一网络层**：封装了通用的 HTTP 网络请求能力，支持拦截器等高级功能。
- **共享组件库**：方便在不同功能模块间复用 UI 组件和业务逻辑。
- **声明式 UI**：采用 ArkTS eTS 进行高效、现代的 UI 开发。
- **路由管理**：集成了第三方路由库 `@hadss/hmrouter`，优雅地处理页面和模块间的跳转。

通过使用本脚手架，开发团队可以跳过繁琐的基础架构搭建过程，直接聚焦于业务功能的实现。

## 2. 核心设计理念

- **模块化 (Modularity)**：每个核心业务功能都作为一个独立的 `feature` 模块存在。这种设计不仅有利于团队并行开发，也使得功能的维护、测试和拔除变得简单。
- **关注点分离 (Separation of Concerns)**：将应用横向切分为不同的层级。例如，`common/network` 专注于网络，`common/component` 专注于可复用组件，`features/*` 专注于具体业务。
- **可扩展性 (Scalability)**：当需要开发新功能时，只需在 `features` 目录下创建一个新的模块，即可无缝集成到现有应用中，而无需大规模改动核心代码。

## 3. 技术栈

- **操作系统**: HarmonyOS (OpenHarmony)
- **开发语言**: **ArkTS**
- **UI 框架**: ArkUI (基于 eTS 声明式 UI 范式)
- **构建工具**: **Hvigor**
- **核心依赖**:
  - `@hadss/hmrouter`: 一个强大的第三方路由框架，用于解耦页面导航。

## 4. 项目结构详解

```
/
├── AppScope/              # 应用全局配置与资源
├── common/                # 公共基础模块 (HAR)
│   ├── component/         # 可复用的 UI 组件或业务组件
│   └── network/           # 统一网络请求模块 (httpClient)
├── entry/                 # 应用主入口模块 (HAP)
├── features/              # 业务功能模块 (HAP or HAR)
│   ├── one/               # 功能模块一
│   ├── two/               # 功能模块二
│   ├── three/             # 功能模块三 (网络请求示例所在模块)
│   └── ...
├── hvigorfile.ts          # Hvigor 构建脚本
├── oh-package.json5       # HarmonyOS 包管理器配置文件
└── README.md              # 项目说明文档
```

- **`entry`**: 应用的唯一主入口模块，通常作为应用的启动模块。它负责应用的生命周期管理，并作为壳工程聚合所有的 `feature` 模块。
- **`features`**: 存放各个独立的业务功能模块。每个子目录（如 `one`, `two`）都是一个独立的 HarmonyOS 模块。
  - **如何新增功能模块？**
    1. 在 `features` 目录下右键 -> New -> Module。
    2. 选择 "Empty Ability" 模板。
    3. 完成创建后，新的功能模块会自动被工程识别和依赖。
- **`common`**: 存放公共的、可被所有模块共享的资源和逻辑，通常打包为 **HAR (Harmony Archive)**。
  - **`common/network`**: 封装了全局唯一的 `httpClient`。它提供了请求/响应拦截器、统一的错误处理和 `ApiResult` 数据结构，是应用进行网络通信的基石。
  - **`common/component`**: 用于存放跨模块复用的UI组件（如自定义弹窗、列表项）或工具类（如日期格式化、日志封装 `Logger`）。
- **`AppScope`**: 存放应用级别的全局信息，如 `app.json5` 中的应用配置，以及所有模块共享的 `string.json`, `media` 等资源。

## 5. 快速开始

### 环境要求
- **DevEco Studio**: 请确保已安装最新版本的华为开发者工具。
- **HarmonyOS SDK**: 已正确配置。

### 构建与运行
1. 使用 DevEco Studio 打开本项目。
2. 等待项目自动同步和构建完成。
3. 在工具栏选择 `entry` 模块作为启动模块。
4. 选择一个模拟器或真实设备。
5. 点击 "Run" 按钮即可启动应用。

## 6. 核心功能实践

### 路由导航
本项目使用 `@hadss/hmrouter` 进行页面导航。
- **定义路由**: 在页面 `struct` 上方使用 `@HMRouter` 装饰器定义页面的访问 URL。
  ```typescript
  // at /features/three/src/main/ets/three/pages/ThreePage.ets
  import { RouterUrl } from "component"; // RouterUrl 在公共模块中统一定义

  @HMRouter({ pageUrl: RouterUrl.THREE_TAB_INDEX_PAGE })
  @Entry
  @ComponentV2
  export struct ThreePage { /* ... */ }
  ```
- **发起跳转**: 在需要跳转的地方，调用 `HMRouter.push` 方法。
  ```typescript
  import { HMRouter } from "@hadss/hmrouter";

  // 跳转到 ThreePage
  HMRouter.push(RouterUrl.THREE_TAB_INDEX_PAGE);
  ```

### 网络请求
所有网络请求都应通过 `common/network` 模块提供的 `httpClient` 发起。
- **基本用法**:
  ```typescript
  import { httpClient, HttpError, ApiResult } from "network";

  async function fetchData() {
    try {
      const response: ApiResult<MyDataType> = await httpClient.get('/api/data');
      console.log('Success:', response.data);
    } catch (error) {
      if (error instanceof HttpError) {
        console.error(`Error: Code=${error.code}, Message=${error.message}`);
      }
    }
  }
  ```
- **拦截器**: `httpClient` 支持请求拦截器，可在 `aboutToAppear` 或其他初始化阶段进行注册，用于统一添加 Token、日志记录等。
  ```typescript
  // at /features/three/src/main/ets/three/pages/ThreePage.ets
  aboutToAppear(): void {
    httpClient.addRequestInterceptor({
      onRequest(config) {
        if (!config.header) config.header = {};
        config.header['Authorization'] = 'Bearer your-token';
        return config;
      }
    });
  }
  ```
