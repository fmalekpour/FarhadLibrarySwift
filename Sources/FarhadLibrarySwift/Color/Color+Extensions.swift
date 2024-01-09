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
	
	struct ColorComponents {
		var red: CGFloat
		var green: CGFloat
		var blue: CGFloat
		var alpha: CGFloat
	}

	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	func fmColorComponents() -> ColorComponents
	{
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
#if os(macOS)
		NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
#else
		UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
#endif

		return ColorComponents(red: r, green: g, blue: b, alpha: a)
	}

	
}

extension ShapeStyle where Self == Color
{
	public static var faRandom: Color { Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
}
