//
//  FMToast.swift
//
//  Created by Farhad Malekpour on 1/1/24.
//

import SwiftUI

@available(macOS 14.0, *)
public class FMToast: ObservableObject
{
	fileprivate init(){}
	
	fileprivate var imageView: AnyView?
	fileprivate var textView: AnyView?
	
	@Published fileprivate var display: Bool = false
	
	public func show(_ text: String, systemImage: String? = nil)
	{
		self.textView = AnyView(Text(text))
		if let systemImage
		{
			self.imageView = AnyView(Image(systemName: systemImage))
		}
		self.display = true
	}
	
	public func show<T>(_ text: @escaping () -> T) where T: View
	{
		self.textView = AnyView(text())
		self.imageView = nil
		self.display = true
	}
	
	public func show<T,M>(_ text: @escaping () -> T, image: (() -> M)? = nil) where T: View, M: View
	{
		self.textView = AnyView(text())
		if let img = image?()
		{
			self.imageView = AnyView(img)
		}
		self.display = true
	}
}

struct FMToastView<T: View>
{
	fileprivate var textView: T?
}

public struct FMToastConfig
{
	enum Position {
		case Top
		case Bottom
		case Center
		var toAlignment: Alignment {
			switch self {
				case .Top:		return .top
				case .Bottom:	return .bottom
				case .Center:	return .center
			}
		}
	}
	var deactivationDelay: TimeInterval = 3.0
	var tapToDismiss: Bool = true
	var textFont: Font = .body
	var position: Position = .Top
	var verticalOffset: CGFloat = 20.0
	var textColor: Color = .primary
	var imageColor: Color = .primary
	
}

@available(macOS 14.0, *)
private struct FMToastKey: EnvironmentKey {
	static let defaultValue: FMToast = FMToast()
}

@available(macOS 14.0, *)
public extension EnvironmentValues {
	var fmToast: FMToast {
		get { self[FMToastKey.self] }
		set { self[FMToastKey.self] = newValue }
	}
}

@available(tvOS 17.0, *)
@available(iOS 17.0, *)
@available(macOS 14.0, *)
fileprivate struct FMToast_Modifier: ViewModifier
{
	init(config: ((_: inout FMToastConfig) -> Void)?) {
		self.config = FMToastConfig()
		config?(&self.config)
	}
	private var config: FMToastConfig
	@StateObject var toastEnv: FMToast = FMToast()
	@State private var toastText: AnyView?
	@State private var toastImage: AnyView?
	@State private var toastShow: Bool = false
	@State private var timer: Timer?
	@Environment(\.colorScheme) var colorScheme
	func body(content: Content) -> some View {
		content
			.environment(\.fmToast, toastEnv)
			.overlay(alignment: self.config.position.toAlignment) {
				if toastShow
				{
					HStack(spacing: 10){
						if let toastImage
						{
							toastImage
						}
						toastText
							.font(self.config.textFont)
					}
					.padding(.vertical, 10)
					.padding(.horizontal, 20)
					
					.background(.regularMaterial)
					.clipShape(RoundedRectangle(cornerRadius: 20))
					.offset(y: self.config.verticalOffset)
					.environment(\.colorScheme, colorScheme == .dark ? .light : .dark)
					.onTapGesture(perform: {
						if self.config.tapToDismiss
						{
							timer?.invalidate()
							withAnimation {
								self.toastShow = false
								self.toastImage = nil
								self.toastText = nil
							}
						}
					})
				}
			}
			.onChange(of: toastEnv.display) { oldValue, newValue in
				if newValue
				{
					toastEnv.display = false
					withAnimation(.smooth(duration: 0.2)) {
						self.toastImage = toastEnv.imageView
						self.toastText = toastEnv.textView
						self.toastShow = true
					}
					timer?.invalidate()
					if self.config.deactivationDelay > 0
					{
						timer = .scheduledTimer(withTimeInterval: self.config.deactivationDelay, repeats: false, block: { xTimer in
							withAnimation {
								self.toastShow = false
								self.toastImage = nil
								self.toastText = nil
							}
						})
					}
				}
			}
	}
}

public extension View {
	@available(tvOS 17.0, *)
	@available(iOS 17.0, *)
	@available(macOS 14.0, *)
	func fmToast(config: ((_: inout FMToastConfig) -> Void)? = nil) -> some View {
		modifier(FMToast_Modifier(config: config))
	}
}


@available(tvOS 17.0, *)
@available(iOS 17.0, *)
@available(macOS 14.0, *)
private struct FMToastPreview: View {
	var body: some View {
		NavigationStack{
			VStack{
				FMToastPreview_Page()
			}
			.navigationTitle("Test Toast")
			#if os(iOS)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar(.visible, for: .navigationBar)
			.toolbarBackground(.visible, for: .navigationBar)
			#endif
		}
		
		.fmToast { config in
			config.position = .Top
			config.textFont = .subheadline
		}
	}
}

@available(macOS 14.0, *)
private struct FMToastPreview_Page: View {
	@Environment(\.fmToast) var toast
	var body: some View {
		Button(action: {
			toast.show {
				Text("Test Toast")
			} image: {
				Image(systemName: "circle")
			}
			
		}, label: {
			Text("Activate")
		})
		Button(action: {
			toast.show("A very long message to show the line limits. Some other lorem goes here!", systemImage: "info.circle.fill")
		}, label: {
			Text("Activate Long")
		})
		Button(action: {
			toast.show {
				Text("Test Toast with no image.")
			}
			
		}, label: {
			Text("No Image")
		})
	}
}

@available(tvOS 17.0, *)
@available(iOS 17.0, *)
@available(macOS 14.0, *)
#Preview {
	FMToastPreview()
}
