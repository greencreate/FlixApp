//
//  TrailerViewController.swift
//  Flix
//
//  Created by Joey Steigelman on 2/14/21.
//

import UIKit
import WebKit
import AlamofireImage

class TrailerViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var trailerView: WKWebView!
    
    var movie: [String:Any]!
    
        var videos = [[String:Any]]()
        var id: Int = 0
        var webView = WKWebView()
        var key: String = ""
        var youtube_url: String = "http://www.youtube.com/watch?v="

    
    override func loadView() {
            let webConfiguration = WKWebViewConfiguration()
            webView = WKWebView(frame: .zero, configuration: webConfiguration)
            webView.uiDelegate = self
            view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        let movie_id = movie["id"] as! String
        let key: String
        let name: String
        let site: String
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + movie_id + "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url)
        trailerView.load(request)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            self.videos = dataDictionary["results"] as! [[String:Any]]
            for vid in self.videos{
                let type = vid["type"] as? String
                if type == "Trailer"{
                    self.key = (vid["key"] as? String)!
                    self.youtube_url += self.key
                }
            }
            let url2 = URL(string: self.youtube_url)!
            let request2 = URLRequest(url: url2)
            self.webView.load(request2)
           }
        }
        
        var youtubeURL: URL? {
            guard site == "YouTube" else {
                return nil
            }
            return URL(string: "https://www.youtube.com/watch?v=\(key)")
        }
        
        task.resume()
}
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
