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

        guard let gift = newGiftTextField.text else {return}
        guard let price = newPriceTextField.text else {return}
        guard let priceInt = Int(price) else {return}
        Persistance.shared.add(item: gift, price: priceInt)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
