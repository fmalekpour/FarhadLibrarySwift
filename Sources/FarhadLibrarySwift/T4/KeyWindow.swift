//
//  KeyWindow.swift
//
//
//  Created by Farhad Malekpour on 1/4/24.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#endif

public extension T4
{
#if os(iOS) || os(tvOS)
	@available(iOS 13.0, *)
	@available(tvOS 16.0, *)
	static func getWindowScene() -> UIWindowScene?
	{
		
		for sc in UIApplication.shared.connectedScenes
		{
			if let sc = sc as? UIWindowScene, sc.activationState == .foregroundActive
			{
				return sc
			}
		}
		return nil;
	}
	
	
	static func getKeyWindow() -> UIWindow?
	{
		if #available(iOS 15.0, tvOS 16.0, *) {
			if let scene = T4.getWindowScene(), let keyWindow = scene.keyWindow
			{
				return keyWindow
			}
		}
		else if #available(iOS 13.0, *)
		{
			return UIApplication.shared.connectedScenes
				.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
				.first { $0.isKeyWindow }
		}
		else
		{
			return UIApplication.shared.keyWindow
		}
		
		return nil
	}
	#endif
}
