//
//  ViewController.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 29.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var results = [Page]()
    let prMgr = PRMgr.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
        prMgr.viewController = self
        DispatchQueue.global().async {
            self.prMgr.mainTask()
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
        return 74
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

