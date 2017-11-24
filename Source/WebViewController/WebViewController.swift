//
//  WebViewController.swift
//  massagechair
//
//  Created by andy on 16/9/13.
//  Copyright © 2016年 luxcon. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    static let Defualt_BackICONName = "iconBack"
    
    //返回 按钮图片颜色
    var backIconName: String = "iconBack"
    
    var url:String?{
        
        didSet{
            if let urlStr = self.url,
                let url =  URL(string: urlStr) {
                self.webView.load(URLRequest(url: url ))
            }
        }
    }
    
     lazy var webView: WKWebView = {
        
        let lazyWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        lazyWebView.allowsBackForwardNavigationGestures = true
        lazyWebView.navigationDelegate = self
        lazyWebView.uiDelegate = self
        self.view.addSubview(lazyWebView)
        lazyWebView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return lazyWebView
    }()
    
    var progressView = UIProgressView.init(frame: .zero)
    
    var progressTintColor = UIColor.blue
    
    @discardableResult
    class func open( _ url: String?, title: String? = nil, backIconName: String =  "iconBack") -> WebViewController {
        
        let webVC = WebViewController(web: url, title: title, backIconName: backIconName)
        if let nav = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController as? UINavigationController{
            nav.pushViewController(webVC, animated: true)
        }else{
            let nav = UINavigationController(rootViewController: webVC)
            nav.pushViewController(webVC, animated: true)
        }
        if let urlStr = url,
            let url =  URL(string: urlStr) {
            webVC.webView.load(URLRequest(url: url ))
        }
        return webVC
    }
    
    init(web  url: String?, title: String? = nil, backIconName: String =  "iconBack"){
        super.init(nibName: nil, bundle: nil)
        self.url = url
        self.title = title
        self.backIconName = backIconName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.progressView)
        self.view.bringSubview(toFront: progressView)
        progressView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: self.view.bounds.width, height: 10)
        progressView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        self.progressView.progressViewStyle = .bar

        let backItem = UIBarButtonItem(image: UIImage(named: backIconName)?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(backItemAction(_:)))
        let closeItem = UIBarButtonItem(title: "关闭", style: .done, target: self, action: #selector(closeAction))
        closeItem.tintColor = UINavigationBar.appearance().barTintColor
        self.navigationItem.leftBarButtonItems = [backItem, closeItem]
    }
    
    @objc func backItemAction(_ sender:UIBarButtonItem) -> Void {
        if self.webView.canGoBack{
            self.webView.goBack()
            //self.title = self.webView.title
        }else{
            
            closeAction()
        }
    }
    
    @objc func closeAction()  {
        self.webView.stopLoading()
        if let rootVC = self.navigationController?.viewControllers[0],
            rootVC != self {
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
        self.webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "title")
    }
    
    
    deinit{
        self.webView.stopLoading()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            
            self.progressView.isHidden = false
            self.progressView.setProgress(Float(self.webView.estimatedProgress ), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                
                self.progressView.isHidden = true
                self.progressView.setProgress(0.0, animated: false)
            }else{
                self.view.bringSubview(toFront: self.progressView)
            }
        }else if keyPath == "title"{
            self.title = self.webView.title
        }
    }
    
    class func ClearCache(){

        if  #available(iOS 9.0, *){
            let dateFrom  = Date.init(timeIntervalSince1970: 0)
            let websiteDataTypes:NSSet = WKWebsiteDataStore.allWebsiteDataTypes() as NSSet
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom) {
                //dPrint("清空缓存完成")
            }
        }else{
            
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = libraryPath.appending("/Cookies")
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
    }
    
    lazy var loadView = DYLoadingView()
    
    func showLoadView( _ isShow: Bool = true)  {
        if isShow {
            loadView.center = self.view.center
            loadView.loadingType = .loading
            self.view.addSubview(loadView)
            loadView.loadingColor = progressTintColor
        }else{
            loadView.clear()
            loadView.removeFromSuperview()
        }
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate{
    
    //1. WKNavigationDelegate来追踪加载过程
    //当页面开始时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        showLoadView(  )
    }
    
    //当页面开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        showLoadView( false )
        if let title = webView.title {
            
            self.title = title
        }
    }
    
    //当页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.title = webView.title
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    //当页面加载失败的时候调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.title = webView.title
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //WKNavigtionDelegate来进行页面跳转
    //在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(WKNavigationResponsePolicy.allow)
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.targetFrame == nil{
            webView.load(navigationAction.request)
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    
    // WKUIDelegate
    //1. 创建一个新的WebView
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    
          return WKWebView()
    }
    
    //2.WebVeiw关闭（9.0中的新方法）
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    // 3.显示一个JS的Alert（与JS交互）
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //
    //    //4.弹出一个输入框（与JS交互的）
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(alert.textFields?.first?.text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //5.显示一个确认框（JS的）
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
