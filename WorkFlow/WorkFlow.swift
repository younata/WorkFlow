public protocol WorkFlow {
    var currentComponent: WorkFlowComponent? { get }
    var nextComponent: WorkFlowComponent? { get }

    init(components: [WorkFlowComponent], advance: @escaping (WorkFlow) -> Void, finish: @escaping (WorkFlow) -> Void, cancel: @escaping (WorkFlow) -> Void)
    func startWorkFlow()
    func advanceWorkFlow()

    func cancelWorkFlow()
}

public typealias WorkFlowFinishCallback = (Void) -> Void

public protocol WorkFlowComponent {
    func beginWork(_ finish: @escaping WorkFlowFinishCallback)
}
