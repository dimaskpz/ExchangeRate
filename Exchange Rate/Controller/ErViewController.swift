//
//  ErViewController.swift
//  Exchange Rate
//
//  Created by dimas pratama on 02/02/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import UIKit

class ErViewController : UIViewController {
    
    
    @IBOutlet weak var firstCurrencyLabel: UILabel!
    
    @IBOutlet weak var secondCurrencyLabel: UILabel!
    @IBOutlet weak var firstCurrencyTextField: UITextField!
    @IBOutlet weak var secondCurrencyTextField: UITextField!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    var erManager = ErManager()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        erManager.delegate = self
        erManager.fetchMoney()
        firstCurrencyTextField.delegate = self
        firstCurrencyTextField.keyboardType = .decimalPad
        firstCurrencyTextField.addDoneButtonOnKeyboard()
        firstCurrencyTextField.returnKeyType = .done
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    @IBAction func switchPressed(_ sender: UIButton) {
        let temp = firstCurrencyLabel.text
               firstCurrencyLabel.text = secondCurrencyLabel.text
               secondCurrencyLabel.text = temp
    }
    @IBAction func firstCurrencyPressed(_ sender: UIButton) {
        firstCurrencyTextField.endEditing(true)
        currencyPicker.isHidden = false
    }
    @IBAction func secondCurrencyPressed(_ sender: UIButton) {
        firstCurrencyTextField.endEditing(true)
        currencyPicker.isHidden = false
    }
}

//MARK: -UITextFieldDelegate

extension ErViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charset = CharacterSet(charactersIn: ",")
        let str = firstCurrencyTextField.text
        if str?.rangeOfCharacter(from: charset) != nil && string == ","{
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        secondCurrencyTextField.text = firstCurrencyTextField.text
    }
    
}

//MARK: -UIPickerViewDataSource

extension ErViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return erManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return erManager.currencyArray[row]
    }

}

extension ErViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyPicker.isHidden = true
        let selectedValue = erManager.currencyArray[row]
        erManager.getValuePrice(for: selectedValue)
    }
}

//MARK: -ErManagerDelegate

extension ErViewController: ErManagerDelegate{
    func didUpdateExchange(_ erManager: ErManager, exchange: ErModel) {
        DispatchQueue.main.async {
            
//            self.secondCurrencyLabel.text = exchange.
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

//MARK: -Done Button

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

