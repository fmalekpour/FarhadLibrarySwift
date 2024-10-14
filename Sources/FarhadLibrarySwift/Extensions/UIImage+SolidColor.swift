//
//  File.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 10/14/24.
//

import Foundation


#if os(iOS)
import UIKit

public extension UIImage {
	
	convenience init(solidColor: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let format = UIGraphicsImageRendererFormat()
		format.scale = 1
		let image = UIGraphicsImageRenderer(size: size, format: format).image { context in
			solidColor.setFill()
			context.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
		}
		self.init(cgImage: image.cgImage!)
	}
}

#endif
