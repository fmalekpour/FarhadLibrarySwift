//
//  FMAlertViewSwift.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 11/25/25.
//

#if os(iOS) || os(tvOS)

import Foundation
import SwiftUI
import UIKit
import Combine

@available(iOS 17.0, *)
final public class FMAlertViewSwift {
	
	
	private init() {}
	
	public static func show(
		title: String = "Warning",
		message: String? = nil)
	{
		Self.show(title: title, message: message, buttons: {})
	}

	public static func show<ButtonsContent: View>(
		title: String = "Warning",
		message: String? = nil,
		@ViewBuilder buttons: @escaping () -> ButtonsContent)
	{

		guard let scene = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first(where: { $0.activationState == .foregroundActive }) else {
			return
		}
		
		let mInfo: AlertInfo = AlertInfo()
		mInfo.mTitle = title
		mInfo.mMessage = message
		
		let mInfoButtons = AlertInfoButtons<ButtonsContent>()
		mInfoButtons.mButtons = buttons
		
		let hudView = GlobalAlertViewHUD(info: mInfo, infoButtons: mInfoButtons)
		
		let hosting = UIHostingController(rootView: hudView)
		hosting.view.backgroundColor = .clear
		
		
		let window = UIWindow(windowScene: scene)
		window.rootViewController = hosting
		window.windowLevel = .alert + 1
		window.backgroundColor = .clear
		
		mInfo.window = window
		mInfo.hostingController = hosting
		FMAlertViewManager.shared.add(mInfo)
	}
}

@available(iOS 17.0, *)
private class AlertInfo: ObservableObject, Identifiable {
	var id: String = UUID().uuidString
	@Published var mTitle: String = "Warning"
	@Published var mMessage: String? = nil
	
	var window: UIWindow? = nil
	var hostingController: UIViewController!
}

@available(iOS 17.0, *)
private class AlertInfoButtons<ButtonsContent: View>: ObservableObject, Identifiable {
	@Published var mButtons: (() -> ButtonsContent)? = nil
}

@available(iOS 17.0, *)
private class FMAlertViewManager{
	static let shared: FMAlertViewManager = FMAlertViewManager()
	
	private var mInfoList: [AlertInfo] = []
	
	func add(_ newInfo: AlertInfo)
	{
		mInfoList.forEach { info in
			info.window?.isHidden = true
		}
		mInfoList.append(newInfo)
		newInfo.window?.isHidden = false
	}
	
	func remove(_ info: AlertInfo)
	{
		info.window?.isHidden = false
		info.window = nil
		mInfoList.removeAll(where: { $0.id == info.id })
		if let last = mInfoList.last {
			last.window?.isHidden = false
		}
	}
	
}

@available(iOS 17.0, *)
private struct GlobalAlertViewHUD<ButtonsContent: View>: View {
	@ObservedObject var mInfo: AlertInfo
	@ObservedObject var mInfoButtons: AlertInfoButtons<ButtonsContent>
	
	@State var mShow: Bool
	
	init(info: AlertInfo, infoButtons: AlertInfoButtons<ButtonsContent>) {
		self.mInfo = info
		self.mInfoButtons = infoButtons
		self.mShow = true
	}
	
	var body: some View {
		ZStack {
			
		}
		.onChange(of: mShow, initial: false, { oldValue, newValue in
			if oldValue && !newValue{
				FMAlertViewManager.shared.remove(mInfo)
			}
		})
		.alert(mInfo.mTitle, isPresented: $mShow, presenting: mInfo) { info in
			mInfoButtons.mButtons?()
		} message: { info in
			if let message = info.mMessage
			{
				Text(message)
			}
		}

	}
}

@available(iOS 17.0, *)
#Preview("FMWaitView") {
	VStack(spacing: 10){
		Button("Show Alert") {
			FMAlertViewSwift.show(title: "Note", message: "Something happened! Please try again.", buttons: {
				Button {
					print("cancel Clicked")
				} label: {
					Text("Cancel")
				}
				
				Button {
					print("OK Clicked")
				} label: {
					Text("OK")
				}
				
			})
		}
		Button("Show Double Alert") {
			FMAlertViewSwift.show(title: "Note1", message: "Something happened! Please try again. Stage 1, trying to see if the back alert that is stacked is visible when the front one shows.", buttons: {
				Button {
					print("OK Clicked")
				} label: {
					Text("OK")
				}
			})
			FMAlertViewSwift.show(title: "Note2", message: "Something happened! Please try again. Stage 2", buttons: {
				Button {
					print("cancel Clicked")
				} label: {
					Text("Cancel")
				}
				
				Button {
					print("OK Clicked")
				} label: {
					Text("OK")
				}
			})
		}
		Button("Default Buttons") {
			FMAlertViewSwift.show(title: "Note", message: "Something happened! Please try again.", buttons: {})
		}

	}
	.frame(maxWidth: .infinity, maxHeight: .infinity)
	.overlay(alignment: .top, content: {
		Button {
			print("Background button clicked")
		} label: {
			Text("Test if background is clickable")
		}

	})
	.buttonStyle(.bordered)
}
#endif
