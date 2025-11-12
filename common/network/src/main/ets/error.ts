
/**
 * @desc Defines custom error classes for HTTP requests.
 */

/**
 * Represents an error that occurs during an HTTP request.
 */
export class HttpError extends Error {
  /**
   * The HTTP status code.
   */
  readonly code: number;

  /**
   * The response data, if any.
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
 * Represents an error for a cancelled HTTP request.
 */
export class HttpCancelError extends HttpError {
  constructor(message: string = 'Request canceled') {
    super(message, -1);
    this.name = 'HttpCancelError';
  }
}
