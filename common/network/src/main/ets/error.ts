
/**
 * @desc 定义HTTP请求的自定义错误类。
 */

/**
 * 表示在HTTP请求期间发生的错误。
 */
export class HttpError extends Error {
  /**
   * HTTP状态码。
   */
  readonly code: number;

  /**
   * 响应数据（如果有）。
   */
  readonly response: string | object | undefined;

  constructor(message: string, code: number = -1, response?: string | object) {
    super(message);
    this.name = 'HttpError';
    this.code = code;
    this.response = response;
  }
}

/**
 * 表示已取消HTTP请求的错误。
 */
export class HttpCancelError extends HttpError {
  constructor(message: string = 'Request canceled') {
    super(message, -1);
    this.name = 'HttpCancelError';
  }
}
