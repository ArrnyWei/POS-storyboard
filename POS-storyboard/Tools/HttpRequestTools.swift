
//
//  HttpRequestTools.swift
//  river
//
//  Created by shih-yenWei on 24/7/16.
//  Copyright © 2016年 Rytass. All rights reserved.
//

import UIKit
import Security

class HttpRequestTools: NSObject {
    
    static let sharedInstance = HttpRequestTools();
    let hostUrl = "https://script.google.com/macros/s/AKfycbzebEBn5R1gbWPR1e1JW1QxZARnVhUMqqWSTeR3lkX-bPVDm78/exec?module=";
    
    var getHeaders = [
        "cache-control": "no-cache"
    ]
    var postJSONUrlEncodedHeaders = [
        "cache-control": "no-cache",
        "content-type": "application/json"
    ]
    
    let postUrlEncodedHeaders = [
        "content-type": "application/x-www-form-urlencoded",
        "cache-control": "no-cache",
        "postman-token": "2d6ee619-f80d-6d43-99c7-0ae99aa58cec"
    ]

    
    var account = "";
    var pwd = "";
    
    var tempData:Data?;
    var tempError = "";
    var tempJSONError = "";
    var tempCode = "";
    
    func get(_ module:String, parameter:String, completion:@escaping (_ result:NSMutableDictionary?,_ error:String?) ->Void) {
       let request = NSMutableURLRequest(url: URL(string: "\(hostUrl)\(module)\(parameter)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = getHeaders
        
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                completion(nil,(error?.localizedDescription)!);
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                if httpResponse?.statusCode == 200 {

                    do {
                        let resultString = String(data: data!, encoding: String.Encoding.utf8)!;
                        let resultData = resultString.data(using: String.Encoding.utf8);
                        let json = try JSONSerialization.jsonObject(with: resultData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSMutableDictionary
                        
                        completion(json,nil);
                        
                    }
                    catch{
                        
                        completion(nil,"JSON Error");
                        print(error);
                    }
                }
                else {
                    
                    completion(["error":"YES"],nil);
                }
                
                
            }
        }).resume()
    }
    
    func postDataByJSON(_ module:String,data:[String:Any], completion:@escaping (_ result:[String:Any]?,_ error:String?) ->Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(hostUrl)\(module)")!,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = postJSONUrlEncodedHeaders
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted);
        }
        catch {
            completion(nil,"JSON Error");
            print(error);
        }
        
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            
            if (error != nil) {
                completion(nil,(error?.localizedDescription)!);
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                if httpResponse?.statusCode == 200 {
                    
                    let resultString = String(data: data!, encoding: String.Encoding.utf8)!;
                    let resultData = resultString.data(using: String.Encoding.utf8);
                    do {
                        let json = try JSONSerialization.jsonObject(with: resultData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
                        completion(json,nil);
                        
                    }
                    catch{
                        completion(nil,"JSON Error");
                        print(error);
                    }
                }
                else {
                    completion(nil,"API error");
                }
            }
        }).resume()
    }
    
    
}
