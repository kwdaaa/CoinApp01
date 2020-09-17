//
//  ViewController.swift
//  CoinApp
//
//  Created by 川田 文香 on 2020/09/13.
//  Copyright © 2020 kwdaaa.com. All rights reserved.
//

import UIKit

// UIPickerViewDataSource,UIPickerViewDelegate追加
// CoinManagerDelegate追加

// ※ピッカービューを使うときは、必ず「UIPickerViewDataSource」を追加する必要がある。
// ※ピッカービューにデータソースを使うときは、必ず「UIPickerViewDelegate」を追加する必要がある。
// CoinManagerDelegateプロトコルにレートや各国の通貨など値が入っているので、「CoinManagerDelegate」を追加。
class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerDelegate {
    
    // CoinManagerDelegateプロトコルの中のdidUpdatePrice関数について設定。
    func didUpdatePrice(price: String, currency: String, world: String) {
        // 「DispatchQueue」は、非同期処理を可能にする。
        // こっちの処理を優先させる。
        DispatchQueue.main.async{
            self.coinLabel.text = price
            self.currencyLabel.text = currency
            self.worldLabel.text = world
        }
    }
    
    
    // CoinManagerDelegateプロトコルの中のdidFailWithError関数について設定。
    func didFailWithError(error: Error) {
        print("error")
    }
    
    
    
    // ※ピッカービューを使うときは、必ずnumberOfComponents関数を設定する必要がある。（ピッカー数の指定）
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 一つだけ表示
        return 2
    }
    
    //「coinManager」という変数で、構造体CoinManagerにアクセス
    var coinManager = CoinManager()
    
    // ※ピッカービューを使うときは、必ずpickerView関数を設定する必要がある。
    // セル数の指定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            //CoinManagerという構造体の中にある（今は変数coinManager）、currencyArrayの配列の数分だけピッカービューのセル数設定。
            return coinManager.coinArray.count
        }
        return coinManager.currencyArray.count
    }
    
    // ※ピッカービューを使うときは、必ずpickerView関数を設定する必要がある。
    // ラベル数の指定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            // rowはユーザーが選択したものの配列番号
            return coinManager.coinArray[row]
        }
        return coinManager.currencyArray[row]
    }
    
    // 選択されたピッカーの値を取得（何をユーザーが選んでいるのか分かるところ）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 取得の確認（「2 CNY」とか表示される。）
        print(row,coinManager.currencyArray[row])
        
        
        // 入れて
        let selectedCoin = coinManager.coinArray[pickerView.selectedRow(inComponent: 0)]
        
        // 入れて
        let selectedWorld = coinManager.currencyArray[pickerView.selectedRow(inComponent: 1)]
        
        // コインマネージャーに送る
        // Struct CoinManager（変数coinManager）のgetCoinPrice関数に、coinManager.currencyArray[row]（変数selectedCurrency）を送る。
        
        // コインマネージャーに送る
        // Struct CoinManager（変数coinManager）のgetCoinPrice関数に、coinManager.currencyArray[row]（変数selectedCoin）を送る。
        coinManager.getCoinPrice(for: selectedCoin, worldString: selectedWorld)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // delegateとは、「ある特定の事項について、問い合わせ先を指定する」
        // currencyPicker.dataSource = self → currencyPicker の問い合わせ先として、viewDidLoadを指定する。
        //https://techacademy.jp/magazine/15055
        
        // ※class ViewControllerへ「UIPickerViewDataSource」を追加したら、必ず追加しなくてはいけない。
        currencyPicker.dataSource = self
        // ※class ViewControllerへ「UIPickerViewDelegate」を追加したら、必ず追加しなくてはいけない。
        currencyPicker.delegate = self
        //　coinManagerをdelegateとして使う。
        coinManager.delegate = self
    }
    
    
    @IBOutlet var worldLabel: UILabel!
    
    @IBOutlet var coinLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var currencyPicker: UIPickerView!
}

