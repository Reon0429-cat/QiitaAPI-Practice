//
//  OAuthViewController.swift
//  QiitaAPI-Practice
//
//  Created by 大西玲音 on 2021/10/30.
//

import UIKit
import WebKit
import OAuthSwift

final class OAuthViewController: OAuthWebViewController {
    
    private var targetURL: URL?
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        let cancelButton = UIButton()
        cancelButton.titleLabel?.text = "cancel"
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo:  self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo:  self.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo:  self.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40.0)
        ])
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: 82.0),
            cancelButton.heightAnchor.constraint(equalToConstant: 32.0),
            cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            cancelButton.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20.0)
        ])
        
    }
    
    override func handle(_ url: URL) {
        targetURL = url
        super.handle(url)
        self.loadAddressURL()
    }
    
    private func loadAddressURL() {
        guard let url = targetURL else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func cancelButtonDidTapped() {
        self.dismissWebViewController()
    }
    
}

extension OAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.host == "oauth-callback" {
                OAuthSwift.handle(url: url)
                decisionHandler(WKNavigationActionPolicy.cancel)
                self.dismissWebViewController()
                return
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        print("DEBUG_PRINT: ", error.localizedDescription)
        self.dismissWebViewController()
    }
    
}
