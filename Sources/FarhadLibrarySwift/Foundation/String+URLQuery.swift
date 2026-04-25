//
//  String+URLQuery.swift
//
//
//  Created by Farhad Malekpour on 3/8/24.
//

import Foundation

public extension String
{
	@available(tvOS 16.0, *)
	@available(macOS 13.0, *)
	@available(iOS 16.0, *)
	
	func fmParseQueryString() -> [String: Any]
	{
		if let parts = self.urlComponentsDictionary(), let queryItems = parts["queryItems"] as? [String: Any]
		{
			return queryItems
		}
		return [:]
		
		
		/*
		var RV: [String: Any] = [:]
		var bs = self
		
		if let index = bs.firstIndex(of: "?")
		{
			let qml = bs.index(after: index)
			bs = String(bs[qml...])
		}
		
		if let index = bs.firstIndex(of: "#")
		{
			bs = String(bs[..<index])
		}
		
		bs = bs.replacing("?", with: "&")
		bs = bs.replacing("#", with: "&")

		let comps = bs.split(separator: "&")
		for part in comps
		{
			let p = String(part).fmTrim()
			guard !p.isEmpty else { continue }
			let m = p.split(separator: ":")
			if m.count > 1
			{
				RV[String(m[0]).fmTrim()] = String(m[1]).fmTrim()
			}
		}
		
		return RV
		*/
	}

}

import Foundation

public extension String {
	
	/// Parses the string as a URL and extracts all components into a dictionary.
	/// - Returns: A `[String: Any]` dictionary containing URL components, or `nil` if the string is not a valid URL.
	///
	/// The returned dictionary may contain the following keys:
	/// - `scheme`: String (e.g., "https")
	/// - `user`: String (userinfo username, percent-decoded)
	/// - `password`: String (userinfo password, percent-decoded)
	/// - `host`: String (percent-decoded)
	/// - `port`: Int
	/// - `path`: String (percent-decoded)
	/// - `pathComponents`: [String] (non-empty path segments)
	/// - `fragment`: String (percent-decoded)
	/// - `query`: String (the raw query string)
	/// - `queryItems`: [String: Any] (parsed query parameters; repeated keys become arrays; nested
	///   `key[sub]=value` and `key[]=value` syntaxes are expanded into nested dictionaries / arrays)
	/// - `absoluteString`: String (the full normalized URL)
	func urlComponentsDictionary() -> [String: Any]? {
		let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return nil }
		
		// URLComponents handles most edge cases (IPv6 hosts, percent encoding, etc.).
		// Fall back to manually percent-encoding if the raw string contains characters
		// URLComponents would otherwise reject.
		let components: URLComponents? = {
			if let c = URLComponents(string: trimmed) { return c }
			if let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			   let c = URLComponents(string: encoded) {
				return c
			}
			return nil
		}()
		
		guard let comps = components else { return nil }
		
		var result: [String: Any] = [:]
		
		if let scheme = comps.scheme, !scheme.isEmpty {
			result["scheme"] = scheme
		}
		if let user = comps.user, !user.isEmpty {
			result["user"] = user
		}
		if let password = comps.password, !password.isEmpty {
			result["password"] = password
		}
		if let host = comps.host, !host.isEmpty {
			result["host"] = host
		}
		if let port = comps.port {
			result["port"] = port
		}
		
		let path = comps.path
		if !path.isEmpty {
			result["path"] = path
			let segments = path
				.split(separator: "/", omittingEmptySubsequences: true)
				.map { String($0).removingPercentEncoding ?? String($0) }
			if !segments.isEmpty {
				result["pathComponents"] = segments
			}
		}
		
		if let fragment = comps.fragment, !fragment.isEmpty {
			result["fragment"] = fragment
		}
		
