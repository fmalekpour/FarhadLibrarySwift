//
//  FMWatch.swift
//
//
//  Created by Farhad Malekpour on 4/12/24.
//

#if os(watchOS)

import Foundation
import WatchKit

enum FMWatchType: UInt {
	case type38mm
	case type42mm
	case type40mm
	case type44mm
	case type41mm
	case type45mm

}

class FMWatch
{
	static func getType() -> FMWatchType
	{
		let w: CGFloat = WKInterfaceDevice.current().screenBounds.width
		
		if(w==136)	{	return .type38mm;	}
		if(w==156)	{	return .type42mm;	}
		if(w==162)	{	return .type40mm;	}
		if(w==184)	{	return .type44mm;	}
		if(w==176)	{	return .type41mm;	}
		if(w==198)	{	return .type45mm;	}
		
		return .type38mm;
	}
}

#endif
