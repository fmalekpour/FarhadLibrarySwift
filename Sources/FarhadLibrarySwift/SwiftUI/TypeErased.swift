//
//  TypeErased.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 4/16/25.
//

import SwiftUI

private protocol _AnyButtonStyleBox {
	func makeBody(configuration: ButtonStyle.Configuration) -> AnyView
}

private struct _ButtonStyleBox<Base: ButtonStyle>: _AnyButtonStyleBox {
	let base: Base
	
	func makeBody(configuration: ButtonStyle.Configuration) -> AnyView {
		AnyView(base.makeBody(configuration: configuration))
	}
}

public struct AnyButtonStyle: ButtonStyle {
	private let box: _AnyButtonStyleBox
	
	init<S: ButtonStyle>(_ style: S) {
		self.box = _ButtonStyleBox(base: style)
	}
	
	public func makeBody(configuration: Configuration) -> some View {
		box.makeBody(configuration: configuration)
	}
}



public struct AnyViewModifierApplier {
	private let apply: (AnyView) -> AnyView
	
	public init<M: ViewModifier>(_ modifier: M) {
		self.apply = { base in
			AnyView(base.modifier(modifier))
		}
	}
	
	public func apply(to base: AnyView) -> AnyView {
		apply(base)
	}
}

public extension View {
	func applyModifier(_ applier: AnyViewModifierApplier) -> some View {
		applier.apply(to: AnyView(self))
	}
}


