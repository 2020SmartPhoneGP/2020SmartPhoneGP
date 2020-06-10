
import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  // MARK: - Properties
  @IBOutlet var tableView: UITableView!
  @IBOutlet var searchFooter: SearchFooter!
  
    // 디테일뷰는 메인스토리보드에 추가 시켜서 동물 사진 파싱 할 예정
  var detailViewController: DetailViewController? = nil
  var search = [SearchSource]()
    
// 검색중인 리스트를 보유
  var filteredSearches = [SearchSource]()
  let searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - View Setup
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 검색 컨트롤러 설정
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Animals"
    navigationItem.searchController = searchController
    definesPresentationContext = true
    
    // Setup the Scope Bar
    searchController.searchBar.scopeButtonTitles = ["All", "Kind", "Age", "Other"]
    searchController.searchBar.delegate = self
    
    // Setup the search footer
    tableView.tableFooterView = searchFooter
    
    /*              // 카테고리, 이름은 파싱해서 변수로 넣을것  카테고리-타이틀  네임-서브타이틀
    search = [
      SearchSource(category:"Chocolate", name:"Chocolate Bar"),
      SearchSource(category:"Chocolate", name:"Chocolate Chip"),
      SearchSource(category:"Chocolate", name:"Dark Chocolate"),
      SearchSource(category:"Hard", name:"Lollipop"),
      SearchSource(category:"Hard", name:"Candy Cane"),
      SearchSource(category:"Hard", name:"Jaw Breaker"),
      SearchSource(category:"Other", name:"Caramel"),
      SearchSource(category:"Other", name:"Sour Chew"),
      SearchSource(category:"Other", name:"Gummi Bear"),
      SearchSource(category:"Other", name:"Candy Floss"),
      SearchSource(category:"Chocolate", name:"Chocolate Coin"),
      SearchSource(category:"Chocolate", name:"Chocolate Egg"),
      SearchSource(category:"Other", name:"Jelly Beans"),
      SearchSource(category:"Other", name:"Liquorice"),
      SearchSource(category:"Hard", name:"Toffee Apple")]
    */
    
    if let splitViewController = splitViewController {
      let controllers = splitViewController.viewControllers
      detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if splitViewController!.isCollapsed {
      if let selectionIndexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: selectionIndexPath, animated: animated)
      }
    }
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Table View
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      searchFooter.setIsFilteringToShow(filteredItemCount: filteredSearches.count, of: search.count)                    // 전체 카운트 중 필터링 된 카운트를 표시
      return filteredSearches.count     // 행의 개수는 필터링 된 행의 개수
    }
    
    searchFooter.setNotFiltering()
    return search.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    // 필터링을 했다면
    let tv_Search: SearchSource                 // tv_Search  테이블뷰 지역변수
    if isFiltering() {
      tv_Search = filteredSearches[indexPath.row]
    } else {        // 아니라면
      tv_Search = search[indexPath.row]
    }
    cell.textLabel!.text = tv_Search.age
    cell.detailTextLabel!.text = tv_Search.kind
    return cell
  }
  
  // MARK: - Segues
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showDetail" {
      if let indexPath = tableView.indexPathForSelectedRow {
        let pre_Search: SearchSource              // pre_Search  prepare 지역변수
        if isFiltering() {
          pre_Search = filteredSearches[indexPath.row]
        } else {
          pre_Search = search[indexPath.row]
        }
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.detailSearch = pre_Search
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }
    }
  }
  
  // MARK: - Private instance methods
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    // search bar 안에 텍스트가 들어있다면 filteredCandies를 candies 안에 filter를 써서
    // candy 배열을 bool incloser 안을 통과한 아이템들만 필터링을 해서 이 함수에 넣어라
    filteredSearches = search.filter({( searchsource : SearchSource) -> Bool in
      let doesCategoryMatch = (scope == "All") || (searchsource.kind == scope)
      
      if searchBarIsEmpty() {
        return doesCategoryMatch
      } else {
        return doesCategoryMatch &&
            searchsource.age.lowercased().contains(searchText.lowercased())
            // 각각의 객체들이 name을 소문자로 바꿔서 searchText에 텍스트가 들어있느냐 있으면 true
            // true를 반환하는 아이템들만 filteredSearches에 넣어라
            // 핵심!!!!!!!!!!!!!!!!!!!
      }
    })
    tableView.reloadData()
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
    // 필터링을 하고 있는가?
  func isFiltering() -> Bool {
    // index == 0 이면 all  // != 0 이면 카테고리를 선택한 것
    let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
    return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
  }
}

extension MasterViewController: UISearchBarDelegate {
  // MARK: - UISearchBar Delegate
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
  }
}

// 내용 업데이트 함수
extension MasterViewController: UISearchResultsUpdating {
  // MARK: - UISearchResultsUpdating Delegate
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
    filterContentForSearchText(searchController.searchBar.text!, scope: scope)
  }
}
