//
//  Bindable.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/22/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import Foundation

open class Bindable<Value: NSObject> {
    private var observations = [NSKeyValueObservation : (Value, AnyObject?) -> Bool]()
    open var value: Value
    private let onMainThread: Bool
    public init(_ value: Value, onMainThread: Bool = true) {
        self.value = value
        self.onMainThread = onMainThread
    }
}

private extension Bindable {
    func addObservation<O: AnyObject, T>(
        sourceKeyPath: KeyPath<Value, T>,
        for object: O,
        handler: @escaping (O, Value) -> Void
        )
    {
        handler(object, value)
        var block: (() -> Void)?
        let observer = value.observe(sourceKeyPath, options: [.old, .new], changeHandler: { (value, change) in
            block?()
        })
        observations[observer] = { [weak object, weak self] value, deleteObject in
            guard let self = self, let object = object, object !== deleteObject  else {
                return false
            }
            if self.onMainThread && !Thread.isMainThread {
                DispatchQueue.main.async {
                    handler(object, value)
                }
            } else {
                handler(object, value)
            }
            return true
        }
        block = { [weak self, weak observer] in
            if let self = self, let observer = observer {
                let mark = self.observations[observer]?(self.value, nil) ?? false
                if !mark {
                    self.observations.removeValue(forKey: observer)
                }
            }
        }
    }

    func update() {
        observations = observations.filter({ (key, action) -> Bool in
            return action(value, nil)
        })
    }
}

public extension Bindable {
    func bind<O: AnyObject, T>(
        _ sourceKeyPath: KeyPath<Value, T>,
        to object: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, T>
        ) {
        addObservation(sourceKeyPath: sourceKeyPath, for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }

    func bind<O: AnyObject, T>(
        _ sourceKeyPath: KeyPath<Value, T>,
        to object: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, T?>
        ) {
        addObservation(sourceKeyPath: sourceKeyPath, for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            object[keyPath: objectKeyPath] = value
        }
    }

    func bind<O: AnyObject, T, R>(
        _ sourceKeyPath: KeyPath<Value, T>,
        to object: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, R>,
        transform: @escaping (T) -> R
        ) {
        addObservation(sourceKeyPath: sourceKeyPath, for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            let transformed = transform(value)
            object[keyPath: objectKeyPath] = transformed
        }
    }

    func bind<O: AnyObject, T, R>(
        _ sourceKeyPath: KeyPath<Value, T>,
        to object: O,
        _ objectKeyPath: ReferenceWritableKeyPath<O, R?>,
        transform: @escaping (T) -> R?
        ) {
        addObservation(sourceKeyPath: sourceKeyPath, for: object) { object, observed in
            let value = observed[keyPath: sourceKeyPath]
            let transformed = transform(value)
            object[keyPath: objectKeyPath] = transformed
        }
    }

    func unbind() {
        observations.removeAll()
    }

    func unbind<O: AnyObject>(object: O) {
        observations = observations.filter({ (key, action) -> Bool in
            return action(value, object)
        })
    }
}
