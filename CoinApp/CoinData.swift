//
//  CoinData.swift
//  CoinApp
//
//  Created by 川田 文香 on 2020/09/13.
//  Copyright © 2020 kwdaaa.com. All rights reserved.
//

import Foundation

// 「Decodable」はJASON形式のデータを取ってくる時に必要なコード
struct CoinData:Decodable {
    let rate:Double
}
