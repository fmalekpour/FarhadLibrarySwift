//
//  Color+Extensions.swift
//
//
//  Created by Farhad Malekpour on 12/21/23.
//

import Foundation
import SwiftUI

extension Color
{
	public static var faRandom: Color { Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
}

extension ShapeStyle where Self == Color
{
	public static var faRandom: Color { Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1)) }
}
