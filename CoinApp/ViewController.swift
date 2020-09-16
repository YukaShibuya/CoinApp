//
//  ViewController.swift
//  CoinApp
//
//  Created by 渋谷柚花 on 2020/09/13.
//  Copyright © 2020 渋谷柚花. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,CoinManagerdelegate {
    
    func didUpdatePrice(price: String, currency: String, current: String) {
         DispatchQueue.main.async {
                   self.coinLabel.text = price
                   self.currencyLabel.text = current
                   self.currencyL.text = currency
               }
               
    }
    
    func didFailWithError(error: Error) {
        print("error")
    }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
//       構造体CoinManagerにアクセス
    var coinManager = CoinManager()
    
    
//    ピッカービューのセルの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        構造体の中のcuurencyArrayのカウント分(数を決めてる)
        if component == 0 {
            return coinManager.currencyArray.count}
        return coinManager.currentArray.count
    }
    
//  セルに表示するラベル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if  component == 0 {
            return coinManager.currencyArray[row]
        }
        
        return coinManager.currentArray[row]
        
    }
//    
//    選択されたピッカーの値を取得（何をユーザーが選んだのか）
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(row,coinManager.currencyArray[row])
        print(row,coinManager.currentArray[row])
        
//        入れて
        let selected = coinManager.currencyArray[pickerView.selectedRow(inComponent: 0)]
        let selectedcoin = coinManager.currentArray[pickerView.selectedRow(inComponent: 1)]
//        コインマネージャーに渡す/ getCoinPriceにselectedを渡す
        coinManager.getCoinPrice(for: selected,current: selectedcoin)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }

    
    
    @IBOutlet var coinLabel: UILabel!
    
    @IBOutlet var currencyLabel: UILabel!
    
    @IBOutlet var currencyPicker: UIPickerView!
    

    @IBOutlet var currencyL: UILabel!
    
}

