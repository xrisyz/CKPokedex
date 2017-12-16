//
//  HomeController.swift
//  CKPokedex
//
//  Created by Christopher Brandon Karani on 17/11/2017.
//  Copyright © 2017 Christopher Brandon Karani. All rights reserved.
//

import UIKit
import IGListKit
import TRON
import RealmSwift



protocol HomeControllerDelegate: class {
    func reloadAdapter()
}

private let reuseIdentifier = "Cell"

class HomeController: UICollectionViewController {
    var networkService : NetworkService
    var pokemons = [Pokemon]()
    let databaseService : DatabaseService = DatabaseManager()


    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupIGListKit()
        fetchData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    func reloadAdapter() {
        self.adapter.reloadData(completion: nil)
    }
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupIGListKit() {
        adapter.collectionView = collectionView
        collectionView?.backgroundColor = .white
        adapter.dataSource = self
    }
}

// DataSource

extension HomeController : ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let realmObjects = databaseService.realmDatabase.objects(PokemonData.self)
        print("The First Real, Object is: ", realmObjects.first)
        print("Realm Objects Count ",realmObjects.count)
        let items = realmObjects.sorted {Int($0.id!)! < Int($1.id!)!}
        
        return items
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CKPokemonIndexController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
//Network
extension HomeController {
    func fetchData() {
        networkService.fetchPokemon { (pokemons) in
            self.pokemons = pokemons
            self.adapter.reloadData(completion: nil)
        }
    }
}

