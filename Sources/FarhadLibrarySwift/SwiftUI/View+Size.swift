//
//  View+Size.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 1/13/25.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
private struct FMReportSize: ViewModifier {
	var mReporter: (_ size: CGSize) -> Void = {_ in}
	func body(content: Content) -> some View {
		content
			.overlay {
				GeometryReader { geo in
					Color.clear
						.onChange(of: geo.size, initial: true) { oldValue, newValue in
							mReporter(newValue)
						}
				}
			}
	}
}


public extension View {
	@available(iOS 17.0, *)
	func fmReportSize(_ reporter: @escaping (_ size: CGSize) -> Void) -> some View {
		modifier(FMReportSize(mReporter: reporter))
	}
}

