//
//  Color+Raw.swift
//  
//
//  Created by Farhad Malekpour on 12/21/23.
//

import Foundation
import SwiftUI

@available(tvOS 16.0, *)
@available(macOS 13.0, *)
@available(iOS 16.0, *)
extension Color : @retroactive RawRepresentable
{
	
	private static var PTB_32: Double = 1431655765.0  // 0x55555555
	private static var PTB_16: Double = 21845.0  // 0x5555
	private static var PTB_8: Double = 255.0

	public init?(rawValue: String) {
		
		let rw = Array(rawValue.trimmingPrefix("@").trimmingPrefix("#"))
		let r: CGFloat
		let g: CGFloat
		let b: CGFloat
		let a: CGFloat

		if rw.count == 32
		{
			r = PT32(String(rw[0..<8]))
			g = PT32(String(rw[8..<16]))
			b = PT32(String(rw[16..<24]))
			a = PT32(String(rw[24..<32]))
		}
		else if rw.count == 16
		{
			r = PT16(String(rw[0..<4]))
			g = PT16(String(rw[4..<8]))
			b = PT16(String(rw[8..<12]))
			a = PT16(String(rw[12..<16]))
		}
		else if rw.count == 12
		{
			r = PT16(String(rw[0..<4]))
			g = PT16(String(rw[4..<8]))
			b = PT16(String(rw[8..<12]))
			a = 1.0
		}
		else if rw.count == 8
		{
			r = PT8(String(rw[0..<2]))
			g = PT8(String(rw[2..<4]))
			b = PT8(String(rw[4..<6]))
			a = PT8(String(rw[6..<8]))
		}
		else if rw.count == 6
		{
			r = PT8(String(rw[0..<2]))
			g = PT8(String(rw[2..<4]))
			b = PT8(String(rw[4..<6]))
			a = 1.0
		}
		else
		{
			return nil
		}
		
		
#if os(macOS)
		self = Color(NSColor(red: r, green: g, blue: b, alpha: a))
		
#else
		self = Color(UIColor(red: r, green: g, blue: b, alpha: a))
#endif

		
		
		func PT32(_ v: String) -> Double
		{
			guard let r = Int(v, radix: 16) else { return 0.0 }
			return (Double(r)/Self.PTB_32)-1.0
		}
		func PT16(_ v: String) -> Double
		{
			guard let r = Int(v, radix: 16) else { return 0.0 }
			return (Double(r)/Self.PTB_16)-1.0
		}
		func PT8(_ v: String) -> Double
		{
			guard let r = Int(v, radix: 16) else { return 0.0 }
			return Double(r)/Self.PTB_8
		}
	}
	
	public var rawValue: String {
		self.rawValue16
	}
	
	
	/// Raw value in 6 digit hex format
	public var rawValue6: String{
		let components = self.fmColorComponentsRGBA()
		
		let value = "#\(cm(components.red))\(cm(components.green))\(cm(components.blue))"
		return value
		
		func cm(_ v: CGFloat) -> String
		{
			String(format: "%0.2X", UInt8(T4.CAP(v, minimum: 0.0, maximum: 1.0)*Self.PTB_8))
		}
	}
	
	/// Raw value in 8 digit hex format
	public var rawValue8: String{
		let components = self.fmColorComponentsRGBA()
		
		let value = "#\(cm(components.red))\(cm(components.green))\(cm(components.blue))\(cm(components.alpha))"
		return value
		
		func cm(_ v: CGFloat) -> String
		{
			String(format: "%0.2X", UInt8(T4.CAP(v, minimum: 0.0, maximum: 1.0)*Self.PTB_8))
		}
	}
	
	/// Raw value in 16 digit hex format
	public var rawValue16: String{
		let components = self.fmColorComponentsRGBA()
		
		let value = "@\(cm(components.red))\(cm(components.green))\(cm(components.blue))\(cm(components.alpha))"
		return value
		
		func cm(_ v: CGFloat) -> String
		{
			String(format: "%0.4X", UInt16(truncatingIfNeeded: Int(Double((v+1.0)*Self.PTB_16))))
		}
	}
	
	/// Raw value in 32 digit hex format
	public var rawValue32: String{
		let components = self.fmColorComponentsRGBA()
		
		let value = "@\(cm(components.red))\(cm(components.green))\(cm(components.blue))\(cm(components.alpha))"
		return value
		
		func cm(_ v: CGFloat) -> String
		{
			String(format: "%0.8X", UInt32(truncatingIfNeeded: Int(Double((v+1.0)*Self.PTB_32))))
		}
	}
	
}

