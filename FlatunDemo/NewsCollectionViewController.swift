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



class NewsCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {


    @IBOutlet weak var collectionView: UICollectionView!

    var sourceId: Int? = 2 { didSet{ loadNews() } }

    var news: News?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        loadNews{
            self.collectionView.reloadData()
        }

    }

    func loadNews(from url: String = "", _ completion: @escaping () -> Void){
        guard let id = sourceId else { return }
        let urlString = url.isEmpty ? "\(baseRequestURL)?provider=\(id)" : url
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }

            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of [NewsSources] object
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
                }

            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

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
//        print("\(cell as! NewsPostCVCell)")
//        cell.backgroundColor = .black
        cell.newsPost = news?.posts[indexPath.row]

        if indexPath.row == (news?.posts.count ?? 0) - 1 {
            loadNews(from: news?.nextLink ?? "" ){
                self.collectionView.reloadData()
            }
        }

        return cell
    }

    // MARK: UICollectionViewDelegate
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

struct ImageInfo: Codable{
    let image: URL
    let heigtht: Int
    let width: Int
    let color: UIColor

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decode(URL.self, forKey: .image)
        heigtht = try container.decode(Int.self, forKey: .height)
        width = try container.decode(Int.self, forKey: .width)
        let colorHexString = try container.decode(String.self, forKey: .color)
        color = UIColor(hex: colorHexString)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(heigtht, forKey: .height)
        try container.encode(width, forKey: .width)
        let hexColorCode = color.toHexString()
        try container.encode(hexColorCode, forKey: .color)

    }

    private enum CodingKeys: String, CodingKey{
        case image
        case height
        case width
        case color
    }
}

struct NewsPost: Codable{
    let images: [ImageInfo]
    let title: String
    let published: Date
    let providerAuthorName: String
    let providerAuthorAvatar: URL?
    let likesCount: Int

        init(
             images: [ImageInfo],
             title: String,
             published: Date,
             providerAuthorName: String,
             providerAuthorAvatar: URL?,
             likesCount: Int
            )
        {
            self.images = images
            self.title = title
            self.published = published
            self.providerAuthorName = providerAuthorName
            self.providerAuthorAvatar = providerAuthorAvatar
            self.likesCount = likesCount
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            providerAuthorName = try container.decode(String.self, forKey: .providerAuthorName)
            providerAuthorAvatar = try container.decode(URL?.self, forKey: .providerAuthorAvatar)
            likesCount = try container.decode(Int.self, forKey: .likesCount)

            let dateString = try container.decode(String.self, forKey: .published)
            let formatter = DateFormatter.iso8601Full
            if let date = formatter.date(from: dateString) {
                published = date
            } else {
                print(dateString)
                throw DecodingError.dataCorruptedError(forKey: .published,
                                                       in: container,
                                                       debugDescription: "Date string does not match format expected by formatter.")
            }

            images = try container.decode([ImageInfo].self, forKey: .images)
        }

        private enum CodingKeys: String, CodingKey{
            case images 
            case title
            case published
            case providerAuthorName = "provider_author_name"
            case providerAuthorAvatar = "provider_author_avatar"
            case likesCount = "likes_count"
        }
}

struct News: Codable{
    var nextLink: String?
    var posts = [NewsPost]()

    init(next: String?, posts: [NewsPost]){
        self.nextLink = next
        self.posts = posts
    }

    private enum CodingKeys: String, CodingKey{
        case nextLink = "next"
        case posts = "results"
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

extension UIColor{

    convenience init(hex: String){
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

//        if ((cString.count) != 6) {
//            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0

        return NSString(format:"#%06x", rgb) as String
    }
}
