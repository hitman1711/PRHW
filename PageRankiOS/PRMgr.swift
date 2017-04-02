//
//  PRMgr.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 30.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import Foundation

final class PRMgr {
    static let shared: PRMgr = PRMgr()
    private init() {}
    let graph = Graph.shared
    
    func startJobs(url: String, completion: @escaping ([Page], [Double]) -> ()) {
        fillFrom(link: url)
        while true {
            guard let pageLink = graph.pageForDownload()?.link else {
                break
            }
            if pageLink.contains(baseURL) {
                fillFrom(link: pageLink)
            }
        }
        performPRTasks { times in
            var pages = Array(self.graph.pages.values)
            pages.sort(by: >)
            completion(pages, times)
        }
    }
    
    func fillFrom(link: String) {
        let links = NetMgr.performTask(urlStr: link)
        graph.pages[link]?.isDownloaded = true
        for strLink in links {
            if strLink.contains(baseURL) {
                graph.link(fromLink: link, toLink: strLink)
            }
        }
    }
    
    func performPRTasks(completion: @escaping ([Double]) -> ()) {
        var columns = [[Bool]]()
        var keys = [String]()
        
        for (fromKey, _) in graph.pages {
            keys.append(fromKey)
            var row = [Bool]()
            for (_, toVal) in graph.pages {
                let isContains = toVal.relations.contains(where: { (toPage: Page) -> Bool in
                    toPage.link == fromKey
                })
                row.append(isContains)
            }
            columns.append(row)
        }
        
        let parallelLessIterTime = parallelLessIterationPR()
        let parallelLessTime = parallelLessPR()
        let parallelExTime = parallelExPR()
        completion([parallelLessIterTime, parallelLessTime, parallelExTime])
//        reloadData()
    }
    
    
    func parallelLessIterationPR() -> Double {
        startPR()
        let before = Date().timeIntervalSince1970
        calculatePR()
        let after = Date().timeIntervalSince1970
        let result = after-before
        print("ParallelLessIterationPR: \(result)")
        return result
    }
    
    func parallelLessPR() -> Double {
        startPR()
        let before = Date().timeIntervalSince1970
        calculateExPR()
        let after = Date().timeIntervalSince1970
        let result = after-before
        print("ParallelLessPR: \(result)")
        return result
    }
    
    func parallelExPR() -> Double {
        startPR()
        let before = Date().timeIntervalSince1970
        calculateParallelExPR()
        let after = Date().timeIntervalSince1970
        let result = after-before
        print("ParallelExPR: \(result)")
        return result
    }
    
    
    func startPR() {
        for (_, page) in graph.pages {
            page.pageRank = 1.0 / Double(graph.pages.count)
        }
    }
    
    func calculatePR() {
        let N = Double(graph.pages.count)
        
        for _ in 0..<maxPages {
            for (_, page) in graph.pages {
                var inbound: Double = 0.0
                for parent in page.parents {
                    inbound += parent.pageRank / Double(parent.relations.count)
                }
                page.pageRank = (1 - fadingCoeff) / N + fadingCoeff*inbound
            }
        }
    }
    
    func calculateExPR() {
        let N = graph.pages.count
        let values = Array(graph.pages.values)
        for _ in 0..<maxPages {
            for i in 0..<N {
                let page = values[i]
                var pr = 0.0
                for parent in page.parents {
                    pr += parent.relations.count > 0 ? 1.0 / Double(parent.relations.count) : 0
                }
                page.nextPR = pr
            }
            normalizeGraph()
        }
    }
    
    func calculateParallelExPR() {
        let N = graph.pages.count
        let values = Array(graph.pages.values)
        for _ in 0..<maxPages {
            DispatchQueue.concurrentPerform(iterations: N, execute: { (i: Int) in
                let page = values[i]
                var pr = 0.0
                for parent in page.parents {
                    pr += parent.relations.count > 0 ? 1.0 / Double(parent.relations.count) : 0
                }
                page.nextPR = pr
            })
            normalizeGraph()
        }
    }
    
    func normalizeGraph() {
        for (_, page) in graph.pages {
            if let pr = page.nextPR {
                page.pageRank = pr
            }
        }
    }
    
}
