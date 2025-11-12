
/**
 * @desc Defines data models and types for the network module.
 */
import http from '@ohos.net.http';

/**
 * Defines the structure for a generic API response.
 * The actual data from the backend should be wrapped in this structure.
 * @template T The type of the 'data' field.
 */
export interface ApiResult<T> {
  code: number;
  message: string;
  data: T;
}

/**
 * Extends the default HttpRequestOptions to include custom configurations.
 */
export interface CustomRequestOptions extends http.HttpRequestOptions {
  /**
   * The request URL, which can be a full URL or a relative path.
   */
  url: string;

  /**
   * Request parameters, typically for GET requests.
   * These will be appended to the URL as a query string.
   */
  params?: Record<string, string | number | boolean>;

  /**
   * Request body, typically for POST, PUT, PATCH requests.
   */
  data?: object | string | ArrayBuffer;
}
