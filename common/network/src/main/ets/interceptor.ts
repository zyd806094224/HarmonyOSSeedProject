
/**
 * @desc 定义请求和响应拦截器的接口。
 */
import { CustomRequestOptions } from './model';
import { HttpError } from './error';

/**
 * 请求拦截器接口。
 */
export interface RequestInterceptor {
  /**
   * 在发送请求之前调用的钩子。
   * 它可以修改请求配置。
   * @param config 请求配置。
   * @returns 修改后的配置或解析为该配置的Promise。
   */
  onRequest(config: CustomRequestOptions): CustomRequestOptions | Promise<CustomRequestOptions>;
}

/**
 * 响应拦截器接口。
 */
export interface ResponseInterceptor<T = unknown> {
  /**
   * 成功接收到响应时调用的钩子。
   * 它可以转换响应数据。
   * @param response 来自HTTP请求的响应对象。
   * @returns 转换后的数据或解析为该数据的Promise。
   */
  onResponse(response: T): T | Promise<T>;

  /**
   * 请求期间发生错误时调用的钩子。
   * @param error 错误对象。
   * @returns 应该以错误拒绝的Promise。
   */
  onError(error: HttpError): Promise<never>;
}
