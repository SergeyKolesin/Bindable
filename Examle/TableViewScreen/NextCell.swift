//
//  NextCell.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/15/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import UIKit
import Bindable

class NextCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    var viewModel: Bindable<NextCellViewModel>? {
        didSet {
            oldValue?.unbind()
        }
    }

    func config(viewModel: NextCellViewModel) {
        self.viewModel = Bindable(viewModel)
        self.viewModel?.bind(\NextCellViewModel.title, to: titleLabel, \.text)
    }
}
