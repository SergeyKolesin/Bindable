//
//  ViewController.swift
//  Bindable
//
//  Created by Sergei Kolesin on 4/1/19.
//  Copyright © 2019 Sergei Kolesin. All rights reserved.
//

import UIKit
import Bindable

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    var binded = false
    
    var viewModel: Bindable<ViewModel>?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = Bindable(ViewModel(counter: 3))
        bindUnbind()
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showNextViewController" {
//            if let vc = segue.destination as? NextViewController {
//                vc.viewModel = Bindable(NextViewModel())
//            }
//        }
//    }

    @IBAction func pressButton(_ sender: Any) {
        viewModel?.value.increaseCounter()
    }

    @IBAction func changeTitle(_ sender: Any) {
        viewModel?.value.changeTitle()
    }

    @IBAction func deleteLabel(_ sender: Any) {
        viewModel?.unbind(object: label2)
    }
    
    @IBAction func pressBindButton(_ sender: Any) {
        bindUnbind()
    }

    func configLabel1() {
        viewModel?.bind(\.counter, to: label1, \.text, transform: String.init)
    }

    func configLabel2() {
        viewModel?.bind(\.counter, to: label2, \.text, transform: {String($0+1)})
    }

    func configTitle() {
        viewModel?.bind(\.title, to: self, \.title)
    }

    func bindUnbind() {
        if binded {
            viewModel?.unbind()
        } else {
            configTitle()
            configLabel1()
            configLabel2()
        }
        binded = !binded

    }
    
}

