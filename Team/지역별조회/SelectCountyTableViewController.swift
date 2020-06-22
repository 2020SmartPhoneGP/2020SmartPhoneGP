import UIKit

class SelectCountyTableViewController: ParserTableViewController {
//군, 구 조회
    
    @IBOutlet var tbData: UITableView!
    
    @IBOutlet weak var navTitle: UINavigationItem!
    var upperCd = ""  // default
    var orgCd = ""
    var apiController : GetAPI = GetAPI()
    
    var orgdownNm : [String] = []
    var orgCds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if upperCd != ""{
            beginParsing(wantURL: apiController.getCounty(wantURL: "시군구", upperCd: upperCd), strings: "orgdownNm", "orgCd")
        }
        
        if let cluster = valueCluster["orgdownNm"]{
            orgdownNm = cluster
        }
        if let cluster = valueCluster["orgCd"]{
            orgCds = cluster
        }
        tbData.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orgdownNm.count
    }
    
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountyCell", for: indexPath)
        
        cell.textLabel?.text = orgdownNm[indexPath.row]
        //cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as //String
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        orgCd = orgCds[indexPath.row]
        return indexPath
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath : NSIndexPath){
        
        //self.performSegue(withIdentifier: "segueToShowKind", sender: tableView)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueToShowKind"{
            if let showRegionKindTableViewController = segue.destination as? ShowRegionKindTableViewController{
                showRegionKindTableViewController.currentOrgCd = upperCd
                showRegionKindTableViewController.currentDownOrgCd = orgCd
            }
        }
    }
}
