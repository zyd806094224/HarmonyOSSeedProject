
/**
 * @desc 定义网络模块的数据模型和类型。
 */
import http from '@ohos.net.http';

/**
 * 定义通用API响应的结构。
 * 后端的实际数据应该包装在此结构中。
 * @template T 'data'字段的类型。
 */
export interface ApiResult<T> {
  code: number;
  message: string;
  data: T;
}

/**
 * 扩展默认的HttpRequestOptions以包含自定义配置。
 */
export interface CustomRequestOptions extends http.HttpRequestOptions {
  /**
   * 请求URL，可以是完整URL或相对路径。
   */
  url: string;

  /**
   * 请求参数，通常用于GET请求。
   * 这些参数将作为查询字符串附加到URL上。
   */
  params?: Record<string, string | number | boolean>;

  /**
   * 请求体，通常用于POST、PUT、PATCH请求。
   */
  data?: object | string | ArrayBuffer;
}
