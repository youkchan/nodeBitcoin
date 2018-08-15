//
//  ViewController.swift
//  node
//
//  Created by kobayashitakahiro on 2018/08/14.
//  Copyright © 2018年 kobayashitakahiro. All rights reserved.
//

import UIKit
import web3swift
import BigInt

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        // Do any additional setup after loading the view, typically from a nib.
        let address = EthereumAddress("0xcd2a3d9f938e13cd947ec05abc7fe734df8dd826") // regtest
//        let address = EthereumAddress("0x34684c06822bab1f22fc8777bebbb3341c76f15e") // testnet
        let web3rin = Web3.new(URL(string: "http://153.126.153.29:4444")!)
        let balanceResult = web3rin?.eth.getBalance(address: address!)
        guard case .success(let balance)? = balanceResult else {return}
        print(balance)

        let gasPriceResult = web3rin?.eth.getGasPrice()
        guard case .success(let gasprice)? = gasPriceResult else {return}
        print(gasprice)
//
        let contractAddress = EthereumAddress("0x1af2844a588759d0de58abd568add96bb8b3b6d8")! // BKX token on Ethereum mainnet
//        let contractAddress = EthereumAddress("0x7ca735a321664f395e1853a393cd5693ada3bbcb")! // macbook to deploy
//
        let abi = "[{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"constant\":true,\"inputs\":[],\"name\":\"getGreeting\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newGreeting\",\"type\":\"string\"}],\"name\":\"setGreeting\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
        let contract = web3rin?.contract(abi, at: contractAddress, abiVersion: 1)! // utilize precompiled ERC20 ABI for your concenience
        var options = Web3Options.defaultOptions()
        var gasLimit: BigUInt? = BigUInt(5000000000000) // - default gas limit
        var gasPrice: BigUInt? = BigUInt(5000000000000) // - default gas price, quite small
        options.gasLimit = gasLimit
        options.gasPrice = gasPrice
        options.from = address
        options.to = EthereumAddress("0x1af2844a588759d0de58abd568add96bb8b3b6d8")
        
        let writetest:String = "from mobile3"

//        guard let result = contract.method("setGreeting", parameters: [writetest] as [AnyObject], options: options) else {return}
//        let re = result.send()
        
        guard let result = contract?.method("getGreeting", parameters: [], options: options)?.call(options: nil) else {return}
        print(result)
        guard case .success(let string) = result else {return}
        print(string)
        
        let coldWalletAddress = EthereumAddress("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
        let constractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
        
//        var options = Web3Options.defaultOptions()
        // public var to: EthereumAddress? = nil - to what address transaction is aimed
        // public var from: EthereumAddress? = nil - form what address it should be sent (either signed locally or on the node)
        // public var gasLimit: BigUInt? = BigUInt(90000) - default gas limit
        // public var gasPrice: BigUInt? = BigUInt(5000000000) - default gas price, quite small
        // public var value: BigUInt? = BigUInt(0) - amount of WEI sent along the transaction
//        options.gasPrice = gasPrice
//        options.gasLimit = gasLimit
        
//        let web3Main = Web3.InfuraMainnetWeb3()

//        let contractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")! // BKX token on Ethereum mainnet
//        let contract = web3Main.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
//        guard let bkxBalanceResult = contract.method("balanceOf", parameters: [coldWalletAddress] as [AnyObject], options: options)?.call(options: nil) else {return} // encode parameters for transaction
//        guard case .success(let bkxBalance) = bkxBalanceResult, let bal = bkxBalance["0"] as? BigUInt else {return} // bkxBalance is [String: Any], and parameters are enumerated as "0", "1", etc in order of being returned. If returned parameter has a name in ABI, it is also duplicated
//        print("BKX token balance = " + String(bal))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

