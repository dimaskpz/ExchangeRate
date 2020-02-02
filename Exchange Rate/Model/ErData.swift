//
//  ErData.swift
//  Exchange Rate
//
//  Created by dimas pratama on 02/02/20.
//  Copyright © 2020 dimas pratama. All rights reserved.
//

import Foundation

struct ErData:Decodable {
    let rates:Rates
}

struct Rates:Decodable{
    let USD:Double?
    let IDR:Double?
    let SGD:Double?
    let EUR:Double?
}
