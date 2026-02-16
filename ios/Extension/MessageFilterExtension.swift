import IdentityLookup
import Foundation

class MessageFilterExtension: ILMessageFilterExtension {
    // Rely on default lazy loading of FilterEngine.shared in offlineAction
    
    // MARK: - ILMessageFilterExtension

    func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
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
        return FilterEngine.shared.filterMessage(sender: sender, body: messageBody)
    }
}
