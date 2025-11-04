import { StartupConfig, StartupConfigEntry, StartupListener } from "@kit.AbilityKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { Logger } from "component";

const TAG: string = "SeedStartupConfig"

/**
 * 冷启动任务列表参数配置
 */
export default class SeedStartupConfig extends StartupConfigEntry {

  /**
   * @returns 启动任务参数配置
   */
  onConfig(): StartupConfig {
    Logger.i(TAG, 'onConfig')
    // 启动完成回调
    let onCompleteCallback = (error: BusinessError<void>) => {
      Logger.i(TAG, 'onCompletedCallback');
      if (error) {
        Logger.i(TAG, 'errorCode=' + error.code + ', msg=' + error.message);
      } else {
        Logger.i(TAG, 'onCompletedCallback: success');
      }
    }
    let startupListener: StartupListener = {
      'onCompleted': onCompleteCallback
    }
    let config: StartupConfig = {
      'timeoutMs': 10000, // 10s超时时间
      'startupListener': startupListener // 启动监听对象
    }
    return config;
  }
}