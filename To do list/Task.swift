//
//  Task.swift
//  To do list
//
//  Created by Сергей Черных on 14.02.2022.
//

import Foundation

protocol CompositeTask {
    var name: String { get set }
    var subtask: [CompositeTask] { get set }
}

class Task: CompositeTask {
    var name: String
    var subtask: [CompositeTask] = []

    init(name: String) {
        self.name = name
    }
}
