//
//  ViewController.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 29.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import UIKit

final class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    
    var results = [Page]()
    let prMgr = PRMgr.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        self.setLoadingScreen()
        
        DispatchQueue.global().async {
            self.prMgr.startJobs(url: baseURL, completion: { (pages: [Page], times: [Double]) in
                DispatchQueue.main.async {
                    self.results = pages
                    self.tableView.reloadData()
                    self.tableView.separatorStyle = .singleLine
                    self.removeLoadingScreen()
                    
                    var msg = "ParallelLessIterationPR: \(times[0])\n"
                    msg.append("ParallelLessPR: \(times[1])\n")
                    msg.append("ParallelExPR: \(times[2])")
                    let alert = UIAlertController(title: "Готово", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let idxPath = tableView.indexPathForSelectedRow,
        let toVC = segue.destination as? PageViewController {
            toVC.page = results[idxPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.linkLabel.text = "URL: \(results[indexPath.row].link)"
        cell.rankLabel.text = "Rank: \(results[indexPath.row].pageRank)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    private func setLoadingScreen() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableView.frame.width / 2) - (width / 2)
        let y = (self.tableView.frame.height / 2) - (height / 2) - (self.navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        self.loadingLabel.textColor = .gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRect(x: 0,y: 0, width: 140, height: 30)
        
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.spinner.startAnimating()
        
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        self.tableView.addSubview(loadingView)
    }
    
    private func removeLoadingScreen() {
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

