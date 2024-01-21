//
//  Sheet+CloseButton.swift
//
//
//  Created by Farhad Malekpour on 1/21/24.
//

import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct FMSheet_CloseButton: ViewModifier
{
	var closeButtonImage: Image
	@Environment(\.verticalSizeClass) private var verticalSizeClass
	@Environment(\.dismiss) private var dismissDialog
	
	public func body(content: Content) -> some View {
		content
			.toolbar(content: {
				ToolbarItemGroup(placement: .topBarLeading) {
					if verticalSizeClass == UserInterfaceSizeClass.compact
					{
						Button(action: {
							dismissDialog()
						}, label: {
							closeButtonImage
						})
					}
				}
			})
	}
}

@available(iOS 15.0, *)
public extension View {
	func fmAutoCloseButton(image: Image) -> some View {
		modifier(FMSheet_CloseButton(closeButtonImage: image))
	}
}
