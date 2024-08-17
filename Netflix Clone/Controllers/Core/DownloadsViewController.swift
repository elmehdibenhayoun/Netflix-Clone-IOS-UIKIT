//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by MAC on 12/8/2024.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var movies: [TitleItem] =  [TitleItem]()
    
    private let downloadedTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.indetifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        } 
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistanceManager.shared.fetchingTitleFromDataBase { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                self?.downloadedTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.indetifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        
        let movie = movies[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (movie.title ?? movie.original_title) ?? "nil", posterURL: movie.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistanceManager.shared.deleteTitleWith(model: movies[indexPath.row] ) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                
                
            }
        default:
            break;
           
            
        
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        guard let titleName = movie.original_title ?? movie.title else {return}
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: movie.overview ?? ""))
                    self?.navigationController?.pushViewController(vc , animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
