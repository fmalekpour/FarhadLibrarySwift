//
//  FilePath.swift
//
//
//  Created by Farhad Malekpour on 12/28/23.
//

import Foundation

public extension T4
{
	static func DOCUMENTS_PATH(_ path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func LIBRARY_PATH(_ path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func CACHES_PATH(_ path: String) -> String?
	{
		guard let st1 = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func BUNDLE_PATH(_ path: String) -> String
	{
		let st1 = Bundle.main.bundlePath
		return String(NSString(string: st1).appendingPathComponent(path))
	}
	
	static func APPLICATION_SUPPORT_PATH(_ path: String) -> String?
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

#if os(macOS)
	static func DOCUMENTS_URL(_ path: String) -> URL?
	{
		T4.Path2Url(T4.DOCUMENTS_PATH(path))
	}
#else
	@available(tvOS 16.0, *)
	@available(iOS 16.0, *)
	static func DOCUMENTS_URL(_ path: String) -> URL
	{
		URL.documentsDirectory.appending(path: path)
	}
#endif

#if os(macOS)
	static func LIBRARY_URL(_ path: String) -> URL?
	{
		T4.Path2Url(T4.LIBRARY_PATH(path))
	}
#else
	@available(tvOS 16.0, *)
	@available(iOS 16.0, *)
	static func LIBRARY_URL(_ path: String) -> URL
	{
		URL.libraryDirectory.appending(path: path)
	}
#endif

#if os(macOS)
	static func CACHES_URL(_ path: String) -> URL?
	{
		T4.Path2Url(T4.CACHES_PATH(path))
	}
#else
	@available(tvOS 16.0, *)
	@available(iOS 16.0, *)
	static func CACHES_URL(_ path: String) -> URL
	{
		URL.cachesDirectory.appending(path: path)
	}
#endif
	
	static func BUNDLE_URL(_ path: String) -> URL?
	{
		T4.Path2Url(T4.BUNDLE_PATH(path))
	}
	
	static func APPLICATION_SUPPORT_URL(_ path: String) -> URL?
	{
		T4.Path2Url(T4.APPLICATION_SUPPORT_PATH(path))
	}
	
	static func SHARED_GROUP_URL(container: String, path: String) -> URL?
	{
		T4.Path2Url(T4.SHARED_GROUP_PATH(container: container, path: path))
	}
	

	
	
	private static func Path2Url(_ path: String?) -> URL?
	{
		if let path
		{
			#if os(iOS) || os(watchOS)
			if #available(iOS 16.0, *) {
				return URL(filePath: path)
			} else {
				return URL(fileURLWithPath: path)
			}
			#elseif os(macOS)
			if #available(macOS 13.0, *) {
				return URL(filePath: path)
			} else {
				return URL(fileURLWithPath: path)
			}
			#endif
		}
		return nil
	}
}
