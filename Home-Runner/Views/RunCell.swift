//
//  RunCell.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/16/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class RunCell: UITableViewCell {

    
    @IBOutlet weak var runDurationLbl: UILabel!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var avgPaceLbl: UILabel!
    @IBOutlet weak var runDateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(run: Run) {
        self.runDateLbl.text = run.date.formatDateString()
        self.totalDistanceLbl.text = "\(run.distance.metersToKilometers(places: 2)) km"
        self.runDurationLbl.text = run.duration.formatTimeDuration()
        self.avgPaceLbl.text = run.pace.formatTimeDuration()
    }
    
}
