//
//  FMFilePanel.swift
//  PDFScanner
//
//  Created by Farhad Malekpour on 6/18/23.
//  Copyright © 2023 Dayana Networks Ltd. All rights reserved.
//
// Original name was FAFilePanel


import Foundation
import SwiftUI

#if os(macOS)
import UniformTypeIdentifiers
import AppKit

@available(macOS 11.0, *)
private struct FMFilePanel: ViewModifier
{
	typealias Configuration = FMFilePanelConfiguration
	
	
	@Binding var isPresented: Bool
	@State var configurationDefault: Configuration
	@State var configurationBlock: Configuration.ConfigurationBlock?
	@State var onCompletion: (_ urls: [URL]?) -> Void
	
	
	func body(content: Content) -> some View {
		content
			.onChange(of: isPresented) { newValue in
				if newValue
				{
					presentDialog()
				}
			}
		
		
	}
	
	func presentDialog() {
		var conf = configurationDefault
		if let configBlock = configurationBlock
		{
			conf = configBlock(configurationDefault)
		}
		let panel = (conf.panelType == .Open ? NSOpenPanel() : NSSavePanel())
		panel.nameFieldLabel = conf.nameFieldLabel
		panel.nameFieldStringValue = conf.nameFieldStringValue
		panel.title = conf.title
		panel.prompt = conf.prompt
		panel.message = conf.message
		panel.directoryURL = conf.directoryUrl?.standardizedFileURL
		panel.canCreateDirectories = true
		
		if let panel = panel as? NSOpenPanel
		{
			panel.canChooseFiles = conf.canChooseFiles
			panel.canChooseDirectories = conf.canChooseDirectories
			panel.allowsMultipleSelection = conf.allowsMultipleSelection
		}

		let result = panel.runModal()
		
		if result == .OK, let panel = panel as? NSOpenPanel
		{
			onCompletion(panel.urls)
		}
		else if result == .OK, let url = panel.url
		{
			onCompletion([url])
		}
		else
		{
			onCompletion(nil)
		}
		isPresented = false
	}
	
}

@available(macOS 11.0, *)
public struct FMFilePanelConfiguration
{
	public typealias Configuration = FMFilePanelConfiguration
	public typealias ConfigurationBlock = (_ config: Configuration) -> Configuration
	
	fileprivate enum PanelType {
		case Open
		case Save
	}

	
	fileprivate var panelType: PanelType
	
	fileprivate var nameFieldLabel: String
	fileprivate var nameFieldStringValue: String
	fileprivate var title: String
	fileprivate var prompt: String
	fileprivate var message: String
	fileprivate var allowedContentTypes: [UTType]
	fileprivate var allowsOtherFileTypes: Bool
	fileprivate var directoryUrl: URL?
	
	fileprivate var canChooseFiles: Bool = false
	fileprivate var canChooseDirectories: Bool = false
	fileprivate var allowsMultipleSelection: Bool = false
	
	static var selectFileForReading: Configuration = Configuration(
		panelType: .Open,
		
		nameFieldLabel: "Open File:",
		nameFieldStringValue: "",
		title: "Open File",
		prompt: "Open",
		message: "",
		allowedContentTypes: [],
		allowsOtherFileTypes: false,
		
		canChooseFiles: true,
		canChooseDirectories: false,
		allowsMultipleSelection: false
		
	)
	
	static var selectFilesForReading: Configuration = .selectFileForReading.withAllowsMultipleSelection(true)
	
	static var selectDirectory: Configuration = Configuration(
		panelType: .Open,
		
		nameFieldLabel: "",
		nameFieldStringValue: "",
		title: "Select Directory",
		prompt: "Select Directory",
		message: "",
		allowedContentTypes: [],
		allowsOtherFileTypes: false,
		
		canChooseFiles: false,
		canChooseDirectories: true,
		allowsMultipleSelection: false
		
	)
	
