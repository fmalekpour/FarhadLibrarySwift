//
//  TextField22.swift
//  test-swiftui-components
//
//  Created by Farhad Malekpour on 3/26/24.
//

import SwiftUI

@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
public struct FMTextField: View {
	@Binding private var mText: String
	private var mLabel: String
	private var mPrompt: String
	
	@FocusState private var focusedField: Field?
	@State private var hasFocusAnim: Bool = false
	private var mIsSecure: Bool
	@Binding private var mShowPass: Bool
	//@State private var mIsShowingPass: Bool = false
	@State private var mIsShowingPassTrans: Bool = false
	private var mAllowShowPass: Bool
	var mOnShowPassChanged: Binding<Bool> = .constant(false)
	
	public init(text: Binding<String>, prompt: String = "", label: String) {
		_mText = text
		_mShowPass = .constant(false)
		self.mLabel = label
		self.mIsSecure = false
		//self.mShowPass = false
		self.mPrompt = prompt
		self.mAllowShowPass = false
	}
	
	fileprivate init(text: Binding<String>, prompt: String = "", label: String, isSecure: Bool, allowShowPass: Bool, showPass: Binding<Bool>) {
		_mText = text
		self.mLabel = label
		self.mIsSecure = isSecure
		_mShowPass = showPass
		self.mPrompt = prompt
		self.mAllowShowPass = allowShowPass
	}
	
	enum Field: Hashable {
		case textField
		case secureField
		case secureShowField
	}
	
	public var body: some View {
#if os(macOS)
		FMTextField_Mac(mText: $mText, mLabel: mLabel, mPrompt: mPrompt, mIsSecure: mIsSecure, mShowPass: $mShowPass, mAllowShowPass: mAllowShowPass)
#else
		ZStack{
			VStack(alignment: .leading, spacing: 0){
				if hasFocusAnim || !mText.isEmpty
				{
					Text(self.mLabel)
						.font(.caption)
						.foregroundStyle(.secondary)
				}
				HStack{
					ZStack{
						if mIsSecure
						{
							TextField(text: $mText, prompt: Text("")) {}
								.focused($focusedField, equals: .secureShowField)
								.opacity(!mShowPass ? 0.0 : 1.0)
								.autocorrectionDisabled()
								.disabled(!mShowPass && !mIsShowingPassTrans)
								.foregroundStyle(Color.accentColor)
#if os(iOS)
								.textInputAutocapitalization(.never)
#endif
							
							
							SecureField(text: $mText, prompt: Text("")) {}
								.focused($focusedField, equals: .secureField)
								.opacity(mShowPass ? 0.0 : 1.0)
								.autocorrectionDisabled()
								.disabled(mShowPass && !mIsShowingPassTrans)
								.foregroundStyle(Color.accentColor)
							
#if os(iOS)
								.textInputAutocapitalization(.never)
#endif
							
						}
						else
						{
							
							TextField(text: $mText, prompt: Text("")) {}
								.focused($focusedField, equals: .textField)
								.frame(maxWidth: .infinity)
								.foregroundStyle(Color.accentColor)
							
							
						}
						TextField(text: .constant(""), prompt: Text("")) {}
							.opacity(0.0)
							.disabled(true)
							.allowsHitTesting(false)
						
					}
					
					
					
					if hasFocusAnim
					{
						if !mIsSecure || !mAllowShowPass
						{
							Button(action: {
								mText = ""
							}, label: {
								Image(systemName: "multiply.circle.fill")
							})
							.buttonStyle(.borderless)
							.foregroundStyle(.placeholder)
						}
					}
					
					if mIsSecure && mAllowShowPass && ( hasFocusAnim || !mText.isEmpty)
					{
						Button(action: {
							mIsShowingPassTrans = true
							let currentFocus = focusedField
							mShowPass.toggle()
							if currentFocus != nil
							{
								Task{
									try? await Task.sleep(for: .milliseconds(1))
									focusedField = ( currentFocus == .secureField ? .secureShowField : .secureField )
									mIsShowingPassTrans = false
								}
							}
							else
							{
								mIsShowingPassTrans = false
							}
						}, label: {
							Image(systemName: mShowPass ? "eye.slash" : "eye")
						})
						.buttonStyle(.borderless)
						.foregroundStyle(.placeholder)
					}
				}
				.overlay(alignment: .leading) {
					if !hasFocusAnim  && mText.isEmpty
					{
						VStack(alignment: .leading){
							Text(self.mLabel)
								.allowsHitTesting(false)
							if !self.mPrompt.isEmpty
							{
								Text(self.mPrompt)
									.allowsHitTesting(false)
									.font(.footnote)
									.foregroundStyle(.secondary)
							}
						}
					}
				}
			}
			VStack(spacing: 0, content: {
				Text(self.mLabel)
					.font(.caption)
				TextField(text: .constant(""), prompt: Text("")) {}
					.disabled(true)
					.allowsHitTesting(false)
				
			})
			.allowsHitTesting(false)
			.opacity(0.0)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			if mIsSecure
			{
				focusedField = (mShowPass ? .secureShowField : .secureField)
			}
			else
			{
				//print("TAP")
				focusedField = .textField
			}
		}
#if !os(tvOS) && !os(watchOS)
		.alignmentGuide(.listRowSeparatorLeading, computeValue: { dimension in
			0
		})
#endif
		.onChange(of: focusedField) { oldValue, newValue in
			withAnimation {
				hasFocusAnim = (newValue != nil)
			}
		}
#endif
		
	}
}

