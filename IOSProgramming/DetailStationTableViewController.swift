//
//  DetailStationTableViewController.swift
//  IOSProgramming
//
//  Created by KPUGAME on 2021/05/24.
//

import UIKit

class DetailStationTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    
    let postsname : [String] = ["충전소명", "충전기 타입", "충전기 ID", "충전기 주소", "충전기 상태", "갱신 날짜"]
    var posts : [String] = ["", "", "", "", "", ""]
    
    var element = NSString()
    
    var csNm = NSMutableString()
    var cpNm = NSMutableString()
    var cpId = NSMutableString()
    var addr = NSMutableString()
    var cpStat = NSMutableString()
    var statUpdateDatetime = NSMutableString()
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            posts = ["", "", "", "", "", ""]
            
            csNm = NSMutableString()
            csNm = ""
            cpNm = NSMutableString()
            cpNm = ""
            
            cpId = NSMutableString()
            cpId = ""
            addr = NSMutableString()
            addr = ""
            
            cpStat = NSMutableString()
            cpStat = ""
            statUpdateDatetime = NSMutableString()
            statUpdateDatetime = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "csNm")
        {
            csNm.append(string)
        }
        else if element.isEqual(to: "cpNm")
        {
            cpNm.append(string)
        }
        else if element.isEqual(to: "cpId")
        {
            cpId.append(string)
        }
        else if element.isEqual(to: "addr")
        {
            addr.append(string)
        }
        else if element.isEqual(to: "cpStat")
        {
            if (string == "1")
            {
                cpStat.append("충전가능")
            }
            else if (string == "2")
            {
                cpStat.append("충전중")
            }
            else if (string == "3")
            {
                cpStat.append("고장/점검")
            }
            else if (string == "4")
            {
                cpStat.append("통신장애")
            }
            else if (string == "5")
            {
                cpStat.append("통신미연결")
            }
        }
        else if element.isEqual(to: "statUpdateDatetime")
        {
            statUpdateDatetime.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item")
        {
            if !csNm.isEqual(nil)
            {
                posts[0] = csNm as String
            }
            if !cpNm.isEqual(nil)
            {
                posts[1] = cpNm as String
            }
            if !cpId.isEqual(nil)
            {
                posts[2] = cpId as String
            }
            if !addr.isEqual(nil)
            {
                posts[3] = addr as String
            }
            if !cpStat.isEqual(nil)
            {
                posts[4] = cpStat as String
            }
            if !statUpdateDatetime.isEqual(nil)
            {
                posts[5] = statUpdateDatetime as String
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginParsing()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        return cell
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
