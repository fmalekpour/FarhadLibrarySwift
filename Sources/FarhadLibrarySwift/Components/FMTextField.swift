//
//  FMTextField.swift
//
//
//  Created by Farhad Malekpour on 2/21/24.
//

import Foundation
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
	private var mShowPass: Bool
	@State private var mIsShowingPass: Bool = false
	@State private var mIsShowingPassTrans: Bool = false
	
	public init(text: Binding<String>, prompt: String = "", label: String) {
		_mText = text
		self.mLabel = label
		self.mIsSecure = false
		self.mShowPass = false
		self.mPrompt = prompt
	}
	
	fileprivate init(text: Binding<String>, prompt: String = "", label: String, isSecure: Bool, showPass: Bool) {
		_mText = text
		self.mLabel = label
		self.mIsSecure = isSecure
		self.mShowPass = showPass
		self.mPrompt = prompt
	}
	
	enum Field: Hashable {
		case textField
		case secureField
		case secureShowField
	}
	
	public var body: some View {
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
								.opacity(!mIsShowingPass ? 0.0 : 1.0)
								.autocorrectionDisabled()
								.disabled(!mIsShowingPass && !mIsShowingPassTrans)
								.foregroundStyle(Color.accentColor)
							#if os(iOS)
								.textInputAutocapitalization(.never)
							#endif
							
							
							SecureField(text: $mText, prompt: Text("")) {}
								.focused($focusedField, equals: .secureField)
								.opacity(mIsShowingPass ? 0.0 : 1.0)
								.autocorrectionDisabled()
								.disabled(mIsShowingPass && !mIsShowingPassTrans)
								.foregroundStyle(Color.accentColor)
#if os(iOS)
								.textInputAutocapitalization(.never)
#endif
						}
						else
						{
							TextField(text: $mText, prompt: Text("")) {}
								.focused($focusedField, equals: .textField)
								.foregroundStyle(Color.accentColor)
						}
						TextField(text: .constant(""), prompt: Text("")) {}
							.opacity(0.0)
							.disabled(true)
							.allowsHitTesting(false)
					}
					
					
					if hasFocusAnim
					{
						if !mIsSecure || !mShowPass
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
					
					if mIsSecure && mShowPass && ( hasFocusAnim || !mText.isEmpty)
					{
						Button(action: {
							mIsShowingPassTrans = true
							let currentFocus = focusedField
							mIsShowingPass.toggle()
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
							Image(systemName: mIsShowingPass ? "eye.slash" : "eye")
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
				
			})
			.allowsHitTesting(false)
			.opacity(0.0)
		}
		.contentShape(Rectangle())
		.onTapGesture {
			if mIsSecure
			{
				focusedField = (mIsShowingPass ? .secureShowField : .secureField)
			}
			else
			{
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
		
	}
}

@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
public struct FMSecureTextField: View {
	@Binding private var mText: String
	private var mLabel: String
	private var mShowPass: Bool
	private var mPrompt: String
	
	public init(text: Binding<String>, prompt: String = "", label: String, showPass: Bool = true) {
		_mText = text
		self.mLabel = label
		self.mShowPass = showPass
		self.mPrompt = prompt
	}
	
	public var body: some View {
		FMTextField(text: $mText, prompt: mPrompt, label: mLabel, isSecure: true, showPass: mShowPass)
	}
}


@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
private struct FMTextField_Preview: View {
	@State var mText1: String = ""
	@State var mText2: String = "Test Input"
	@State var mText3: String = ""
	@State var mText4: String = "a hard to guess pass"
	
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
