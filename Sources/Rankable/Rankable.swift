// https://www.appsdissected.com/order-core-data-entities-maximum-speed/

// Setup rank (space all elements out) ✅
// Move rank (move an element) ✅
// Space out (make space for new rank, or space out all) ✅
// Insert into rank (add new element into list and make space if needed) ✅
// Reversed rank? Or just reverse the input?
// multiple sections?
// RankableObject and Rankable (value type)



var kElementSpacing = 16
//let copy = todos
//copy[1].order = kElementSpacing * 0
//copy[3].order = kElementSpacing * 1
//copy[0].order = kElementSpacing * 2
//copy[2].order = kElementSpacing * 3

public protocol RankableObject: AnyObject {
  var rank: Int { get set } // TODO: Make Index generic vs just Int
}

/// Space out all elements in the given collection
public func spaceOutAllElements<Elements: Collection>(
  _ elements: Elements
) where Elements.Element: RankableObject {
  for (offset, element) in elements.enumerated() {
    element.rank = (offset + 1) * kElementSpacing
  }
}

/// Space out starting at the given index until adjacent gaps are filled
internal func spaceOut<Elements: Collection>(
  _ elements: Elements,
  atIndex index: Int,
  reservation: Int? = nil
) where Elements.Element: RankableObject {
  var offset = index
  var offsetIndex = elements.index(elements.startIndex, offsetBy: offset)
  var offsetRank = elements[offsetIndex].rank

  let lastIndex = elements.index(elements.endIndex, offsetBy: -1, limitedBy: elements.startIndex)

  if offsetIndex == lastIndex {
    elements[offsetIndex].rank = offsetRank + kElementSpacing
  } else {
    let afterOffsetIndex = elements.index(offsetIndex, offsetBy: 1)
    let afterOffsetRank = elements[afterOffsetIndex].rank

    if let reservation, reservation + kElementSpacing > afterOffsetRank {
      spaceOut(
        elements,
        atIndex: offset + 1,
        reservation: reservation + kElementSpacing
      ) // FIXME: use indexes instead
    }

    let notEnoughSpaceAfterOffset = offsetRank + kElementSpacing > afterOffsetRank
    if notEnoughSpaceAfterOffset {
      spaceOut(
        elements,
        atIndex: offset + 1,
        reservation: (reservation ?? offsetRank) + kElementSpacing
      ) // FIXME: use indexes instead
      elements[offsetIndex].rank = (reservation ?? offsetRank)
    } else {
      elements[offsetIndex].rank = (reservation ?? offsetRank)
    }
  }
}

/// Insert the source to the destination making space where needed
///
/// gap of 2
/// A....B.CD.E.....F..G..H..I move item
/// |....|.|__|__|...|..|..|..|
///  start ^__|__^ end
///
/// A....B.C D.E..F.....G..H..I move item
///         ^           <
/// A....B.C[]DE..F.....G..H..I make space
/// A....B.C..D[]EF.....G..H..I make more space
/// A....B.C..D..EF.....G..H..I ready
/// |....|.|__|__||.....|..|..|
/// A....B.C.GD..EF........H..I move item
public func moveElement<Elements: Collection>(
  source: Int,
  destination: Int,
  elements: Elements
) where Elements.Element: RankableObject, Elements.Index == Int {
  guard source != destination else { return }
  guard elements.count > 1 else { return }

  let elementMovedUp = destination > source
  let newRank = reserveRank(destination: destination, useSpacingAfterDestination: elementMovedUp, elements: elements)
  elements[source].rank = newRank
}

/// Setup a rank at the given destination making space if needed
///
/// - Parameters:
///   - destination: Index where to reserve a new rank
///   - useSpacingAfterDestination: if true, reserve after destination. Otherwise, before destination
///
/// - Returns: non-zero rank for the new element
public func reserveRank<Elements: Collection>(
  destination: Int,
  useSpacingAfterDestination: Bool = true,
  elements: Elements
) -> Int where Elements.Element: RankableObject, Elements.Index == Int {
  guard !elements.isEmpty else { return kElementSpacing }
  guard elements.indices.contains(destination) else {
    return kElementSpacing * elements.count
  }

  let destinationIndex = elements.index(elements.startIndex, offsetBy: destination)

  let movingElementAtStart = destinationIndex == elements.startIndex
  let movingElementAtEnd = destinationIndex == elements.index(elements.endIndex, offsetBy: -1, limitedBy: elements.startIndex)

  let leadingOrder: Int
  let trailingOrder: Int

  func reserve() -> Int {
    let isThereSpaceBetweenOrders = trailingOrder - leadingOrder > 1
    if isThereSpaceBetweenOrders {
      let newRank = (leadingOrder + trailingOrder) / 2
      return newRank
    } else {
      if useSpacingAfterDestination {
        spaceOut(elements, atIndex: destination)
      } else if movingElementAtStart {
        spaceOut(elements, atIndex: destination)
      } else {
        spaceOut(elements, atIndex: destination - 1)
      }

      return reserveRank(destination: destination, useSpacingAfterDestination: useSpacingAfterDestination, elements: elements)
    }
  }

  if movingElementAtEnd {
    let lastRank = elements[destination].rank
    return lastRank + kElementSpacing
  } else if movingElementAtStart {
    leadingOrder = .zero
    trailingOrder = elements[destinationIndex].rank
    return reserve()
  } else {
    if useSpacingAfterDestination {
      leadingOrder = elements[destination].rank
      trailingOrder = elements[destination + 1].rank
    } else {
      leadingOrder = elements[destination - 1].rank
      trailingOrder = elements[destination].rank
    }

    return reserve()
  }
}
