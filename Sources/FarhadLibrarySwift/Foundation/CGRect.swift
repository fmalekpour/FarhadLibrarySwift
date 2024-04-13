//
//  CGRect.swift
//
//
//  Created by Farhad Malekpour on 4/12/24.
//

import Foundation

public extension CGRect
{
	func fm_aspectFitRect(_ innerRect: CGRect) -> CGRect {
		
		// the width and height ratios of the rects
		let wRatio: CGFloat = self.size.width/innerRect.size.width
		let hRatio: CGFloat = self.size.height/innerRect.size.height
		
		// calculate scaling ratio based on the smallest ratio.
		let ratio: CGFloat = (wRatio < hRatio) ? wRatio : hRatio
		
		// The x-offset of the inner rect as it gets centered
		let xOffset: CGFloat = (self.size.width-(innerRect.size.width * ratio)) * 0.5
		
		// The y-offset of the inner rect as it gets centered
		let yOffset: CGFloat = (self.size.height-(innerRect.size.height*ratio)) * 0.5
		
		// aspect fitted origin and size
		let innerRectOrigin: CGPoint = CGPoint(x: xOffset+self.origin.x, y: yOffset+self.origin.y)
		let innerRectSize: CGSize = CGSize(width: innerRect.size.width*ratio, height: innerRect.size.height*ratio)
		
		return CGRect(origin: innerRectOrigin, size: innerRectSize)
	}
}
