//
//  String+Extra.swift
//
//
//  Created by Farhad Malekpour on 3/8/24.
//

import Foundation

public extension String
{
	init(randomLength: Int, allowdCharacters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
	{
		let s = "\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)\(allowdCharacters)"
			.shuffled()
			.prefix(randomLength)
		
		self.init(s)
	}

	
	
	func fmLength() -> Int {
		return self.count
	}
	
	func fmTrim() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	func fmSubstring(_ location:Int, length:Int) -> String! {
		return (self as NSString).substring(with: NSMakeRange(location, length))
	}
	
	func fmSubstring(from index: Int) -> Substring
	{
		return self.suffix(from: self.index(self.startIndex, offsetBy: index))
	}
	
	func fmSubstring(to index: Int) -> Substring
	{
		return self.prefix(index)
	}
	
	subscript(index: Int) -> String! {
		get {
			return self.fmSubstring(index, length: 1)
		}
	}
	
	func fmLocation(_ other: String) -> Int {
		return (self as NSString).range(of: other).location
	}
	
	func fmContains(_ other: String) -> Bool {
		return (self as NSString).contains(other)
	}
	
	// http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
	func fmIsNumeric() -> Bool {
		return (self as NSString).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location == NSNotFound
	}
	
	func fmEmptyDefault(_ defaultString: String) -> String
	{
		if self.fmTrim().isEmpty
		{
			return defaultString
		}
		return self
	}
	
	func fmHtmlDecoded() -> String?
	{
		guard let data = self.data(using: .utf8) else {
			return nil
		}
		
		let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
			.documentType: NSAttributedString.DocumentType.html,
			.characterEncoding: String.Encoding.utf8.rawValue
		]
		
		guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
			return nil
		}
		
		return attributedString.string
	}
	
	var fmIsValidEmail: Bool {
		NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
	}

	
	
}
