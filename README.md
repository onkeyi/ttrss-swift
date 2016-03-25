### ttrssapi

## Login
```sh

let api = TTRSSApi(apiURL:"http://exsamplettrss.com/api/",delegate: self)

api.login("test",password: "test")
```

## getHeadlines
```sh
let api = TTRSSApi(apiURL:"http://exsamplettrss.com/api/",delegate: nil)
let param = ["sid":"0337teoa49n55cbsfkrf3785q2","feed_id":"-4"] as [String:AnyObject]

api.getHeadlines(param, complete: { data , error in
    print(data)
})
```        

