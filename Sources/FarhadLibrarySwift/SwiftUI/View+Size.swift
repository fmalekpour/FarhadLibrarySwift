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

private struct FMReportContainerCornerInsets: ViewModifier {
	var mReporter: (_ insets: FMRectangleCornerInsets) -> Void = {_ in}
	var mInitial: Bool
	func body(content: Content) -> some View {
		if #available(iOS 26.0, watchOS 26.0, tvOS 26.0, *)  {
			content
				.overlay {
					GeometryReader { geo in
						Color.clear
							.onChange(of: geo.containerCornerInsets, initial: mInitial) { oldValue, newValue in
								mReporter(FMRectangleCornerInsets(topLeading: newValue.topLeading,
																  topTrailing: newValue.topTrailing,
																  bottomLeading: newValue.bottomLeading,
																  bottomTrailing: newValue.bottomTrailing))
							}
					}
				}
		}
		else if mInitial
		{
			content
				.onAppear {
					mReporter(.zero)
				}
		}
	}
}
public struct FMRectangleCornerInsets
{
	public var topLeading: CGSize
	public var topTrailing: CGSize
	public var bottomLeading: CGSize
	public var bottomTrailing: CGSize
	static public var zero = FMRectangleCornerInsets(topLeading: .zero, topTrailing: .zero, bottomLeading: .zero, bottomTrailing: .zero)
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
	
	func fmReportContainerCornerInsets(initial: Bool = true, _ reporter: @escaping (_ insets: FMRectangleCornerInsets) -> Void) -> some View {
		modifier(FMReportContainerCornerInsets(mReporter: reporter, mInitial: initial))
	}
	
}

