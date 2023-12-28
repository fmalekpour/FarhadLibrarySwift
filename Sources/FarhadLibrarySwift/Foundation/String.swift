//
//  String.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension String
{
	init(randomLength: Int, allowdCharacters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	{
		let s = "\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)"
			.shuffled()
			.prefix(randomLength)
		
		self.init(s)
	}
}
