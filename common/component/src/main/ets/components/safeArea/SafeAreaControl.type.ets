/**
 * 定义安全区域控制空间的接口
 * 该接口用于描述页面或组件的安全区域边距
 * 安全区域是指在某些设备上（如带有刘海或圆角屏幕的设备），应用需要避免使用的区域
 * 通过这个接口，可以获取到应用安全区域的上、下、左、右边距
 */
export interface SafeAreaControlSpace {
  /**
   * 安全区域顶部边距
   */
  top: number;

  /**
   * 安全区域底部边距
   */
  bottom: number;

  /**
   * 安全区域左侧边距
   */
  left: number;

  /**
   * 安全区域右侧边距
   */
  right: number;
}
