//
//  T4Log.swift
//  FarhadLibrarySwift
//
//  Created by Farhad Malekpour on 12/13/24.
//

import Foundation

public extension T4
{
	@available(tvOS 13.4, *)
	@available(macOS 10.15.4, *)
	@available(iOS 13.4, *)
	actor Log
	{
		static let shared = T4.Log()
		private let mLogsDateFormatter: DateFormatter = DateFormatter()
		private var mBuffer: [String] = []
		private init() {
			self.mLogsDateFormatter.dateFormat = "dd-hh:mm:ss.SSS"
		}
		
		
		static fileprivate func printv(_ items: Any...)
		{
			var st: String = ""
			print(items, to: &st)
			Task{
				let stamp = "[\(Log.shared.mLogsDateFormatter.string(from: Date()))]"
				st = String(st.trimmingCharacters(in: .whitespacesAndNewlines).prefix(256))
				if st.hasPrefix("["), st.hasSuffix("]")
				{
					st.removeFirst()
					st.removeLast()
					if st.hasPrefix("\""), st.hasSuffix("\"")
					{
						st.removeFirst()
						st.removeLast()
					}
				}
				st = stamp + " " + st + "\n"
				print(st, separator: "", terminator: "")
				var cr: [String] = UserDefaults.standard.stringArray(forKey: "T4LOGS") ?? []
				cr.append(st)
				UserDefaults.standard.set(Array(cr.suffix(100)), forKey: "T4LOGS")
			}
		}
		
		public static func getLogs() -> [String]
		{
			UserDefaults.standard.stringArray(forKey: "T4LOGS") ?? []
		}
	}
}


@available(tvOS 13.4, *)
@available(macOS 10.15.4, *)
@available(iOS 13.4, *)
public func printv(_ items: Any...)
{
	T4.Log.printv(items)
}

@available(tvOS 13.4, *)
@available(macOS 10.15.4, *)
@available(iOS 13.4, *)
public func T4Log(_ items: Any...)
{
	T4.Log.printv(items)
}
