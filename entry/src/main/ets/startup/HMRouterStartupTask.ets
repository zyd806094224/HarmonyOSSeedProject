import { HMRouterMgr } from '@hadss/hmrouter'
import { common, StartupTask } from '@kit.AbilityKit'
import { Logger, sdkDebug } from 'component'

/**
 * 路由框架启动任务
 */
@Sendable
export default class HMRouterStartupTask extends StartupTask {
  /**
   * 构造函数
   */
  constructor() {
    super()
  }

  /**
   * 初始化任务
   * @param context 上下文
   * @returns 执行对象
   */
  async init(context: common.AbilityStageContext) {

    Logger.e("zzz","HMRouterStartupTask-init")
    // 路由框架初始化
    HMRouterMgr.init({
      context: context
    })
    // 增加路由日志
    if (sdkDebug) {
      HMRouterMgr.openLog("DEBUG")
    }
  }
}