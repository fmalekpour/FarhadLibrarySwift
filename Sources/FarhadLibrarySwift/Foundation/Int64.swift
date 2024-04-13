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

	
}
