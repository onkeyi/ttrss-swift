//
//  Licensed Swift File.swift
//  ttrssapi
//
// Copyright (c) 2016年 sunflowerstudio
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Alamofire

public class TTRSSApi {

    private var apiURL: String?
    private var delegate: ApiDelegate
    
    internal enum ApiName: String {
        case getVersion = "getVersion"
        case login = "login"
        case getApiLevel = "getApiLevel"
        case logout = "logout"
        case isLoggedIn = "isLoggedIn"
        case getUnread = "getUnread"
        case getCounters = "getCounters"
        case getFeeds = "getFeeds"
        case getCategories = "getCategories"
        case getHeadlines = "getHeadlines"
        case updateArticle = "updateArticle"
        case getArticle = "getArticle"
        case getConfig = "getConfig"
        case updateFeed = "updateFeed"
        case getPref = "getPref"
        case catchupFeed = "catchupFeed"
        case setArticleLabel = "setArticleLabel"
        case shareToPublished = "shareToPublished"
        case subscribeToFeed = "subscribeToFeed"
        case unsubscribeFeed = "unsubscribeFeed"
    }

    init(apiURL: String,delegate:ApiDelegate) {
        self.apiURL = apiURL
        self.delegate = delegate
    }
    
    func call(param:NSDictionary, complete: (NSDictionary?, NSError?) -> Void) {
        self.execute(param, completionHandler: { data , error in
            complete(data,error)
        })
        
    }
    
    internal func login(user:String ,password:String) {
        let param = ["op" : ApiName.login.rawValue, "user" : user, "password" : password]
        self.execute(param, completionHandler: { result, error in
            if error != nil {
                self.delegate.fail(error)
                return;
            }
            self.delegate.success(result!)
        })
    }
    
    func getHeadlines(param:NSDictionary, complete: (NSDictionary?, NSError?) -> Void) {
        var p = ["op" : ApiName.getHeadlines.rawValue]
        p.update(param as! Dictionary<String, String>)
        self.execute(p, completionHandler: { data , error in
            complete(data,error)
        })
        
    }
    
    func getHeadLines(param:NSDictionary) {
        var p = ["op" : ApiName.getHeadlines.rawValue]
        p.update(param as! Dictionary<String, String>)
        
        self.execute(p, completionHandler: { data , error in
            if error != nil {
                self.delegate.fail(error)
                return;
            }
            self.delegate.success(data!)
        })
    }
    
    func getCategories(param: NSDictionary) {
        var p = ["op": ApiName.getCategories.rawValue]
        p.update(param as! Dictionary<String, String>)
        
        self.execute(p, completionHandler: { data , error in
            if error != nil {
                self.delegate.fail(error)
                return;
            }
            self.delegate.success(data!)
        })
    }
    
    func getCategories(param:NSDictionary, complete: (NSDictionary?, NSError?) -> Void) {
        var p = ["op" : ApiName.getCategories.rawValue]
        p.update(param as! Dictionary<String, String>)
        
        self.execute(p, completionHandler: { data , error in
            complete(data,error)
        })
        
    }
    
    private func execute(param: NSDictionary, completionHandler: (NSDictionary?, NSError?) -> Void) {
        Alamofire.request(.POST, self.apiURL!, parameters: param as? [String:AnyObject], encoding: .JSON)
        .response {
            request, response, data, error in

            if let err = error {
                print("Network error: \(err.localizedDescription)")
                completionHandler(nil, err)
                return
            }

            if response?.statusCode != 200 {
                print("Status Code: \(response?.statusCode)");
                completionHandler(nil, error)
                return
            }

            do {
                let responseObject = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                completionHandler(responseObject, error)
            } catch let error as NSError {
                print("Parsing error: \(error.localizedDescription)")
                completionHandler(nil, error)
            } catch {

            }
            
            //dispatch_async(dispatch_get_main_queue()) {

            //}
        }
    }
}

protocol ApiDelegate {
    func success(data: NSDictionary?)
    func fail(error:NSError?)
}

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
