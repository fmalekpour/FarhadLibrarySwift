//
//  Color+Raw.swift
//  
//
//  Created by Farhad Malekpour on 12/21/23.
//

import Foundation
import SwiftUI

@available(macOS 13.0, *)
@available(iOS 16.0, *)
extension Color : RawRepresentable
{
	public init?(rawValue: String) {
		
		let rw = Array(rawValue.trimmingPrefix("@").trimmingPrefix("#"))
		
		if rw.count == 16
		{
			self = Color(.sRGB,
						 red: PT16(String(rw[0..<4])),
						 green: PT16(String(rw[4..<8])),
						 blue: PT16(String(rw[8..<12])),
						 opacity: PT16(String(rw[12..<16])))
		}
		else if rw.count == 8
		{
			self = Color(.sRGB,
						 red: PT8(String(rw[0..<2])),
						 green: PT8(String(rw[2..<4])),
						 blue: PT8(String(rw[4..<6])),
						 opacity: PT8(String(rw[6..<8])))
		}
		else if rw.count == 6
		{
			self = Color(.sRGB,
						 red: PT8(String(rw[0..<2])),
						 green: PT8(String(rw[2..<4])),
						 blue: PT8(String(rw[4..<6])),
						 opacity: 1.0)
		}
		else
		{
			return nil
		}
		
		func PT16(_ v: String) -> Double
		{
			guard let r = Int(v, radix: 16) else { return 0.0 }
			return (Double(r)/21845.0)-1.0
		}
		func PT8(_ v: String) -> Double
		{
			guard let r = Int(v, radix: 16) else { return 0.0 }
			return Double(r)/255.0
		}
	}
	
	public var rawValue: String {
		var r: CGFloat = 0
		var g: CGFloat = 0
		var b: CGFloat = 0
		var a: CGFloat = 0
		
#if os(macOS)
		NSColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
#else
		UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
#endif
		
		
		
		let value = "@\(cm(r))\(cm(g))\(cm(b))\(cm(a))"
		return value
		
		func cm(_ v: CGFloat) -> String
		{
			String(format: "%0.4X", UInt16(truncatingIfNeeded: Int(Double((v+1.0)*21845.0))))
		}
		
	}
}

