import UIKit
import Charts
import TinyConstraints

final class CustomFormatter: IAxisValueFormatter {

    var labels: [String] = []

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        let count = self.labels.count

        guard let axis = axis, count > 0 else {
            return ""
        }

        let factor = axis.axisMaximum / Double(count)

        let index = Int((value / factor).rounded())

        if index >= 0 && index < count {
            return self.labels[index]
        }

        return ""
    }
}

class GraphViewController: ParserViewController, ChartViewDelegate {

    var apiController : GetAPI = GetAPI()
    var lineChartView : LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .systemFill
        chartView.rightAxis.enabled = false
        //chartView.xAxis.enabled = false
        chartView.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.leftAxis.labelPosition = .outsideChart
        
        
        return chartView
    }()
    
    var yValues : [ChartDataEntry] = []
    var orgDownNm : [String] = []
    var orgCd : [String] = []
    var regionDictionary : [String : String] = [:]
    var width : Int = 1300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginParsing(wantURL: apiController.getURL(wantURLs: "시도"), strings: "orgCd", "orgdownNm")       // 시도코드,   시도명
        
        if let cluster = valueCluster["orgdownNm"]{
            orgDownNm = cluster
        }
        if let cluster = valueCluster["orgCd"]{
            orgCd = cluster
        }
        
        for i in 0..<orgCd.count{ // 지역코드들이 들어있는 거
            beginParsing(wantURL: apiController.getURLs(keywords: "전체", "시도코드", orgCd[i]), strings: "totalCount")
            
            if let cluster = valueCluster["totalCount"]{
                regionDictionary[orgDownNm[i]] = cluster[0]
            }
        }
        
        let widthResize : Int = width / orgDownNm.count
        var index : Int = 0
        
        for i in orgDownNm{
            let c = ChartDataEntry(x : Double(widthResize * index), y : Double(Int(regionDictionary[i]!)!))
            yValues.append(c)
            index += 1
        }
        
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValues, label: "지역별 유기동물 수")
        
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.8
        
        let data = LineChartData(dataSet: set1)
        
        data.setDrawValues(true)
        
        lineChartView.data = data
        
        let customFormater = CustomFormatter()
        customFormater.labels = orgDownNm

        lineChartView.xAxis.valueFormatter = customFormater
        lineChartView.xAxis.labelPosition = .bottom
    }
}


