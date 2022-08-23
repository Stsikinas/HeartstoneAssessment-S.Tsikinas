//
//  Extensions.swift
//  Hearthstone
//
//  Created by Stavros Tsikinas on 28/7/22.
//

import Foundation
import UIKit


// - MARK: UIKit Extensions

extension UIViewController {
    
    func showInfoAlert(with message: String) {
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func addButtons(right: [UIBarButtonItem]? = nil, left: [UIBarButtonItem]? = nil) {
        if let right = right {
            navigationItem.setRightBarButtonItems(right, animated: true)
        }
        if let left = left {
            navigationItem.setLeftBarButtonItems(left, animated: true)
        }
    }
}

extension UIBarButtonItem {
    
    public static func set(for expression: Bool, toggledName: String, nonToggledName: String) -> UIImage? {
        UIImage(systemName: expression ? toggledName : nonToggledName)
    }
    
}

extension UIButton.Configuration {
    public static func typed(with text: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        config.title = text
        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 15
        background.backgroundColor = .typeColor
        config.background = background
        
        return config
    }
}

extension UIImageView {
    
    // TODO: Write Unit Tests
    func load(from url: URL, mode: UIView.ContentMode) {
        
        URLSession.shared.dataTask(with: url) {  [weak self] data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                self?.addPlaceholderImage(from: url, with: mode)
                    return
                }
                DispatchQueue.main.async() {
                    self?.image = image
                    self?.contentMode = mode
                }
            }.resume()
    }
    
    private func addPlaceholderImage(from url: URL, with mode: UIView.ContentMode) {
        
        if let imgData = try? Data(contentsOf: url) {
            if let img = UIImage(data: imgData) {
                DispatchQueue.main.async { [weak self] in
                    self?.image = img
                    self?.contentMode = mode
                }
            }
        }
    }
    
}

extension UIColor {
    
    static var primaryColor: UIColor {
        UIColor(red: 0.29, green: 0.79, blue: 0.79, alpha: 1.0)
    }
    
    static var accentColor: UIColor {
        UIColor(red: 0.28, green: 0.21, blue: 0.11, alpha: 1.0)
    }
    
    static var typeColor: UIColor {
        UIColor(red: 0.48, green: 0.39, blue: 0.29, alpha: 1.0)
    }
    
}

extension UIView {
    
    func addSeparator() -> UIView {
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        separatorView.backgroundColor = UIColor(named: "SeparatorColor")
        addSubview(separatorView)
        
        return separatorView
    }
    
    /// Make view rounded (dashboard item)
    func cardView(of radius: CGFloat, with shadow: UIColor? = nil) {
        layer.cornerRadius = radius
        if let shadow = shadow {
            layer.shadowColor = shadow.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            layer.shadowRadius = 12.0
            layer.shadowOpacity = 0.7
        }
    }
    
