import Alamofire
import UIKit
import SwiftyJSON
import MapKit

class RegionMapViewController: ParserViewController, MKMapViewDelegate {

    var apiController : GetAPI = GetAPI()
    
    let urlKaKao : String = "https://dapi.kakao.com/v2/local/search/keyword.json?query="
    let serviceKeyKaKao : String = "9fb0a00c7f2ee88b655b37d5deb61879"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapInfo: UILabel!
    @IBOutlet weak var addressInfo: UILabel!
    @IBOutlet weak var numberInfo: UILabel!
    
    
    var currentCareNm = ""
    var currentCareAddr = ""
    var currentCareTel = ""
    var myJson : Dictionary<String, [[String:String]]> = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if currentCareNm != ""{
            searchKeyword(keyword: currentCareNm)
            mapInfo.text = currentCareNm
            addressInfo.text = currentCareAddr
            numberInfo.text = currentCareTel
        }
    }

    func addJson(name : String, dictKey : String, dictValue : String){
        if let _ = myJson[name]{
            myJson[name]!.append([dictKey : dictValue])
        }
        else{
            myJson[name] = [[dictKey : dictValue]]
        }
        
    }
    
    func searchKeyword(keyword: String){
        let url = urlKaKao + keyword
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed){
            Alamofire.request(encoded,
                              method: .get,
                              encoding: JSONEncoding.prettyPrinted,
                              headers: ["Authorization" : "KakaoAK \(serviceKeyKaKao)"])
                .responseJSON{response in
                    switch response.result{
                        case .success(let json):
                            let value = JSON(json)
                            if let v = value.dictionary{
                                if let datas = v["documents"]{
                                    for i in 0..<datas.count{
                                        let name = datas[i]["place_name"].string!
                                        let dict = datas[i].dictionaryValue
                                        for (keys, values) in dict{
                                            self.addJson(name: name, dictKey: keys, dictValue: values.string!)
                                        }
                                        for (_, values) in self.myJson{
                                            var x = 0.0
                                            var y = 0.0
                                            for l in values{
                                                if let tx = l["x"]{
                                                    x = Double(tx)!
                                                }
                                                if let ty = l["y"]{
                                                    y = Double(ty)!
                                                }
                                            }
                                            self.setAnnotation(latitudeValue: CLLocationDegrees(y), longitudeValue: CLLocationDegrees(x), delta: 0.1, title: name, subtitle: name)
                                        }
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error)
                            DispatchQueue.main.async { print("검색 도중에 에러가 발생했습니다.")}
                    }
            }
        }
    }
    

    
    // 위도와 경도, 스팬(영역 폭)을 입력받아 지도에 표시
    func goLocation(latitudeValue: CLLocationDegrees,
                    longtudeValue: CLLocationDegrees,
                    delta span: Double) -> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        mapView.setRegion(pRegion, animated: true)
        return pLocation
    }
    
    // 특정 위도와 경도에 핀 설치하고 핀에 타이틀과 서브 타이틀의 문자열 표시
    func setAnnotation(latitudeValue: CLLocationDegrees,
                       longitudeValue: CLLocationDegrees,
                       delta span :Double,
                       title strTitle: String,
                       subtitle strSubTitle:String){
        let annotation = MKPointAnnotation()
        annotation.coordinate = goLocation(latitudeValue: latitudeValue, longtudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }
}
