import XCTest

@testable import Rankable

final class RankableTests: XCTestCase {
  override class func setUp() {
    kElementSpacing = 4
  }

  func testSpacingOutAllElements() {
    let todo1 = Todo(title: "1", order: 0)
    let todo2 = Todo(title: "2", order: 0)
    let todo3 = Todo(title: "3", order: 0)
    let todo4 = Todo(title: "4", order: 0)
    let elements = [todo1, todo2, todo3, todo4]

    spaceOutAllElements(elements)
    XCTAssertEqual(
      elements.map(\.order),
      [4, 8, 12, 16]
    )
  }

  func testMovingElement_inside_movedUp() {
    let todo1 = Todo(title: "1", order: 4)
    let todo3 = Todo(title: "3", order: 8)
    let todo2 = Todo(title: "2", order: 12)
    let todo4 = Todo(title: "4", order: 16)
    let elements = [
      todo1, // 0
      todo3, // 1
      todo2, // 2
      todo4, // 3
    ]

    moveElement(source: 1, destination: 2, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_inside_movedUp_adjacentRanks() {
    let todo1 = Todo(title: "1", order: 4)
    let todo3 = Todo(title: "3", order: 5)
    let todo4 = Todo(title: "4", order: 50)
    let todo2 = Todo(title: "2", order: 100)
    let elements = [
      todo1, // 0
      todo3, // 1
      todo4, // 2
      todo2, // 3
    ]

    moveElement(source: 3, destination: 1, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.order),
      [
        kElementSpacing * 1,
        (kElementSpacing + kElementSpacing * 2) / 2,
        kElementSpacing * 2,
        50,
      ]
    )
  }

  func testMovingElement_inside_movedUp_adjacentRanks_spaceOutMoreThanOnce() {
    let todo1 = Todo(title: "1", order: 4)
    let todo3 = Todo(title: "3", order: 5)
    let todo4 = Todo(title: "4", order: 6)
    let todo5 = Todo(title: "5", order: 7)
    let todo6 = Todo(title: "6", order: 8)
    let todo7 = Todo(title: "7", order: 50)
    let todo2 = Todo(title: "2", order: 100)
    let elements = [
      todo1, // 0
      todo3, // 1
      todo4, // 2
      todo5, // 3
      todo6, // 4
      todo7, // 5
      todo2, // 6
    ]

    moveElement(source: 6, destination: 1, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4, 5, 6, 7].map(String.init)
    )
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.order),
      [
        kElementSpacing * 1,
        (kElementSpacing + kElementSpacing * 2) / 2,
        kElementSpacing * 2,
        kElementSpacing * 3,
        kElementSpacing * 4,
        kElementSpacing * 5,
        50,
      ]
    )
  }

  func testMovingElement_inside_movedUp_adjacentRanks_spaceOutAllTheWay() {
    let todo1 = Todo(title: "1", order: 4)
    let todo3 = Todo(title: "3", order: 5)
    let todo4 = Todo(title: "4", order: 6)
    let todo5 = Todo(title: "5", order: 7)
    let todo6 = Todo(title: "6", order: 8)
    let todo7 = Todo(title: "7", order: 9)
    let todo2 = Todo(title: "2", order: 10)
    let elements = [
      todo1, // 0
      todo3, // 1
      todo4, // 2
      todo5, // 3
      todo6, // 4
      todo7, // 5
      todo2, // 6
    ]

    moveElement(source: 6, destination: 1, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4, 5, 6, 7].map(String.init)
    )
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.order),
      [
        kElementSpacing * 1,
        (kElementSpacing + kElementSpacing * 2) / 2,
        kElementSpacing * 2,
        kElementSpacing * 3,
        kElementSpacing * 4,
        kElementSpacing * 5,
        kElementSpacing * 6,
      ]
    )
  }

  func testMovingElement_inside_movedDown() {
    let todo1 = Todo(title: "1", order: 4)
    let todo3 = Todo(title: "3", order: 8)
    let todo2 = Todo(title: "2", order: 12)
    let todo4 = Todo(title: "4", order: 16)
    let elements = [
      todo1, // 0
      todo3, // 1
      todo2, // 2
      todo4, // 3
    ]

    moveElement(source: 2,destination: 1,elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_inside_movedDown_adjacentRanks() {}
  func testMovingElement_inside_movedDown_adjacentRanks_spaceOutMoreThanOnce() {}
  func testMovingElement_inside_movedDown_adjacentRanks_spaceOutAllTheWay() {}

  func testMovingElement_bounds_movedUp() {
    let todo1 = Todo(title: "1", order: 4)
    let todo2 = Todo(title: "2", order: 8)
    let todo4 = Todo(title: "4", order: 12)
    let todo3 = Todo(title: "3", order: 16)
    let elements = [
      todo1, // 0
      todo2, // 1
      todo4, // 2
      todo3, // 3
    ]

    moveElement(source: 2, destination: 3, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_bounds_movedUp2() {
    let todo1 = Todo(title: "1", order: 4)
    let todo4 = Todo(title: "4", order: 8)
    let todo2 = Todo(title: "2", order: 12)
    let todo3 = Todo(title: "3", order: 16)
    let elements = [
      todo1, // 0
      todo4, // 1
      todo2, // 2
      todo3, // 3
    ]

    moveElement(source: 1, destination: 3, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_bounds_movedUp_adjacentRanks() {}
  func testMovingElement_bounds_movedUp_adjacentRanks_spaceOutMoreThanOnce() {}
  func testMovingElement_bounds_movedUp_adjacentRanks_spaceOutAllTheWay() {}

  func testMovingElement_bounds_movedDown() {
    let todo2 = Todo(title: "2", order: 4)
    let todo1 = Todo(title: "1", order: 8)
    let todo3 = Todo(title: "3", order: 12)
    let todo4 = Todo(title: "4", order: 16)
    let elements = [
      todo2, // 0
      todo1, // 1
      todo3, // 2
      todo4, // 3
    ]

    moveElement(source: 1, destination: 0, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_bounds_movedDown2() {
    let todo2 = Todo(title: "2", order: 4)
    let todo3 = Todo(title: "3", order: 8)
    let todo1 = Todo(title: "1", order: 12)
    let todo4 = Todo(title: "4", order: 16)
    let elements = [
      todo2, // 0
      todo3, // 1
      todo1, // 2
      todo4, // 3
    ]

    moveElement(source: 2, destination: 0, elements: elements)
    XCTAssertEqual(
      elements.sorted(by: { $0.order < $1.order }).map(\.title),
      [1, 2, 3, 4].map(String.init)
    )
  }

  func testMovingElement_bounds_movedDown_adjacentRanks() {}
  func testMovingElement_bounds_movedDown_adjacentRanks_spaceOutMoreThanOnce() {}
  func testMovingElement_bounds_movedDown_adjacentRanks_spaceOutAllTheWay() {}

  func testReserve_emptyElements() {}

  func tes() {

    let todo1 = Todo(title: "1", order: 0)
    let todo2 = Todo(title: "2", order: 0)
    let todo3 = Todo(title: "3", order: 0)
    let todo4 = Todo(title: "4", order: 0)
    let todo5 = Todo(title: "5", order: 0)

    let todo22 = Todo(title: "2", order: 0)

    var todos: [Todo] {
      [
        todo2,
        todo1,
        todo5,
        todo3,
        todo4,
      ].sorted(by: { $0.order < $1.order })
    }

    // testMovingElement_bounds_movedDown_needsSpacingOut
    moveElement(source: 4, destination: 0, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 4, destination: 0, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 4, destination: 0, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 4, destination: 0, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

    // testMovingElement_bounds_movedUp
    moveElement(source: 0, destination: 4, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 0, destination: 4, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 0, destination: 4, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 0, destination: 4, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")
    moveElement(source: 0, destination: 4, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

    // testInsertElement_inside
    todo5.title = "2"
    todo5.rank = reserveRank(destination: 2, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

    // testInsertElement_atStart
    todo4.title = "0"
    todo4.rank = reserveRank(destination: 0, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

    // testInsertElement_atEnd
    todo3.title = "100"
    todo3.rank = reserveRank(destination: todos.count - 1, elements: todos)
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

    //
    todos.map(\.title).joined(separator: ",")
    todos.map(\.order).map(String.init).joined(separator: ",")

  }
}

class Todo {
  var title = "Untitled"
  var isCompleted = false

  var order = 0

  init(
    title: String = "Untitled",
    isCompleted: Bool = false,
    order: Int
  ) {
    self.title = title
    self.isCompleted = isCompleted
    self.order = order
  }
}

extension Todo: RankableObject {
  var rank: Int {
    get { order }
    set { order = newValue }
  }
}
