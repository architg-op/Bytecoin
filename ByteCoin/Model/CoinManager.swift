//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin : CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=E9275FC8-F736-4771-AF17-B866BAFDDA80"
        
        // 1. Create URL
        if let url = URL(string: urlString) {
        
            // 2. Create URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give URLSession a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    
                    if let safeData = data {
                        if let coin = self.parseJSON(safeData) {
                            self.delegate?.didUpdateCoin(self, coin: coin)
                        }
                    }
                }
                
                // 4. Start the task
                task.resume()
        }
    }
    
    func parseJSON(_ coinData : Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let coin = CoinModel(price: rate)
            return coin
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }

    
}
