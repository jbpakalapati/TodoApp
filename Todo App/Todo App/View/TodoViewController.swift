//
//  TodoViewController.swift
//  Todo App
//
//  Created by MacBook  on 1/27/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class TodoViewController: UIViewController {

    
    @IBOutlet weak var todoTableView: UITableView!
    
    var todoList:[TodoItem] = []
    let db = Firestore.firestore()
    let notif = NotificationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.delegate = self
        todoTableView.dataSource = self
        // Do any additional setup after loading the view.
        let item1 = TodoItem(title: "Goto Supermarket", subTitle: "need to get some grocery")
        let item2 = TodoItem(title: "iPHone", subTitle: "Need to complete project")
        let item3 = TodoItem(title: "Document Submit", subTitle: "Need to submit document to via")
        todoList = [item1,item2,item3]
        loadAllTodos()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Logout", message: "Are surre to logout", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            do {
              try Auth.auth().signOut()
                
                self.navigationController?.popToRootViewController(animated: true)
            } catch let signOutError as NSError {
              print("Error signing out: %@", signOutError)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.itemAlert(title: "New Item", message: "Add new to do list", textInput: "")

    }
    
    func addTodoList(title : String?){
        if let titl = title, let userEmail = Auth.auth().currentUser?.email {
            
            db.collection(Support.FTodoCollection)
                .addDocument(data: [
                    Support.FStore.todouser:userEmail,
                    Support.FStore.todoTitle:titl,
                    Support.FStore.todoSubTitle:titl,
                    Support.FStore.todoDate:Date().timeIntervalSince1970]){
                         (error) in
                         if let e = error {
                             print("There was an issue saving data to firestore, \(e)")
                         } else {
                             DispatchQueue.main.async {
                                 //self.messageTextfield.text = ""
                                 let item = TodoItem(title: titl, subTitle: titl)
                                 self.todoList.append(item)
                                 self.todoTableView.reloadData()
                             }
                             print("Successfully saved data")
                         }
                     }
        }
        
    }
    
    func loadAllTodos(){
        if let user =  Auth.auth().currentUser?.email{
            todoList = []
            db.collection(Support.FTodoCollection)
                .whereField(Support.FStore.todouser, isEqualTo: user)
                .order(by: Support.FStore.todoDate)
                .addSnapshotListener { querySnapshot, error in
                    if let er = error {
                        
                    } else {
                        if let snapShotDoc = querySnapshot?.documents{
                            for doc in snapShotDoc{
                                print(doc.data())
                                let data = doc.data()
                                if let user = data[Support.FStore.todouser]{
                                    let newtodo = TodoItem(title: data[Support.FStore.todoTitle] as! String, subTitle: data[Support.FStore.todoSubTitle] as! String)
                                    self.todoList.append(newtodo)
                                    self.todoTableView.reloadData()
                                }
                            }
                        }
                    }
                }
        }
    }
    
}
// hadling Table view datasource methods
extension TodoViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Support.tvCell, for: indexPath)
        cell.imageView?.image = UIImage(systemName: Support.listIcon)
        cell.textLabel?.text = todoList[indexPath.row].title
        cell.detailTextLabel?.text = todoList[indexPath.row].subTitle
        cell.backgroundColor = UIColor(named: Support.accentColor)
        return cell
    }
    
    
}

