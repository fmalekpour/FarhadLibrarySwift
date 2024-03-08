//
//  String+URLQuery.swift
//
//
//  Created by Farhad Malekpour on 3/8/24.
//

import Foundation

public extension String
{
	@available(tvOS 16.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	
	func fmParseQueryString() -> [String: Any]
	{
		var RV: [String: Any] = [:]
		var bs = self
		
		if let index = bs.firstIndex(of: "?")
		{
			let qml = bs.index(after: index)
			bs = String(bs[qml...])
		}
		
		if let index = bs.firstIndex(of: "#")
		{
			bs = String(bs[..<index])
		}
		
		bs = bs.replacing("?", with: "&")
		bs = bs.replacing("#", with: "&")

		let comps = bs.split(separator: "&")
		for part in comps
		{
			var p = String(part).fmTrim()
			guard !p.isEmpty else { continue }
			let m = p.split(separator: ":")
			if m.count > 1
			{
				RV[String(m[0]).fmTrim()] = String(m[1]).fmTrim()
			}
		}
		
		return RV
	}

}