    /// Add anchors to the view programmatically
    func addAnchors(wAnchor: NSLayoutDimension? = nil, _ wMulti: CGFloat? = nil,
                    hAnchor: NSLayoutDimension? = nil,_ hMulti: CGFloat? = nil,
                    cXAnchor: NSLayoutXAxisAnchor? = nil,
                    cYAnchor: NSLayoutYAxisAnchor? = nil,
                    lAnchor: NSLayoutXAxisAnchor? = nil, leftConstant: CGFloat? = nil,
                    tAnchor: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat? = nil,
                    rAnchor: NSLayoutXAxisAnchor? = nil, rightConstant: CGFloat? = nil,
                    bAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat? = nil,
                    widthConstant: CGFloat? = nil,
                    heightConstant: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let wAnchor = wAnchor {
            widthAnchor.constraint(equalTo: wAnchor, multiplier: wMulti == nil ? 1.0 : wMulti!).isActive = true
        }
        
        if let hAnchor = hAnchor {
            heightAnchor.constraint(equalTo: hAnchor, multiplier: hMulti == nil ? 1.0 : hMulti!).isActive = true
        }
        
        if let cXAnchor = cXAnchor {
            centerXAnchor.constraint(equalTo: cXAnchor, constant: 0).isActive = true
        }
        
        if let cYAnchor = cYAnchor {
            centerYAnchor.constraint(equalTo: cYAnchor, constant: 0).isActive = true
        }
        
        if let lAnchor = lAnchor {
            leftAnchor.constraint(equalTo: lAnchor, constant: leftConstant == nil ? 0 : leftConstant!).isActive = true

        }
        
        if let tAnchor = tAnchor {
            topAnchor.constraint(equalTo: tAnchor, constant: topConstant == nil ? 0 : topConstant!).isActive = true

        }
        
        if let rAnchor = rAnchor {
            rightAnchor.constraint(equalTo: rAnchor, constant: rightConstant == nil ? 0 : rightConstant!).isActive = true
        }
        
        if let bAnchor = bAnchor {
            bottomAnchor.constraint(equalTo: bAnchor, constant: bottomConstant == nil ? 0 : bottomConstant!).isActive = true
        }
        
        if let widthConstant = widthConstant {
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        
        if let heightConstant = heightConstant {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
}


// - MARK: Foundation extensions

extension String {
    
    func convertToURL() -> URL? {
        URL(string: self)
    }
}

// - MARK: Custom extensions

// - MARK: - Models Extensions

extension CardsResponse {
    // Ensure that decoding is successful for keys with whitespaces/special characters
    enum CodingKeys: String, CodingKey {
        case Basic = "Basic"
        case Classic = "Classic"
        case Promo = "Promo"
        case HallofFame = "Hall of Fame"
        case Naxxramas = "Naxxramas"
        case GoblinsvsGnomes = "Goblins vs Gnomes"
        case BlackrockMountain = "Blackrock Mountain"
        case TheGrandTournament = "The Grand Tournament"
        case TheLeagueofExplorers = "The League of Explorers"
        case WhispersoftheOldGods = "Whispers of the Old Gods"
        case OneNightinKarazhan = "One Night in Karazhan"
        case MeanStreetsofGadgetzan = "Mean Streets of Gadgetzan"
        case JourneytoUnGoro = "Journey to Un'Goro"
        case TavernBrawl = "Tavern Brawl"
        case HeroSkins = "Hero Skins"
        case Missions = "Missions"
        case Credits = "Credits"
        case System = "System"
        case Debug = "Debug"
    }
    
    func getAllCards() -> [Card] {
        Basic + Classic + Promo + HallofFame + Naxxramas + GoblinsvsGnomes + BlackrockMountain + TheGrandTournament + TheLeagueofExplorers + WhispersoftheOldGods + OneNightinKarazhan + MeanStreetsofGadgetzan + JourneytoUnGoro + TavernBrawl + HeroSkins + Missions + Credits + System + Debug
    }
}

extension CardViewModel {
    
    // In case new entries have "corrupt" data
    static var placeholderTitle: String {
        "No Name"
    }
}

extension CardViewModel {
    
    func getUrl() -> URL {
        guard let url = self.image.convertToURL() else {
            return URL(string: "https://via.placeholder.com/500x500.png?text=No+Image+Found")!
        }
        return url
    }
    
}

extension CardViewModel {
    
    func isFeatured(_ card: Card) -> Bool {
        
        return card.rarity == "Legendary" && ((card.mechanics?.contains(["name": "Deathrattle"])) != nil)
    }
    
}

extension CardViewModel {
    
    init(card: Card) {
        self.title = card.name ?? CardViewModel.placeholderTitle
        self.image = card.img ?? "https://via.placeholder.com/500x500.png?text=No+Image+Found"
        // TODO: isFavorite should be initialized based on the Query in DB (Favorites table)
        self.isFavorite = false
        self.select = {}
        self.description = (card.flavor?.isEmpty ?? true) ? "No Information to show" : card.flavor
        self.type = card.type
    }
}

extension CardsDataService {
    enum ServiceType {
        case AllCards
        case Favorites
    }
}

// - MARK: - Views Extensions

extension HomeTabViewController {
    
    func initView() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .primaryColor
    }
    
}

extension HomeTabViewController {
    
    // TODO: Write UI Tests
    func createTabNavigation(for root: UIViewController, with title: String? = "Title", and icon: String? = nil) -> UIViewController {
        let navigation = UINavigationController(rootViewController: root)
        if let title = title {
            navigation.tabBarItem.title = title
        }
        if let icon = icon {
            navigation.tabBarItem.image = UIImage(
                systemName: icon,
                withConfiguration:UIImage.SymbolConfiguration(scale: .large)
            )
        }
        navigation.navigationBar.prefersLargeTitles = true
        root.navigationItem.title = title
        root.navigationItem.largeTitleDisplayMode = .always
        
        return navigation
    }
    
}

extension HomeTabViewController {
    
    func attachFavoritesService() -> FavoritesService {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve app delegate")
        }
        
        return FavoritesService(with: appDelegate.persistentContainer)
    }
    
}

extension CardsCollectionViewController {
    
    func select(_ card: Card) {
        let destVC = CardViewController()
        destVC.card = card
        destVC.favoriteService = databseService
        show(destVC, sender: self)
    }
}

extension CardGridViewCell {
    
    // TODO: Write UI Test
    func configure() {
        cardName.text = cardViewModel.title
        cardImage.load(from: cardViewModel.getUrl(), mode: .scaleAspectFit)
    }
    
}

extension CardView {
    
    func configure() {
        cardImage.load(from: cardViewModel.getUrl(), mode: .scaleAspectFit)
        cardName.text = cardViewModel.title
        cardText.text = cardViewModel.description
        cardType.configuration = .typed(with: cardViewModel.type ?? "")
    }
    
}
