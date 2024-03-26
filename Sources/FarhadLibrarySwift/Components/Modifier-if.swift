//
//  Modifier-if.swift
//  FarhadLibrary-xcode4.0
//
//  Created by Farhad Malekpour on 2/22/23.
//

import SwiftUI

public extension View {
	@ViewBuilder
	func `if`<Transform: View>(_ condition: Bool,_ transform: (Self) -> Transform) -> some View {
		if condition { transform(self) }
		else { self }
	}
	
	@ViewBuilder
	func `ifInline`<Content: View>(_ condition: @autoclosure () -> Bool, _ transform: (Self) -> Content) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}
}
