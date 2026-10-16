//
//  HStackEqualWidth.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 4/16/25.
//

import Foundation
import SwiftUI

@available(tvOS 16.0, *)
@available(macOS 13.0, *)
@available(iOS 16.0, *)
fileprivate struct HStackEqualWidth_Layout: Layout
{
		var spacing: CGFloat = .nan
	
		func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
			guard !subviews.isEmpty else { return .zero }
			
			let spacing = spacing(subviews: subviews)
			let totalSpacing = spacing.reduce(0.0, +)
			let idealSize = maxSize(subviews: subviews)
			let idealWidth = idealSize.width * CGFloat(subviews.count) + totalSpacing
			let width = finiteWidth(proposal.width) ?? idealWidth
			let itemWidth = max(0.0, (width - totalSpacing) / CGFloat(subviews.count))
			let height = maxHeight(subviews: subviews, width: itemWidth)
			
			return CGSize(width: width, height: height)
		}
		
		func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
			guard !subviews.isEmpty else { return }
			
			let spacing = spacing(subviews: subviews)
			let totalSpacing = spacing.reduce(0.0, +)
			let itemWidth = max(0.0, (bounds.width - totalSpacing) / CGFloat(subviews.count))
			let itemHeight = maxHeight(subviews: subviews, width: itemWidth)
			
			let sizeProposal = ProposedViewSize(width: itemWidth, height: itemHeight)
			
			var x = bounds.minX + itemWidth / 2
			
			for index in subviews.indices {
				subviews[index].place(at: CGPoint(x: x, y: bounds.midY),
									  anchor: .center,
									  proposal: sizeProposal)
				
				x += itemWidth + spacing[index]
			}
		}
		
		private func finiteWidth(_ width: CGFloat?) -> CGFloat? {
			guard let width, width.isFinite else { return nil }
			return max(0.0, width)
		}
		
		private func maxHeight(subviews: Subviews, width: CGFloat) -> CGFloat {
			let proposal = ProposedViewSize(width: width, height: nil)
			return subviews.map { $0.sizeThatFits(proposal).height }.max() ?? 0.0
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
public struct HStackEqualWidth<C: View>: View
{
		private var spacing: CGFloat
		@ViewBuilder private var content: () -> C
		
		public init(spacing: CGFloat = .nan, @ViewBuilder content: @escaping () -> C) {
			self.spacing = spacing
			self.content = content
		}

	public var body: some View
	{
			HStackEqualWidth_Layout(spacing: self.spacing)
		{
			content()
		}
	}
}
