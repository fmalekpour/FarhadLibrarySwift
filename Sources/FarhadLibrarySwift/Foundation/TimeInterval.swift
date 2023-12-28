//
//  TimeInterval.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension TimeInterval
{
	static func UnixTimeStamp() -> TimeInterval
	{
		Date().timeIntervalSince1970
	}
}
