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
        
        let web3 = Web3.new(URL(string: "http://127.0.0.1:8545")!)
        
        //convert test btc private key -> rsk private key and create address
        let rskprivkey = privKeyToRskFormat(btcPrivateKey: "cRAEv7ENBqKbiRJv83bEhRx5qPKRwQJqGts6pcTSbu73JB7Zr1fa")
        let priv:PlainKeystore = PlainKeystore.init(privateKey: rskprivkey)!
        //print(rskprivkey)
        //print(priv.addresses)

        balanceCheck(web3: web3!)
        //ecverify(web3: web3!)
        
        
//        let address = EthereumAddress("0xcd2a3d9f938e13cd947ec05abc7fe734df8dd826") // regtest
////        let address = EthereumAddress("0x34684c06822bab1f22fc8777bebbb3341c76f15e") // testnet
//        let web3rin = Web3.new(URL(string: "http://153.126.153.29:4444")!)
//        let balanceResult = web3rin?.eth.getBalance(address: address!)
//        guard case .success(let balance)? = balanceResult else {return}
//        print(balance)
//
//        let gasPriceResult = web3rin?.eth.getGasPrice()
//        guard case .success(let gasprice)? = gasPriceResult else {return}
//        print(gasprice)
////
//        let contractAddress = EthereumAddress("0x1af2844a588759d0de58abd568add96bb8b3b6d8")! // BKX token on Ethereum mainnet
////        let contractAddress = EthereumAddress("0x7ca735a321664f395e1853a393cd5693ada3bbcb")! // macbook to deploy
////
//        let abi = "[{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"constant\":true,\"inputs\":[],\"name\":\"getGreeting\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_newGreeting\",\"type\":\"string\"}],\"name\":\"setGreeting\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
//        let contract = web3rin?.contract(abi, at: contractAddress, abiVersion: 1)! // utilize precompiled ERC20 ABI for your concenience
//        var options = Web3Options.defaultOptions()
//        var gasLimit: BigUInt? = BigUInt(5000000000000) // - default gas limit
//        var gasPrice: BigUInt? = BigUInt(5000000000000) // - default gas price, quite small
//        options.gasLimit = gasLimit
//        options.gasPrice = gasPrice
//        options.from = address
//        options.to = EthereumAddress("0x1af2844a588759d0de58abd568add96bb8b3b6d8")
//
//        let writetest:String = "from mobile3"
//
////        guard let result = contract.method("setGreeting", parameters: [writetest] as [AnyObject], options: options) else {return}
////        let re = result.send()
//
//        guard let result = contract?.method("getGreeting", parameters: [], options: options)?.call(options: nil) else {return}
//        print(result)
//        guard case .success(let string) = result else {return}
//        print(string)
//
//        let coldWalletAddress = EthereumAddress("0x6394b37Cf80A7358b38068f0CA4760ad49983a1B")
//        let constractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")
//
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
    
    func privKeyToRskFormat(btcPrivateKey:String)-> String {
        let privKeyBytes = keyBtcToRskInBytes(btcPrivateKey:btcPrivateKey)
        return privKeyBytes.toHexString()
    }
    
    func keyBtcToRskInBytes(btcPrivateKey:String)-> Data {
        let decodedKey = Base58.bytesFromBase58(btcPrivateKey)
        let privKeyBytes = Data(decodedKey[1...decodedKey.count-6])
        return privKeyBytes
    }
    
    func balanceCheck(web3:web3)-> Bool? {
        
        let abi = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"calcAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalDeposit\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"constant\":false,\"inputs\":[],\"name\":\"deposit\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"withdraw\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"mint\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
        let contractAddress = EthereumAddress("0xe85bca1671d1bb34c5bf1b7db51cbe0ac92c131e")!
        let contract = web3.contract(abi, at: contractAddress, abiVersion: 1)!

        let address_string = "0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc"
        let address = EthereumAddress(address_string)
        var options = Web3Options.defaultOptions()
        var gasLimit: BigUInt? = BigUInt(5000000000000) // - default gas limit
        var gasPrice: BigUInt? = BigUInt(5000000000000) // - default gas price, quite small
        options.gasLimit = gasLimit
        options.gasPrice = gasPrice
        options.from = address
        guard let ret = contract.method("balanceOf", parameters: [address_string] as [AnyObject], options: options)?.call(options: nil) else {return false }
        //let balance = ret.value!["0"]
        let balance_any = ret.value!["0"]
        print(balance_any)
        
        //Any?から取り出せない
        
//        if (balance as! Int > 10) {
//            return true
//        }

        
        return false
    }

    
    func deposit(web3:web3, value:BigUInt) {
        let abi = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"calcAmount\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalDeposit\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},{\"constant\":false,\"inputs\":[],\"name\":\"deposit\",\"outputs\":[],\"payable\":true,\"stateMutability\":\"payable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"amount\",\"type\":\"uint256\"}],\"name\":\"withdraw\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"mint\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"
        let contractAddress = EthereumAddress("0xe85bca1671d1bb34c5bf1b7db51cbe0ac92c131e")!
        let contract = web3.contract(abi, at: contractAddress, abiVersion: 1)!
        let address_string = "0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc"
        let address = EthereumAddress(address_string)
        var options = Web3Options.defaultOptions()
        var gasLimit: BigUInt? = BigUInt(5000000000000) // - default gas limit
        var gasPrice: BigUInt? = BigUInt(5000000000000) // - default gas price, quite small
        options.gasLimit = gasLimit
        options.gasPrice = gasPrice
        options.from = address
        let priv:PlainKeystore = PlainKeystore.init(privateKey: "891e9fde727d3504777424054db1408c48840d282e12ebf633de5051acfc81dd")!
        let keystoreManager = KeystoreManager.init([priv])
        web3.addKeystoreManager(keystoreManager)
        options.value = value
        var intermediateSend = contract.method(options: options)!
        let sendResult = intermediateSend.send(password: "")
        print(sendResult)
    }
    
    func ecverify(web3:web3)-> Bool? {
    
        let abi = "[{\"constant\":true,\"inputs\":[{\"name\":\"hash\",\"type\":\"bytes32\"},{\"name\":\"signature\",\"type\":\"bytes\"}],\"name\":\"ecrecovery\",\"outputs\":[{\"name\":\"sig_address\",\"type\":\"address\"}],\"payable\":false,\"stateMutability\":\"pure\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"hash\",\"type\":\"bytes32\"},{\"name\":\"sig\",\"type\":\"bytes\"},{\"name\":\"signer\",\"type\":\"address\"}],\"name\":\"ecverify\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"}]"
        
        let address = EthereumAddress("0x9DB516CC86D6278ee43BD91Bf935C4845Dc2B2D3")
        let balanceResult = web3.eth.getBalance(address: address!)
        guard case .success(let balance) = balanceResult else {return nil}
        //print(balance)
        
        let gasPriceResult = web3.eth.getGasPrice()
        guard case .success(let gasprice) = gasPriceResult else {return nil}
        //print(gasprice)
        
        let contractAddress = EthereumAddress("0x14abdb322d9ebd9a9b0ebe597a09d34344ab9c46")!
        let contract = web3.contract(abi, at: contractAddress, abiVersion: 1)!
        var options = Web3Options.defaultOptions()
        var gasLimit: BigUInt? = BigUInt(5000000000000) // - default gas limit
        var gasPrice: BigUInt? = BigUInt(5000000000000) // - default gas price, quite small
        options.gasLimit = gasLimit
        options.gasPrice = gasPrice
        options.from = address
        options.to = EthereumAddress("0x14abdb322d9ebd9a9b0ebe597a09d34344ab9c46")
        
        let msg_seed = String(arc4random())
        let msg_hex:String = "0x" + msg_seed.sha3(.keccak256)
        let msg = Data(hex: msg_hex)
        let signerAddress = EthereumAddress("0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc")
        let pk = Data(hex: "891e9fde727d3504777424054db1408c48840d282e12ebf633de5051acfc81dd")
        
        let priv:PlainKeystore = PlainKeystore.init(privateKey: "891e9fde727d3504777424054db1408c48840d282e12ebf633de5051acfc81dd")!
        let keystoreManager = KeystoreManager.init([priv])
        //print(priv.addresses)
        let data = Data.fromHex(msg_hex)
        var signature_string = ""
        let (compressedSignature, _) = SECP256K1.signForRecovery(hash: msg, privateKey: pk, useExtraEntropy: false)
        print(compressedSignature?.toHexString())
        
        
        //let signRes = web3rin?.personal.signPersonalMessage(message: msg_hex.data(using: .utf8)!, from: signerAddress!, password: "")
        //guard case .success(var signature)? = signRes else {return nil}
        //print(signature.toHexString())
        
