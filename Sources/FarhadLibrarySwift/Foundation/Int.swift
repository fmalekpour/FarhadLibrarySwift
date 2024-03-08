//
//  Int.swift
//
//
//  Created by Farhad Malekpour on 3/8/24.
//

import Foundation

public extension Int
{
	init?(_ value: Any) {
		self.init("\(value)")
	}
}
