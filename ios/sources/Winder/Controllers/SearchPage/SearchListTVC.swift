//
//  SearchListTVC.swift
//  Winder
//
//  Created by 이동규 on 2021/11/17.
//

import Foundation
import UIKit

class SearchListTVC: UITableViewController {
    
    lazy var wineModel = WineModel()
    lazy var filteredWine = [WineCell]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpWineLists()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.setUpSearchController()
        
    }
    
    @IBAction func didTapFilterConditionBtn(_ sender: Any) {
        print(#function)
        guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "ID-PopUpToFilterVC") else { return }
        popupVC.modalPresentationStyle = .overFullScreen
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true, completion: nil)
    }
    
    private func setUpTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 308
    }
    
    private func setUpWineLists() {
        self.wineModel.loadFromAPI {
            self.filteredWine = self.wineModel.wineCellList
            self.tableView.reloadData()
            self.setUpTableView()
        }
    }
    
    private func setUpSearchController() {
        self.searchController.searchBar.placeholder = "Seach wine from list"
        self.searchController.searchResultsUpdater = self // 중요. 사용자가 검색한 값에 따라 업데이트
        self.searchController.navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.sizeToFit()
        self.navigationItem.searchController = self.searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ID-manual-SearchWineTVC-WineInfoVC" {
            guard let infoVC = segue.destination as? WineInfoVC else { return }
            infoVC.modalPresentationStyle = .fullScreen
            if let isActive = self.navigationItem.searchController?.isActive {
                if isActive {
                    self.navigationItem.searchController?.isActive = false
                    if let indexPath = sender as? IndexPath {
                        let row = self.isFiltering ? self.filteredWine[indexPath.section] : self.wineModel.wineCellList[indexPath.section]
                        WineModel().loadDetailFromAPI(wineID: row.id ?? 1591326) { wineDetail in
                            if let wineDetail = wineDetail {
                                infoVC.wineDetail = wineDetail
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.navigationController?.pushViewController(infoVC, animated: true)
                        }
                    }
                } else {
                    print("here!!", infoVC)
                    if let indexPath = sender as? IndexPath {
                        print("here!!", infoVC, indexPath)
                        let row = self.isFiltering ? self.filteredWine[indexPath.section] : self.wineModel.wineCellList[indexPath.section]
                        print(#function, row.id)
                        WineModel().loadDetailFromAPI(wineID: row.id ?? 1591326) { wineDetail in
                            if let wineDetail = wineDetail {
                                infoVC.wineDetail = wineDetail
                            }
                        }
                        
                        //self.navigationController?.pushViewController(infoVC, animated: true)
                    }
                }
            }
        }
    }
    
    func getImageFromURL(_ urlStr: String, completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlStr)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    completion(image)
                } else {
                    print(#function, "parse error")
                }
            }
        }
    }
    
    //+
}

// MARK: - 테이블뷰 델리게이트&데이터소스 구현
extension SearchListTVC {
    
    // 셀 높이(동적으로하려면 automatic dimension 알아보기)
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(308.0)
    }
    
    // 섹션 별 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (self.isFiltering ? self.filteredWine.count : self.wineModel.wineList.count)
        return 1
    }
    
    // 대신 섹션 개수를 원래 대로
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.isFiltering ? self.filteredWine.count : self.wineModel.wineCellList.count)
    }
    
    // 셀 섹션 헤더높이
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    // 셀 데이터
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID-SearchWineCell", for: indexPath) as! SearchWineCell
        
        // 검색때는 필터링 로우로 바꾸기 -> 섹션으로 커스텀함
        let row = self.isFiltering ? self.filteredWine[indexPath.section] : self.wineModel.wineCellList[indexPath.section]
        
        // MARK: - api에 맞춰서변경해야함
        
        self.getImageFromURL(row.image["wine_bottle"]!) { image in
            if let image = image {
                cell.wineImageView.image = image
            }
        }
        
        self.getImageFromURL(row.image["country_flag"]!) { image in
            if let image = image {
                cell.wineCountryIcon.image = image
            }
        }
        
        cell.wineryLabel.text = row.winery
        cell.wineTitleLabel.text = row.name
        cell.wineCountryAndRegionLabel.text = "\(row.country), \(row.region)"
        //cell.wineTypeLabel.text = row. // 와인타입은 패싱중
        cell.ratingLabel.text = row.rating
        cell.priceLabel.text = row.price
        // 셀 안에 5로 둥글게
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ID-manual-SearchWineTVC-WineInfoVC", sender: indexPath)
    }
}

// MARK: - 서치바 세팅
extension SearchListTVC: UISearchResultsUpdating {
    
    func filteredContentForSearchText(_ searchText:String){
        self.filteredWine = self.wineModel.wineCellList.filter({ wine -> Bool in
            return wine.name.uppercased().contains(searchText.uppercased()) || wine.country.contains(searchText) || wine.region.contains(searchText)
        })
        self.tableView.reloadData()
    }
    
    // 서치 컨트롤 글자 바뀔 때마다 호출되는 함수
    func updateSearchResults(for searchController: UISearchController) {
        //print(#function)
        filteredContentForSearchText(searchController.searchBar.text ?? "")
    }

}
