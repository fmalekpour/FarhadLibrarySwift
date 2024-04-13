//
//  T4.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

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
