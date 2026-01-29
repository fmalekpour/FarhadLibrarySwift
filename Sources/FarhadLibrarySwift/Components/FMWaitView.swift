//
//  FMWaitUI.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 11/25/25.
//

#if os(iOS) || os(tvOS)

import Foundation
import SwiftUI
import UIKit
import Combine

@available(iOS 26.0, *)
@available(tvOS 26.0, *)
final class FMWaitView {
	static let shared = FMWaitView()
	
	enum WaitType{
		case basic
		case progress
		case dialog
	}
	
	
	
	class Info: ObservableObject {
		@Published var mWaitType: WaitType = .basic
		@Published var mTitle: String = "Please wait…"
		@Published var mMessage: String? = nil
		@Published var mProgress: Progress = Progress()
		@Published var mButtons: [ButtonInfo] = []
	}
	
	
	struct ButtonInfo: Identifiable
	{
		var id: String = UUID().uuidString
		var mRole: ButtonRole? = nil
		var mTitle: String
		var mAction: () -> Void
	}
	
	private var mInfo: Info = Info()
	
	private var window: UIWindow?
	private var hostingController: UIHostingController<GlobalWaitViewHUD>?
	
	private init() {}
	
	func show(title: String = "Please wait…", message: String? = nil, type: WaitType = .basic, buttons: [ButtonInfo] = [])
	{

		guard let scene = UIApplication.shared.connectedScenes
			.compactMap({ $0 as? UIWindowScene })
			.first(where: { $0.activationState == .foregroundActive }) else {
			return
		}
		
		mInfo.mWaitType = type
		mInfo.mTitle = title
		mInfo.mMessage = message
		mInfo.mButtons = buttons
		
		if window == nil {
			let hudView = GlobalWaitViewHUD(mInfo: mInfo)
			
			let hosting = UIHostingController(rootView: hudView)
			hosting.view.backgroundColor = .clear
			
			let window = UIWindow(windowScene: scene)
			window.rootViewController = hosting
			window.windowLevel = .alert + 1
			window.backgroundColor = .clear
			
			self.window = window
			self.hostingController = hosting
		} else if let hosting = hostingController {
			hosting.rootView = GlobalWaitViewHUD(mInfo: mInfo)
		}
		
		window?.isHidden = false
	}
	
	func hide() {
		window?.isHidden = true
	}
	
	func setType(_ WaitType: WaitType) {
		mInfo.mWaitType = WaitType
	}
	
	func setTitle(_ title: String) {
		mInfo.mTitle = title
	}
	
	func setMessage(_ message: String?) {
		mInfo.mMessage = message
	}
	
	func setProgress(_ progress: Progress) {
		mInfo.mProgress = progress
	}
	
	func setButtons(_ buttons: [ButtonInfo]) {
		mInfo.mButtons = buttons
	}
	
	func addButton(_ button: ButtonInfo) {
		mInfo.mButtons.append(button)
	}
	
	
}

@available(iOS 26.0, *)
@available(tvOS 26.0, *)
private struct GlobalWaitViewHUD: View {
	@ObservedObject var mInfo: FMWaitView.Info
	
