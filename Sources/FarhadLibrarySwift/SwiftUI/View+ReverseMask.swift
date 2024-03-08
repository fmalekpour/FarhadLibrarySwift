//
//  View+ReverseMask.swift
//  Created by Farhad Malekpour on 12/17/23.
//

import Foundation
import SwiftUI

@available(tvOS 15.0, *)
@available(iOS 15.0, *)
@available(macOS 12.0, *)
extension View {
	@inlinable
	public func fmReverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View
	{
		self.mask 
		{
			Rectangle()
				.overlay(alignment: alignment) {
					mask()
						.blendMode(.destinationOut)
				}
		}
	}
}
