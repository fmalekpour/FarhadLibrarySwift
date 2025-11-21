//
//  FMError.swift
//
//
//  Created by Farhad Malekpour on 2/25/24.
//

import Foundation

enum FMError__NOT_USED: Error
{
	case General(String)
}

public class FMError: Error
{
	/// The error message
	public let message: String
	/// The error code
	public let code: Int
	/// The timestamp of the error
	public let timestamp: Date
	/// The underlying error which caused this error
	public let error: Error?
	/// The name of the error
	public let name: String
	
	public init(code: Int, message: String, timestamp: Date? = nil, error: Error? = nil, name: String = "FLS:Error") {
		self.code = code
		self.message = message
		self.timestamp = timestamp ?? Date()
		self.error = error
		self.name = name
	}
	

}


/// Extension for `CustomStringConvertible` conformance
extension FMError: CustomStringConvertible {
	/// Provides error JSON string if found.
	public var description: String {
		return "[FLS\(self.code)] \(self.message)"
	}
	public var localizedDescription: String {
		return self.description
	}
}

extension FMError: Equatable
{
	public static func == (lhs: FMError, rhs: FMError) -> Bool {
		lhs.code == rhs.code && lhs.message == rhs.message
	}
}
