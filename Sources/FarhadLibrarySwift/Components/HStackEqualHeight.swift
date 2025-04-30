//
//  HStack_FMEqualHeight.swift
//  FarhadLibrary-xcode4.0
//
//  Created by Farhad Malekpour on 5/1/23.
//
// Original name was HStack_FMEqualHeight

import Foundation
import SwiftUI

@available(tvOS 16.0, *)
@available(macOS 13.0, *)
@available(iOS 16.0, *)
fileprivate struct HStackEqualHeight_Layout: Layout
{
	var spacing: CGFloat = .nan
	
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		let maxSize = maxSize(subviews: subviews)
		let spacing = spacing(subviews: subviews)
		let totalSpacing = spacing.reduce(0.0, +)
		
		return CGSize(width: maxSize.width * CGFloat(subviews.count) + totalSpacing,
					  height: maxSize.height)
	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		let maxSize = maxSize(subviews: subviews)
		let spacing = spacing(subviews: subviews)
		
		let sizeProposal = ProposedViewSize(width: maxSize.width,
											height: maxSize.height)
		
		var x = bounds.minX + maxSize.width / 2
		
		for index in subviews.indices {
			subviews[index].place(at: CGPoint(x: x, y: bounds.midY),
								  anchor: .center,
								  proposal: sizeProposal)
			
			x += maxSize.width + spacing[index]
		}
	}
	
	private func maxSize(subviews: Subviews) -> CGSize {
		
		let subviewSizes = subviews.map { $0.sizeThatFits(.unspecified) }
		
		let maxSize: CGSize = subviewSizes.reduce(.zero, { result, size in
			CGSize(width: max(result.width, size.width),
				   height: max(result.height, size.height))
		})
		
		return maxSize
	}
	
	private func spacing(subviews: Subviews) -> [CGFloat] {
		
		subviews.indices.map { index in
			
			guard index < subviews.count - 1 else { return 0.0 }
			
			if spacing.isNaN
			{
				return subviews[index].spacing.distance(to: subviews[index + 1].spacing,
														along: .horizontal)
			}
			else
			{
				return spacing
			}
		}
	}
}

@available(tvOS 16.0, *)
@available(macOS 13.0, *)
@available(iOS 16.0, *)
public struct HStackEqualHeight<C: View>: View
{
	private var spacing: CGFloat
	@ViewBuilder private var content: () -> C
	
	public init(spacing: CGFloat = .nan, @ViewBuilder content: @escaping () -> C) {
		self.spacing = spacing
		self.content = content
	}

	public var body: some View
	{
		HStackEqualHeight_Layout(spacing: self.spacing)
		{
			content()
		}
	}
}
