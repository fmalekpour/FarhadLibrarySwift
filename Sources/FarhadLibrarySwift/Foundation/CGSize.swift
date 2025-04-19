//
//  CGSize.swift
//
//
//  Created by Farhad Malekpour on 4/1/24.
//

import Foundation

extension CGSize: @retroactive RawRepresentable
{
	public init?(rawValue: String) {
		let parts = rawValue.replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "").split(separator: ",")
		if parts.count == 2
		{
			self.init(width: Double(String(parts[0])) ?? 0.0, height: Double(String(parts[1])) ?? 0.0)
		}
		else
		{
			return nil
		}
	}
	
	public var rawValue: String {
		return "{\(self.width),\(self.height)}"
	}
	
	public typealias RawValue = String
	
	
}