		if let rawQuery = comps.percentEncodedQuery, !rawQuery.isEmpty {
			result["query"] = rawQuery
			
			// Prefer URLComponents.queryItems (already percent-decoded), but fall back
			// to manual parsing if the platform fails to populate it.
			let pairs: [(String, String?)]
			if let items = comps.queryItems {
				pairs = items.map { ($0.name, $0.value) }
			} else {
				pairs = String.parseQueryString(rawQuery)
			}
			
			let parsed = String.buildQueryDictionary(from: pairs)
			if !parsed.isEmpty {
				result["queryItems"] = parsed
			}
		}
		
		if let absolute = comps.url?.absoluteString ?? comps.string {
			result["absoluteString"] = absolute
		}
		
		return result
	}
	
	// MARK: - Helpers
	
	/// Manual fallback parser for query strings.
	private static func parseQueryString(_ query: String) -> [(String, String?)] {
		var results: [(String, String?)] = []
		// Support both `&` and `;` as separators (legacy spec).
		let pairs = query.split(whereSeparator: { $0 == "&" || $0 == ";" })
		for pair in pairs {
			if pair.isEmpty { continue }
			let parts = pair.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
			let rawKey = String(parts[0])
			let rawValue: String? = parts.count > 1 ? String(parts[1]) : nil
			// Form-encoded data uses `+` for spaces.
			let key = rawKey.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? rawKey
			let value = rawValue.map { $0.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? $0 }
			if !key.isEmpty {
				results.append((key, value))
			}
		}
		return results
	}
	
	/// Builds a `[String: Any]` from name/value pairs, handling repeated keys
	/// and bracketed nesting (`a[b]=1`, `a[]=1`).
	private static func buildQueryDictionary(from pairs: [(String, String?)]) -> [String: Any] {
		var dict: [String: Any] = [:]
		for (key, value) in pairs {
			let resolvedValue: Any = value ?? NSNull()
			let path = parseKeyPath(key)
			insert(value: resolvedValue, atPath: path, into: &dict)
		}
		return dict
	}
	
	/// Parses keys like `a[b][c]` into ["a", "b", "c"], or `a[]` into ["a", ""].
	private static func parseKeyPath(_ key: String) -> [String] {
		guard key.contains("[") else { return [key] }
		
		var components: [String] = []
		var current = ""
		var insideBrackets = false
		
		for ch in key {
			switch ch {
				case "[":
					if !insideBrackets {
						components.append(current)
						current = ""
						insideBrackets = true
					} else {
						current.append(ch)
					}
				case "]":
					if insideBrackets {
						components.append(current)
						current = ""
						insideBrackets = false
					} else {
						current.append(ch)
					}
				default:
					current.append(ch)
			}
		}
		if !current.isEmpty {
			components.append(current)
		}
		return components.isEmpty ? [key] : components
	}
	
	/// Recursively inserts a value into a nested structure, merging duplicates into arrays.
	private static func insert(value: Any, atPath path: [String], into dict: inout [String: Any]) {
		guard let firstKey = path.first else { return }
		let remaining = Array(path.dropFirst())
		
		if remaining.isEmpty {
			// Leaf: collapse repeated keys into arrays.
			if let existing = dict[firstKey] {
				if var arr = existing as? [Any] {
					arr.append(value)
					dict[firstKey] = arr
				} else {
					dict[firstKey] = [existing, value]
				}
			} else {
				dict[firstKey] = value
			}
			return
		}
		
		// Non-leaf: recurse into a child dictionary.
		var child = (dict[firstKey] as? [String: Any]) ?? [:]
		// Treat `a[]=x` as appending to an array under "a".
		if remaining == [""] {
			if var arr = dict[firstKey] as? [Any] {
				arr.append(value)
				dict[firstKey] = arr
			} else if let existing = dict[firstKey] {
				dict[firstKey] = [existing, value]
			} else {
				dict[firstKey] = [value]
			}
			return
		}
		insert(value: value, atPath: remaining, into: &child)
		dict[firstKey] = child
	}
}

