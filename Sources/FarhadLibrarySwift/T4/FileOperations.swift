//
//  FileOperations.swift
//
//
//  Created by Farhad Malekpour on 2/21/24.
//

import Foundation

public extension T4
{
	static func FILE_SIZE(_ filePath: String) -> Int64
	{
		do {
			let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
			return fileAttributes[.size] as? Int64 ?? Int64(0)
		} catch {
		}
		return Int64(0)
	}
	
	static func FILE_EXISTS(_ filePath: String) -> Bool {
		return FileManager.default.fileExists(atPath: filePath)
	}
	
	static func FILE_IS_DIRECTORY(_ filePath: String) -> Bool {
		var isDir: ObjCBool = true
		let exists = FileManager.default.fileExists(atPath: filePath, isDirectory: &isDir)
		return exists && isDir.boolValue
	}
	
	static func FILE_MTIME(_ filePath: String) -> TimeInterval {
		do {
			let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
			let date = fileAttributes[.modificationDate] as? Date
			return date?.timeIntervalSince1970 ?? TimeInterval(0)
		} catch {
		}
		return TimeInterval(0)
	}
	
	static func FILE_CTIME(_ filePath: String) -> TimeInterval {
		do {
			let fileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
			let date = fileAttributes[.creationDate] as? Date
			return date?.timeIntervalSince1970 ?? TimeInterval(0)
		} catch {
		}
		return TimeInterval(0)
	}
	
	@discardableResult
	static func FILE_SET_MTIME(_ filePath: String, timeStamp: TimeInterval) -> Bool {
		do {
			try FileManager.default.setAttributes([.modificationDate : Date(timeIntervalSince1970: timeStamp)], ofItemAtPath: filePath)
			return true
		} catch {}
		return false

	}
	
	@discardableResult
	static func FILE_SET_CTIME(_ filePath: String, timeStamp: TimeInterval) -> Bool {
		do {
			try FileManager.default.setAttributes([.creationDate : Date(timeIntervalSince1970: timeStamp)], ofItemAtPath: filePath)
			return true
		} catch {}
		return false
	}
	
	@discardableResult
	static func FILE_COPY(fromPath: String, toPath: String, overrite: Bool) -> Bool
	{
		do {
			
			if T4.FILE_EXISTS(toPath)
			{
				if(overrite)
				{
					try FileManager.default.removeItem(atPath: toPath)
				}
				else
				{
					return false
				}
			}
			
			try FileManager.default.copyItem(atPath: fromPath, toPath: toPath)
			
			return true
		} catch {
			NSLog("File Copy Error: \(error)")
			return false
		}
	}
	
	@discardableResult
	static func FILE_MOVE(fromPath: String, toPath: String, overrite: Bool) -> Bool
	{
		do {
			
			if T4.FILE_EXISTS(toPath)
			{
				if(overrite)
				{
					try FileManager.default.removeItem(atPath: toPath)
				}
				else
				{
					return false
				}
			}
			
			try FileManager.default.moveItem(atPath: fromPath, toPath: toPath)
			
			return true
		} catch {
			NSLog("File Move Error: \(error)")
			return false
		}
	}
	
	@discardableResult
	static func FILE_DELETE(_ filePath: String) -> Bool
	{
		do {
			if T4.FILE_EXISTS(filePath)
			{
				try FileManager.default.removeItem(atPath: filePath)
			}
			return true
		} catch {
			NSLog("File Delete Error: \(error)")
			return false
		}
	}

}


public extension URL
{
	/// Get and set File Modification time
	var FILE_MTIME: Date {
		get{
			guard self.isFileURL else { return Date(timeIntervalSince1970: 0) }
			if let rs = try? self.resourceValues(forKeys: [.contentModificationDateKey]), let rv = rs.contentModificationDate
			{
				return rv
			}
			return Date(timeIntervalSince1970: 0)
		}
		set(v){
			guard self.isFileURL else { return }
			var rs = URLResourceValues()
			rs.contentModificationDate = v
			try? self.setResourceValues(rs)
		}
	}
	
