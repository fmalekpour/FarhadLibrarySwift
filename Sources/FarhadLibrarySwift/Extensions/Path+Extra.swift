//
//  Path+Extra.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 4/6/25.
//

import Foundation
import SwiftUI

public extension Path {
	init(circleRadius radius:CGFloat)
	{
		self.init(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2.0, height: radius*2.0))
	}
	
	init(circleCenter center: CGPoint, radius: CGFloat)
	{
		self.init(ellipseIn: CGRect(x: -radius+center.x, y: -radius+center.y, width: radius*2.0, height: radius*2.0))
		
	}
	
	init(diamondRadius radius:CGFloat)
	{
		self.init({ path in
			path.move(to: CGPoint(x: 0.0, y: radius))
			path.addLines([
				CGPoint(x: radius, y: 0.0),
				CGPoint(x: 0.0, y: -radius),
				CGPoint(x: -radius, y: 0.0),
				CGPoint(x: 0.0, y: radius),
			])
			
		})
	}
	
	static func pointsOfCircle(center: CGPoint, radius: CGFloat, count: Int = 6) -> [CGPoint]
	{
		var RV: [CGPoint] = []
		let deg: CGFloat = 360.0/CGFloat(count)
		
		for d in stride(from: 0.0, to: 360, by: deg)
		{
			RV.append(CGPoint(x: center.x + (radius * cos(Double(T4.D2R(d)))), y: center.y + ( radius * sin(Double(T4.D2R(d))))))
		}
		return RV
	}
	
	func centralize() -> Path
	{
		let path = self
		return path.offsetBy(dx: -((path.boundingRect.width / 2.0) + path.boundingRect.origin.x), dy: -((path.boundingRect.height / 2.0) + path.boundingRect.origin.y) )
	}

	func contains(point: CGPoint, tolorance: CGFloat) -> Bool
	{
		let points = [
			point,
			CGPoint(x: point.x + tolorance, y: point.y),
			CGPoint(x: point.x - tolorance, y: point.y),
			CGPoint(x: point.x, y: point.y + tolorance),
			CGPoint(x: point.x, y: point.y - tolorance),
			CGPoint(x: point.x - tolorance, y: point.y - tolorance),
			CGPoint(x: point.x - tolorance, y: point.y + tolorance),
			CGPoint(x: point.x + tolorance, y: point.y - tolorance),
			CGPoint(x: point.x + tolorance, y: point.y + tolorance),
		]
		
		for p in points
		{
			if self.contains(p)
			{
				return true
			}
		}
		
		return false
	}

	/// Create a rectangle with 3 given points
	/// - Parameters:
	///   - pointA: First point
	///   - pointB: 2nd Point
	///   - pointC: 3rd point
	/// 
	mutating func addRectangle(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint)
	{
		self.addPath(Path({ path in
			path.move(to: pointA)
			path.addLine(to: pointB)
			path.addLine(to: pointC)
			path.addLine(to: self.getRectangleForthPoint(pointA: pointA, pointB: pointB, pointC: pointC))
			path.addLine(to: pointA)
			path.closeSubpath()
		}))
	}
	
	mutating func addCircle(center: CGPoint, radius: CGFloat)
	{
		self.addEllipse(in: CGRect(x: center.x-radius, y: center.y-radius, width: radius*2.0, height: radius*2.0))
	}
	
	func getRectangleForthPoint(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGPoint
	{
		// Calculate the midpoint of diagonal AC
		let M_x = (pointA.x + pointC.x) / 2
		let M_y = (pointA.y + pointC.y) / 2
		
		// Use the midpoint to find the coordinates of point D
		let xD = 2 * M_x - pointB.x
		let yD = 2 * M_y - pointB.y
		
		return CGPoint(x: xD, y: yD)
	}
	

	
}
