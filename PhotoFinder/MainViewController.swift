import UIKit
import SDWebImage

class MainViewController: UIViewController {
    
    var data: [Photo] = []
    let networkManager = NetworkManager()
    var queryText = ""
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Request", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 12
        return button
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchBar)
        searchBar.delegate = self
        setSearchBarConstraints()
        
        requestButton.addTarget(self, action: #selector(requestButtonClick(_:)), for: .touchUpInside)
        setRequestButtonConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(cancelButtonClick(_:)))
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        setCollectionViewConstraints()
    }
    
    @objc
    func requestButtonClick(_ sender: Any) {
        
        networkManager.dataRequest(query: queryText) { photos in
            self.data = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc
    func cancelButtonClick(_ sender: Any) {
        data = []
        searchBar.text = ""
        queryText = ""
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setSearchBarConstraints() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    func setCollectionViewConstraints() {
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setRequestButtonConstraints() {
        view.addSubview(requestButton)
        requestButton.translatesAutoresizingMaskIntoConstraints = false
        requestButton.leftAnchor.constraint(equalTo: searchBar.rightAnchor, constant: 0).isActive = true
        requestButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7).isActive = true
        requestButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.27).isActive = true
    }
}

// MARK: - Collection View Methods

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let destinationViewController = DetailsViewController()
        guard let urlString = data[indexPath.row].urls?.small else { return }
        guard let url = URL(string: urlString) else { return }
        destinationViewController.imageView.sd_setImage(with: url)
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.photo = data[indexPath.row]
        return cell
    }
}

// MARK: - SearchBar Methods

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText != "" {
            self.queryText = searchText
        }
    }
}
