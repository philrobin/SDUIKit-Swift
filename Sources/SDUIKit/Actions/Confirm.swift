import Foundation

@MainActor class Confirm: Action {
    
    let titleExpression: StringExpression?
    let messageExpression: StringExpression
    
    
    required init(object: JSONObject, registrar: Registrar) {
        titleExpression = registrar.parseStringExpression(object: object["title"])
        messageExpression = registrar.parseStringExpression(object: object["message"])!
     }
    
    func run(screen: Screen) async throws(ActionError) {
        let title = titleExpression?.compute(state: screen.state)
        let message = messageExpression.compute(state: screen.state) ?? ""
        if !(await screen.showConfirmation(title: title, message: message)) {
            throw .init(title: nil, message: nil)
        }
    }
    
}
