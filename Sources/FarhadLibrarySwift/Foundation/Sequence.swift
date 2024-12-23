//
//  Sequence.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 12/22/24.
//

import Foundation

public extension Sequence where Iterator.Element: Equatable {
	
	/// Make array unique (slow), going through all the elements and add them to list if not exist
	func fm_unique() -> [Element] {
		var uniqueValues: [Element] = []
		forEach { item in
			guard !uniqueValues.contains(item) else { return }
			uniqueValues.append(item)
		}
		return uniqueValues
	}
	
}

public extension Sequence where Iterator.Element: Hashable {
	/// Make array unique fast, items need to be hashable and order is not important
	func fm_unique_fast() -> [Iterator.Element] {
		var seen: Set<Iterator.Element> = []
		return filter { seen.insert($0).inserted }
	}
}
