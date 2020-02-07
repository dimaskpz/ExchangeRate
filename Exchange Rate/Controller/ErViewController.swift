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
    
    var erLocal:ErModel?
    
    var isFirstPickerSelected = false
    
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
        let tempLabel = firstCurrencyLabel.text
        firstCurrencyLabel.text = secondCurrencyLabel.text
        secondCurrencyLabel.text = tempLabel
        
        let tempText = firstCurrencyTextField.text
        firstCurrencyTextField.text = secondCurrencyTextField.text
        secondCurrencyTextField.text = tempText
    }
    @IBAction func firstCurrencyPressed(_ sender: UIButton) {
        firstCurrencyTextField.endEditing(true)
        isFirstPickerSelected = true
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
        //        secondCurrencyTextField.text =
        getValuePrice(firstCurrency: firstCurrencyLabel.text!, secondCurrency: secondCurrencyLabel.text!, moneyValue: firstCurrencyLabel.text!)
    }
    
    func getValuePrice(firstCurrency: String, secondCurrency:String, moneyValue:String){
        let firstValue = Double(firstCurrencyTextField.text!)
        print(firstValue ?? -1)
        
        let answer = (firstValue ?? 1) * (erLocal?.IDR ?? 1)
        print(answer)
        
        secondCurrencyTextField.text = String(answer)
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
        
       
        
        let selectedValue = erManager.currencyArray[row]
        
        if isFirstPickerSelected == true && selectedValue != secondCurrencyLabel.text || isFirstPickerSelected == false && selectedValue != firstCurrencyLabel.text {
            if isFirstPickerSelected == true {
                isFirstPickerSelected = false
                firstCurrencyLabel.text = selectedValue
                currencyPicker.isHidden = true
            } else {
                secondCurrencyLabel.text = selectedValue
                currencyPicker.isHidden = true
            }
        } else {
            isFirstPickerSelected = false
            let alert = UIAlertController(title: "", message: "Please select different currencies", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        
    }
}

//MARK: -ErManagerDelegate

extension ErViewController: ErManagerDelegate{
    func didUpdateExchange(_ erManager: ErManager, exchange: ErModel) {
        DispatchQueue.main.async {
            
            self.erLocal = exchange
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

