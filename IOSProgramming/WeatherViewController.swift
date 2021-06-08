//
//  WeatherViewController.swift
//  IOSProgramming
//
//  Created by KPUGAME on 2021/06/04.
//

import UIKit
import Charts

class WeatherViewController: UIViewController, XMLParserDelegate {
    
    var url : String = "http://apis.data.go.kr/1360000/VilageFcstInfoService/getUltraSrtFcst?serviceKey=b97lkQjk63tTOXF5jsp1Xk3qUnVfbQCkbnLAB9C%2FG8fN%2BsAqDpLX8zewnKRXX%2FBlop0MjnhbJcT7V8o23UhMvQ%3D%3D&pageNo=1&numOfRows=100&dataType=XML&base_date=2021"
    
    var nx : String?
    var ny : String?
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var baseDate = NSMutableString()
    
    var category = NSMutableString()
    
    var fcstTime = NSMutableString()
    var fcstValue = NSMutableString()
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var hours: [String] = []
    var hourCount = 1
    var temperatures: [Double] = []
    
    func firstParsing()
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: today as Date)
        print(dateString)
        
        posts = []
        
        var urlFirst = url
        
        urlFirst += dateString + "&base_time=0030&nx=" + nx! + "&ny=" + ny!
        
        parser = XMLParser(contentsOf: (URL(string: urlFirst))!)!
        
        parser.delegate = self
        parser.parse()
    }
    
    func secondParsing()
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: today as Date)
        
        var urlSecond = url
        
        urlSecond += dateString + "&base_time=0630&nx=" + nx! + "&ny=" + ny!
        
        parser = XMLParser(contentsOf: (URL(string: urlSecond))!)!
        
        parser.delegate = self
        parser.parse()
    }
    
    func thirdParsing()
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: today as Date)
        
        var urlThird = url
        
        urlThird += dateString + "&base_time=1230&nx=" + nx! + "&ny=" + ny!
        
        parser = XMLParser(contentsOf: (URL(string: urlThird))!)!
        
        parser.delegate = self
        parser.parse()
    }
    
    func forthParsing()
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMdd"
        let dateString = dateFormatter.string(from: today as Date)
        
        var urlForth = url
        
        urlForth += dateString + "&base_time=1830&nx=" + nx! + "&ny=" + ny!
        
        parser = XMLParser(contentsOf: (URL(string: urlForth))!)!
        
        parser.delegate = self
        parser.parse()
    }
    
    func chartReset()
    {
        barChartView.noDataText = "데이터가 없습니다"
        barChartView.noDataFont = .systemFont(ofSize: 20)
        barChartView.noDataTextColor = .lightGray
        
        setChart(dataPoints: hours, values: temperatures)
    }
    
    func setChart(dataPoints: [String], values: [Double])
    {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "온도")
        
        chartDataSet.colors = [.systemYellow]
        
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hours)
        barChartView.xAxis.setLabelCount(dataPoints.count, force: false)
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            baseDate = NSMutableString()
            baseDate = ""
            
            category = NSMutableString()
            category = ""
            
            fcstTime = NSMutableString()
            fcstTime = ""
            
            fcstValue = NSMutableString()
            fcstValue = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "baseDate")
        {
            baseDate.append(string)
        }
        else if element.isEqual(to: "category")
        {
            category.append(string)
        }
        else if element.isEqual(to: "fcstTime")
        {
            fcstTime.append(string)
        }
        else if element.isEqual(to: "fcstValue")
        {
            fcstValue.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item")
        {
            if !baseDate.isEqual(nil)
            {
                elements.setObject(baseDate, forKey: "baseDate" as NSCopying)
            }
            
            if !category.isEqual(nil)
            {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            
            if !fcstTime.isEqual(nil)
            {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            if !fcstValue.isEqual(nil)
            {
                elements.setObject(fcstValue, forKey: "fcstValue" as NSCopying)
            }
            
            if ((elements.value(forKey: "category")) as! String == "T1H")
            {
                if (elements.value(forKey: "fcstTime") as? String != nil)
                {
                    hours.append(String(hourCount) + "시")
                    hourCount += 1
                }
                
                let temp = Double(elements.value(forKey: "fcstValue") as! String)!
                let doubleAsString = NumberFormatter.localizedString(from: (NSNumber(value: temp)), number: .none)
                
                temperatures.append(Double(doubleAsString)!)
            }
            posts.add(elements)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        firstParsing()
        secondParsing()
        thirdParsing()
        forthParsing()
        
        chartReset()
    }
}
