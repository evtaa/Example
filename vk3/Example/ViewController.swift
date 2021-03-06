//
//  ViewController.swift
//  Example
//
//  Created by Alexandr Evtodiy on 25.09.2020.
//  Copyright © 2020 Alexandr Evtodiy. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    let client_id = "7610564"
    @IBOutlet weak var webview: WKWebView! {
        didSet{
            webview.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = getRequestForRegistrationVK(api_id: client_id)
        webview.load(request)
        
    }
    
    // Функция формирования запроса для регистрации аккаунта в приложении
    func getRequestForRegistrationVK (api_id: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: client_id),
            URLQueryItem(name: "display", value: "mobile"),
            // Адрес, на который будет переадресован пользователь после прохождения авторизации
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            //URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        return URLRequest(url: urlComponents.url!)
    }
    
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        // новый код
        let token = params["access_token"]
        let userId = params["user_id"]
        Session.instance.userId = userId
        Session.instance.token = token
        debugPrint (Session.instance.token)
        debugPrint (Session.instance.userId)
        
        decisionHandler(.cancel)
        
        let vkService = VKService()
               
               vkService.getPhotographes(userId: Session.instance.userId!)
        vkService.getFriends(userId: Session.instance.userId!)
                vkService.getGroupsSearch(search: "Music")
               vkService.getGroups(userId: Session.instance.userId!)
              
    }
}