	static var selectFileForWriting: Configuration = Configuration(
		panelType: .Save,
		
		nameFieldLabel: "Save as:",
		nameFieldStringValue: "",
		title: "Save File",
		prompt: "Save",
		message: "",
		allowedContentTypes: [],
		allowsOtherFileTypes: false
		
	)
	
	
	public func withNameFieldLabel(_ value: String) -> Configuration
	{
		var r = self;	r.nameFieldLabel = value;	return r
	}
	public func withNameFieldStringValue(_ value: String) -> Configuration
	{
		var r = self;	r.nameFieldStringValue = value;	return r
	}
	public func withTitle(_ value: String) -> Configuration
	{
		var r = self;	r.title = value;	return r
	}
	public func withPrompt(_ value: String) -> Configuration
	{
		var r = self;	r.prompt = value;	return r
	}
	public func withMessage(_ value: String) -> Configuration
	{
		var r = self;	r.message = value;	return r
	}
	public func withAllowedContentTypes(_ value: [UTType]) -> Configuration
	{
		var r = self;	r.allowedContentTypes = value;	return r
	}
	public func withAllowsOtherFileTypes(_ value: Bool) -> Configuration
	{
		var r = self;	r.allowsOtherFileTypes = value;	return r
	}
	public func withDirectoryUrl(_ value: URL?) -> Configuration
	{
		var r = self;	r.directoryUrl = value;	return r
	}
	
	
	public func withCanChooseFiles(_ value: Bool) -> Configuration
	{
		var r = self;	r.canChooseFiles = value;	return r
	}
	public func withCanChooseDirectories(_ value: Bool) -> Configuration
	{
		var r = self;	r.canChooseDirectories = value;	return r
	}
	public func withAllowsMultipleSelection(_ value: Bool) -> Configuration
	{
		var r = self;	r.allowsMultipleSelection = value;	return r
	}
	
	
}


@available(macOS 11.0, *)
public extension View {

	func faSelectFileForReading(isPresented: Binding<Bool>, configuration: FMFilePanelConfiguration.ConfigurationBlock?, onCompletion: @escaping (_ urls: [URL]?) -> Void) -> some View
	{
		modifier(FMFilePanel(isPresented: isPresented, configurationDefault: .selectFileForReading, configurationBlock: configuration, onCompletion: onCompletion))
	}

	func faSelectFilesForReading(isPresented: Binding<Bool>, configuration: FMFilePanelConfiguration.ConfigurationBlock?, onCompletion: @escaping (_ urls: [URL]?) -> Void) -> some View
	{
		modifier(FMFilePanel(isPresented: isPresented, configurationDefault: .selectFilesForReading, configurationBlock: configuration, onCompletion: onCompletion))
	}

	func faSelectFileForWriting(isPresented: Binding<Bool>, configuration: FMFilePanelConfiguration.ConfigurationBlock?, onCompletion: @escaping (_ urls: [URL]?) -> Void) -> some View
	{
		modifier(FMFilePanel(isPresented: isPresented, configurationDefault: .selectFileForWriting, configurationBlock: configuration, onCompletion: onCompletion))
	}

	func faSelectDirectory(isPresented: Binding<Bool>, configuration: FMFilePanelConfiguration.ConfigurationBlock?, onCompletion: @escaping (_ urls: [URL]?) -> Void) -> some View
	{
		modifier(FMFilePanel(isPresented: isPresented, configurationDefault: .selectDirectory, configurationBlock: configuration, onCompletion: onCompletion))
	}
}


@available(macOS 11.0, *)
struct FAFileImporterTest: View
{
	@State var mIsPresentingFileImporter: Bool = false
	var body: some View
	{
		VStack{
			Button {
				mIsPresentingFileImporter = true
			} label: {
				Text("Open Save Panel")
			}
			
		}
		/*
		.faFileOpen(isPresented: $mIsPresentingFileImporter, configuration: { config in
			config
				.withMessage("Please select destination")
		}, onCompletion: { url in
			if let url
			{
				print("success: \(url)")
			}
			else
			{
				print("Cancel")
			}
		})
		*/
	}
}

#endif
