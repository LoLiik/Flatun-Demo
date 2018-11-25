//
//  NewsCollectionViewController.swift
//  FlatunDemo
//
//  Created by Евгений on 19.11.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

private let reuseIdentifier = "NewsPostCell"
fileprivate let baseRequestURL = "http://api.flatun.com/api/feed_item/"
fileprivate let itemsPerRow: CGFloat = 1
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class NewsCollectionViewController: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!

    @IBAction func showSide(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)

    }

    private let refreshControl = UIRefreshControl()
    var sourceId: Int? { didSet{ loadNews() } }

    var news: News?

    override func viewDidLoad() {
        super.viewDidLoad()
        if sourceId == nil{
            self.title = "All"
        }
        if #available(iOS 10.0, *){
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        refreshControl.beginRefreshing()
        loadNews{
            self.collectionView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ =  self.view
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor(hex: "5D6474")
        
    }

    @objc private func refreshNews(_ sender: Any){
        loadNews{
            self.collectionView.reloadData()
        }
    }

    func loadNews(from url: String = "", _ completion: @escaping () -> Void){
        var urlString = ""
        if let id = sourceId {
            urlString = url.isEmpty ? "\(baseRequestURL)?provider=\(id)" : url
        } else {
            urlString = baseRequestURL
        }
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of [Providers] object
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                let parsedNews = try decoder.decode(News.self, from: data)

                //Get back to the main queue
                DispatchQueue.main.async {
                    if self.news == nil{
                        self.news = parsedNews
                    } else {
                        self.news?.nextLink = parsedNews.nextLink
                        self.news?.posts.append(contentsOf: parsedNews.posts)
                    }
                    completion()
                    self.refreshControl.endRefreshing()
                }

            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
}

// MARK: UICollectionViewDataSource
extension NewsCollectionViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return news?.posts.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsPostCVCell
        cell.newsPost = news?.posts[indexPath.row]

        if indexPath.row == (news?.posts.count ?? 0) - 1 {
            loadNews(from: news?.nextLink ?? "" ){
                self.collectionView.reloadData()
            }
        }

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension NewsCollectionViewController: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,                          sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width:widthPerItem, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    private func loadNews(){
        
    }

}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}


