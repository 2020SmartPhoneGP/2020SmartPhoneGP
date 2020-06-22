import UIKit

class searchPetWithShowKindTableViewController: ParserTableViewController {

    var apiController : GetAPI = GetAPI()
    
    var imageName : [String] = []
    var happenDt : [String] = []
    var happenPlace : [String] = []
    var sex : [String] = []
    var specialMrk : [String] = []
    var status : [String] = []
    var careNm : [String] = []
    var careTel : [String] = []
    var careAddr : [String] = []
    
    var currentIndex : Int = -1
    
    var breedKindCode : String = ""
    var livestockCode : String = ""
    var isInData : Bool = true
    var row : Int = 10
    var pageNo : Int = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 200.0
        if breedKindCode == "전체"{
            beginParsing(wantURL: apiController.getURLs(keywords: "전체", "축종코드", livestockCode, "페이지" ,String(pageNo))
                , strings: "popfile", "happenDt", "happenPlace", "processState", "sexCd", "specialMark", "careNm", "careTel", "careAddr")
        }
        else{
            beginParsing(wantURL: apiController.getURLs(keywords: "전체", "축종코드", livestockCode,
            "품종코드", breedKindCode, "페이지" ,String(pageNo))
                , strings: "popfile", "happenDt", "happenPlace", "processState", "sexCd", "specialMark", "careNm", "careTel", "careAddr")
        }

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
        if let value = valueCluster["careNm"]{
            careNm = value
        }
        if let value = valueCluster["careTel"]{
            careTel = value
        }
        if let value = valueCluster["careAddr"]{
            careAddr = value
        }
        if imageName.count == 0{
            isInData = false
            imageName.append("DELETE")
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageName.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if careNm.count != 0{
            currentIndex = indexPath.row
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == row-2{
            pageNo += 1
            if breedKindCode == "전체"{
                beginParsing(wantURL: apiController.getURLs(keywords: "전체", "축종코드", livestockCode, "페이지" ,String(pageNo))
                    , strings: "popfile", "happenDt", "happenPlace", "processState", "sexCd", "specialMark", "careNm", "careTel", "careAddr")
            }
            else{
                beginParsing(wantURL: apiController.getURLs(keywords: "전체", "축종코드", livestockCode,
                "품종코드", breedKindCode, "페이지" ,String(pageNo))
                    , strings: "popfile", "happenDt", "happenPlace", "processState", "sexCd", "specialMark", "careNm", "careTel", "careAddr")
            }
            if let value = valueCluster["popfile"]{
                imageName.append(contentsOf: value)
            }
            if let value = valueCluster["happenDt"]{
                happenDt.append(contentsOf: value)
            }
            if let value = valueCluster["happenPlace"]{
                happenPlace.append(contentsOf: value)
            }
            if let value = valueCluster["processState"]{
                status.append(contentsOf: value)
            }
            if let value = valueCluster["sexCd"]{
                sex.append(contentsOf: value)
            }
            if let value = valueCluster["specialMark"]{
                specialMrk.append(contentsOf: value)
            }
            if let value = valueCluster["careNm"]{
                careNm.append(contentsOf: value)
            }
            if let value = valueCluster["careTel"]{
                careTel.append(contentsOf: value)
            }
            if let value = valueCluster["careAddr"]{
                careAddr.append(contentsOf: value)
            }
            
            tableView.reloadData()
            row += 10
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        
        if isInData{
            if let url = URL(string:imageName[indexPath.row]){
                if let data = try? Data(contentsOf: url){
                    cell.petImageView.image = UIImage(data: data)
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
            }
        }
        else{
            cell.status.text = "정보가 없습니다."
            
            cell.specialMark.text = ""
            cell.happenDate.text = ""
            cell.happenPlace.text = ""
            cell.sex.text = ""
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCareNm" {
            if let regionMapViewController = segue.destination as? RegionMapViewController{
                if currentIndex != -1{
                    regionMapViewController.currentCareNm = careNm[currentIndex]
                    regionMapViewController.currentCareAddr = careAddr[currentIndex]
                    regionMapViewController.currentCareTel = careTel[currentIndex]
                }
            }
        }
    }

}
