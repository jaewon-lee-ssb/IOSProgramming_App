//
//  ViewController.swift
//  IOSProgramming
//
//  Created by KPUGAME on 2021/05/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func doneToPickerViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    var pickerDataSource = ["광진구", "구로구", "동대문구", "종로구"]
    
    var url : String = "http://openapi.kepco.co.kr/service/EvInfoServiceV2/getEvSearchList?serviceKey=b97lkQjk63tTOXF5jsp1Xk3qUnVfbQCkbnLAB9C%2FG8fN%2BsAqDpLX8zewnKRXX%2FBlop0MjnhbJcT7V8o23UhMvQ%3D%3D&pageNo=1&numOfRows=200&addr="
    var sgguNm : String = "광진구"
    
    func makeStringKoreanEncoded(_ string: String) -> String
    {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "segueToTableView"
        {
            if let navController = segue.destination as? UINavigationController
            {
                if let electricCarTableViewController = navController.topViewController as? ElectricCarTableViewController
                {
                    if (searchTextField.hasText) {
                        let encodedNm = makeStringKoreanEncoded(String(searchTextField.text!))
                        electricCarTableViewController.url = url + encodedNm
                    }
                    else {
                        let encodedNm = makeStringKoreanEncoded(sgguNm)
                        electricCarTableViewController.url = url + encodedNm
                    }
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return pickerDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return pickerDataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if row == 0
        {
            sgguNm = "광진구"
        }
        else if row == 1
        {
            sgguNm = "구로구"
        }
        else if row == 2
        {
            sgguNm = "동대문구"
        }
        else if row == 3
        {
            sgguNm = "종로구"
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }


}

