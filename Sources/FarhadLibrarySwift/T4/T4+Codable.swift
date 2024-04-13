//
//  T4+Codable.swift
//
//
//  Created by Farhad Malekpour on 4/12/24.
//

import Foundation

public extension T4
{
	static func serialiseObjectToJson<T: Codable>(_ object: T) -> Data?
	{
		Self.lastError = nil
		do {
			let encoder = JSONEncoder()
			encoder.dataEncodingStrategy = .base64
			encoder.keyEncodingStrategy = .useDefaultKeys
			encoder.dateEncodingStrategy = .secondsSince1970
			let jsonData = try encoder.encode(object)
			return jsonData
		} catch {
			Self.lastError = error
		}
		return nil
	}
	
	static func unserialiseDataFromJson<T: Codable>(_ data: Data) -> T?
	{
		Self.lastError = nil
		do {
			let decoder = JSONDecoder()
			decoder.dataDecodingStrategy = .base64
			decoder.keyDecodingStrategy = .useDefaultKeys
			decoder.dateDecodingStrategy = .secondsSince1970
			let object = try decoder.decode(T.self, from: data)
			return object
			
		} catch {
			Self.lastError = error
		}
		return nil
	}
	
	static func serialiseObjectToPList<T: Codable>(_ object: T) -> Data?
	{
		Self.lastError = nil
		do {
			let encoder = PropertyListEncoder()
			encoder.outputFormat = .binary
			let plistData = try encoder.encode(object)
			return plistData
		} catch {
			Self.lastError = error
		}
		return nil
	}
	
	static func unserialiseDataFromPList<T: Codable>(_ data: Data) -> T?
	{
		Self.lastError = nil
		do {
			let decoder = PropertyListDecoder()
			let object = try decoder.decode(T.self, from: data)
			return object
			
		} catch {
			Self.lastError = error
		}
		return nil
	}
	
	static func readDataFromFilePath(_ filePath: String) -> Data?
	{
		Self.lastError = nil
		do {
			let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
			return data
		} catch  {
			Self.lastError = error
		}
		return nil
	}
	
	static func writeDataToFilePath(_ filePath: String, data: Data)
	{
		Self.lastError = nil
		DispatchQueue.global(qos: .background).async {
			
			do {
				try data.write(to: URL(fileURLWithPath: filePath))
			} catch  {
				Self.lastError = error
			}
			
		}
		
	}

}
