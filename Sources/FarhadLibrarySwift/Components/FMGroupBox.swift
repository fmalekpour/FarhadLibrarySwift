//
//  File.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 8/29/26.
//

import Foundation
import SwiftUI

#if os(macOS)

public struct FMGroupBox<TITLE, CONTENTS>: View where TITLE: View, CONTENTS: View {
	@ViewBuilder var mTitle: () -> TITLE
	@ViewBuilder var mContents: () -> CONTENTS
	
	var mBorderColor: Color = Color(nsColor: NSColor.separatorColor)
	
	
	public init(@ViewBuilder _ contents: @escaping () -> CONTENTS, @ViewBuilder label: @escaping () -> TITLE) {
		self.mTitle = label
		self.mContents = contents
	}
	
	public func borderColor(_ color: Color) -> FMGroupBox<TITLE, CONTENTS> {
		var copy = self
		copy.mBorderColor = color
		return copy
	}
	
	@State private var mTitleSize: CGSize = CGSize(width: 10, height: 10)
	
	public var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			
			mTitle()
				.fmReportSize(initial: true) { size in
					mTitleSize = size
				}
				.padding(.horizontal, 20)
				.padding(.bottom, -8)

			
			mContents()
				.padding()
		}
		.overlay(alignment: .topLeading) {
			Canvas(rendersAsynchronously: false) { context, size in
				let lineWidth = 1.0
				let rect = CGRect(x: 0, y: mTitleSize.height / 2, width: size.width, height: size.height - mTitleSize.height / 2)
					.insetBy(dx: 0.5, dy: 0.5)
				
				let path = openRoundedRect(rect: rect, radius: 6, gapOffset: 6, gapWidth: mTitleSize.width + 16)
				
				context.stroke(path, with: .color(mBorderColor), lineWidth: lineWidth)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.id("ovr-\(mTitleSize.width)-\(mTitleSize.height)")
			.allowsHitTesting(false)
		}
	}
	
	private func openRoundedRect(
		rect: CGRect,
		radius: CGFloat,
		gapOffset: CGFloat = 10,
		gapWidth: CGFloat = 30
	) -> Path {
		var path = Path()
		
		let r = min(radius, rect.width / 2, rect.height / 2)
		
		// Gap is on the top straight edge,
		// measured from the end of the top-left rounded corner.
		let gapStart = rect.minX + r + gapOffset
		let gapEnd   = gapStart + gapWidth
		
		// Start immediately after the gap
		path.move(to: CGPoint(x: gapEnd, y: rect.minY))
		
		// Top-right
		path.addLine(to: CGPoint(x: rect.maxX - r, y: rect.minY))
		
		path.addArc(
			center: CGPoint(x: rect.maxX - r, y: rect.minY + r),
			radius: r,
			startAngle: .degrees(-90),
			endAngle: .degrees(0),
			clockwise: false
		)
		
		// Right
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - r))
		
		// Bottom-right
		path.addArc(
			center: CGPoint(x: rect.maxX - r, y: rect.maxY - r),
			radius: r,
			startAngle: .degrees(0),
			endAngle: .degrees(90),
			clockwise: false
		)
		
		// Bottom
		path.addLine(to: CGPoint(x: rect.minX + r, y: rect.maxY))
		
		// Bottom-left
		path.addArc(
			center: CGPoint(x: rect.minX + r, y: rect.maxY - r),
			radius: r,
			startAngle: .degrees(90),
			endAngle: .degrees(180),
			clockwise: false
		)
		
		// Left
		path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + r))
		
		// Top-left
		path.addArc(
			center: CGPoint(x: rect.minX + r, y: rect.minY + r),
			radius: r,
			startAngle: .degrees(180),
			endAngle: .degrees(270),
			clockwise: false
		)
		
		// Finish immediately before the gap
		path.addLine(to: CGPoint(x: gapStart, y: rect.minY))
		
		return path
	}
	
}

public extension FMGroupBox where TITLE == Text {
	init(_ title: String, @ViewBuilder _ contents: @escaping () -> CONTENTS) {
		self.mContents = contents
		self.mTitle = {
			Text(title)
				.font(.subheadline)
				.foregroundColor(.primary)
		}
	}
}

#Preview {
	VStack(spacing: 16){
		FMGroupBox("Hello"){
			HStack{
				Text("World")
				Spacer()
				Button {
					
				} label: {
					Text("Test")
				}
			}
		}
		
		FMGroupBox {
			HStack{
				Text("World")
				Spacer()
				Button {
					
				} label: {
					Text("Test")
				}
			}
		} label: {
			Text("Custom Title")
				.foregroundStyle(.indigo)
		}
		.borderColor(.pink)

	}
	.padding()
}

#endif
