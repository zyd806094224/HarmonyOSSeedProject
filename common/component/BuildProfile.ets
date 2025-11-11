/**
 * Use these variables when you tailor your ArkTS code. They must be of the const type.
 */
export const HAR_VERSION = '1.0.0';
export const BUILD_MODE_NAME = 'release';
export const DEBUG = false;
export const TARGET_NAME = 'default';
export const apiDebug = false;
export const sdkDebug = false;

/**
 * BuildProfile Class is used only for compatibility purposes.
 */
export default class BuildProfile { 
	static readonly HAR_VERSION = HAR_VERSION;
	static readonly BUILD_MODE_NAME = BUILD_MODE_NAME;
	static readonly DEBUG = DEBUG;
	static readonly TARGET_NAME = TARGET_NAME;
	static readonly apiDebug = apiDebug;
	static readonly sdkDebug = sdkDebug;
}