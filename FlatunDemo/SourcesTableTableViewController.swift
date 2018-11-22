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
        //        news.append(NewsSource.init(name: "Dribbble", logoURL: URL(string: "http://api.flatun.com/media/17a75821-e183-423d-b6a8-490fa78abfff.png")))
//        tableView.reloadData()
        loadSources {
            self.tableView.reloadData()
        }

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sources?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsSourceCell", for: indexPath)
        if let newsSourceCell = cell as? NewsSourceTVCell{
            newsSourceCell.newsSource = sources?[indexPath.row]
        }
        return cell
    }

     // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show News"{
            let destinationVC = segue.destination as! NewsCollectionViewController
//            destinationVC.sourceId = 
        }
    }

}

struct NewsSource: Codable{
    var id: Int
    var name: String
    var description: String
    var imageURL: URL?

    init(
        id: Int,
        name: String,
        description: String,
        imageURL: URL?
        //        rrsURL: URL?,
        //        siteURL: URL?,
        //        userActive: Bool,
        //        language: String?,
        //        active: Bool,
        //        votesCount: Int,
        //        lastFeedItem: Int,
        //        defaultType: String
        )
    {
        self.id = id
        self.name = name
        self.description = description
        self.imageURL = imageURL
        //        self.rrsURL = rrsURL
        //        self.siteURL = siteURL
        //        self.boolUserActive = userActive
        //        self.language = language
        //        self.boolActive = active
        //        self.votesCount = votesCount
        //        self.lastFeedItem = lastFeedItem
        //        self.defaultType = defaultType

    }

//    init(from decoder: Decoder) throws{
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let id: String = try container.decode(String.self, forKey: .id)
//        let name: Int = try container.decode(Int.self, forKey: .name)
//        let twitter: URL = try container.decode(URL.self, forKey: .imageURL)
//    }

    private enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case imageURL = "image"
        //        case rrsURL = "rss_url"
        //        case siteURL = "site_url"
        //        case userActive = "user_active"
        //        case language
        //        //    case tags: [Tag]
        //        case active
        //        case votesCount = "votes_count"
        //        //    case tileType: TileType
        //        case lastFeedItem = "last_feed_item"
    }
}
