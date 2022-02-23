//
//  ViewController.swift
//  To do list
//
//  Created by Сергей Черных on 14.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var tasks: [CompositeTask] = []
    var index: Int = 0
    weak var prevVC: ViewController?

    @IBAction func addButtonPressed(_ sender: Any) {
        let indexPath = IndexPath(row: tasks.count, section: 0)
        tasks.append(Task(name: "new task \(tasks.count)"))
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.prevVC?.tasks[index].subtask = self.tasks
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainVC") as? ViewController else { return }
        vc.tasks = tasks[indexPath.row].subtask
        vc.index = indexPath.row
        vc.prevVC = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "\(tasks[indexPath.row].name)"
        cell.detailTextLabel?.text = "\(tasks[indexPath.row].subtask.count) subtasks"
        return cell
    }
}
