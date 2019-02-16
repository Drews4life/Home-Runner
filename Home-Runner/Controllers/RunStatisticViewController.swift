//
//  SecondViewController.swift
//  Home-Runner
//
//  Created by Andrii Zakharenkov on 2/14/19.
//  Copyright © 2019 Andrii Zakharenkov. All rights reserved.
//

import UIKit

class RunStatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Run.retrieveAllRuns()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "runLogCell", for: indexPath) as? RunCell else { return RunCell() }
        guard let run = Run.retrieveAllRuns()?[indexPath.row] else { return RunCell() }
        
        cell.configureCell(run: run)
        
        return cell
    }

}

