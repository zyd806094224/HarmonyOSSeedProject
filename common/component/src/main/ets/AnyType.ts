/**
 * 定义一个类型别名 `AnyType`，表示可以是任意类型的值。
 */
export type AnyType = any;

/**
 * 定义一个类型别名 `AnyObject`，表示键为字符串、值为任意类型的对象。
 */
export type AnyObject = { [key: string]: any };

/**
 * 定义一个泛型类型别名 `AnyObjectValue`，表示键为字符串、值为指定类型 `T` 的对象。
 * 
 * @typeParam T - 对象中每个属性的值类型。
 */
export type AnyObjectValue<T> = { [key: string]: T };
