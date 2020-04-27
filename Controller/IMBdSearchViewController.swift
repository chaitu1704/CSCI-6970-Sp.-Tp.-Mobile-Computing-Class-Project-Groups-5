//
//  ViewController.swift
//  IMDB Search
//
//  Created by Ajay Saradhi Reddy on 3/22/20.
//  Copyright © 2020 Ajay Saradhi Reddy. All rights reserved.
//

import UIKit

class IMBdSearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var contentTitle: UITextField!
    @IBOutlet weak var contentType: UITextField!
    @IBOutlet weak var contentYear: UITextField!
    
    private var imdbResult:IMDbInfo!
    private var pickerView = UIPickerView()
    private var type = ["none", "movie", "series", "episode"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        loader.hidesWhenStopped = true
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.contentType.delegate = self
        self.contentType.delegate = self
        self.contentYear.delegate = self
        self.pickerView.reloadAllComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.imdbResult = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! IMDbResultViewController
        vc.imdbResult = self.imdbResult
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.contentType == textField{
            self.pickerView.reloadAllComponents()
            self.pickerView.selectRow(0, inComponent: 0, animated: true)
            self.contentType.inputView = pickerView
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func search(_ sender: Any) {
        self.contentType.resignFirstResponder()
        self.contentYear.resignFirstResponder()
        self.contentTitle.resignFirstResponder()
        if let title = self.contentTitle.text, let type = self.contentType.text, let year = self.contentYear.text{
            if title != ""{
                //adding title query as mentioned in the api
                var searchFields = "t=\(title)"
                //adding content type query as mentioned in the api if the user has entered it
                if type != ""{ searchFields = searchFields + "&type=\(type)" }
                //adding year query as mentioned in the api if the user has entered it
                if year != ""{ searchFields = searchFields + "&y=\(year)"  }
                
                if let searchField = searchFields.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed){
                    if let url = URL(string: "https://www.omdbapi.com/?apikey=56960628&\(searchField)"){
                        let imdbSearch = apiRequest(url: url)
                        loader.isHidden = false
                        loader.startAnimating()
                        imdbSearch.dataRequest(objectType: IMDbInfo.self) { (result: Result) in
                            DispatchQueue.main.async {
                                self.loader.stopAnimating()
                                switch result {
                                case .success(let object):
                                    if let error = object.Error{
                                        self.showAlert(title: "Error", message: error) { (_) in }
                                    }else{
                                        self.imdbResult = object
                                        self.performSegue(withIdentifier: "results", sender: nil)
                                    }
                                case .failure(let error):
                                    self.showAlert(title: "Error", message: error.localizedDescription) { (_) in }
                                }
                            }
                        }
                    }else{
                        self.showAlert(title: "Error", message: "Something went wrong") { (_) in }
                    }
                }else{
                    self.showAlert(title: "Error", message: "Something went wrong") { (_) in }
                }
            }else{
                self.showAlert(title: "Error", message: "Title is required to search for the movie") { (_) in }
            }
        }else{
            self.showAlert(title: "Error", message: "Title is required to search for the movie") { (_) in }
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

extension IMBdSearchViewController{
    
    //code for the picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.type.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.type[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.type[row] == "none"{
            self.contentType.text = ""
        }else{
            self.contentType.text = self.type[row]
        }
    }
    
}

