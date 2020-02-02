//
//  ErViewController.swift
//  Exchange Rate
//
//  Created by dimas pratama on 02/02/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import UIKit

class ErViewController : UIViewController {
    
    @IBOutlet weak var firstCurrency: UILabel!
    @IBOutlet weak var secondCurrency: UILabel!
    
    var erManager = ErManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        erManager.delegate = self
        erManager.fetchMoney()
    }
    
    @IBAction func switchPressed(_ sender: UIButton) {
        let temp = firstCurrency.text
               firstCurrency.text = secondCurrency.text
               secondCurrency.text = temp
    }
}

extension ErViewController: ErManagerDelegate{
    func didUpdateExchange(_ erManager: ErManager, exchange: ErModel) {
        DispatchQueue.main.async {
//            self.
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
