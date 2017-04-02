//
//  PageViewController.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 02.04.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import UIKit

final class PageViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var relationsTableView: UITableView!
    @IBOutlet weak var parentsTableView: UITableView!
    
    var page: Page?
    var relationsDataSrc: RelationsDataSource!
    var parentsDataSrc: ParentsDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let page = page {
            linkLabel.text = "URL: \(page.link)"
            rankLabel.text = "Rank: \(page.pageRank)"

            relationsDataSrc = RelationsDataSource(relations: Array(page.relations))
            parentsDataSrc = ParentsDataSource(parents: Array(page.parents))
            
            relationsTableView.dataSource = relationsDataSrc
            relationsTableView.delegate = self
            parentsTableView.dataSource = parentsDataSrc
            parentsTableView.delegate = self
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toVC = self.storyboard?.instantiateViewController(withIdentifier: "PageViewControllerID") as? PageViewController {
            let selectedPage = tableView == relationsTableView ? relationsDataSrc.relations[indexPath.row] : parentsDataSrc.parents[indexPath.row]
            toVC.page = selectedPage
            self.navigationController?.show(toVC, sender: self)
        }
    }
}

final class RelationsDataSource: NSObject, UITableViewDataSource {
    var relations: [Page]!
    
    init(relations: [Page]) {
        self.relations = relations
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.linkLabel.text = "URL: \(relations[indexPath.row].link)"
        cell.rankLabel.text = "Rank: \(relations[indexPath.row].pageRank)"
        return cell
    }
}

final class ParentsDataSource: NSObject, UITableViewDataSource {
    var parents: [Page]!
    
    init(parents: [Page]) {
        self.parents = parents
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.linkLabel.text = "URL: \(parents[indexPath.row].link)"
        cell.rankLabel.text = "Rank: \(parents[indexPath.row].pageRank)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
}
