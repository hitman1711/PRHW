//
//  NetMgr.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 30.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import Foundation
import HTMLReader

final class NetMgr {
    class func performTask(urlStr: String) -> [String] {
        var result = [String]()
        autoreleasepool {
            let url = URL(string: urlStr)!
            do {
                let str = try String.init(contentsOf: url, encoding: String.Encoding.utf8)
                let doc = HTMLDocument(string: str)
                let aNodes = doc.nodes(matchingSelector: "a")
                for node in aNodes {
                    if let href = node.attributes["href"], href.contains(baseURL) {
                        result.append(href)
                    }
                }
            } catch {
                print("Catch Error: \(error.localizedDescription)")
            }
        }
        return result
    }
}
