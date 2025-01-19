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
	static let fmTintColor = Color(uiColor: .tintColor)
	static let fmLabel = Color(uiColor: .label)
	static let fmSecondaryLabel = Color(uiColor:.secondaryLabel)
	static let fmTtertiaryLabel = Color(uiColor:.tertiaryLabel)
	static let quaternaryLabel = Color(uiColor:.quaternaryLabel)
	static let fmLink = Color(uiColor:.link)
	static let fmPlaceholderText = Color(uiColor:.placeholderText)
	static let fmSeparator = Color(uiColor:.separator)
	static let fmOpaqueSeparator = Color(uiColor:.opaqueSeparator)
	static let fmSystemBackground = Color(uiColor:.systemBackground)
	static let fmSecondarySystemBackground = Color(uiColor:.secondarySystemBackground)
	static let fmTertiarySystemBackground = Color(uiColor:.tertiarySystemBackground)
	static let fmSystemGroupedBackground = Color(uiColor:.systemGroupedBackground)
	static let fmSecondarySystemGroupedBackground = Color(uiColor:.secondarySystemGroupedBackground)
	static let fmTertiarySystemGroupedBackground = Color(uiColor:.tertiarySystemGroupedBackground)
	static let fmSystemFill = Color(uiColor:.systemFill)
	static let fmSecondarySystemFill = Color(uiColor:.secondarySystemFill)
	static let fmTertiarySystemFill = Color(uiColor:.tertiarySystemFill)
	static let fmQuaternarySystemFill = Color(uiColor:.quaternarySystemFill)
	static let fmLightText = Color(uiColor:.lightText)
	static let fmDarkText = Color(uiColor:.darkText)
}

#endif
