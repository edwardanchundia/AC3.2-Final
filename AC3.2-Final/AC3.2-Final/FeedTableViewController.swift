//
//  FeedTableViewController.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class FeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let reuseableCellIdentifier = "FeedCell"
    var currentUser: User?
    var currentUserUid: String?
    
    var databaseReference: FIRDatabaseReference!
    var links = [Photo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let loginController = LogInViewController()
        present(loginController, animated: true, completion: nil)
        setupViewHierarchy()
        configureConstraints()
        
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        getLinks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLinks()
    }

    func getLinks() {
        databaseReference.observeSingleEvent(of: .value, with: { (snapshot) in
            var newLinks: [Photo] = []
            for child in snapshot.children {
                dump(child)
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String: String] {
                    let link = Photo(key: snap.key, userId: valueDict["userId"] ?? "", comment: valueDict["comment"] ?? "")
                    newLinks.append(link)
                }
            }
            self.links = newLinks
            self.feedTableView.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCellIdentifier, for: indexPath) as! FeedTableViewCell
        
        let link = links[indexPath.row]
        cell.feedComments.text = link.comment
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/\(link.key)")
        spaceRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error)
            } else {
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    cell.feedImage.image = image
                    cell.setNeedsLayout()
                }
            }
        }

        return cell
    }
    
    func setupViewHierarchy()  {
        self.view.addSubview(feedTableView)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        feedTableView.snp.makeConstraints({ (view) in
            view.top.bottom.width.height.equalToSuperview()
        })
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(FeedTableViewCell.self, forCellReuseIdentifier: reuseableCellIdentifier)
    }
    
    internal lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: self.reuseableCellIdentifier)
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        return tableView
    }()

}
