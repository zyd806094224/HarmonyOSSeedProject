export namespace CanvasUtil {

  /**
   * 计算画布宽度
   * @param value - 输入的数值
   * @returns 计算后的画布宽度
   */
  export function getWidth(value: number): number {
    return value / 3 * 4;
  }

  /**
   * 初始化卫星画布
   * @param canvas - 画布渲染上下文
   * @param height - 画布的高度
   * @param color - 画布的颜色，可以是颜色值或资源路径
   * @throws {Error} 如果直径不是正数，则抛出错误
   */
  export function initSatelliteCanvas(canvas: CanvasRenderingContext2D, height: number, color: number | string): void {
    if (height <= 0) {
      throw new Error('Diameter must be a positive number');
    }
    canvas.strokeStyle = color;
    canvas.fillStyle = color;
    canvas.lineWidth = height / 60 + 1;
  }

  /**
   * 绘制卫星画布
   * @param canvas - 画布渲染上下文
   * @param height - 画布的高度
   * @param dragPercent - 拖动百分比，范围在0到1之间
   * @throws {Error} 如果直径不是正数，则抛出错误
   * @throws {Error} 如果拖动百分比不在0到1之间，则抛出错误
   */
  export function drawSatelliteCanvas(canvas: CanvasRenderingContext2D, height: number, dragPercent: number): void {
    if (height <= 0) {
      throw new Error('Diameter must be a positive number');
    }
    if (dragPercent < 0 || dragPercent > 1) {
      throw new Error('Drag percent must be between 0 and 1');
    }
    const ringOx = height / 2; // 圆心x坐标
    const ringOy = getWidth(height) / 2; // 圆心y坐标
    const ringRadius = height / 4; // 半径
    const point1x = ringOx + ringRadius * Math.cos(Math.PI * 150 / 180); // 计算点1的x坐标
    const point1y = ringOy + ringRadius * Math.sin(Math.PI * 150 / 180); // 计算点1的y坐标
    const point2x = ringOx + ringRadius * Math.cos(Math.PI * -30 / 180); // 计算点2的x坐标
    const point2y = ringOy + ringRadius * Math.sin(Math.PI * -30 / 180); // 计算点2的y坐标

    canvas.clearRect(0, 0, height, height);
    // 绘制圆环
    canvas.beginPath();
    canvas.arc(ringOx, ringOy, ringRadius, 0, Math.PI * 2);
    canvas.stroke();
    // 绘制卫星
    dragPercent = Math.min(dragPercent, 0.75); // 限制dragPercent最大值为0.75
    canvas.beginPath();
    canvas.arc(
      dragPercent * (point2x - point1x) + point1x,
      dragPercent * (point2y - point1y) + point1y,
      height / 20 + 1, 0, Math.PI * 2);
    canvas.fill();
  }
}
