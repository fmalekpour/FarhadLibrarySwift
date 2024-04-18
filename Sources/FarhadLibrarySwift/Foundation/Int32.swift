//
//  Int32.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension Int32
{
	init(randomFrom: Int32, to: Int32)
	{
		let rn = Int32(truncatingIfNeeded: UInt32(arc4random())/2)
		self.init(Int32((rn % ((to)-(randomFrom)))+(randomFrom)))
	}
	

}
