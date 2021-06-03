//
//  ViewController.swift
//  IOSProgramming
//
//  Created by KPUGAME on 2021/05/23.
//

import UIKit
import Speech

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func startTranscribing(_ sender: Any)
    {
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        try! startSession()
    }
    @IBAction func stopTranscribing(_ sender: Any)
    {
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    //private let speechRecognizer = SFSpeechRecognizer()!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    
    private var speechRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBAction func doneToPickerViewController(segue: UIStoryboardSegue)
    {
        
    }
    
    var pickerDataSource = ["서울특별시", "경기도", "인천광역시", "부산광역시", "대전광역시", "대구광역시", "울산광역시", "세종특별자치시", "광주광역시", "강원도", "충청북도", "충청남도", "경상북도", "경상남도", "전라북도", "전라남도", "제주특별자치도"]
    
    var url : String = "http://openapi.kepco.co.kr/service/EvInfoServiceV2/getEvSearchList?serviceKey=b97lkQjk63tTOXF5jsp1Xk3qUnVfbQCkbnLAB9C%2FG8fN%2BsAqDpLX8zewnKRXX%2FBlop0MjnhbJcT7V8o23UhMvQ%3D%3D&pageNo=1&numOfRows=200&addr="
    var sgguNm : String = "서울특별시"
    
    func startSession() throws
    {
        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record)
        
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = speechRecognitionRequest else {
            fatalError("SFSpeechAudioBufferRecognitionRequest object creation failed")
        }
        
        let inputNode = audioEngine.inputNode
        
        recognitionRequest.shouldReportPartialResults = true
        
        speechRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            
            var finished = false
            
            if let result = result {
                self.searchTextField.text = result.bestTranscription.formattedString
                finished = result.isFinal
            }
            
            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
                
                self.transcribeButton.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func authorizeSR()
    {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true
                    
                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)
                    
                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition restricted on device", for: .disabled)
                    
                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition not authorized", for: .disabled)
                }
            }
        }
    }
    
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
        sgguNm = pickerDataSource[row]
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
    }


}

