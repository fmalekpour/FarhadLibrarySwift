//
//  FAVisualEffectView-mac.swift
//  FarhadLibraryMac
//
//  Created by Farhad Malekpour on 1/2/23.
//

import SwiftUI

#if os(macOS)

@available(macOS 12.0, *)
public struct FMWindowFinder: ViewModifier {
	
	var runBlock: (_ window: NSWindow) -> Void
	@State var wmTag: Int = Int((Int32(truncatingIfNeeded: UInt32(arc4random())/2) % (999999999)))
	
	
	public func body(content: Content) -> some View {
		
		content
			.overlay(content: {
				FMWindowFinderTempView(tag: $wmTag)
			})
			.onAppear(perform: {
				Task(priority: .background) {
					for _ in 0..<5000
					{
						if NSApp.windows.count > 0
						{
							break
						}
						else
						{
							print(".")
						}
						try await Task.sleep(nanoseconds: 1000000) //0.001 seconds
					}
					DispatchQueue.main.async {
						for win in NSApp.windows
						{
							if let cn = win.contentView, cn.viewWithTag(wmTag) != nil
							{
								runBlock(win)
								break
							}
							
						}
					}
				}
			})
	}
}

struct FMWindowFinderTempView: NSViewRepresentable {
	
	@Binding var tag: Int
	
	class WFT_VIEW: NSView {
		private var _tag: Int = -1
		override var tag: Int {
			get {
				return _tag
			}
			set {
				_tag = newValue
			}
		}
		init(frame frameRect: NSRect, tag: Int) {
			super.init(frame: frameRect)
			self.tag = tag
		}
		required init?(coder: NSCoder) {
			super.init(coder: coder)
		}
	}
	
	func makeNSView(context: Context) -> WFT_VIEW {
		let RV = WFT_VIEW(frame: NSRect(x: 0, y: 0, width: 1, height: 1), tag: tag)
		RV.isHidden = true
		return RV
	}
	
	func updateNSView(_ nsView: WFT_VIEW, context: Context) {
		nsView.tag = tag
	}
}

public extension View {
	
	@available(macOS 12.0, *)
	func fmWindowFinder(_ runBlock: @escaping (_ window: NSWindow) -> Void) -> some View {
		modifier(FMWindowFinder(runBlock: runBlock))
	}
	
}


#endif




