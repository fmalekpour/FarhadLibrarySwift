//
//  T4+Screen.swift
//
//
//  Created by Farhad Malekpour on 4/12/24.
//

import Foundation

#if os(watchOS)
import WatchKit
#elseif os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS)
import UIKit
#endif


public extension T4
{
	var SCALE_FACTOR: CGFloat {
		#if os(watchOS)
		return WKInterfaceDevice.current().screenScale
		#elseif os(macOS)
		return 1.0
		#else
		return UIScreen.main.nativeScale
		#endif
	}
	
	var SCALE_FACTOR_PHYSICAL: CGFloat {
		#if os(watchOS)
		return WKInterfaceDevice.current().screenScale
		#elseif os(macOS)
		return 1.0
		#else
		return UIScreen.main.scale
		#endif
	}
	
	var L4A_SCREEN_BOUNDS: CGRect {
		#if os(watchOS)
		return WKInterfaceDevice.current().screenScale
		#elseif os(tvOS)
		return UIScreen.main.bounds
		#elseif os(macOS)
		return NSScreen.main?.frame ?? .zero
		#else
		return UIScreen.main.bounds
		#endif
	}

	/*
	#define L4A_SCALE_FACTOR				FMScreenScale()
	#define L4A_SCALE_FACTOR_PHYSICAL		FMScreenPhysicalScale()
	#define L4A_SCREEN_BOUNDS				FMScreenBounds()
*/
}
