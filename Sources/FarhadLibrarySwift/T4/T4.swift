//
//  T4.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

#if os(iOS)
#warning("Build for iOS")
#elseif os(watchOS)
#warning("Build for WatchOS")
#elseif os(tvOS)
#warning("Build for tvOS")
#elseif os(macOS)
#warning("Build for macOS")
#endif



public class T4 {
	public static var lastError: Error? {
		didSet{
			if T4.shouldLogLastError, let er = T4.lastError
			{
				T4.NSLog("\(er)")
			}
		}
	}
	public static var shouldLogLastError: Bool = false

	
}
