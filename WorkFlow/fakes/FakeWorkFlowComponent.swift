import WorkFlow

// this file was generated by Xcode-Better-Refactor-Tools
// https://github.com/tjarratt/xcode-better-refactor-tools

private var number: Int = 0

class FakeWorkFlowComponent : WorkFlowComponent, Equatable, CustomDebugStringConvertible {
    private let hash: Int

    var debugDescription: String {
        return "FakeWorkFlowComponent - \(hash)"
    }

    init() {
        self.hash = number
        number += 1
    }

    private(set) var beginWorkCallCount : Int = 0
    private var beginWorkArgs : Array<(WorkFlow)> = []
    func beginWorkArgsForCall(callIndex: Int) -> (WorkFlow) {
        return self.beginWorkArgs[callIndex]
    }
    func beginWork(workFlow: WorkFlow) {
        self.beginWorkCallCount++
        self.beginWorkArgs.append((workFlow))
    }

    static func reset() {
    }
}

func ==(a: FakeWorkFlowComponent, b: FakeWorkFlowComponent) -> Bool {
    return a.hash == b.hash
}
