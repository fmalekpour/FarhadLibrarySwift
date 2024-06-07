//
//  File.swift
//  
//
//  Created by Farhad Malekpour on 6/6/24.
//

import Foundation

public extension UInt64
{
	func fm_setBit(_ position: UInt8) -> UInt64 {
		return self | 1 << position
	}
	
	func fm_clearBit(_ position: UInt8) -> UInt64 {
		return self & ~(1 << position)
	}
	
	func fm_isBitSet(_ position: UInt8) -> Bool {
		return (self & (1 << position)) == (1 << position)
	}
	
	mutating func fm_bit(_ position: UInt8,_ value: Bool)
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
