//
//  ErManager.swift
//  Exchange Rate
//
//  Created by dimas pratama on 02/02/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import Foundation

protocol ErManagerDelegate {
    func didUpdateExchange(_ erManager: ErManager, exchange:ErModel)
    func didFailWithError(error:Error)
}

struct ErManager{
    let exchangeURL = "https://api.exchangerate-api.com/v4/latest/USD"
    
    let currencyArray = ["IDR","USD","SGD","EUR"]
    
    var delegate:ErManagerDelegate?
    
    var exchangeDataGet:ErModel?
    
//    func getValuePrice(firstCurrency: String, secondCurrency:String){
//        
//        
//    }
    
    func fetchMoney(){
        let url = "\(exchangeURL)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString:String){
        if let url = URL(string:urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){ (data,response, error) in
                if error != nil {
                    return
                }
                if let safeData =  data {
                    if let exchange = self.parseJSON(erData: safeData){
                        self.delegate?.didUpdateExchange(self, exchange: exchange)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    func parseJSON(erData:Data)-> ErModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ErData.self, from: erData)
            let usd:Double = decodedData.rates.USD!
            let idr:Double = decodedData.rates.IDR!
            let sgd:Double = decodedData.rates.SGD!
            let eur:Double = decodedData.rates.EUR!
            print(usd)
            let exchange = ErModel(USD: usd, IDR: idr, SGD: sgd, EUR: eur)
            return exchange
        } catch {
            print(error)
            return nil
        }
        
    }
    
}
