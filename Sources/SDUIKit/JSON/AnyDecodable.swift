public struct AnyDecodable: Decodable {
  public var value: JSONValue

  private struct CodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    init?(intValue: Int) {
      self.stringValue = "\(intValue)"
      self.intValue = intValue
    }
    init?(stringValue: String) { self.stringValue = stringValue }
  }

  public init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: CodingKeys.self) {
      var result = [String: JSONValue]()
      try container.allKeys.forEach { (key) throws in
        result[key.stringValue] = try container.decode(AnyDecodable.self, forKey: key).value
      }
      value = result
    } else if var container = try? decoder.unkeyedContainer() {
      var result = [JSONValue]()
      while !container.isAtEnd {
        result.append(try container.decode(AnyDecodable.self).value)
      }
      value = result
    } else if let container = try? decoder.singleValueContainer() {
      if let intVal = try? container.decode(Int.self) {
        value = intVal
      } else if let doubleVal = try? container.decode(Double.self) {
        value = doubleVal
      } else if let boolVal = try? container.decode(Bool.self) {
        value = boolVal
      } else if let stringVal = try? container.decode(String.self) {
        value = stringVal
      } else {
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "the container contains nothing serialisable")
      }
    } else {
      throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not serialise"))
    }
  }
}
