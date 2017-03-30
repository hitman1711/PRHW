//
//  Graph.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 29.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import Foundation

final class Graph {
    static let shared: Graph = Graph()
    private init() {}
    
    var pages: [String: Page] = [:]
    
    func link(fromLink: String, toLink: String)  {
        let from = page(link: fromLink)
        let to = page(link: toLink)
        if let fromPage = from, let toPage = to {
            fromPage.addRelation(page: toPage)
        }
    }
    
    func page(link: String) -> Page? {
        guard let result: Page = pages[link] else {
            if pages.count > maxPages {
                return nil
            }
            let pg = Page(lnk: link)
            pages[link] = pg
            return pg
        }
        return result
    }
    
    func pageForDownload() -> Page? {
        for (_, page) in pages {
            if !page.isDownloaded {
                return page
            }
        }
        return nil
    }
}