//        do {
//            guard let signature = try Web3Signer.signPersonalMessage(data!, keystore: keystoreManager, account: signerAddress!, password: "", useExtraEntropy: false) else {return nil}
//
//            signature_string = signature.toHexString()
//            //print(signature.description)
//            //print(signature.toHexString())
//        }catch{
//            //print(error)
//            return nil
//        }
        signature_string = (compressedSignature?.toHexString())!
        signature_string = "0x" + signature_string
        //let result = web3rin?.browserFunctionsFunctions.personalECRecover(msg_hex, signature: signature_string)
        //print(result)
        //let signature = web3rin?.browserFunctionsFunctions.sign(msg_hex, "0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc", password: "test")
        //let signature = web3rin?.browserFunctionsFunctions.personalSign(msg_hex, account: "0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc")
        //sign(msg_hex, "0x4F0C2aB902a8B28F21c585b1d2a6Bd603082deCc" , "test")
        
        //let privateKey = PrivateKey(data: pk)
        
        //let signature = try? Crypto.sign(msg, privateKey: privateKey)
        //let publicKey = Data(hex: privateKey.publicKey().description)
        //let verify = try? Crypto.verifySignature(signature!, message: msg, publicKey: publicKey)
        //print(verify)
        //print(privateKey.publicKey().toAddress())
        
        
        //print(signature?.hashValue)
        //print(signature?.bytes)
        //print(signature?.toHexString())
        //let signature_string:String = (signature?.toHexString())!
        //signature_string = "0x5025b1719cec2eb29c7448e059fff154388361c6d61cb8cdae4212bbcad5c13f41a307c8e7d6e79e9887b98da86c4af2ae3bede76a3eb5c9d312d342596547bb1b"
        //let writetest:String = "from mobile3"
        
        //        guard let result = contract.method("setGreeting", parameters: [writetest] as [AnyObject], options: options) else {return}
        //        let re = result.send()
        //print(msg_hex)
        
        //print(signature_string)
        //msg_hex = "0x8fc1fedd35837f0fb69fb9e4223161c0ac1abe7813dd565a10034d27ff7fb68b"
        guard let ret = contract.method("ecrecovery", parameters: [msg_hex, signature_string] as [AnyObject], options: options)?.call(options: nil) else {return nil }
        print(ret)
        //guard case .success(let string) = result else {return nil}
        //print(string)
        return false
    }


}

