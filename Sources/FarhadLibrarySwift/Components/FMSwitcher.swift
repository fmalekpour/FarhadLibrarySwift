//
//  FMSwitcher.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 10/15/26.
//

import SwiftUI

@available(iOS 17.0, *)
public struct FMSwitcher<Selection: Hashable>: View {
	
	public init(selectedItem: Binding<Selection>, items: [FMSwitcherItem<Selection>]) {
		self._selectedItem = selectedItem
		self.items = items
	}
	
	public func setLeftImage(_ image: Image) -> Self {
		let copy = self
		copy.mImageLeft = image
		return copy
	}
	
	public func setRightImage(_ image: Image) -> Self {
		let copy = self
		copy.mImageRight = image
		return copy
	}
	
	
	@Binding private var selectedItem: Selection
	private var items: [FMSwitcherItem<Selection>]

	@State private var mImageLeft: Image = Image(systemName: "chevron.left")
	@State private var mImageRight: Image = Image(systemName: "chevron.right")
	@State private var mSize: CGSize = CGSize(width: 1, height: 1)
	@State private var mOffset: CGFloat = 0
	
	public var body: some View {
		ZStack{
			ForEach(items, id: \.self) { item in
				Text(item.title)
					.lineLimit(1)
					.opacity(0.0)
			}
		}
		.padding(.vertical, 4)
		.padding(.horizontal, 20)
		.overlay(alignment: .leading, content: {
			HStack(spacing: 0, content: {
				ForEach(items, id: \.self) { item in
					Text(item.title)
						.lineLimit(1)
						.minimumScaleFactor(0.8)
						.padding(.horizontal, 20)
						.frame(width: mSize.width, alignment: .center)
						.clipped()
				}
			})
			.offset(x: mOffset)
		})
		.fmReportSize(initial: true, { size in
			if size.width > mSize.width
			{
				mSize = size
			}
		})
		.overlay(content: {
			HStack {
				Button {
					leftClicked()
				} label: {
					HStack{
						mImageLeft
							.imageScale(.small)
							.scaleEffect(0.85)
							.foregroundStyle(.tint)
						Spacer()
					}
					.padding(.leading, 5)
					.frame(maxHeight: .infinity)
					.opacity(selectedItem == items.first?.id ? 0.7 : 1.0)
					.grayscale(selectedItem == items.first?.id ? 1.0 : 0.0)
				}
				.disabled(selectedItem == items.first?.id)
				
				
				
				
				Button {
					rightClicked()
				} label: {
					HStack{
						Spacer()
						mImageRight
							.imageScale(.small)
							.scaleEffect(0.85)
							.foregroundStyle(.tint)
					}
					.padding(.trailing, 5)
					.frame(maxHeight: .infinity)
					.opacity(selectedItem == items.last?.id ? 0.7 : 1.0)
					.grayscale(selectedItem == items.last?.id ? 1.0 : 0.0)
				}
				.disabled(selectedItem == items.last?.id)
				
			}
			.buttonStyle(.borderless)
			.buttonRepeatBehavior(.enabled)

		})
		.onChange(of: selectedItem, initial: true, { oldValue, newValue in
			if let newItem = items.first(where: { $0.id == newValue })
			{
				moveToItem(newItem, animated: oldValue != newValue)
			}
		})
		.clipped()
	}
	
	private func leftClicked()
	{
		items.first(where: { $0.id == selectedItem }).map { currentItem in
			if let currentIndex = items.firstIndex(of: currentItem), currentIndex > 0
			{
				let newItem = items[currentIndex - 1]
				selectedItem = newItem.id
			}
		}
	}
	
	private func rightClicked()
	{
		items.first(where: { $0.id == selectedItem }).map { currentItem in
			if let currentIndex = items.firstIndex(of: currentItem), currentIndex < items.count - 1
			{
				let newItem = items[currentIndex + 1]
				selectedItem = newItem.id
			}
		}
	}
	
	private func moveToItem(_ item: FMSwitcherItem<Selection>, animated: Bool = true)
	{
		let index = items.firstIndex(of: item) ?? 0
		if animated
		{
			withAnimation(.bouncy(duration: 0.2)) {
				mOffset = CGFloat(-index) * mSize.width
			}
		}
		else
		{
			mOffset = CGFloat(-index) * mSize.width
		}
	}
}

public struct FMSwitcherItem<ID: Hashable>: Hashable
{
	public var id: ID
	public var title: String
	
	public init(id: ID, title: String) {
		self.id = id
		self.title = title
	}
	
	public static func Item(id: ID, title: String) -> Self
	{
		FMSwitcherItem(id: id, title: title)
	}
}

@available(iOS 17.0, *)
public extension FMSwitcher where Selection == Bool {
	static func BinarySwitcher(
		isOn: Binding<Bool>,
		leftTitle: String = "Off",
		rightTitle: String = "On"
	) -> Self {
		FMSwitcher(selectedItem: isOn, items: [
			FMSwitcherItem(id: false, title: leftTitle),
			FMSwitcherItem(id: true, title: rightTitle)
		])
	}
}


@available(iOS 17.0, *)
private struct FMSwitcherPreview: View {
	@State var selectedItem: Int = 2
	@State var isOn: Bool = true
	var body: some View {
		
		VStack{
			FMSwitcher(selectedItem: $selectedItem, items: [
				FMSwitcherItem(id: 1, title: "Item 1"),
				FMSwitcherItem(id: 2, title: "Another Item 2"),
				FMSwitcherItem(id: 3, title: "Item 385")
			])

			FMSwitcher(selectedItem: $selectedItem, items: [
				FMSwitcherItem(id: 1, title: "Item 1"),
				FMSwitcherItem(id: 2, title: "Another Item 2"),
				FMSwitcherItem(id: 3, title: "Item 385")
			])
			.font(.footnote)
			
			FMSwitcher(selectedItem: $selectedItem, items: [
				FMSwitcherItem(id: 1, title: "Item 1"),
				FMSwitcherItem(id: 2, title: "Another Item 2"),
				FMSwitcherItem(id: 3, title: "Item 385")
			])
			.tint(.green)
			.frame(width: 100)

			FMSwitcher(selectedItem: $selectedItem, items: [
				FMSwitcherItem(id: 1, title: "Item 1"),
				FMSwitcherItem(id: 2, title: "Another Item 2"),
				FMSwitcherItem(id: 3, title: "Item 385")
			])
			.foregroundStyle(.white, .green)
			.tint(.yellow)
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.brown)
			}
			
			HStack{
				FMSwitcher.BinarySwitcher(isOn: $isOn)
				Text("Value: \(isOn ? "On" : "Off")")
			}

		}
	}
}


#Preview {
	if #available(iOS 17.0, *) {
		FMSwitcherPreview()
	} else {
		// Fallback on earlier versions
	}
}
