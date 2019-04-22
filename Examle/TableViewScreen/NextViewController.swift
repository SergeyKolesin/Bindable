//
//  NextViewController.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/5/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import UIKit
import Bindable

class NextViewController: UIViewController {

    var viewModel: Bindable<NextViewModel>! = Bindable(NextViewModel())

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func pressButton1(_ sender: Any) {
        DispatchQueue.global().async {
            if let cellModel = self.viewModel.value.nextCellViewModels.first {
                cellModel.updateTitle()
            }
        }
    }

    @IBAction func pressButton2(_ sender: Any) {
    }

}

extension NextViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.value.nextCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NextCell", for: indexPath) as? NextCell else {
            return UITableViewCell()
        }
        let cellModel = viewModel.value.nextCellViewModels[indexPath.row]
        cell.config(viewModel: cellModel)
        return cell
    }


}

extension NextViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.isSelected = false
        viewModel.value.updateCellTitle(for: indexPath.row)
    }
}