	/// Get and set File Creation time
	var FILE_CTIME: Date {
		get{
			guard self.isFileURL else { return Date(timeIntervalSince1970: 0) }
			if let rs = try? self.resourceValues(forKeys: [.creationDateKey]), let rv = rs.creationDate
			{
				return rv
			}
			return Date(timeIntervalSince1970: 0)
		}
		set(v){
			guard self.isFileURL else { return }
			var rs = URLResourceValues()
			rs.creationDate = v
			try? self.setResourceValues(rs)
		}
	}
	
	/// Get File size
	var FILE_SIZE: Int {
		get{
			guard self.isFileURL else { return 0 }
			if let rs = try? self.resourceValues(forKeys: [.fileSizeKey]), let rv = rs.fileSize
			{
				return rv
			}
			return 0
		}
	}
	
	/// Returns true if file exists
	var FILE_EXISTS: Bool {
		get{
			guard self.isFileURL else { return false }
			if let rs = try? self.checkResourceIsReachable()
			{
				return rs
			}
			return false
		}
	}
	
	/// Returns true if file is a directory
	var FILE_IS_DIRECTORY: Bool {
		get{
			guard self.isFileURL else { return false }
			
			if let rs = try? self.resourceValues(forKeys: [.isDirectoryKey]), let rv = rs.isDirectory
			{
				return rv
			}
			return false
		}
	}
	
	@discardableResult
	func FILE_DELETE() -> Bool
	{
		guard self.isFileURL else { return false }
		var rv: Bool = false
		do{
			try FileManager.default.removeItem(at: self)
			rv = true
		}
		catch{
			print("FILE_DELETE Error: \(error)")
		}
		return rv
	}
	
	@available(watchOS, unavailable)
	@discardableResult
	func FILE_TRASH() -> Bool
	{
		guard self.isFileURL else { return false }
		var rv: Bool = false
		do{
			try FileManager.default.trashItem(at: self, resultingItemURL: nil)
			rv = true
		}
		catch{
			print("FILE_TRASH Error: \(error)")
		}
		return rv
	}
	
	func FILE_COPY(_ targetUrl: URL) -> Bool {
		guard self.isFileURL else { return false }
		
		if targetUrl.FILE_EXISTS
		{
			targetUrl.FILE_DELETE()
		}
		do {
			try FileManager.default.copyItem(at: self, to: targetUrl)
			return true
		} catch {
			print("FILE_COPY Error: \(error)")
		}
		return false
	}
	
	func FILE_MOVE(_ targetUrl: URL) -> Bool {
		guard self.isFileURL else { return false }
		
		if targetUrl.FILE_EXISTS
		{
			targetUrl.FILE_DELETE()
		}
		do {
			try FileManager.default.moveItem(at: self, to: targetUrl)
			return true
		} catch {
			print("FILE_MOVE Error: \(error)")
		}
		return false
	}
	
	
	
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	func FILE_SUGGEST_NAME_FOR_COPY() -> URL?
	{
		//print("------------------------")
		guard self.isFileURL else { return nil }
		var fileName = self.deletingPathExtension().lastPathComponent
		
		var startIndex: Int = 1
		var suffix: String = " copy"
		let rc = /copy\s*(\d*)$/.ignoresCase()
		if let match = fileName.firstMatch(of: rc)
		{
			startIndex = Int(match.1) ?? 1
			suffix = "copy"
			fileName.removeLast(match.0.count)
		}
		
		let base = self.deletingLastPathComponent()
		var rv: URL?
		for idx in stride(from: startIndex, to: 99999, by: 1)
		{
			rv = base.appendingPathComponent("\(fileName)\(suffix)\(idx == 1 ? "" : " \(idx)")", conformingTo: .pdf)
			if let rv, !rv.FILE_EXISTS
			{
				break
			}
		}
		//		print("Result: \(String(describing: rv?.path(percentEncoded: false)))")
		return rv
	}
	
}
