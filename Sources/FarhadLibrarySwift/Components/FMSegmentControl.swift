//
//  FMSegmentControl.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 4/16/25.
//

import SwiftUI

@available(tvOS 17.0, *)
@available(macOS 14.0, *)
@available(iOS 17.0, *)
public struct FMSegmentControl<SelectionValue: Hashable, Content: View>: View {
	private let selection: Binding<SelectionValue>
	private let content: Content
	public var config: FMSegmentControlConfig = FMSegmentControlConfig()
	
	@State private var cellPositions: [SelectionValue: CGRect] = [:]
	@State var selectedCellPosition: CGRect? = nil
	@State var cellPositionsChanged: Int64 = 0
	
	@Environment(\.isEnabled) var isEnabled
	
	public init(
		selection: Binding<SelectionValue>,
		@ViewBuilder content: () -> Content
	) {
		self.selection = selection
		self.content = content()
	}
	
	public var body: some View {
		HStackEqualWidth(spacing: 5){
			_VariadicView.Tree(ValuePickerOptions(selectedValue: selection,
												  cellPositions: $cellPositions,
												  cellPositionChanged: $cellPositionsChanged,
												  config: config)) {
				content
			}
		}
		.opacity(isEnabled ? 1.0 : 0.4)
		.coordinateSpace(name: "FMSegmentControl")
		.background(alignment: .topLeading, content: {
			if let se = selectedCellPosition
			{
				config.selectedBackground()
					.position(x: se.midX, y: se.midY)
					.frame(width: se.width, height: se.height)
			}
		})
		.onChange(of: selection.wrappedValue, initial: true, { oldValue, newValue in
			if let p = cellPositions[newValue]
			{
				withAnimation(.bouncy(duration: 0.2)/*  .easeOut(duration: 0.2)*/){
					selectedCellPosition = p
				}
			}
		})
		.onChange(of: cellPositionsChanged, initial: true, { oldValue, newValue in
			if let p = cellPositions[selection.wrappedValue]
			{
				selectedCellPosition = p
			}
		})
		.applyModifier(config.background())
	}
	
	public func withConfig(_ conf: (_ config: FMSegmentControlConfig) -> FMSegmentControlConfig) -> Self
	{
		var result = self
		result.config = conf(config)
		return result
	}

}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
public struct FMSegmentControlConfig
{
	var backgroundCornerRadius: CGFloat = 8
	var selectedBackgroundCornerRadius: CGFloat = 6
	var selectedBackground: () -> AnyView = {
		AnyView(SegmentDefaultSelectedBackground())
	}
	
	var buttonStyle: ((_ isSelected: Bool, _ isEnabled: Bool, _ colorScheme: ColorScheme) ->  AnyButtonStyle) = { isSelected, isEnabled, colorScheme in
		AnyButtonStyle(SegmentDefaultButtonStyle(isSelected: isSelected, isEnabled: isEnabled, colorScheme: colorScheme))
	}
	
	var background: () -> AnyViewModifierApplier = {
		AnyViewModifierApplier(SegmentDefaultModifier())
	}
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
private struct SegmentDefaultButtonStyle: ButtonStyle {
	var isSelected: Bool
	var isEnabled: Bool
	var colorScheme: ColorScheme
	//@Environment(\.colorScheme) var colorScheme

	func makeBody(configuration: Configuration) -> some View {
		ZStack {
			configuration.label
				.font(.caption)
				.fontWeight(.medium)
				.foregroundStyle(colorScheme == .dark ? .white : .black)
				.padding(.vertical, 6)
				.padding(.horizontal, 10)
				
		}
	}
}

private struct SegmentDefaultModifier: ViewModifier {
	@Environment(\.colorScheme) var colorScheme
	func body(content: Content) -> some View {
		content
			.padding(2)
			.background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.2))
			.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}

