# DBRouter

DBRouter是为了适应客户端组件化开发模式的路由框架，解决模块间页面跳转的耦合问题。

## 功能介绍

- 支持通过标准URL进行页面跳转，并支持将URL中参数注入到目标页面中
- 支持返回到指定页面
- 支持返回n级页面
- 支持从外部浏览器或者第三方应用通过标准URL唤醒APP并打开指定页面
- 从外部应用里通过URL打开App指定页面时，支持白名单功能，不在白名单内的只唤起App
- 通过标准URL跳转, 支持跳转到原生页面、外部浏览器

## 安装

```ruby
pod 'DBRouter'
```

## 使用说明

### 配置

1. ##### 工程中配置路由文件

   routerClassList.json : 路由url规则与页面类名对应关系

   routerWhiteList.json: url白名单列表，控制外部应用通过url打开指定页面

2. ##### 引入头文件

   ```
   import <DBRouter/DBRouter.h>
   ```

### 第三方应用跳转至App

1. 在Info.plist中加入scheme, 以DBRouter前缀开头，例如：

   ```xml
   <key>CFBundleURLTypes</key>
   	<array>
   		<dict>
   			<key>CFBundleTypeRole</key>
   			<string>Editor</string>
   			<key>CFBundleURLSchemes</key>
   			<array>
   				<string>DBRouter</string>
   			</array>
   		</dict>
   	</array>
   ```

2. 在 routerWhiteList.json 中加入允许外部访问的url规则,  例如：

   ```json
   [
     "DBRouter://com.xujiebing.DBRouter/模块名/页面名"
   ]
   ```

   > url规则在routerWhiteList.json文件中获取, 注意去除url中的参数

3. 在AppDelegate加入以下代码:

   ```
   // iOS9以及之前
   - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
       DBRouterManager.routerManager.routerUrl(url);
       return YES;
   }
   
   // iOS9之后
   - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
       DBRouterManager.routerManager.routerUrl(url);
       return YES;
   }
   ```

   

4. 打开safari浏览器, 访问 `DBRouter://com.xujiebing.DBRouter/模块名/页面名` 即可跳转到指定页面

### 内部跳转相关

   1. 根据标准url跳转, 支持传参(参数目前只支持NSDictionary, 非字典传入会被忽略)

      ```
      DBRouterManager.routerManager.routerWithUrl(@"DBRouter://com.xujiebing.DBRouter/page1/index?jumptype=1");
      
      DBRouterManager.routerManager.routerWithUrlAndParams(@"DBRouter://com.xujiebing.DBRouter/page1/index?jumptype=1", dic)
      ```

   2. 根据url获取viewController

      ```
      DBRouterManager.routerManager.viewControllerWithUrl(@"DBRouter://com.xujiebing.DBRouter/page2/findpage");
      ```

   3. 返回上级页面

      ```
      DBRouterManager.routerManager.popRouter;
      ```

4. 返回N级页面

      ```
   DBRouterManager.routerManager.popRouterWithIndex(index);
   ```

5. 返回指定页面

      ```
      DBRouterManager.routerManager.popRouterWithUrlAndAnimated(@"DBRouter://com.xujiebing.DBRouter/page2/findpage", YES); 
      ```


### 内部App跳转到原生浏览器

只要传入url scheme为http/https即可, 示例：

   ```objective-c
DBRouterManager.routerManager.routerWithUrl(@"http://www.baidu.com/");
   ```

### url规则说明

```
DBRouter://com.xujiebing.DBRouter/page2/findpage?jumptype=*&*parameter=*
```

目前url是以标准的url组成：

* **scheme**

  DBRouter：App的scheme，不区分大小写

  如果scheme为`htpp/https`,则会跳转至手机浏览器

* **host**

  com.xujiebing.DBRouter

* **一级目录**

  page2：也可以叫模块目录

  模块目录主要是区分不同的业务模块，提升了解析效率

* **二级目录**

  findpage，具体页面路径

* **请求参数**

```
jumptype=*
jumptype表示 跳转方式, 默认为push
对应的枚举关系：push-1、present-2

*parameter=*
*parameter中的*表示必填项，parameter的值不能为空或不能为*, 后面的*则标识可以为任意字符(*除外)
```

> 注意实际的跳转路由中的参数不能以*开头，如：
>
> 正确写法：
>
> DBRouterManager.routerManager.routerWithUrlAndParams(@"DBRouter://com.xujiebing.DBRouter/page1/index?jumptype=1", dic)
>
> 错误写法：
>
> DBRouterManager.routerManager.routerWithUrlAndParams(@"DBRouter://com.xujiebing.DBRouter/page1/index?*jumptype=1", dic)

## Author

xujiebing, xujiebing1992@gmail.com

## License

DBRouter is available under the MIT license. See the LICENSE file for more info.

