//
//  TableViewController.swift
//  StorylyDemo
//
//  Created by Yiğit Çalışkan on 4.09.2023.
//  Copyright © 2023 App Samurai Inc. All rights reserved.
//

import UIKit
import Storyly

class TableViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: .zero)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        return _tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.tableView.dataSource = self

        self.tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.reuseIdentifier)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 1
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseIdentifier, for: indexPath) as! TableCell
        cell.indexPath = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
