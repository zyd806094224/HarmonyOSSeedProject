/**
 * 标签栏项目属性类，用于封装标签栏项目的区域信息和矩形位置。
 *
 * 该类接收一个`Area`对象作为参数，并初始化其内部的区域信息和矩形位置。
 * 矩形位置通过解析`Area`对象中的`position`、`width`和`height`属性来设置，默认值为0。
 */
export class _TabBarItemAttribute {
  /**
   * 区域信息对象，包含标签栏项目的布局信息。
   */
  private area: Area;
  /**
   * 只读属性，表示标签栏项目的矩形位置。
   */
  private rect: _AreaRect;

  /**
   * 构造函数，用于初始化`_TabBarItemAttribute`实例。
   *
   * @param area 包含标签栏项目布局信息的区域对象。
   */
  constructor(area: Area) {
    this.area = area;
    // 初始化rect属性，解析area中的位置和尺寸信息
    let left = area.position?.x != undefined ? Number(area.position.x).valueOf() : 0;
    let right = area.position?.y != undefined ? Number(area.position.y).valueOf() : 0;
    let width = area.width != undefined ? Number(area.width).valueOf() : 0;
    let height = area.height != undefined ? Number(area.height).valueOf() : 0;
    this.rect = {
      left: left,
      top: right,
      width: width,
      height: height,
      centerX: left + width / 2,
      centerY: right + height / 2,
      right: left + width,
      bottom: right + height
    };
  }

  /**
   * 获取标签栏项目的最小X坐标。
   */
  get minX(): number {
    return this.rect.left;
  }

  /**
   * 获取标签栏项目的最小Y坐标。
   */
  get minY(): number {
    return this.rect.top;
  }

  /**
   * 获取标签栏项目的中心X坐标。
   */
  get midX(): number {
    return this.rect.centerX;
  }

  /**
   * 获取标签栏项目的中心Y坐标。
   */
  get midY(): number {
    return this.rect.centerY;
  }


  /**
   * 获取标签栏项目的最大X坐标。
   */
  get maxX(): number {
    return this.rect.right;
  }

  /**
   * 获取标签栏项目的最大Y坐标。
   */
  get maxY(): number {
    return this.rect.bottom;
  }

  /**
   * 获取标签栏项目的宽度。
   */
  get width(): number {
    return this.rect.width;
  }

  /**
   * 获取标签栏项目的高度。
   */
  get height(): number {
    return this.rect.height;
  }
}

/**
 * 描述标签栏项目的矩形位置接口。
 */
interface _AreaRect {
  /**
   * 矩形的X坐标。
   */
  left: number;

  /**
   * 矩形的Y坐标。
   */
  top: number;

  /**
   * 矩形的宽度。
   */
  width: number;

  /**
   * 矩形的高度。
   */
  height: number;

  /**
   * 矩形的中心点的X坐标。
   */
  centerX: number;

  /**
   * 矩形的中心点的Y坐标。
   */
  centerY: number;

  /**
   * 矩形的右边的X坐标。
   */
  right: number;

  /**
   * 矩形的底边的Y坐标。
   */
  bottom: number;
}
