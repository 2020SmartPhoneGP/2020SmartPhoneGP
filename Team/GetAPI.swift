import Foundation

class GetAPI{
    
    var parser = XMLParser()
    
    let url : String = "http://openapi.animal.go.kr/openapi/service/rest/abandonmentPublicSrvc/"
    let serviceKey : String = "ServiceKey=DeCjFxU1UcuiqQfAOH7zkJ8t7Nfra9iDFLrkosSdeSP6wvt5bQeKIjbhq4ht662LtQR%2BwTvpM54nIx%2BgeyEMdg%3D%3D"
    
    let command : Dictionary = [
        "시도":"sido?"
    
    ]
    
    func getURL(wantURL : String) -> String{
        if let com = command[wantURL]{
            return url + com + serviceKey
        }
            
        return ""
    }
}
