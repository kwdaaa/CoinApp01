//
//  CoinManager.swift
//  CoinApp
//
//  Created by 川田 文香 on 2020/09/13.
//  Copyright © 2020 kwdaaa.com. All rights reserved.
//

import Foundation

// プロトコルの作成。
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String,currency: String, world: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    //    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    // URL
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    
    // APIKey
    let apiKey = "5E9FDFB5-358F-486F-B9FD-E7E68513A04C"
    
    //　仮想通貨
    let coinArray = ["BTC","BCH","ETH","XRP","XEM"]
    
    // 各国の通貨
    let currencyArray = ["USD","CNY","EUR","JPY","HKD"]

    
    
    // CoinManagerDelegateプロトコルにアクセス。
    // プロトコルにアクセスするには、「delegate:」をつける必要がある。
    var delegate:CoinManagerDelegate?
    
    
    // 「currencyString」で受け取る。「currencyString」でなくても「hoge」でも何でも良い。
    //　今、「currencyString」には、【ViewController.swift】の「coinManager.getCoinPrice(for: selectedCurrency)」で渡したcoinManager.currencyArray[row]（ユーザーが選択したcurrencyArrayの値指定CNYなどが入っている。）
    func getCoinPrice(for currencyString:String, worldString:String){
        
        // HGDなどがprintされる。
        print(currencyString)
        
        let urlString = "\(baseURL)/\(currencyString)/\(worldString)?apikey=\(apiKey)"
        
        // https://rest.coinapi.io/v1/exchangerate/BTC/JPY?apikey=5E9FDFB5-358F-486F-B9FD-E7E68513A04Cなどがprintされる。
        print(urlString)
        
        
        // urlStringがURLとして認識できる形で発行されていたら、
        if let url = URL(string: urlString){
            
            // URLSessionというものを使えるようにしている。
            
            //「configuration」はURLSessionの設定を提供するクラス。タイムアウト（wifi接続悪かったり）とか、キャッシュ、クッキーとかを変更できるところ。
            //　「.default」で、「configuration」のデフォルトを使います。
            let session = URLSession(configuration: .default)
            
            
            // URLSession（変数session）のdataTaskにアクセス。dataTaskはswiftに備わっている関数。
            // open func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
            // dataTask関数の(Data?, URLResponse?, Error?)を(data,responce,error)置き換え。
            let task = session.dataTask(with: url){ (data,responce,error)in
                
                // エラーとして返ってきたら、（エラーがnilじゃなかったら）
                if error != nil{
                    
                    // プロトコルで設定した、func didFailWithError(error: Error)エラーとして返す。
                    self.delegate?.didFailWithError(error:error!)
                    return
                }
                
                // ?? safeData → 「let task = session.dataTask(with: url){ (data,responce,error)in」のdata部分。
                if let safeData = data {
                    // bitcoinPrice変数　→ parseJSON関数で取ってきたrateの値。
                    if let bitcoinPrice = self.parseJSON(safeData){
                        
                        //「"%.2f"」で小数点以下第２位まで。「"%.3f"」で小数点以下第３位まで。
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        // protocol CoinManagerDelegate {
                            // func didUpdatePrice(price: String,currency: String)
                            // func didFailWithError(error: Error)
                        // }
                        // 上記プロトコルの、func didUpdatePrice(price: String,currency: String)に「priceString」（レート）と「currencyString」（各国の通貨）を格納。
                        self.delegate?.didUpdatePrice(price: priceString, currency: currencyString, world: worldString)
                    }
                }
            }
            // タスクの処理を開始する。
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        //　JSONDecoder()はJSONの解析用に定義。JSONDecoder()はswiftに備わっている関数。
        let decoder = JSONDecoder()
        
        // do catchはエラー処理の時によく使う。
        do {
            // JSONDecoder()を使って、「.decode」（解析）します。
            // CoinData.selfは、【CoinData.swift】で定義した「Struct CoinData」の中身にアクセス。
            let decodeData = try decoder.decode(CoinData.self, from: data)
            
            // Struct CoinData（decodeData変数）で設定したrateを入れる。
            let lastPrice = decodeData.rate
            
            // レートがprimtされる。
            print(lastPrice)
            return lastPrice
            
        } catch {
            // アプリ落ちないように。エラー回避。あらかじめエラーを予測。
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
