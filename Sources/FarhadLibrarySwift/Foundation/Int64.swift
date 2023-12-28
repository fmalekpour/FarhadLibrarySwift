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
}