private struct SegmentDefaultSelectedBackground: View{
	@Environment(\.colorScheme) var colorScheme
	var body: some View{
		RoundedRectangle(cornerRadius: 6)
			.fill(colorScheme == .dark ? Color.black.opacity(0.4) : Color.white.opacity(0.6))
	}
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
private struct ValuePickerOptions<Value: Hashable>: _VariadicView.MultiViewRoot {
	private let selectedValue: Binding<Value>
	private var cellPositions: Binding<[Value: CGRect]>
	private var cellPositionsChanged: Binding<Int64>
	private var config: FMSegmentControlConfig
	
	
	init(selectedValue: Binding<Value>,
		 cellPositions: Binding<[Value: CGRect]>,
		 cellPositionChanged: Binding<Int64>,
		 config: FMSegmentControlConfig)
	{
		self.selectedValue = selectedValue
		self.cellPositions = cellPositions
		self.cellPositionsChanged = cellPositionChanged
		self.config = config
	}
	
	@ViewBuilder
	func body(children: _VariadicView.Children) -> some View {
		ForEach(children) { child in
			ValuePickerOption(
				selectedValue: selectedValue,
				value: child[CustomTagValueTraitKey<Value>.self],
				cellPositions: cellPositions,
				cellPositionsChanged: cellPositionsChanged,
				config: config
			) {
				child
			}
			
		}
	}
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
private struct ValuePickerOption<Content: View, Value: Hashable>: View {
	
	private let selectedValue: Binding<Value>
	private let value: Value?
	private var cellPositions: Binding<[Value: CGRect]>
	private var cellPositionsChanged: Binding<Int64>
	private var config: FMSegmentControlConfig
	private let content: Content
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.isEnabled) var isEnabled

	init(
		selectedValue: Binding<Value>,
		value: CustomTagValueTraitKey<Value>.Value,
		cellPositions: Binding<[Value: CGRect]>,
		cellPositionsChanged: Binding<Int64>,
		config: FMSegmentControlConfig,
		@ViewBuilder _ content: () -> Content
	) {
		self.selectedValue = selectedValue
		self.cellPositions = cellPositions
		self.cellPositionsChanged = cellPositionsChanged
		self.config = config
		self.value = if case .tagged(let tag) = value {
			tag
		} else {
			nil
		}
		self.content = content()
	}
	
	var body: some View {
		Button(
			action: {
				if let value {
					selectedValue.wrappedValue = value
				}
			},
			label: {
				HStack {
					content
						.frame(maxWidth: .infinity, alignment: .center)
				}
				.accessibilityElement(children: .combine)
				.accessibilityAddTraits(isSelected ? .isSelected : [])
			}
		)
		.buttonStyle(config.buttonStyle(isSelected, isEnabled, colorScheme))
		.contentShape(Rectangle())
		.overlay{
			GeometryReader { geo in
				Color.clear
					.onChange(of: geo.size, initial: true) { oldValue, newValue in
						if let value
						{
							let fr = geo.frame(in: .named("FMSegmentControl"))
							if cellPositions[value].wrappedValue != fr
							{
								cellPositions[value].wrappedValue = fr
								cellPositionsChanged.wrappedValue += 1
							}
						}
					}
			}
		}
	}

	private var isSelected: Bool {
		selectedValue.wrappedValue == value
	}
	
	
}




extension View {
	public func pickerTag<V: Hashable>(_ tag: V) -> some View {
		_trait(CustomTagValueTraitKey<V>.self, .tagged(tag))
	}
}

private struct CustomTagValueTraitKey<V: Hashable>: _ViewTraitKey {
	enum Value {
		case untagged
		case tagged(V)
	}
	
	static var defaultValue: CustomTagValueTraitKey<V>.Value {
		.untagged
	}
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
private struct PreviewContent: View {
	@State private var selection = "Jo"
	
	var body: some View {
		NavigationStack {
			List {
				FMSegmentControl(selection: $selection) {
					ForEach(["Jo", "Jean", "Juan"], id: \.self) { name in
						Text(verbatim: name)
							.pickerTag(name)
					}
				}
			}
			.navigationTitle("CPicker (\(selection))")
		}
	}
}

@available(iOS 17.0, *)
@available(macOS 14.0, *)
@available(tvOS 17.0, *)
#Preview {
	PreviewContent()
}
