//
//  Sheet+CloseButton.swift
//
//
//  Created by Farhad Malekpour on 1/21/24.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
@available(macOS 12.0, *)
public struct FMSheet_CloseButton<V: View>: ViewModifier
{
	var closeButtonImage: () -> V
	@Environment(\.verticalSizeClass) private var verticalSizeClass
	@Environment(\.dismiss) private var dismissDialog
	
	public func body(content: Content) -> some View {
		content
		#if os(iOS) || os(watchOS)
			.toolbar(content: {
				ToolbarItemGroup(placement: .topBarLeading) {
					if verticalSizeClass == UserInterfaceSizeClass.compact
					{
						Button(action: {
							dismissDialog()
						}, label: {
							closeButtonImage()
						})
					}
				}
			})
		#endif
	}
}

@available(iOS 15.0, *)
@available(macOS 12.0, *)
public extension View {
	func fmAutoCloseButton(image: Image) -> some View {
		modifier(FMSheet_CloseButton(closeButtonImage: {
			image
		}))
	}
	func fmAutoCloseButton<T: View>(_ view: @escaping () -> T) -> some View {
		modifier(FMSheet_CloseButton(closeButtonImage: view))
	}
	func fmAutoCloseButton<T: View>(_ view: T) -> some View {
		modifier(FMSheet_CloseButton(closeButtonImage: {
			view
		}))
	}
}
