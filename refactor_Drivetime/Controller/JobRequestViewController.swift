//
//  JobRequestViewController.swift
//  refactor_Drivetime
//
//  Created by Wing Sun Cheung on 2/11/19.
//  Copyright © 2019 Wing Sun Cheung. All rights reserved.
//

import UIKit

class JobRequestViewController: UIViewController, JobRequestDelegate {
    
    var dataProvider: JobRequestDataProvider?
    @IBOutlet weak var jobRequestTableView: UITableView!
    var client: (APIClient & LoginSavable)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTableView()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Job Requests"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataProvider?.loadData()
    }
    
    func onFetchingJobRequestComplete() {
        jobRequestTableView.reloadData()
    }
    
    func initializeTableView() {
        jobRequestTableView.register(UINib(nibName: "JobRequestCell", bundle: nil), forCellReuseIdentifier: "JobRequestCell")
        
        dataProvider = JobRequestDataProvider(client: client, delegate: self)
        
        jobRequestTableView.dataSource = dataProvider
        jobRequestTableView.delegate = dataProvider
        
    }
}
