//
//  UIImage+Extra.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 10/14/24.
//

import Foundation

#if os(iOS) || os(watchOS)
import UIKit

public extension UIImage {
	
	/// Creates a new image filled entirely with a solid color.
	/// - Parameters:
	///   - solidColor: The color to fill the image with.
	///   - size: The size of the resulting image. Defaults to a 1x1 point image.
	convenience init(solidColor: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bytesPerRow = 4 * Int(size.width)
		let context = CGContext(
			data: nil,
			width: Int(size.width),
			height: Int(size.height),
			bitsPerComponent: 8,
			bytesPerRow: bytesPerRow,
			space: colorSpace,
			bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
		)
		
		context?.setFillColor(solidColor.cgColor)
		context?.fill(rect)
		
		if let cgImage = context?.makeImage() {
			self.init(cgImage: cgImage)
		} else {
			self.init()
		}
	}
	
	/// Redraws the receiver's underlying `CGImage` into a new bitmap context of the given size,
	/// placing it within `drawRect`. Used internally by `scaleImage(toFit:)` and `scaleImage(toFill:)`.
	/// - Parameters:
	///   - size: The size of the destination bitmap context (i.e. the final image size).
	///   - drawRect: The rectangle, within the destination context, in which the image is drawn.
	/// - Returns: A new `UIImage` containing the redrawn content, or `nil` if the operation fails.
	private func drawing(size: CGSize, drawRect: CGRect) -> UIImage? {
		guard let cgImage = self.cgImage else { return nil }
		
		// `size`/`drawRect` are in points. The bitmap needs to be sized in pixels
		// (points * scale), otherwise the resulting UIImage (tagged with `scale`)
		// ends up reporting a point size that is `scale` times smaller than requested.
		let scale = self.scale
		let pixelWidth = Int((size.width * scale).rounded())
		let pixelHeight = Int((size.height * scale).rounded())
		guard pixelWidth > 0, pixelHeight > 0 else { return nil }
		
		let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = cgImage.bitmapInfo.rawValue != 0
		? cgImage.bitmapInfo.rawValue
		: CGImageAlphaInfo.premultipliedLast.rawValue
		
		guard let context = CGContext(
			data: nil,
			width: pixelWidth,
			height: pixelHeight,
			bitsPerComponent: 8,
			bytesPerRow: 0,
			space: colorSpace,
			bitmapInfo: bitmapInfo
		) else { return nil }
		
		context.interpolationQuality = .high
		// Scale the context so drawing coordinates (drawRect) can stay in points.
		context.scaleBy(x: scale, y: scale)
		context.draw(cgImage, in: drawRect)
		
		guard let outputImage = context.makeImage() else { return nil }
		return UIImage(cgImage: outputImage, scale: scale, orientation: .up)
	}

	/// Scales the image to fit entirely within the given size while preserving its aspect ratio.
	/// The resulting image will be no larger than `size` in either dimension, and may be smaller
	/// in one dimension if the aspect ratios don't match (no cropping occurs).
	/// - Parameter size: The bounding size to fit the image within.
	/// - Returns: A new, aspect-fit scaled `UIImage`, or `nil` if the operation fails.
	func scale(toFit size: CGSize) -> UIImage? {
		let aspectWidth = size.width / self.size.width
		let aspectHeight = size.height / self.size.height
		let aspectRatio = min(aspectWidth, aspectHeight)
		
		let newSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
		
		return drawing(size: newSize, drawRect: CGRect(origin: .zero, size: newSize))
	}
	
	/// Scales the image to completely fill the given size while preserving its aspect ratio.
	/// The image is scaled up (or down) so both dimensions cover `size`, then centered and
	/// cropped to exactly match `size` (any content extending beyond the bounds is clipped).
	/// - Parameter size: The exact size the resulting image should fill.
	/// - Returns: A new, aspect-fill scaled and cropped `UIImage`, or `nil` if the operation fails.
	func scale(toFill size: CGSize) -> UIImage? {
		let aspectWidth = size.width / self.size.width
		let aspectHeight = size.height / self.size.height
		let aspectRatio = max(aspectWidth, aspectHeight)
		
		let scaledSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)
		let origin = CGPoint(
			x: (size.width - scaledSize.width) / 2,
			y: (size.height - scaledSize.height) / 2
		)
		
		return drawing(size: size, drawRect: CGRect(origin: origin, size: scaledSize))
	}
}

#endif
