//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CoinViewController: UIViewController {
    
    var currencyType : String = ""
    
    var coinManager = CoinManager()
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }


}

//MARK: - CoinManagerDelegate

extension CoinViewController: CoinManagerDelegate {
    
    func didUpdateCoin(_ coinManager: CoinManager, coin : CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(coin.price)
            self.currencyLabel.text = self.currencyType
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerViewDataSource

extension CoinViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

//MARK: - UIPickerViewDelegate

extension CoinViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyType = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
    }
}

