import UIKit

class searchPetTableViewController: ParserTableViewController {

    var apiController : GetAPI = GetAPI()
    
    var imageName : [String] = []
    var happenDt : [String] = []
    var happenPlace : [String] = []
    var sex : [String] = []
    var specialMrk : [String] = []
    var status : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200.0
        
        beginParsing(wantURL: apiController.getURLs(keywords: "전체", "축종코드", "417000",
        "품종코드", "000054", "시도코드", "6110000", "시군구코드", "3220000")
            , strings: "popfile", "happenDt", "happenPlace", "processState", "sexCd", "specialMark")
        
        if let value = valueCluster["popfile"]{
            imageName = value
        }
        if let value = valueCluster["happenDt"]{
            happenDt = value
        }
        if let value = valueCluster["happenPlace"]{
            happenPlace = value
        }
        if let value = valueCluster["processState"]{
            status = value
        }
        if let value = valueCluster["sexCd"]{
            sex = value
        }
        if let value = valueCluster["specialMark"]{
            specialMrk = value
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        
        if let url = URL(string:imageName[indexPath.row]){
            if let data = try? Data(contentsOf: url){
                cell.petImageView.image = UIImage(data: data)
            }
        }
        cell.happenDate.text = happenDt[indexPath.row]
        cell.happenPlace.text = happenPlace[indexPath.row]
        if sex[indexPath.row] == "F"{
            cell.sex.text = "여자"
        }
        else{
            cell.sex.text = "남자"
        }
        cell.specialMark.text = specialMrk[indexPath.row]
        cell.status.text = "상태 : " + status[indexPath.row]
        return cell
    }

}
