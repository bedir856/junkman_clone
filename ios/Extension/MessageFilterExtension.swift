import IdentityLookup
import Foundation

class MessageFilterExtension: ILMessageFilterExtension {

    override init() {
        // Initialize FilterEngine early to load model
        _ = FilterEngine.shared
    }

    deinit {
    }

    // MARK: - ILMessageFilterExtension

    override func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
        // First, check if we need to defer to network (not implemented here, keeping it offline)
        // Let's perform offline check
        
        let action = self.offlineAction(for: queryRequest)
        let response = ILMessageFilterQueryResponse()
        response.action = action

        completion(response)
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> ILMessageFilterAction {
        guard let sender = queryRequest.sender, let messageBody = queryRequest.messageBody else {
            return .none
        }

        // Use our Filter Engine
        let engineResult = FilterEngine.shared.filterMessage(sender: sender, body: messageBody)
        
        // Map our internal enum to ILMessageFilterAction
        // Note: In real app, we might distinguish between .junk, .transaction, .promotion
        // but ILMessageFilterAction mainly supports .none, .allow, .filter, .junk, .promotion, .transaction
        
        return engineResult
    }
}
