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
	var mInitial: Bool
	func body(content: Content) -> some View {
		content
			.overlay {
				GeometryReader { geo in
					Color.clear
						.onChange(of: geo.size, initial: mInitial) { oldValue, newValue in
							mReporter(newValue)
						}
				}
			}
	}
}

@available(iOS 17.0, *)
private struct FMReportSafeAreaInsets: ViewModifier {
	var mReporter: (_ insets: EdgeInsets) -> Void = {_ in}
	var mInitial: Bool
	func body(content: Content) -> some View {
		content
			.overlay {
				GeometryReader { geo in
					Color.clear
						.onChange(of: geo.safeAreaInsets, initial: mInitial) { oldValue, newValue in
							mReporter(newValue)
						}
				}
			}
	}
}


public extension View {
	@available(iOS 17.0, *)
	func fmReportSize(initial: Bool = true, _ reporter: @escaping (_ size: CGSize) -> Void) -> some View {
		modifier(FMReportSize(mReporter: reporter, mInitial: initial))
	}

	@available(iOS 17.0, *)
	func fmReportSafeAreaInsets(initial: Bool = true, _ reporter: @escaping (_ insets: EdgeInsets) -> Void) -> some View {
		modifier(FMReportSafeAreaInsets(mReporter: reporter, mInitial: initial))
	}

}

