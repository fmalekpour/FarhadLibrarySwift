//
//  Data.swift
//
//
//  Created by Farhad Malekpour on 1/4/24.
//

import Foundation

public extension Data
{
	
	@available(iOS 16.0, *)
	@available(macOS 13.0, *)
	func fmBase64EncodedString(options: Base64EncodingOptions = []) -> String?
	{
		var res = self.base64EncodedString(options: options)
		res.replace("+", with: "_P")
		res.replace("/", with: "_S")
		res.replace("=", with: "_E")
		return res
	}

	@available(iOS 16.0, *)
	@available(macOS 13.0, *)
	func fmBase64EncodedData(options: Base64EncodingOptions = []) -> Data?
	{
		self.fmBase64EncodedString(options: options)?.data(using: .utf8)
	}

	@available(iOS 16.0, *)
	@available(macOS 13.0, *)
	func fmBase64DecodedString(options: Base64DecodingOptions = []) -> String?
	{
		if let data = self.fmBase64DecodedData(options: options)
		{
			return String(data: data, encoding: .utf8)
		}
		return nil
	}
	
	@available(iOS 16.0, *)
	@available(macOS 13.0, *)
	func fmBase64DecodedData(options: Base64DecodingOptions = []) -> Data?
	{
		if let string = String(data: self, encoding: .utf8)
		{
			let encoded = string
				.replacing("_P", with: "+")
				.replacing("_S", with: "/")
				.replacing("_E", with: "=")
			return Data(base64Encoded: encoded, options: options)
		}
		return nil
	}
	
}

