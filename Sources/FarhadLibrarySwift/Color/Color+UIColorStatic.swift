//
//  Color+UIColorStatic.swift
//
//
//  Created by Farhad Malekpour on 2/10/24.
//

import Foundation
import SwiftUI

#if os(iOS)

@available(iOS 15.0, *)
public extension Color
{
	static var fmTintColor = Color(uiColor: .tintColor)
	static var fmLabel = Color(uiColor: .label)
	static var fmSecondaryLabel = Color(uiColor:.secondaryLabel)
	static var fmTtertiaryLabel = Color(uiColor:.tertiaryLabel)
	static var quaternaryLabel = Color(uiColor:.quaternaryLabel)
	static var fmLink = Color(uiColor:.link)
	static var fmPlaceholderText = Color(uiColor:.placeholderText)
	static var fmSeparator = Color(uiColor:.separator)
	static var fmOpaqueSeparator = Color(uiColor:.opaqueSeparator)
	static var fmSystemBackground = Color(uiColor:.systemBackground)
	static var fmSecondarySystemBackground = Color(uiColor:.secondarySystemBackground)
	static var fmTertiarySystemBackground = Color(uiColor:.tertiarySystemBackground)
	static var fmSystemGroupedBackground = Color(uiColor:.systemGroupedBackground)
	static var fmSecondarySystemGroupedBackground = Color(uiColor:.secondarySystemGroupedBackground)
	static var fmTertiarySystemGroupedBackground = Color(uiColor:.tertiarySystemGroupedBackground)
	static var fmSystemFill = Color(uiColor:.systemFill)
	static var fmSecondarySystemFill = Color(uiColor:.secondarySystemFill)
	static var fmTertiarySystemFill = Color(uiColor:.tertiarySystemFill)
	static var fmQuaternarySystemFill = Color(uiColor:.quaternarySystemFill)
	static var fmLightText = Color(uiColor:.lightText)
	static var fmDarkText = Color(uiColor:.darkText)
}

#endif
