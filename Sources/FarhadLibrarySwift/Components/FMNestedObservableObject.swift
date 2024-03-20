//
//  FMNestedObservableObject.swift
//  
//
//  Created by Farhad Malekpour on 3/20/24.
//

import Foundation
import Combine

@propertyWrapper
public struct NPublished<Value : ObservableObject> {
	
	public static subscript<T: ObservableObject>(
		_enclosingInstance instance: T,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
		storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
	) -> Value {
		
		get {
			if instance[keyPath: storageKeyPath].cancellable == nil, let publisher = instance.objectWillChange as? ObservableObjectPublisher   {
				instance[keyPath: storageKeyPath].cancellable =
				instance[keyPath: storageKeyPath].storage.objectWillChange.sink { _ in
					
					Task {
						await MainActor.run(body: {
							publisher.send()
						})
					}
					//publisher.send()
				}
			}
			
			return instance[keyPath: storageKeyPath].storage
		}
		set {
			
			if let cancellable = instance[keyPath: storageKeyPath].cancellable {
				cancellable.cancel()
			}
			if let publisher = instance.objectWillChange as? ObservableObjectPublisher   {
				instance[keyPath: storageKeyPath].cancellable =
				newValue.objectWillChange.sink { _ in
					Task {
						await MainActor.run(body: {
							publisher.send()
						})
					}
					
					//publisher.send()
				}
			}
			instance[keyPath: storageKeyPath].storage = newValue
		}
	}
	
	@available(*, unavailable,
				message: "This property wrapper can only be applied to classes"
	)
	public var wrappedValue: Value {
		get { fatalError() }
		set { fatalError() }
	}
	
	private var cancellable: AnyCancellable?
	private var storage: Value
	
	public init(wrappedValue: Value) {
		storage = wrappedValue
	}
}

