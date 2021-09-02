//
//  ViewController.swift
//  YalantisTest
//
//  Created by Danil Tymofeev on 01.09.2021.
//
import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    @IBOutlet weak var totalLimitLabel: UILabel!
    @IBOutlet weak var numberLimitLabel: UILabel!
    @IBOutlet weak var listTableView: UITableView!
    
    var giftList = [String]()
    var priceList = [Int]()
    var checkList = [Bool]()
    var checkStack = [Int]()
    
    
//MARK: - Main limit logic
    func checkLimit(index: Int){
        var savedStack: [Int] = Persistance.shared.downloadStack()
        print("new stack \(savedStack.count)")
        var currentSum = 0
        guard let limit = Int(numberLimitLabel.text!) else {return}
        for i in 0..<savedStack.count{
            currentSum += priceList[savedStack[i]]
            print(currentSum)
        }
        if currentSum > limit {
            while currentSum > limit{
                guard let oldItem = savedStack.first else {return}
                print(oldItem)
                currentSum -= priceList[oldItem]
                print(currentSum)
                savedStack.remove(at: 0)
            }
            print("checklist count \(checkList.count)")
            
            for i in 0..<checkList.count{
                if savedStack.contains(i){
                    checkList[i] = true
                } else { checkList[i] = false}
            }
        }
        print(checkList[savedStack[0]])
        Persistance.shared.save(giftList: giftList, priceList: priceList, checkList: checkList)
        Persistance.shared.saveStack(stack: savedStack)
        listTableView.reloadData()
    }
//    func limitControl(){
//        guard let limit = Int(numberLimitLabel.text!) else {return}
//        var currentSum = 0
//        var removeFromStack = [Int]()
//        print("cs start limit \(checkStack.count)")
//        for i in 0..<checkStack.count {
//            currentSum += priceList[checkStack[i]]
//        }
//        print("cs start limit \(checkStack.count)")
//        for i in 0..<checkStack.count{
//            if currentSum <= limit {
//                break
//            } else {
//                currentSum -= priceList[checkStack[i]]
//                removeFromStack.append(i)
//            }
//        }
//        guard removeFromStack == [] else {return}
//        print("cs start limit \(checkStack.count)")
//        for i in 0..<removeFromStack.count {
//            checkStack.remove(at: removeFromStack[i])
//            checkList[removeFromStack[i]] = false
//        }
//    }
//        let reversedCheckStack = checkStack.reversed() as [Int]
//        var currentSum = 0
//        var indexToDelete = [Int]()
//        for i in 0..<checkStack.count {
//            if currentSum <= limit {
//                currentSum += priceList[reversedCheckStack[i]]
//            } else {
//                checkList[reversedCheckStack[i]] = false
//                indexToDelete.append(reversedCheckStack[i])
//            }
//        }
//        for _ in 0..<indexToDelete.count{
//            checkList.dropFirst()
//        }
        
//        for i in 0..<savedIndexes.count {
//            if currentSum > limit {
//                currentSum -= priceList[savedIndexes[i]]
//                checkList[savedIndexes[i]] = false
//            }
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        (giftList, priceList, checkList) = Persistance.shared.download()
        checkStack = Persistance.shared.downloadStack()
        print(giftList)
        print(priceList)
        print(checkList)
        print(checkStack)
        listTableView.reloadData()
    }
}
//MARK: - Connecting Table
extension ListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let check = tableView.cellForRow(at: indexPath)?.accessoryType else {return}
        if check == .none {
            //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            print("checkstack \(checkStack)")
            checkList[indexPath.row] = true
            checkStack.append(indexPath.row)
            
            Persistance.shared.save(giftList: giftList, priceList: priceList, checkList: checkList)
            Persistance.shared.saveStack(stack: checkStack)
            print("checkstack savedc\(checkStack)")
            
            
            checkLimit(index: indexPath.row)

            (giftList, priceList, checkList) = Persistance.shared.download()
            checkStack = Persistance.shared.downloadStack()
            print(giftList)
            print(priceList)
            print(checkList)
            print(checkStack)
            listTableView.reloadData()
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            checkList[indexPath.row] = false
            let newStack = checkStack.filter{$0 != indexPath.row}
        
            print("cs else \(checkStack.count)")
            Persistance.shared.save(giftList: giftList, priceList: priceList, checkList: checkList)
            Persistance.shared.saveStack(stack: newStack)
            (giftList, priceList, checkList) = Persistance.shared.download()
            checkStack = Persistance.shared.downloadStack()
            print(giftList)
            print(priceList)
            print(checkList)
            print(checkStack)
            listTableView.reloadData()
        }
    }
}
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giftList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CellForList
        cell.giftLabel.text = giftList[indexPath.row]
        cell.priceLabel.text = String(priceList[indexPath.row])
        if checkList[indexPath.row] {cell.accessoryType = .checkmark} else {cell.accessoryType = .none}
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, success) in
        self.listTableView.beginUpdates()
        Persistance.shared.delete(index: indexPath.row)
        Persistance.shared.deleteStack(index: indexPath.row)
        (self.giftList, self.priceList, self.checkList) = Persistance.shared.download()
        
        self.checkStack = Persistance.shared.downloadStack()
           self.listTableView.deleteRows(at: [indexPath], with: .fade)
           self.listTableView.endUpdates()
           print("deleting")
       }
       return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

