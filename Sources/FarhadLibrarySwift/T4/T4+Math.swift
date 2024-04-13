//
//  File.swift
//  
//
//  Created by Farhad Malekpour on 4/12/24.
//

import Foundation

public extension T4
{
	static var PI: Double = 3.14159265359
	static var PI_HALF: Double = 1.57079632679
	static var PI_DOUBLE: Double = 6.28318530718
	
	static var CG_PI: CGFloat = 3.14159265359
	static var CG_PI_HALF: CGFloat = 1.57079632679
	static var CG_PI_DOUBLE: CGFloat = 6.28318530718
	
	static func R2D(_ radian: Double) -> Double
	{
		return (radian / T4.PI * 180.0)
	}
	
	static func D2R(_ degree: Double) -> Double
	{
		return (degree / 180.0 * T4.PI)
	}
	
	static func R2D(_ radian: CGFloat) -> CGFloat
	{
		return (radian / T4.CG_PI * 180.0)
	}
	
	static func D2R(_ degree: CGFloat) -> CGFloat
	{
		return (degree / 180.0 * T4.CG_PI)
	}
	
	static func FixDecimal(_ value: CGFloat, decimals: Int = 2) -> CGFloat
	{
		return CGFloat(self.FixDecimal(Double(value), decimals: decimals))
	}
	
	static func FixDecimal(_ value: Double, decimals: Int = 2) -> Double
	{
		let v = pow(10.0, Double(decimals))
		return round(value*v)/v
	}
	
	static func CAP<T: Comparable>(_ value: T , minimum: T, maximum: T) -> T
	{
		return max(min(value, maximum), minimum)
	}
	static func LIMIT<T: Comparable>(_ value: T , minimum: T, maximum: T) -> T
	{
		return max(min(value, maximum), minimum)
	}
	
	static func CONVERT<T: FloatingPoint>(_ value: T , fromStart: T, fromEnd: T, toStart: T, toEnd: T) -> T
	{
		let m1 = fromEnd - fromStart
		let m2 = value - fromStart
		let m3 = toEnd - toStart
		
		return ((m2 / m1) * m3) + toStart
	}

	
}
