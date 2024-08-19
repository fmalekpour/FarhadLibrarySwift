//
//  FMMultiPartFormData.swift
//  CleanSheet
//
//  Created by Farhad Malekpour on 6/6/24.
//

import Foundation

public struct FMMultipartFormData: Hashable, Equatable {
	public struct Part: Hashable, Equatable {
		public var name: String
		public var data: Data
		public var filename: String?
		public var contentType: String?
		
		public var value: String? {
			get {
				return String(bytes: self.data, encoding: .utf8)
			}
			set {
				guard let value = newValue else {
					self.data = Data()
					return
				}
				
				self.data = value.data(using: .utf8, allowLossyConversion: true)!
			}
		}
		
		public init(name: String, data: Data, filename: String? = nil, contentType: String? = nil) {
			self.name = name
			self.data = data
			self.filename = filename
			self.contentType = contentType
		}
		
		public init(name: String, value: String) {
			let data = value.data(using: .utf8, allowLossyConversion: true)!
			self.init(name: name, data: data, filename: nil, contentType: nil)
		}
	}
	
	public enum MultipartType: String {
		case formData = "form-data"
		case mixed = "mixed"
	}
	
	public var boundary: String
	public var parts: [Part]
	public var multipartType: MultipartType
	
	public var contentType: String {
		return "multipart/\(multipartType.rawValue); boundary=\(self.boundary)"
	}
	
	public var bodyData: Data {
		var body = Data()
		for part in self.parts {
			body.fappend("--\(self.boundary)\r\n")
			body.fappend("Content-Disposition: form-data; name=\"\(part.name)\"")
			if let filename = part.filename?.replacingOccurrences(of: "\"", with: "_") {
				body.fappend("; filename=\"\(filename)\"")
			}
			body.fappend("\r\n")
			if let contentType = part.contentType {
				body.fappend("Content-Type: \(contentType)\r\n")
			}
			body.fappend("\r\n")
			body.append(part.data)
			body.fappend("\r\n")
		}
		body.fappend("--\(self.boundary)--\r\n")
		
		return body
	}
	
	public init(parts: [Part] = [], boundary: String = UUID().uuidString, multipartType: MultipartType = .formData) {
		self.parts = parts
		self.boundary = boundary
		self.multipartType = multipartType
	}
	
	public subscript(name: String) -> Part? {
		get {
			return self.parts.first(where: { $0.name == name })
		}
		set {
			precondition(newValue == nil || newValue?.name == name)
			
			var parts = self.parts
			parts = parts.filter { $0.name != name }
			if let newValue = newValue {
				parts.append(newValue)
			}
			self.parts = parts
		}
	}
}


private extension Data {
	mutating func fappend(_ string: String) {
		self.append(string.data(using: .utf8, allowLossyConversion: true)!)
	}
}
