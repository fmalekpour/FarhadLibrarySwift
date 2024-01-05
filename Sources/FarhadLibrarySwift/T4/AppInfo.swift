//
//  AppInfo.swift
//
//
//  Created by Farhad Malekpour on 1/4/24.
//

import Foundation

public extension T4 {
	static var APP_RUNNING_VER: String {
		if let RV = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		{
			return String(RV)
		}
		return ""
	}
	
	static var APP_RUNNING_BUILD: String {
		if let RV = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
		{
			return String(RV)
		}
		return ""
	}
	
	static var APP_RUNNING_ID: String {
		if let RV = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
		{
			return String(RV)
		}
		return ""
	}

}
