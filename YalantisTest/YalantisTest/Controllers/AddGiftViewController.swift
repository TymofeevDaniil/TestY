//
//  AddGiftViewController.swift
//  YalantisTest
//
//  Created by Danil Tymofeev on 01.09.2021.
//

import UIKit

protocol NewGift{
    func add(window: AddGiftViewController)
}

class AddGiftViewController: UIViewController {
    
    var delegate: NewGift?
    @IBOutlet weak var newGiftTextField: UITextField!
    @IBOutlet weak var newPriceTextField: UITextField!
    @IBAction func addGiftButton(_ sender: Any) {
        //delegate?.add(window: self)
        guard let gift = newGiftTextField.text else {return}
        guard let price = newPriceTextField.text else {return}
        guard let priceInt = Int(price) else {return}
        Persistance.shared.add(item: gift, price: priceInt)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//extension ListViewController: NewGift{
//    func add(window: AddGiftViewController) {
//        guard let gift = window.newGiftTextField.text else {return}
//        guard let price = window.newPriceTextField.text else {return}
//        guard let priceInt = Int(price) else {return}
//        Persistance.shared.add(item: gift, price: priceInt)
//        (giftList, priceList, checkList) = Persistance.shared.download()
//        listTableView.reloadData()
//        self.view.layoutSubviews()
//    }
//}
