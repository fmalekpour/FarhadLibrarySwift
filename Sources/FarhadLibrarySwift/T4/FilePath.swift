//
//  FilePath.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension T4
{
	static func DOCUMENTS_PATH(path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func LIBRARY_PATH(path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func CACHES_PATH(path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func BUNDLE_PATH(path: String) -> String
	{
		let st1 = Bundle.main.bundlePath
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func APPLICATION_SUPPORT_PATH(path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func SHARED_GROUP_PATH(container: String, path: String) -> String?
	{
		if let c = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: container)
		{
			return c.appendingPathComponent(path).path
		}
		return nil
	}

	
}
