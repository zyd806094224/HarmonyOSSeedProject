import { window } from '@kit.ArkUI';
import { AnyType } from '../AnyType';

/**
 * 工具类，提供窗口相关的操作方法。
 */
export namespace WindowUtils {
  /**
   * 获取当前窗口。
   * @returns 返回一个 Promise，解析为窗口对象。
   */
  export const getWindowStage: () => Promise<window.Window> = () => {
    return window.getLastWindow(getContext());
  }

  /**
   * 设置窗口的状态栏属性。
   * @param options 状态栏属性配置。
   * @returns 返回一个 Promise，解析为操作结果。
   */
  export const setStatusBar: (options: window.SystemBarProperties) => Promise<AnyType> = (options) => {
    return new Promise((resolve, reject) => {
      getWindowStage().then(res => {
        res.setWindowSystemBarProperties(options).then(r => resolve(r)).catch((err: AnyType) => reject(err));
      }).catch((err: AnyType) => reject(err));
    });
  }

  /**
   * 设置窗口是否全屏。
   * @param isFullScreen 是否全屏。
   * @returns 返回一个 Promise，解析为操作结果。
   */
  export const setWindowLayoutFullScreen: (isFullScreen: boolean) => Promise<AnyType> = (isFullScreen) => {
    return new Promise((resolve, reject) => {
      getWindowStage().then(res => {
        res.setWindowLayoutFullScreen(isFullScreen).then(r => resolve(r)).catch((err: AnyType) => reject(err));
      }).catch((err: AnyType) => reject(err));
    });
  }

  /**
   * 获取窗口属性。
   * @returns 返回一个 Promise，解析为窗口属性对象。
   */
  export const getWindowProperties: () => Promise<window.WindowProperties> = () => {
    return new Promise((resolve, reject) => {
      getWindowStage().then(res => {
        resolve(res.getWindowProperties());
      }).catch((err: AnyType) => reject(err));
    });
  }

  /**
   * 获取窗口的避免区域。
   * @param type 避免区域类型，默认为系统类型。
   * @returns 返回一个 Promise，解析为避免区域对象。
   */
  export const getWindowAvoidArea: (type?: window.AvoidAreaType) => Promise<window.AvoidArea> = (type = window.AvoidAreaType.TYPE_SYSTEM) => {
    return new Promise((resolve, reject) => {
      getWindowStage().then(res => {
        resolve(res.getWindowAvoidArea(type));
      }).catch((err: AnyType) => reject(err));
    });
  }

  /**
   * 获取窗口的 UI 上下文。
   * @returns 返回一个 Promise，解析为 UI 上下文对象。
   */
  export const getUIContext: () => Promise<UIContext> = () => {
    return new Promise((resolve, reject) => {
      getWindowStage().then(res => {
        resolve(res.getUIContext());
      }).catch((err: AnyType) => reject(err));
    });
  }
}