extension TodoViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row is \(todoList[indexPath.row])")
        //tableView.cellForRow(at: indexPath)?.backgroundColor = .white
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // ...
        
        
        // Done action
        let done = UIContextualAction(style: .normal,
                                         title: "Done") { [weak self] (action, view, completionHandler) in
            self?.handleDone(row: indexPath.row)
                                            completionHandler(true)
        }
        done.backgroundColor = .systemGreen
        
        // Edit action
        let edit = UIContextualAction(style: .normal,
                                       title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.handleEdit(row: indexPath.row)
                                        completionHandler(true)
        }
        edit.backgroundColor = .systemOrange

        // Delete action
        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.handleDelete(row: indexPath.row)
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed

      

        let configuration = UISwipeActionsConfiguration(actions: [done, edit, trash])

        return configuration

    }
    
    private func handleDone(row:Int) {
        
        print(self.todoList[row])
        if let user =  Auth.auth().currentUser?.email{
            db.collection(Support.FTodoCollection)
                .whereField(Support.FStore.todouser, isEqualTo: user)
                .whereField(Support.FStore.todoTitle, isEqualTo: self.todoList[row].title)
                .addSnapshotListener { querySnapshot, error in
                    if let er = error {
                        
                    } else {
                        if let snapShotDoc = querySnapshot?.documents{
                            for doc in snapShotDoc{
                                print(doc.data())
                                self.db.collection(Support.FTodoCollection).document(doc.documentID).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        DispatchQueue.main.async {
                                            self.notif.sendNotification(title: "Done successful", desc: self.todoList[row].title, delay: 30)
                                            //self.todoTableView.reloadData()
                                            self.loadAllTodos()
                                        }
                                        
                                    }
                                }
                                //doc.document
                            }
                        }
                    }
                }
        }
        //self.todoList.remove(at: row)
    }

    private func handleEdit(row:Int) {
        print("Marked as unread")
        editItemAlert(title: "Edit Todo", message:"" , textInput: self.todoList[row].title, row: row)
        
    }

    private func handleDelete(row: Int) {
        print("Moved to trash")
        if let user =  Auth.auth().currentUser?.email{
            db.collection(Support.FTodoCollection)
                .whereField(Support.FStore.todouser, isEqualTo: user)
                .whereField(Support.FStore.todoTitle, isEqualTo: self.todoList[row].title)
                .addSnapshotListener { querySnapshot, error in
                    if let er = error {
                        
                    } else {
                        if let snapShotDoc = querySnapshot?.documents{
                            for doc in snapShotDoc{
                                print(doc.data())
                                self.db.collection(Support.FTodoCollection).document(doc.documentID).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        DispatchQueue.main.async {
                                            self.notif.sendNotification(title: "Delete successful", desc: self.todoList[row].title, delay: 30)
                                            //self.todoTableView.reloadData()
                                            self.loadAllTodos()
                                        }
                                        
                                    }
                                }
                                //doc.document
                            }
                        }
                    }
                }
        }
    }
    
    func updateTodo(todoUpdate:String, row : Int){
        if let user =  Auth.auth().currentUser?.email{
            db.collection(Support.FTodoCollection)
                .whereField(Support.FStore.todouser, isEqualTo: user)
                .whereField(Support.FStore.todoTitle, isEqualTo: self.todoList[row].title)
                .addSnapshotListener { querySnapshot, error in
                    if let er = error {
                        
                    } else {
                        if let snapShotDoc = querySnapshot?.documents{
                            for doc in snapShotDoc{
                                print(doc.data())
                                self.db.collection(Support.FTodoCollection).document(doc.documentID).updateData([
                                    Support.FStore.todoTitle: todoUpdate,
                                    Support.FStore.todoSubTitle: todoUpdate
                                ]) { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        DispatchQueue.main.async {
                                            self.notif.sendNotification(title: "Delete successful", desc: self.todoList[row].title, delay: 30)
                                            //self.todoTableView.reloadData()
                                            self.loadAllTodos()
                                        }
                                        
                                    }
                                }
                                //doc.document
                            }
                        }
                    }
                }
        }
    }
}

extension TodoViewController {
    func itemAlert(title:String,message: String, textInput: String){
        //1. Create the alert controller.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = textInput
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            self.addTodoList(title: (textField?.text)!)
            //return textField?.text
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    func editItemAlert(title:String,message: String, textInput: String, row : Int){
        //1. Create the alert controller.
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = textInput
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField?.text))")
            if let updateT = textField?.text{
                self.updateTodo(todoUpdate: updateT, row: row)
            }
            //return textField?.text
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
}
