//
//  FMDialogManager.swift
//
//
//  Created by Farhad Malekpour on 1/15/24.
//

import Foundation
import SwiftUI

public class FMDialogManager: ObservableObject
{
	public struct DialogButton: Identifiable{
		public var id: UUID = UUID()
		fileprivate var title: String
		fileprivate var action: () -> Void
		
		init(title: String, action: @escaping () -> Void) {
			self.title = title
			self.action = action
		}
	}
	
	
	@Published fileprivate var isPresented: Bool = false
	@Published fileprivate var title: String = ""
	@Published fileprivate var message: String? = nil
	@Published fileprivate var buttons: [DialogButton] = []
	
	public init() {
	}
	
	public func present(_ title: String, _ message: String, buttons: () -> [DialogButton]) {
		self.isPresented = false
		self.title = title
		self.message = message
		self.buttons = buttons()
		self.isPresented = true
	}
}

@available(macOS 12.0, *)
@available(iOS 16.0, *)
public struct FMDialogManager_Modifier: ViewModifier {
	@StateObject var dialogManager: FMDialogManager
	public func body(content: Content) -> some View {
		content
			.alert(dialogManager.title, isPresented: $dialogManager.isPresented, presenting: dialogManager) { bd in
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

@available(macOS 12.0, *)
@available(iOS 16.0, *)
public extension View {
	func fmDialogManager(_ dialogManager: FMDialogManager) -> some View {
		modifier(FMDialogManager_Modifier(dialogManager: dialogManager))
	}
}

#if FM_ALLOW_PREVIEW

private struct FMDialogManager_Preview: View {
	@StateObject var mDialogManager = FMDialogManager()
	var body: some View {
		List{
			Button(action: {
				mDialogManager.present("Test Confirm", "Are you sure you want to continue?") {
					[
						.init(title: "NO", action: {
							print("No Pressed")
						}), .init(title: "YES", action: {
							print("Yes Pressed")
						})
					]
				}
			}, label: {
				Text("Show")
			})
			Button(action: {
				mDialogManager.present("Test Confirm 2", "Are you sure you want to continue #2?") {
					[
						.init(title: "NO", action: {
							print("No Pressed")
						}),
						.init(title: "YES", action: {
							print("Yes Pressed")
						})
					]
				}
			}, label: {
				Text("Show #2")
			})
			Button(action: {
				mDialogManager.present("Alert", "Something is not right!") {
					[
						.init(title: "OK", action: {
							print("OK Pressed")
						})
					]
				}
			}, label: {
				Text("Alert")
			})
		}
		.fmDialogManager(mDialogManager)
		
	}
}

#Preview {
	FMDialogManager_Preview()
	
}

#endif
