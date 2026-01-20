//
//  File.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 1/20/26.
//

import Foundation

public extension Double{
	
	enum DurationStringMode{
		case auto
		case all
		case normal
	}
	
	func durationString(mode: DurationStringMode = .normal) -> String
	{
		let du = self
		let hours = Int(du) / (60 * 60)
		let minutes = (Int(du) % (60 * 60)) / 60
		let seconds = ((Int(du) % (60 * 60)) % 60)
		let milliSec: Int = min(Int(roundl((du - Double(Int(du))) * 100)), 99)
		switch mode {
			case .auto: // auto
				if hours > 0 {
					return String(format: "%02d:%02d:%02d:%02d", hours, minutes, seconds, milliSec)
				} else if minutes > 0 {
					return String(format: "%02d:%02d:%02d", minutes, seconds, milliSec)
				} else {
					return String(format: "%02d:%02d", seconds, milliSec)
				}
			case .all: // all
				return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, milliSec)
			default: // normal
				return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
		}
	}

	
}
