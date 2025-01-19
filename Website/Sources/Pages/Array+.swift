extension Array {
    func splitBy(subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map { startIndex in
            let endIndex = Swift.min(startIndex.advanced(by: subSize), self.count)
            return Array(self[startIndex..<endIndex])
        }
    }
}
