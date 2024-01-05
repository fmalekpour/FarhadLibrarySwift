//
//  String+Emoji.swift
//
//
//  Created by Farhad Malekpour on 1/4/24.
//

import Foundation

public extension Character
{
	var isSimpleEmoji: Bool {
		guard let firstScalar = unicodeScalars.first else { return false }
		return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
	}
	
	var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
	
	var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

public extension String {
	var isSingleEmoji: Bool { count == 1 && containsEmoji }
	
	var containsEmoji: Bool { contains { $0.isEmoji } }
	
	var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
	
	var emojiString: String { emojis.map { String($0) }.reduce("", +) }
	
	var emojis: [Character] { filter { $0.isEmoji } }
	
	var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}
