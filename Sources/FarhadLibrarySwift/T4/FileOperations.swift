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


