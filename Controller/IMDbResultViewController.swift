//
//  IMDbResultViewController.swift
//  IMDB Search
//
//  Created by Ajay Saradhi Reddy on 3/23/20.
//  Copyright © 2020 Ajay Saradhi Reddy. All rights reserved.
//

import UIKit
import SDWebImage

class IMDbResultViewController: UIViewController {
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var plot: UILabel!
    
    private var link:URL!
    
    var imdbResult:IMDbInfo!

    override func viewDidLoad() {
        super.viewDidLoad()
        loader.hidesWhenStopped = true
        loader.isHidden = false
        loader.startAnimating()
        self.coverImg.sd_setImage(with: URL(string: self.imdbResult.Poster)!) { (_, error, _, _) in
            self.loader.stopAnimating()
            if let error = error{
                self.showAlert(title: "Error", message: error.localizedDescription) { (_) in }
            }
        }
        self.year.text = self.imdbResult.Year
        self.releaseDate.text = self.imdbResult.Released
        self.rating.text = self.imdbResult.imdbRating
        self.name.text = self.imdbResult.Title
        self.plot.text = self.imdbResult.Plot
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! IMDbWebsiteViewController
        vc.link = self.link
    }
    
    @IBAction func openWebsite(_ sender: Any) {
        guard let url = URL(string: "https://www.imdb.com/title/\(self.imdbResult.imdbID!)") else {
            self.showAlert(title: "Error", message: "Could not open IMDb website") { (_) in }
            return
        }
        self.link = url
        self.performSegue(withIdentifier: "web", sender: nil)
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
