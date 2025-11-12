
/**
 * @desc Defines interfaces for request and response interceptors.
 */
import { CustomRequestOptions } from './model';
import { HttpError } from './error';

/**
 * Request interceptor interface.
 */
export interface RequestInterceptor {
  /**
   * A hook that is called before the request is sent.
   * It can modify the request configuration.
   * @param config The request configuration.
   * @returns The modified configuration or a Promise that resolves to it.
   */
  onRequest(config: CustomRequestOptions): CustomRequestOptions | Promise<CustomRequestOptions>;
}

/**
 * Response interceptor interface.
 */
export interface ResponseInterceptor<T = unknown> {
  /**
   * A hook that is called when a response is successfully received.
   * It can transform the response data.
   * @param response The response object from the HTTP request.
   * @returns The transformed data or a Promise that resolves to it.
   */
  onResponse(response: T): T | Promise<T>;

  /**
   * A hook that is called when an error occurs during the request.
   * @param error The error object.
   * @returns A Promise that should be rejected with the error.
   */
  onError(error: HttpError): Promise<never>;
}
