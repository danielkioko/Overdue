//
//  CalculatorController.swift
//  funding
//
//  Created by Daniel Nzioka on 11/19/19.
//  Copyright © 2019 Daniel Nzioka. All rights reserved.
//

import UIKit
import AVFoundation

class CalculatorController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var displayNum: UILabel!
    @IBOutlet var cardBackground: UIView!
    @IBOutlet var billBtn: UIButton!
    @IBOutlet var eraseLayer: UIView!
    @IBOutlet var createLayer: UIView!
    
    @IBAction func createBillWithResult(_ sender: Any) {
        
        let result = String(displayNum.text!)
        
//        let calc = CalculatorController()
//        let editBill = CreateChange()
//        
//        editBill.noteTextAmountView.text = result
//        self.present(editBill, animated: true, completion: nil)
        
    }
    
    var prevNum : Double = 0
    var currentNum : Double = 0
    var preTag = "+"
    var tagList = ["+", "-", "*", "/"]
    var modOccured = false
    var decimal : Bool = false
    
    var audioPlayer : AVAudioPlayer!
    let url = Bundle.main.url(forResource: "click", withExtension: "wav")

    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
    }
    
    @IBAction func numButtonsPressed(_ sender: UIButton) {
        playSound()
        //print(sender.tag)
        if (displayNum.text! == "0" || displayNum.text! == "+" || displayNum.text! == "-" || displayNum.text! == "*" || displayNum.text! == "/" || modOccured ) && !(sender.tag == 0) && !(sender.tag==100){
            displayNum.text = String(sender.tag)
        }
        else if sender.tag == 100 && !decimal{
            decimal = true
            displayNum.text = displayNum.text! + "."
        }
        else if !(displayNum.text! == "0") && !(sender.tag == 100){
            displayNum.text = displayNum.text! + String(sender.tag)
        }
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        playSound()
        if prevNum==0 {
            prevNum = Double(displayNum.text!) ?? 0
            decimal = false
        }
        else{
           // decimal = true
            currentNum = Double(displayNum.text!) ?? 0
            if preTag == "+"{
                prevNum += currentNum
            }
            else if preTag == "-"{
                prevNum -= currentNum
            }
            else if preTag == "*"{
                prevNum *= currentNum
            }
            else if preTag == "/"{
                prevNum /= currentNum
            }
        }
        
        if sender.tag == 4{
            currentNum = Double(displayNum.text!) ?? 0
            prevNum = currentNum/100
            modOccured = true
            decimal = true
        }
        
        if sender.tag == 10 || sender.tag == 4{
            decimal = true
            displayNum.text = String(prevNum)
            prevNum = 0
            preTag = "+"
        }
        else{
            displayNum.text = String(tagList[sender.tag])
            preTag = tagList[sender.tag]
        }
                
    }
    
    
    @IBAction func clearScreen(_ sender: UIButton) {
        playSound()
        displayNum.text = "0"
        prevNum = 0
        currentNum = 0
        preTag = "+"
        modOccured = false
        decimal = false
    }
    
    
    @IBAction func invertnum(_ sender: UIButton) {
        playSound()
        currentNum = Double(displayNum.text!) ?? 0
        currentNum = -currentNum
        displayNum.text = String(currentNum)
        prevNum = currentNum
    }
    
    @IBAction func erase(_ sender: UIButton) {
        playSound()
        if displayNum.text!.count > 1{
            let index = displayNum.text!.index(before: displayNum.text!.endIndex)
            displayNum.text = String(displayNum.text![..<index])
            let dotCheck = displayNum.text!.firstIndex(of: ".") ?? displayNum.text!.endIndex
            if dotCheck == displayNum.text!.endIndex{
                decimal = false
            }
            //print(String(displayNum.text![..<index]))
        }
        else if displayNum.text!.count == 1{
            displayNum.text = "0"
            decimal = false
        }
    }
    
    func playSound(){
    }
    
}
