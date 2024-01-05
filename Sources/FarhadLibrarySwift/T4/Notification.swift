//
//  Notification.swift
//
//
//  Created by Farhad Malekpour on 1/4/24.
//

import Foundation

public extension T4 {

	static func POST_NC(_ name: Notification.Name)
	{
		Task {
			await MainActor.run(body: {
				NotificationCenter.default.post(name: name, object: nil)
			})
		}
	}
	static func POST_NC(_ name: Notification.Name, userInfo: [AnyHashable:Any])
	{
		Task {
			await MainActor.run(body: {
				NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
			})
		}
	}

}
