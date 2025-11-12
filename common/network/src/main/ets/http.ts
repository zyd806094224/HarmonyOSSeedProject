
/**
 * @desc Core implementation of the HttpClient.
 */
import http from '@ohos.net.http';
import { ApiResult, CustomRequestOptions } from './model';
import { HttpError } from './error';
import { RequestInterceptor, ResponseInterceptor } from './interceptor';

class HttpClient {
  private readonly baseUrl: string;
  private readonly globalHeaders: Record<string, string>;
  private readonly requestInterceptors: RequestInterceptor[] = [];
  private readonly responseInterceptors: ResponseInterceptor[] = [];

  constructor(baseUrl: string = '', globalHeaders: Record<string, string> = {}) {
    this.baseUrl = baseUrl;
    this.globalHeaders = {
      'Content-Type': 'application/json',
      ...globalHeaders,
    };
  }

  /**
   * Adds a request interceptor.
   * @param interceptor The request interceptor to add.
   */
  addRequestInterceptor(interceptor: RequestInterceptor): void {
    this.requestInterceptors.push(interceptor);
  }

  /**
   * Adds a response interceptor.
   * @param interceptor The response interceptor to add.
   */
  addResponseInterceptor(interceptor: ResponseInterceptor): void {
    this.responseInterceptors.push(interceptor);
  }

  /**
   * Makes a GET request.
   * @template T The expected type of the 'data' field in the API response.
   */
  async get<T>(url: string, params?: Record<string, string | number | boolean>, options?: Omit<CustomRequestOptions, 'url' | 'params'>): Promise<ApiResult<T>> {
    return this.request<T>({ ...options, url, params, method: http.RequestMethod.GET });
  }

  /**
   * Makes a POST request.
   * @template T The expected type of the 'data' field in the API response.
   */
  async post<T>(url: string, data?: object | string, options?: Omit<CustomRequestOptions, 'url' | 'data'>): Promise<ApiResult<T>> {
    return this.request<T>({ ...options, url, data, method: http.RequestMethod.POST });
  }

  /**
   * Makes a PUT request.
   * @template T The expected type of the 'data' field in the API response.
   */
  async put<T>(url: string, data?: object | string, options?: Omit<CustomRequestOptions, 'url' | 'data'>): Promise<ApiResult<T>> {
    return this.request<T>({ ...options, url, data, method: http.RequestMethod.PUT });
  }

  /**
   * Makes a DELETE request.
   * @template T The expected type of the 'data' field in the API response.
   */
  async delete<T>(url: string, options?: Omit<CustomRequestOptions, 'url'>): Promise<ApiResult<T>> {
    return this.request<T>({ ...options, url, method: http.RequestMethod.DELETE });
  }

  /**
   * The core request method.
   * @template T The expected type of the 'data' field in the API response.
   */
  async request<T>(options: CustomRequestOptions): Promise<ApiResult<T>> {
    let config = await this.applyRequestInterceptors(options);
    const url = this.buildUrl(config.url, config.params);
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(url, this.buildRequestOptions(config));
      const result = await this.handleResponse<T>(response);
      return this.applyResponseInterceptors(result);
    } catch (err) {
      const httpError = this.createHttpError(err);
      return this.applyResponseErrorInterceptors(httpError);
    } finally {
      httpRequest.destroy();
    }
  }

  private buildUrl(url: string, params?: Record<string, string | number | boolean>): string {
    const fullUrl = (url.startsWith('http://') || url.startsWith('https://')) ? url : `${this.baseUrl}${url}`;
    if (!params) {
      return fullUrl;
    }
    const queryString = Object.entries(params)
      .map(([key, value]) => `${encodeURIComponent(key)}=${encodeURIComponent(value)}`)
      .join('&');
    return `${fullUrl}${queryString ? '?' + queryString : ''}`;
  }

  private buildRequestOptions(config: CustomRequestOptions): http.HttpRequestOptions {
    const headers = { ...this.globalHeaders, ...config.header };
    const extraData = typeof config.data === 'object' ? JSON.stringify(config.data) : config.data;

    return {
      method: config.method || http.RequestMethod.GET,
      header: headers,
      extraData: extraData,
      readTimeout: config.readTimeout || 10000,
      connectTimeout: config.connectTimeout || 10000,
    };
  }

  private async handleResponse<T>(response: http.HttpResponse): Promise<ApiResult<T>> {
    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new HttpError(`Request failed with status code ${response.responseCode}`, response.responseCode, response.result as string);
    }
    if (typeof response.result !== 'string') {
      throw new HttpError('Invalid response format, expected a string.', response.responseCode, response.result);
    }
    try {
      // Assuming the server returns a JSON string that matches the ApiResult<T> structure.
      return JSON.parse(response.result);
    } catch (e) {
      throw new HttpError('Failed to parse JSON response.', response.responseCode, response.result);
    }
  }

  private createHttpError(err: unknown): HttpError {
    if (err instanceof HttpError) {
      return err;
    }
    const error = err as Error & { code?: number };
    return new HttpError(error.message, error.code ?? -1);
  }

  private async applyRequestInterceptors(config: CustomRequestOptions): Promise<CustomRequestOptions> {
    let processedConfig = config;
    for (const interceptor of this.requestInterceptors) {
      processedConfig = await interceptor.onRequest(processedConfig);
    }
    return processedConfig;
  }

  private async applyResponseInterceptors<T>(result: ApiResult<T>): Promise<ApiResult<T>> {
    let processedResult = result;
    for (const interceptor of this.responseInterceptors) {
      processedResult = await interceptor.onResponse(processedResult) as ApiResult<T>;
    }
    return processedResult;
  }

  private applyResponseErrorInterceptors(error: HttpError): Promise<never> {
    let p: Promise<never> = Promise.reject(error);
    this.responseInterceptors.forEach(interceptor => {
      p = interceptor.onError(error);
    });
    return p;
  }
}


export const httpClient = new HttpClient('http://192.168.213.9:8060');
