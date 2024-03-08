//
//  Color+Codable.swift
//  
//
//  Created by Farhad Malekpour on 12/21/23.
//

import Foundation
import SwiftUI


@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
extension Color: Codable
{
	private enum CodingKeys: String, CodingKey{
		case mHex = "hex"
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(self.rawValue, forKey: .mHex)
	}
	
	public init(from decoder: Decoder) throws {
		self.init(.clear)
		
		let values = try decoder.container(keyedBy: CodingKeys.self)
		if let colorStr = try values.decodeIfPresent(String.self, forKey: .mHex)
		{
			if let c = Color(rawValue: colorStr)
			{
				self.init(c)
			}
		}
		else
		{
			self.init(.clear)
		}
	}
}
