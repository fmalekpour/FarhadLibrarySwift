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
	
	static var APP_RUNNING_STOREID: Int? {
		if let RV = Bundle.main.infoDictionary?["FMAppStoreID"] as? Int
		{
			return RV
		}
		return nil
	}
	
	@available(tvOS 16.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	static var DEVICE_UID: String {
		if let uid = UserDefaults.standard.string(forKey: "_app_deviceUUID")
		{
			return uid
		}
		
		let uid = UUID().uuidString.replacing("-", with: "")
		UserDefaults.standard.set(uid, forKey: "_app_deviceUUID")
		return uid
		
	}
}
