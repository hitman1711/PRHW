//
//  CustomTableViewCell.swift
//  PageRankiOS
//
//  Created by Артур Сагидулин on 30.03.17.
//  Copyright © 2017 Артур Сагидулин. All rights reserved.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
