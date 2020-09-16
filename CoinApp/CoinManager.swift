//
//  CoinManager.swift
//  CoinApp
//
//  Created by 渋谷柚花 on 2020/09/13.
//  Copyright © 2020 渋谷柚花. All rights reserved.
//

import Foundation

protocol CoinManagerdelegate {
    func didUpdatePrice(price: String,currency:String,current:String)
    func didFailWithError(error:Error)
    
}




struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/"
    let apiKey = "C5ED300B-186C-4BEA-A6DC-C327526995F4"
    let currencyArray = ["BTC","BCH","ETH","XRP","XEM"]
    let currentArray = ["USD","CNY","EUR","JPY","HKD"]
    //   プロトコルにアクセス
    var delegate:CoinManagerdelegate?
    
    func getCoinPrice(for currency:String,current:String){
        
        let urlString
            = "\(baseURL)\(currency)/\(current)?apikey=\(apiKey)"
        
        print(urlString)
        
        //    URLに正しくアクセスしたら、実行
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration:.default)
            //            swiftのdataタスクというところにアクセス、オブジェクトを経由してアクセスちっちゃい値であれば、ここでいじれる
            let task = session.dataTask(with:url){
                (data,responce,error)in
                //                エラーの処理
                if error != nil{
                    self.delegate?.didFailWithError(error:error!); return
                }
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData){
                        let priceString =
                            // 小数点以下代２位とする
                            String(format:"%.2f",bitcoinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency,current: current)
                    }
                    
                }
                
            }
            task.resume()
            
        }
        
        
        
    }
    func parseJSON(_ data:Data) -> Double?{
        //        JSONの解析に必要
        let decoder = JSONDecoder()
        //            doはエラー処理の時　decodedataは、
        do{
            let decodeData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodeData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            delegate?.didFailWithError(error:error)
            return nil
            
        }
}


}
