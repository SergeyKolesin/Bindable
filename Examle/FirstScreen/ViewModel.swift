//
//  ViewModel.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/1/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import Foundation

class ViewModel: NSObject {
    @objc dynamic var counter: Int
    @objc dynamic var title = "title"
    init(counter: Int = 0) {
        self.counter = counter
    }

    func increaseCounter() {
        counter += 1
    }

    func changeTitle() {
        title = "title" + String(Int.random(min: 0, max:100))
    }
}

extension Int {
    static func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}