#if os(macOS)
@available(macOS 14.0, *)
fileprivate struct FMTextField_Mac: View
{
	@Binding fileprivate var mText: String
	fileprivate var mLabel: String
	fileprivate var mPrompt: String
	fileprivate var mIsSecure: Bool
	@Binding fileprivate var mShowPass: Bool
	fileprivate var mAllowShowPass: Bool = true
	//@State var mIsShowingPass: Bool = false
	
	
	var body: some View {
		VStack(alignment: .leading){
			if !mLabel.isEmpty
			{
				Text(mLabel)
			}
			
			HStack{
				if !mIsSecure || mShowPass
				{
					TextField(text: $mText, prompt: Text(mPrompt)) {}
						.textFieldStyle(.roundedBorder)
						.foregroundStyle(Color.accentColor)
				}
				else if mIsSecure
				{
					SecureField(text: $mText, prompt: Text(mPrompt)) {}
						.autocorrectionDisabled()
						.textFieldStyle(.roundedBorder)
						.foregroundStyle(Color.accentColor)
				}
				
				if mIsSecure && mAllowShowPass
				{
					Button(action: {
						mShowPass.toggle()
					}, label: {
						Image(systemName: mShowPass ? "eye.slash" : "eye")
					})
					.buttonStyle(.borderless)
				}
				
			}
		}
	}
}
#endif



@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
public struct FMSecureTextField: View {
	@Binding private var mText: String
	private var mLabel: String
	//private var mShowPass: Bool
	private var mPrompt: String
	private var mAllowShowPass: Bool = true
	private var mShowPass: Binding<Bool>? = nil
	@State private var mInternalShowPass: Bool = false
	
	public init(text: Binding<String>, prompt: String = "", label: String) {
		_mText = text
		self.mLabel = label
		self.mPrompt = prompt
	}
	
	public var body: some View {
		FMTextField(text: $mText,
					prompt: mPrompt,
					label: mLabel,
					isSecure: true,
					allowShowPass: mAllowShowPass,
					showPass: (mShowPass != nil ? mShowPass! : $mInternalShowPass))
	}
	
	func allowShowPass(_ allow: Bool) -> Self
	{
		var RV = self
		RV.mAllowShowPass = allow
		return RV
	}
	
	func showPass(_ show: Bool) -> Self
	{
		var RV = self
		RV._mInternalShowPass = State(initialValue: true)
		return RV
	}
	
	func showPass(_ show: Binding<Bool>) -> Self
	{
		var RV = self
		RV.mShowPass = show
		return RV
	}
	
}


@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
struct FMTextField_Preview: View {
	@State var mText1: String = ""
	@State var mText2: String = "Test Input"
	@State var mText3: String = ""
	@State var mText4: String = "a hard to guess pass"
	@State var mShowPassState: Bool = false
	
	var body: some View {
		List{
			Section{
				FMTextField(text: $mText1, prompt: "To enter title 1", label: "Title 1")
			}
			
			Section{
				FMTextField(text: $mText2, label: "Title 2")
			}
			
			Section{
				FMTextField(text: $mText1, label: "Title 10")
				FMTextField(text: $mText1, label: "Title 11")
			}
			
			Section{
				FMSecureTextField(text: $mText3, label: "Secure 1")
				FMSecureTextField(text: $mText4, label: "Secure 2")
				FMSecureTextField(text: $mText4, label: "Secure 3 - no show pass")
					.allowShowPass(false)
				FMSecureTextField(text: $mText4, label: "Secure 4 - show pass by default")
					.allowShowPass(true)
					.showPass(true)
				FMSecureTextField(text: $mText4, label: "Secure 5 - show pass binding")
					.allowShowPass(true)
					.showPass($mShowPassState)
			}
			.onChange(of: mShowPassState) { oldValue, newValue in
				print("Showpass-> \(newValue)")
			}
			
			
			Section{
				TextField(text: .constant("")) {
					Text("")
				}
			}
		}
		
	}
}




@available(tvOS 16.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
#Preview {
	FMTextField_Preview()
}