	var body: some View {
		ZStack {
			// Dim background
			Color.black.opacity(0.35)
				.ignoresSafeArea()
			
			VStack(spacing: 16) {
				if mInfo.mWaitType == .progress || mInfo.mWaitType == .basic
				{
					ProgressView()
						.progressViewStyle(.circular)
				}
				
				Text(mInfo.mTitle)
					.font(.headline)
				
				if let message = mInfo.mMessage {
					Text(message)
						.font(.subheadline)
						.multilineTextAlignment(.center)
						.foregroundStyle(.secondary)
				}
				
				if mInfo.mWaitType == .progress
				{
					VStack{
						ProgressView(value: T4.CAP(mInfo.mProgress.fractionCompleted, minimum: 0.0, maximum: 1.0))
							.progressViewStyle(.linear)
						HStack{
							if !mInfo.mProgress.isFractionOnly
							{
								Text("\(mInfo.mProgress.completedUnitCount.sizeString(mode: .MB)) / \(mInfo.mProgress.totalUnitCount.sizeString(mode: .MB))")
									.font(.caption)
									.foregroundStyle(.secondary)
							}
							Spacer()
							Text("\(Int((mInfo.mProgress.fractionCompleted * 100).rounded()))%")
								.font(.caption)
								.foregroundStyle(.secondary)
						}
					}
					.monospacedDigit()
				}
				
				GlassEffectContainer(spacing: 5) {
					HStack(spacing: 5) {
						ForEach(mInfo.mButtons){ button in
							Button(role: button.mRole, action: button.mAction) {
								Text(button.mTitle)
									.frame(maxWidth: .infinity)
							}
							.buttonStyle(.glass)
						}
					}
					.frame(maxWidth: .infinity)
					.padding(.top, 10)
				}
				
				
			}
			.padding(24)
			.frame(maxWidth: 260)
			//.glassEffect()
			.background(.regularMaterial)
			.cornerRadius(20)
			.shadow(radius: 20)
		}
	}
}

@available(iOS 26.0, *)
@available(tvOS 26.0, *)
#Preview("FMWaitView") {
	VStack(spacing: 10){
		Button("Show Basic") {
			FMWaitView.shared.show(title: "Loading", message: "Please wait while we process your request.")
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				FMWaitView.shared.hide()
			}
		}

		Button("Show Change Text") {
			FMWaitView.shared.show(title: "Loading", message: "Please wait while we process your request.")
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				FMWaitView.shared.show(title: "Phase 2", message: "Now we are doing phase 2")
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
					FMWaitView.shared.hide()
				}
			}
			
		}

		Button("Show Change Type") {
			FMWaitView.shared.show(title: "Loading", message: "Please wait while we process your request.")
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				FMWaitView.shared.setType(.progress)
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
					FMWaitView.shared.hide()
				}
			}
			
		}
		
		Button("Show Progress") {
			FMWaitView.shared.show(title: "Loading", message: "Downloading file...", type: .progress)
			FMWaitView.shared.setProgress(Progress(totalUnitCount: 100000, completedUnitCount: 5000)  )

			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				FMWaitView.shared.setProgress(Progress(totalUnitCount: 100000, completedUnitCount: 25000)  )
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					FMWaitView.shared.setProgress(Progress(totalUnitCount: 100000, completedUnitCount: 35000)  )
					DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
						FMWaitView.shared.setProgress(Progress(totalUnitCount: 100000, completedUnitCount: 60000)  )
						DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
							FMWaitView.shared.setProgress(Progress(totalUnitCount: 100000, completedUnitCount: 95000)  )
							DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
								FMWaitView.shared.hide()
							}
						}
					}
				}
			}
		}
		
		Button("Dialog with buttons") {
			FMWaitView.shared.show(title: "Warning", message: "Something bad happened", type: .dialog, buttons: [
				.init(mRole: .cancel, mTitle: "Cancel", mAction: { print("Cancel tapped"); FMWaitView.shared.hide() }),
				.init(mTitle: "OK", mAction: { print("OK tapped") })
			])
		}

	}
	.buttonStyle(.bordered)
}

extension Progress {
	convenience init(totalUnitCount: Int64, completedUnitCount: Int64) {
		self.init()
		self.totalUnitCount = totalUnitCount
		self.completedUnitCount = completedUnitCount
	}
	convenience init(fractionCompleted: Double) {
		self.init()
		self.totalUnitCount = 100_000_000_000_000
		self.completedUnitCount = Int64(fractionCompleted * 100_000_000_000_000)
	}
	
	var isFractionOnly: Bool {
		get {
			return totalUnitCount == 100_000_000_000_000
		}
	}
	
	
	
}

#endif
