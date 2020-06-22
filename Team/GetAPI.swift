import Foundation

class GetAPI{
    
    var parser = XMLParser()
    
    let url : String = "http://openapi.animal.go.kr/openapi/service/rest/abandonmentPublicSrvc/"
    let serviceKey : String = "ServiceKey=DeCjFxU1UcuiqQfAOH7zkJ8t7Nfra9iDFLrkosSdeSP6wvt5bQeKIjbhq4ht662LtQR%2BwTvpM54nIx%2BgeyEMdg%3D%3D"
    
    let command : Dictionary = [
        "시도":"sido?", "유기동물 조회":"abandonmentPublic?", "시군구" : "sigungu?", "품종" : "kind?up_kind_cd=", "전체" : "abandonmentPublic?", "유기날짜" : "bgnde=",
        "축종코드" : "upkind=", "품종코드" : "kind=", "시도코드" : "upr_cd=", "시군구코드" : "org_cd=",
        "상태" : "state=", "페이지" : "pageNo="
    
    ]
    
    func getURL(wantURLs : String...) -> String{
        var URL = url
        for text in wantURLs{
            if let com = command[text]{
                URL += com
            }
        }       // 찾을 원소들
        URL += serviceKey
        return URL
    }
    
    // command에 맞게 키워드 자동 조합
    func getURLs(keywords : String...) -> String{
        var URL = url
        for i in 0..<keywords.count{
            if let com = command[keywords[i]]{
                URL += com
            }
            else if keywords[i] == "&"{
                URL += "&"
            }
            else{
                URL += keywords[i]
                if let _ = Int(keywords[i]){
                    URL += "&"
                }
            }
        }
        URL += serviceKey
        return URL
    }
    
    func getFindWhole(wantURL : String) -> String{
        if let com = command[wantURL]{
            // 임시 - 날짜, 페이지 넘버, 줄 수 
            return url + com + "bgnde=20140301&endde=20150430&pageNo=1&numOfRow=10&" + serviceKey
        }
            
        return ""
    }
    
    func getCounty(wantURL : String, upperCd : String ) -> String{
        if let com = command[wantURL]{
            return url + com + "upr_cd=" + upperCd + "&" + serviceKey
        }
        return ""
    }
    
    func getBreedKind(wantURL : String, upKindCd : String ) -> String{
        if let com = command[wantURL]{
            return url + com +  upKindCd + "&" + serviceKey
        }
        return ""
    }
}
