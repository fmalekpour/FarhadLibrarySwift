//
//  Int64.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension Int64
{
	init(randomFrom: Int64, to: Int64)
	{
		let rn = Int64(arc4random())
		self.init(Int64((rn % ((to)-(randomFrom)))+(randomFrom)))
	}
	
	static func UnixTimeStamp() -> Int64
	{
		Int64(Date().timeIntervalSince1970)
	}
	
	func fm_setBit(_ position: Int64) -> Int64 {
		return self | 1 << position
	}
	
	func fm_clearBit(_ position: Int64) -> Int64 {
		return self & ~(1 << position)
	}
	
	func fm_isBitSet(_ position: Int64) -> Bool {
		return (self & (1 << position)) == (1 << position)
	}
	
	mutating func fm_bit(_ position: Int64,_ value: Bool)
	{
		if value
		{
			self = self.fm_setBit(position)
		}
		else
		{
			self = self.fm_clearBit(position)
		}
	}

	enum SizeStringMode{
		case auto
		case GB
		case MB
		case KB
	}
	
	func sizeString(mode: SizeStringMode = .auto) -> String
	{
		let size = self
		switch mode {
			case .auto:
				if size<1024
				{ return String(format: "%lldB",size) }
				else if size<1024*1024
				{ return String(format: "%.2fKB",(Double(size)/1024.0)) }
				else if size<1024*1024*1024
				{ return String(format: "%.2fMB",(Double(size)/1024.0/1024.0)) }
				else
				{ return String(format: "%.2fGB",(Double(size)/1024.0/1024.0/1024.0)) }
			case .GB:
				return String(format: "%.2fGB",(Double(size)/1024.0/1024.0/1024.0))
			case .MB:
				return String(format: "%.2fMB",(Double(size)/1024.0/1024.0))
			case .KB:
				return String(format: "%.2fKB",(Double(size)/1024.0))
		}
	}

	
}
