node.xcworkspaceを開いてください。
> pod install 済みなので誤動作した場合はご連絡ください。(普通は外部packageごとはgitに上げないと思うので)

### infula -> rskサーバへの変更
modify file "Web3+infura.swift"
```
//        var requestURLstring = "https://" + net.name + ".infura.io/"
        var requestURLstring = "http://153.126.153.29:4444"
```
