export namespace SkeletonUtils {
  /**
   * 根据 progress 计算渐变颜色和位置
   * @param startColors 起始颜色和位置数组
   * @param endColors 结束颜色和位置数组
   * @param progress 动画进度，范围 [0, 1]
   * @returns 计算后的颜色和位置数组
   */
  export function interpolateColors(
    startColors: [string, number][],
    endColors: [string, number][],
    progress: number
  ): [string, number][] {
    if (startColors.length !== endColors.length) {
      throw new Error("startColors and endColors must have the same length");
    }

    if (progress < 0 || progress > 1) {
      throw new Error("progress must be within the range [0, 1]");
    }

    return startColors.map((value, index) => {
      const startColor = value[0];
      const startPosition = value[1];
      const endColor = endColors[index][0];
      const endPosition = endColors[index][1];
      const interpolatedPosition = startPosition + (endPosition - startPosition) * progress;
      const interpolatedColor = interpolateHexColor(startColor, endColor, progress);
      return [interpolatedColor, interpolatedPosition];
    });
  }

  /**
   * 计算两个十六进制颜色之间的过渡颜色
   * @param startHex 起始颜色
   * @param endHex 结束颜色
   * @param progress 动画进度
   * @returns 过渡颜色的十六进制值
   */
  function interpolateHexColor(startHex: string, endHex: string, progress: number): string {
    try {
      const startRGB = hexToRGB(startHex);
      const endRGB = hexToRGB(endHex);
      const interpolatedRGB = startRGB.map((start, index) =>
      Math.floor(start + (endRGB[index] - start) * progress)
      );
      return rgbToHex(interpolatedRGB[0], interpolatedRGB[1], interpolatedRGB[2]);
    } catch (error) {
      console.error("Invalid color input:", error);
      return "#000000"; // 默认返回黑色
    }
  }

  /**
   * 将十六进制颜色转换为 RGB 数组
   * @param hex 十六进制颜色值
   * @returns RGB 数组
   */
  function hexToRGB(hex: string): number[] {
    if (!/^[#][0-9A-Fa-f]{6}$/.test(hex)) {
      throw new Error("Invalid hex color format");
    }
    const bigint = parseInt(hex.slice(1), 16);
    return [(bigint >> 16) & 255, (bigint >> 8) & 255, bigint & 255];
  }

  /**
   * 将 RGB 数组转换为十六进制颜色值
   * @param r 红色值 (0-255)
   * @param g 绿色值 (0-255)
   * @param b 蓝色值 (0-255)
   * @returns 十六进制颜色值
   */
  function rgbToHex(r: number, g: number, b: number): string {
    if (r < 0 || r > 255 || g < 0 || g > 255 || b < 0 || b > 255) {
      throw new Error("Invalid RGB values");
    }
    return `#${((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)}`;
  }
}
