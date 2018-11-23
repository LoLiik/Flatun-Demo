//
//  SourcesTableTableViewController.swift
//  FlatunDemo
//
//  Created by Евгений on 18.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class SourcesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var sources: [NewsSource]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "TableBackground"))
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        loadSources {
            self.tableView.reloadData()
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func loadSources(_ completion: @escaping () -> Void){
        let urlString = "http://api.flatun.com/api/provider/"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of [NewsSources] object
                let parsedSources = try JSONDecoder().decode([NewsSource].self, from: data)

                //Get back to the main queue
                DispatchQueue.main.async {
                    self.sources = parsedSources
                    completion()
                }

            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsSourceCell", for: indexPath)
        if let newsSourceCell = cell as? NewsSourceTVCell{
            newsSourceCell.newsSource = sources?[indexPath.row]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let id = sources?[indexPath.row].id {
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("ShowCollection"), object: nil, userInfo: ["SourceId":id, "SourceTitle": sources?[indexPath.row].name])
        }

    }


}



