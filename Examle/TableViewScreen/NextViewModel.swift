//
//  NextViewModel.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/5/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import Foundation

class NextViewModel: NSObject {

    var nextCellViewModels = [NextCellViewModel]()

    override init() {
        for i in 0..<20 {
            nextCellViewModels.append(NextCellViewModel(title: String(i)))
        }
    }

    func updateCellTitle(for index: Int) {
        if index >= 0 && index < nextCellViewModels.count {
            nextCellViewModels[index].updateTitle()
        }
    }
}
