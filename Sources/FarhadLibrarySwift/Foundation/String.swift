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
	
	@available(iOS 16.0, *)
	func fmBase64EncodedString(options: Data.Base64EncodingOptions = []) -> String?
	{
		self.data(using: .utf8)?.fmBase64EncodedString(options: options)
	}
	
	@available(iOS 16.0, *)
	func fmBase64EncodedData(options: Data.Base64EncodingOptions = []) -> Data?
	{
		self.data(using: .utf8)?.fmBase64EncodedData(options: options)
	}
	
	@available(iOS 16.0, *)
	func fmBase64DecodedString(options: Data.Base64DecodingOptions = []) -> String?
	{
		self.data(using: .utf8)?.fmBase64DecodedString(options: options)
	}

	@available(iOS 16.0, *)
	func fmBase64DecodedData(options: Data.Base64DecodingOptions = []) -> Data?
	{
		self.data(using: .utf8)?.fmBase64DecodedData(options: options)
	}


}
