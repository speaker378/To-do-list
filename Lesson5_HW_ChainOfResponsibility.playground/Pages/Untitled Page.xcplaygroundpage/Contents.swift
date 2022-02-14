import UIKit

func data(from file: String) -> Data {
    let path1 = Bundle.main.path(forResource: file, ofType: "json")!
    let url = URL(fileURLWithPath: path1)
    let data = try! Data(contentsOf: url)
    return data
}

let data1 = data(from: "1")
let data2 = data(from: "2")
let data3 = data(from: "3")


struct Person: Codable {
    let name: String
    let age: Int
    let isDeveloper: Bool
}

protocol ParserHandler {
    var next: ParserHandler? { get set }
    func parse(from data: Data) -> [Person]
}

class JSONTypeOne: ParserHandler {

    struct Wrap: Codable {
        let data: [Datum]
    }

    struct Datum: Codable {
        let name: String
        let age: Int
        let isDeveloper: Bool
    }

    var next: ParserHandler?

    func parse(from data: Data) -> [Person] {
        var result: [Person] = []
        do {
            result = try JSONDecoder().decode(Wrap.self, from: data).data.map{ Person(name: $0.name, age: $0.age, isDeveloper: $0.isDeveloper) }
        } catch {
            guard let next = next else { return result }
            result = next.parse(from: data)
        }
        return result
    }
}

class JSONTypeTwo: ParserHandler {

    struct Wrap: Codable {
        let result: [Result]
    }

    struct Result: Codable {
        let name: String
        let age: Int
        let isDeveloper: Bool
    }

    var next: ParserHandler?

    func parse(from data: Data) -> [Person] {
        var result: [Person] = []
        do {
            result = try JSONDecoder().decode(Wrap.self, from: data).result.map{ Person(name: $0.name, age: $0.age, isDeveloper: $0.isDeveloper) }
        } catch {
            guard let next = next else { return result }
            result = next.parse(from: data)
        }
        return result
    }
}

class JSONTypeThree: ParserHandler {

    struct Element: Codable {
        let name: String
        let age: Int
        let isDeveloper: Bool
    }

    var next: ParserHandler?

    func parse(from data: Data) -> [Person] {
        var result: [Person] = []
        do {
            result = try JSONDecoder().decode([Element].self, from: data).map{ Person(name: $0.name, age: $0.age, isDeveloper: $0.isDeveloper) }
        } catch {
            guard let next = next else { return result }
            result = next.parse(from: data)
        }
        return result
    }
}


let parseOne = JSONTypeOne()
let parseTwo = JSONTypeTwo()
let parseThree = JSONTypeThree()
parseOne.next = parseTwo
parseTwo.next = parseThree
parseOne.parse(from: data1)
parseOne.parse(from: data2)
parseOne.parse(from: data3)
