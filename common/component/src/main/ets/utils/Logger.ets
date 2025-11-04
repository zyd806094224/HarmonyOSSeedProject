import hilog from '@ohos.hilog'

/**
 * 统一的日志打印
 */
export class Logger {
  /**
   * 是否是debug模式
   */
  static isDebug = true
  /**
   * 域
   */
  private static DOMAIN = 0x1111

  /**
   * info级别日志
   * @param tag 标签
   * @param msg 日志信息
   */
  static i(tag: string, msg: string) {
    if (Logger.isDebug) {
      hilog.info(Logger.DOMAIN, tag, msg)
    }
  }

  /**
   * error级别日志
   * @param tag 标签
   * @param msg 日志信息
   */
  static e(tag: string, msg: string) {
    if (Logger.isDebug) {
      hilog.error(Logger.DOMAIN, tag, msg)
    }
  }

  /**
   * warning级别日志
   * @param tag 标签
   * @param msg 日志信息
   */
  static w(tag: string, msg: string) {
    if (Logger.isDebug) {
      hilog.warn(Logger.DOMAIN, tag, msg)
    }
  }
}