//
//  CollectionView TableViewCell.swift
//  Netflix Clone
//
//  Created by MAC on 12/8/2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = [Movie]()
    private var tvs: [Tv] = [Tv]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movies: [Movie]?, tvs: [Tv]?) {
           self.movies = movies ?? []
           self.tvs = tvs ?? []
           DispatchQueue.main.async {
               [weak self] in
               self?.collectionView.reloadData()
           }
       }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistanceManager.shared.downloadTitleWith(model: movies[indexPath.row]) { result in
            switch result {
            case.success():
                print("downloaded to Database")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //print("Downloading \(movies[indexPath.row].original_title ?? "")")
        
    }

}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count + tvs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let itemIndex = indexPath.item
        if itemIndex < movies.count {
            let movie = movies[itemIndex]
            cell.configure(with: movie.poster_path)
        } else {
            let tvIndex = itemIndex - movies.count
            let tv = tvs[tvIndex]
            cell.configure(with: tv.poster_path)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
         let title = movies[indexPath.row]
        guard let titleName = title.original_title ?? title.title else {return}
        
        APICaller.shared.getMovie(with: titleName + "trailer"){ [weak self] result in
            switch result {
            case .success(let videoElement):
                
                guard let strongSelf = self else {return}
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? "Unknown")
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
        identifier: nil,
        previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) {_ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return config
    }
}
