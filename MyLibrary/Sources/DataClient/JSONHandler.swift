import Foundation

let jsonEncoder = {
  $0.dateEncodingStrategy = .iso8601
  $0.keyEncodingStrategy = .convertToSnakeCase
  return $0
}(JSONEncoder())


let jsonDecoder = {
  $0.dateDecodingStrategy = .iso8601
  $0.keyDecodingStrategy = .convertFromSnakeCase
  return $0
}(JSONDecoder())
