//
//  Color+Extensions.swift
//
//
//  Created by Farhad Malekpour on 12/21/23.
//

import Foundation
import SwiftUI

public extension Color
{
	static var faRandom: Color { Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
	
	struct ColorComponentsRGBA {
		public var red: CGFloat
		public var green: CGFloat
		public var blue: CGFloat
		public var alpha: CGFloat
	}
	
	struct ColorComponentsHSBA {
		public var hue: CGFloat
		public var saturation: CGFloat
		public var brightness: CGFloat
		public var alpha: CGFloat
	}
	
	@available(tvOS 14.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	func fmColorComponentsRGBA() -> ColorComponentsRGBA
	{
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
#if os(macOS)
		NSColor(self).usingColorSpace(.sRGB)?.getRed(&r, green: &g, blue: &b, alpha: &a)
#else
		UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
#endif

		return ColorComponentsRGBA(red: r, green: g, blue: b, alpha: a)
	}

	@available(tvOS 14.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	func fmColorComponentsHSBA() -> ColorComponentsHSBA
	{
		var h: CGFloat = 0
		var s: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
#if os(macOS)
		NSColor(self).usingColorSpace(.sRGB)?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
#else
		UIColor(self).getHue(&h, saturation: &s, brightness: &b, alpha: &a)
#endif
		
		return ColorComponentsHSBA(hue: h, saturation: s, brightness: b, alpha: a)
	}
	

	
	
	
	@available(tvOS 14.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	@available(*, deprecated, message: "Use fmColorComponentsRGBA()")
	func fmColorComponents() -> ColorComponentsRGBA
	{
		self.fmColorComponentsRGBA()
	}
	
}

extension ShapeStyle where Self == Color
{
	public static var faRandom: Color { Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
}
