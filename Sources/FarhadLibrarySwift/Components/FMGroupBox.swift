//
//  File.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 8/29/26.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
public struct FMGroupBox<TITLE, CONTENTS>: View where TITLE: View, CONTENTS: View {
	@ViewBuilder private var mTitle: () -> TITLE
	@ViewBuilder private var mContents: () -> CONTENTS
	
#if os(macOS)
	private var mBorderColor: Color = Color(nsColor: NSColor.separatorColor)
#elseif os(watchOS)
	private var mBorderColor: Color = Color(uiColor: UIColor.darkGray)
#else
	private var mBorderColor: Color = Color(uiColor: UIColor.separator)
#endif
	private var mHasTitle: Bool = true
	private var mCornerRadius: CGFloat = 8.0
	
	
	public init(@ViewBuilder _ contents: @escaping () -> CONTENTS, @ViewBuilder label: @escaping () -> TITLE) {
		self.mTitle = label
		self.mContents = contents
	}
	
	public func boxBorderColor(_ color: Color) -> FMGroupBox<TITLE, CONTENTS> {
		var copy = self
		copy.mBorderColor = color
		return copy
	}
	
	public func boxCornerRadius(_ radius: CGFloat) -> FMGroupBox<TITLE, CONTENTS> {
		var copy = self
		copy.mCornerRadius = radius
		return copy
	}
	
	@State private var mTitleSize: CGSize = .zero
	
	public var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			if mHasTitle
			{
				mTitle()
					.padding(.leading, mCornerRadius + 10)
					.fmReportSize(initial: true) { size in
						mTitleSize = size
					}
					.padding(.bottom, -8)
			}

			
			mContents()
				.clipShape(RoundedRectangle(cornerRadius: mCornerRadius))
			
		}
		.overlay(alignment: .topLeading) {
			Canvas(rendersAsynchronously: false) { context, size in
				let lineWidth = 1.0
				let rect = CGRect(x: 0, y: mTitleSize.height / 2, width: size.width, height: size.height - mTitleSize.height / 2)
					.insetBy(dx: 0.5, dy: 0.5)
				
				let path = openRoundedRect(rect: rect, radius: mCornerRadius, gapOffset: 4, gapWidth: mTitleSize.width)
				
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
		gapOffset: CGFloat,
		gapWidth: CGFloat
	) -> Path {
		var path = Path()
		
		if self.mHasTitle == false {
			path.addRoundedRect(in: rect, cornerSize: CGSize(width: radius, height: radius))
			return path
		}
		
		let r = min(radius, rect.width / 2, rect.height / 2)
		
		// Gap is on the top straight edge,
		// measured from the end of the top-left rounded corner.
		let gapStart = rect.minX + r + gapOffset
		let gapEnd   = gapStart + gapWidth - r + gapOffset
		
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

@available(iOS 17.0, *)
public extension FMGroupBox where TITLE == Text {
	init(_ title: String, @ViewBuilder _ contents: @escaping () -> CONTENTS) {
		self.mContents = contents
		self.mTitle = {
			Text(title)
				.font(.subheadline)
				.foregroundColor(.primary)
		}
	}
	init(@ViewBuilder _ contents: @escaping () -> CONTENTS) {
		self.mContents = contents
		self.mTitle = {
			Text("")
		}
		self.mHasTitle = false
	}
}

#Preview {
	if #available(iOS 17.0, *) {
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
				.padding()
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
				.padding()
			} label: {
				Text("Custom Title")
					.foregroundStyle(.indigo)
			}
			.boxBorderColor(.pink)
			.boxCornerRadius(12)
			
			
			FMGroupBox{
				HStack{
					Text("No Title")
					Spacer()
					Button {
						
					} label: {
						Text("Test")
					}
				}
				.padding()
			}
			
			FMGroupBox{
				HStack{
					Text("No Title Background")
					Spacer()
					Button {
						
					} label: {
						Text("Test")
					}
				}
				.padding()
				.background(content: {
					Color.red.opacity(0.2)
				})
			}
			.boxCornerRadius(16)
			

		}
		.padding()
	}
}

