//
//  IMDbWebsiteViewController.swift
//  IMDB Search
//
//  Created by Ajay Saradhi Reddy on 3/23/20.
//  Copyright © 2020 Ajay Saradhi Reddy. All rights reserved.
//

import UIKit
import WebKit

class IMDbWebsiteViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    var link:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    private func setup(){
        if let url = link {
            let request = URLRequest(url: url)
            webView.load(request)
        }else{
            self.showAlert(title: "Error", message: "Something went wrong while loading website") { (_) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //code for reusable alert controller
    func showAlert(title: String, message: String, completion: @escaping (_ done: String?) -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_) in
            completion(nil)
        }))
        self.present(alert, animated: true)
    }
    
}
