//
//  ViewController.swift
//  QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import OAuthSwift
import WebKit

// 05614dff7a2335e88aa85900a655618675695b7b

final class ViewController: UIViewController {
    
    private var oauthswift: OAuth2Swift?
    private var client: OAuthSwiftClient?
    private lazy var webVC: OAuthViewController = {
        let controller = OAuthViewController()
        controller.view = WKWebView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.view.frame.width,
                                                  height: self.view.frame.height))
        controller.delegate = self
        controller.viewDidLoad()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func register(_ sender: Any) {
        let _ = webVC.webView
        oauthswift = OAuth2Swift(consumerKey: "c81ac913a21a003330523e6fd82079b4cd61b3ce",
                                 consumerSecret: "21c7260dd439a00fd98a09c02d3c83b2f944349c",
                                 authorizeUrl: "https://qiita.com/api/v2/oauth/authorize",
                                 accessTokenUrl: "https://qiita.com/api/v2/access_tokens",
                                 responseType: "token")
        oauthswift?.authorizeURLHandler = webVC
        oauthswift?.allowMissingStateCheck = true
        oauthswift?.authorize(
            withCallbackURL: URL(string: "REON://oauth-callback")!,
            scope: "read_qiita write_qiita",
            state: "",
            headers: ["Content-Type": "application/json"],
            completionHandler: { result in
                switch result {
                    case .success(let (credential, _, _)):
                        print("DEBUG_PRINT: token", credential.oauthToken)
                        self.client = OAuthSwiftClient(credential: credential)
                    case .failure(let error):
                        print("DEBUG_PRINT: ", error.description)
                }
            }
        )
    }
    
    @IBAction private func getUserInfo(_ sender: Any) {
        let userID = "REON"
        client?.get(
            URL(string: "https://qiita.com/api/v2/users/\(userID)")!,
            completionHandler: { result in
                switch result {
                    case .success(let response):
                        if let json = try? response.jsonObject(options: .allowFragments) as? [String : Any] {
                            print("DEBUG_PRINT: json", json)
                        }
                    case .failure(let error):
                        print("DEBUG_PRINT: ", error.description)
                }
            }
        )
    }
    
}

extension ViewController: OAuthWebViewControllerDelegate {
    
    func oauthWebViewControllerDidPresent() {
    }
    
    func oauthWebViewControllerDidDismiss() {
    }
    
    func oauthWebViewControllerWillAppear() {
    }
    
    func oauthWebViewControllerDidAppear() {
    }
    
    func oauthWebViewControllerWillDisappear() {
    }
    
    func oauthWebViewControllerDidDisappear() {
        oauthswift?.cancel()
    }
    
}
