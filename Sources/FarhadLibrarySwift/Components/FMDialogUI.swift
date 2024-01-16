//
//  FMDialogUI.swift
//
//
//  Created by Farhad Malekpour on 1/15/24.
//

import Foundation
import SwiftUI

public class FMDialogUI: ObservableObject
{
	fileprivate struct ConfirmButton: Identifiable{
		var id: UUID = UUID()
		var title: String
		var action: () -> Void
	}
	
	
	@Published fileprivate var isPresented: Bool = false
	@Published fileprivate var title: String = ""
	@Published fileprivate var message: String? = nil
	@Published fileprivate var buttons: [ConfirmButton] = []
	
	@discardableResult
	func show() -> Self {
		self.isPresented = true
		return self
	}
	
	@discardableResult
	func reset() -> Self {
		isPresented = false
		title = ""
		message = nil
		buttons = []
		return self
	}
	
	@discardableResult
	func withTitle(_ t: String) -> Self {
		self.title = t
		return self
	}
	
	@discardableResult
	func withMessage(_ m: String) -> Self {
		self.message = m
		return self
	}
	
	@discardableResult
	func addButton(_ text: String, action: @escaping () -> Void) -> Self {
		self.buttons.append(ConfirmButton(title: text, action: action))
		return self
	}
	
	
}

struct FMConfirmDialogUI_Modofier: ViewModifier {
	@StateObject var build: FMDialogUI = FMDialogUI()
	func body(content: Content) -> some View {
		content
			.environment(\.fmDialog, build)
			.alert(build.title, isPresented: $build.isPresented, presenting: build) { bd in
				ForEach(bd.buttons) { btn in
					Button(action: {
						btn.action()
					}, label: {
						Text(btn.title)
					})
				}
			} message: { bd in
				if let msg = bd.message
				{
					Text(msg)
				}
			}
		
	}
}

private struct FMConfirmDialogUIKey: EnvironmentKey {
	static let defaultValue: FMDialogUI = FMDialogUI()
}

public extension EnvironmentValues {
	var fmDialog: FMDialogUI {
		get { self[FMConfirmDialogUIKey.self] }
		set { self[FMConfirmDialogUIKey.self] = newValue }
	}
}


public extension View {
	func fmDialog() -> some View {
		modifier(FMConfirmDialogUI_Modofier())
	}
}

private struct FMConfirmDialogUI_Preview: View {
	@Environment(\.fmDialog) var confirmDialog
	var body: some View {
		List{
			Button(action: {
				confirmDialog
					.reset()
					.withTitle("Test Confirm")
					.withMessage("Are you sure you want to continue?")
					.addButton("NO") {
						print("No Pressed")
					}
					.addButton("YES") {
						print("Yes Pressed")
					}
					.show()
				
			}, label: {
				Text("Show")
			})
			Button(action: {
				confirmDialog
					.reset()
					.withTitle("Test Confirm 2")
					.withMessage("Are you sure you want to continue #2?")
					.addButton("NO") {
						print("No Pressed")
					}
					.addButton("YES") {
						print("Yes Pressed")
					}
					.show()
				
			}, label: {
				Text("Show #2")
			})
			Button(action: {
				confirmDialog
					.reset()
					.withTitle("Alert")
					.withMessage("Something is not right!")
					.addButton("OK") {
						print("OK Pressed")
					}
					.show()
				
			}, label: {
				Text("Alert")
			})
		}
		
	}
}

#Preview {
	FMConfirmDialogUI_Preview()
		.fmDialog()
}
