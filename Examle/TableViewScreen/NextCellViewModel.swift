//
//  NextCellViewModel.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/5/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import Foundation

class NextCellViewModel: NSObject {
    @objc dynamic var title: String?
    init(title: String?) {
        self.title = title
    }

    func updateTitle() {
        title = (title ?? "") + "q"
    }
}
