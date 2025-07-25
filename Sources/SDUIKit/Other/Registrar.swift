//
//  Registrar.swift
//  SDUIiOS
//
//  Created by Philippe Robin on 28/05/2025.
//

@MainActor
public class Registrar {
    
    private var appTypes: [String: App.Type] = [:]
    private var stackTypes: [String: Stack.Type] = [:]
    private var screenTypes: [String: Screen.Type] = [:]
    private var componentTypes: [String: Component.Type] = [:]
    private var actionTypes: [String: Action.Type] = [:]
    private var booleanExpressionTypes: [String: BooleanExpression.Type] = [:]
    private var numberExpressionTypes: [String: NumberExpression.Type] = [:]
    private var stringExpressionTypes: [String: StringExpression.Type] = [:]
    var components: [String: JSONValue] = [:]
    
    public init() {
        appTypes["classic"] = ClassicApp.self
        
        stackTypes["navigation"] = Navigation.self
        stackTypes["tab"] = TabStack.self
        stackTypes["split"] = SplitStack.self
        
        screenTypes["form"] = Form.self
        
        componentTypes["card"] = Card.self
        componentTypes["combo"] = Combo.self
        componentTypes["flow"] = Flow.self
        componentTypes["responsive"] = Responsive.self
        componentTypes["carousel"] = Carousel.self
        componentTypes["paragraph"] = Paragraph.self
        componentTypes["textField"] = SDUITextField.self
        componentTypes["multilineField"] = MultilineField.self
        componentTypes["passwordField"] = PasswordField.self
        componentTypes["selectField"] = SelectField.self
        componentTypes["dateField"] = DateField.self
        componentTypes["timeField"] = TimeField.self
        componentTypes["switch"] = SwitchField.self
        componentTypes["radioField"] = RadioField.self
        componentTypes["button"] = Button.self
        componentTypes["divider"] = Divider.self
        componentTypes["progress"] = Progress.self
        componentTypes["image"] = SDUIImage.self
        componentTypes["menuItem"] = MenuItem.self
        
        actionTypes["alert"] = Alert.self
        actionTypes["confirm"] = Confirm.self
        actionTypes["prompt"] = Prompt.self
        actionTypes["if"] = IfAction.self
        actionTypes["copy"] = Copy.self
        actionTypes["updateBoolean"] = UpdateBoolean.self
        actionTypes["updateNumber"] = UpdateNumber.self
        actionTypes["updateString"] = UpdateString.self
        actionTypes["fetch"] = Fetch.self
        actionTypes["wait"] = Wait.self
        actionTypes["back"] = Back.self
        actionTypes["push"] = Push.self
        actionTypes["close"] = Close.self
        actionTypes["showDetail"] = ShowDetail.self
        actionTypes["present"] = Present.self
        actionTypes["getLocation"] = GetLocation.self
        actionTypes["openURL"] = OpenURL.self
        actionTypes["replaceScreen"] = ReplaceScreen.self
        actionTypes["replaceApp"] = ReplaceApp.self
        actionTypes["validateScreen"] = ValidateScreen.self
        actionTypes["callback"] = Callback.self
        
        booleanExpressionTypes["constant"] = BooleanConstant.self
        booleanExpressionTypes["variable"] = BooleanVariable.self
        booleanExpressionTypes["default"] = BooleanDefault.self
        booleanExpressionTypes["??"] = BooleanDefault.self
        booleanExpressionTypes["if"] = BooleanIf.self
        booleanExpressionTypes["!"] = Not.self
        booleanExpressionTypes["not"] = Not.self
        booleanExpressionTypes["|"] = BooleanCompute.self
        booleanExpressionTypes["||"] = BooleanCompute.self
        booleanExpressionTypes["&"] = BooleanCompute.self
        booleanExpressionTypes["&&"] = BooleanCompute.self
        booleanExpressionTypes["="] = Compare.self
        booleanExpressionTypes["=="] = Compare.self
        booleanExpressionTypes["!="] = Compare.self
        booleanExpressionTypes["<>"] = Compare.self
        booleanExpressionTypes["<"] = Compare.self
        booleanExpressionTypes["smaller"] = Compare.self
        booleanExpressionTypes[">"] = Compare.self
        booleanExpressionTypes["greater"] = Compare.self
        booleanExpressionTypes["<="] = Compare.self
        booleanExpressionTypes["smallerOrEqual"] = Compare.self
        booleanExpressionTypes[">="] = Compare.self
        booleanExpressionTypes["greaterOrEqual"] = Compare.self
        booleanExpressionTypes["regex"] = Regex.self
        booleanExpressionTypes["isNull"] = IsNull.self
        
        numberExpressionTypes["constant"] = NumberConstant.self
        numberExpressionTypes["variable"] = NumberVariable.self
        numberExpressionTypes["default"] = NumberDefault.self
        numberExpressionTypes["??"] = NumberDefault.self
        numberExpressionTypes["if"] = NumberIf.self
        numberExpressionTypes["+"] = NumberCompute.self
        numberExpressionTypes["plus"] = NumberCompute.self
        numberExpressionTypes["-"] = NumberCompute.self
        numberExpressionTypes["minus"] = NumberCompute.self
        numberExpressionTypes["*"] = NumberCompute.self
        numberExpressionTypes["multiply"] = NumberCompute.self
        numberExpressionTypes["/"] = NumberCompute.self
        numberExpressionTypes["divide"] = NumberCompute.self
        numberExpressionTypes["min"] = NumberCompute.self
        numberExpressionTypes["max"] = NumberCompute.self
        numberExpressionTypes["round"] = Round.self
        numberExpressionTypes["length"] = Length.self
        
        stringExpressionTypes["constant"] = StringConstant.self
        stringExpressionTypes["variable"] = StringVariable.self
        stringExpressionTypes["default"] = StringDefault.self
        stringExpressionTypes["??"] = StringDefault.self
        stringExpressionTypes["if"] = StringIf.self
        stringExpressionTypes["concat"] = Concat.self
        stringExpressionTypes["trim"] = Trim.self
        stringExpressionTypes["formatDate"] = FormatDate.self
        stringExpressionTypes["formatNumber"] = FormatNumber.self
    }
    
    public func register<T: App>(_ type: T.Type, forName name: String) {
        appTypes[name] = type
    }
    
    public func register<T: Stack>(_ type: T.Type, forName name: String) {
        stackTypes[name] = type
    }
    
    public func register<T: Component>(_ type: T.Type, forName name: String) {
        componentTypes[name] = type
    }
    
    public func register<T: Action>(_ type: T.Type, forName name: String) {
        actionTypes[name] = type
    }
    
    public func register<T: BooleanExpression>(_ type: T.Type, forName name: String) {
        booleanExpressionTypes[name] = type
    }
    
    public func register<T: NumberExpression>(_ type: T.Type, forName name: String) {
        numberExpressionTypes[name] = type
    }
    
    public func register<T: StringExpression>(_ type: T.Type, forName name: String) {
        stringExpressionTypes[name] = type
    }
    
    
    func updateComponents(_ components: [String: JSONValue]) {
        self.components = components
    }
    
    public func parseApp(object: JSONValue?) -> App? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseApp(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseApp(object: component)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as? String ?? "classic"
        let aType = appTypes[typeName]!
        return aType.init(object: object, registrar: self)
    }
    
    public func parseStack(object: JSONValue?, state: State, app: App) -> Stack? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseStack(object: object["iOS"], state: state, app: app)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseStack(object: component, state: state, app: app)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as? String ?? "navigation"
        let aType = stackTypes[typeName]!
        return aType.init(object: object, app: app, state: state, registrar: self)
    }
    
    public func parseStacks(object: JSONValue?, state: State, app: App) -> [Stack]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseStacks(object: object["iOS"], state: state, app: app)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseStacks(object: component, state: state, app: app)
        }
        guard let object else { return nil }
        guard let array = object as? [JSONValue] else {
            return [parseStack(object: object, state: state, app: app)!]
        }
        return array.compactMap { parseStack(object: $0, state: state, app: app) }
    }
    
    public func parseScreen(object: JSONValue?, stack: Stack, state: State) -> Screen? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseScreen(object: object["iOS"], stack: stack, state: state)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseScreen(object: component, stack: stack, state: state)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as? String ?? "form"
        let aType = screenTypes[typeName]!
        return aType.init(object: object, stack: stack, state: state, registrar: self)
    }
    
    
    public func parseScreens(object: JSONValue?, stack: Stack, state: State) -> [Screen]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseScreens(object: object["iOS"], stack: stack, state: state)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseScreens(object: component, stack: stack, state: state)
        }
        guard let object else { return nil }
        guard let array = object as? [JSONValue] else {
            return [parseScreen(object: object, stack: stack, state: state)!]
        }
        return array.compactMap { parseScreen(object: $0, stack: stack, state: state) }
    }
    
    public func parseComponent(object: JSONValue?, screen: Screen) -> Component? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseComponent(object: object["iOS"], screen: screen)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseComponent(object: component, screen: screen)
        }
        if let object = object as? String {
            if object == "---" {
                return Divider(object: [:], screen: screen, registrar: self)
            }
            return Paragraph(object: ["spans": object], screen: screen, registrar: self)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as! String
        let aType = componentTypes[typeName]!
        return aType.init(object: object, screen: screen, registrar: self)
    }
    
    public func parseComponents(object: JSONValue?, screen: Screen) -> [Component]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseComponents(object: object["iOS"], screen: screen)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseComponents(object: component, screen: screen)
        }
        guard let object = object else { return nil }
        guard let array = object as? [JSONValue] else {
            return [parseComponent(object: object, screen: screen)].compactMap { $0 }
        }
        return array.compactMap { parseComponent(object: $0, screen: screen) }
    }
    
    func parseSpan(object: JSONValue?, screen: Screen) -> Span? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseSpan(object: object["iOS"], screen: screen)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseSpan(object: component, screen: screen)
        }
        guard let object = object else { return nil }
        if let _ = parseStringExpression(object: object) {
            return Span(object: ["text": object], state: screen.state, registrar: self, stylesheet: screen.stack!.app!.stylesheet)
        }
        if let string = object as? String {
            return Span(object: ["text": string], state: screen.state, registrar: self, stylesheet: screen.stack!.app!.stylesheet)
        }
        guard let object = object as? JSONObject else { return nil }
        return Span(object: object, state: screen.state, registrar: self, stylesheet: screen.stack!.app!.stylesheet)
    }
    
    func ParseSpans(object: JSONValue?, screen: Screen) -> [Span]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return ParseSpans(object: object["iOS"], screen: screen)
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return ParseSpans(object: component, screen: screen)
        }
        guard let object = object else { return nil }
        guard let array = object as? [JSONValue] else {
            return [parseSpan(object: object, screen: screen)].compactMap { $0 }
        }
        return array.compactMap { parseSpan(object: $0, screen: screen) }
    }
    
    public func parseAction(object: JSONValue?) -> Action? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseAction(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseAction(object: component)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as! String
        let aType = actionTypes[typeName]!
        return aType.init(object: object, registrar: self)
    }
    
    public func parseActions(object: JSONValue?) -> [Action]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseActions(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseActions(object: component)
        }
        guard let object else { return nil }
        guard let array = object as? [JSONValue] else {
            return [parseAction(object: object)!]
        }
        return array.compactMap { parseAction(object: $0) }
    }
    
    public func parseBooleanExpression(object: JSONValue?) -> BooleanExpression? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseBooleanExpression(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseBooleanExpression(object: component)
        }
        if let constant = object as? Bool {
            return BooleanConstant(constant: constant)
        }
        if let string = object as? String, string.hasPrefix("$"), string.hasSuffix("$"), string.count > 2 {
            let variable = string.trimmingCharacters(in: .init(charactersIn: "$"))
            return BooleanVariable(object: ["variable": variable, "default": false], registrar: self)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as! String
        let aType = booleanExpressionTypes[typeName]!
        return aType.init(object: object, registrar: self)
    }
    
    public func parseBooleanExpressions(object: JSONValue?) -> [BooleanExpression]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseBooleanExpressions(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseBooleanExpressions(object: component)
        }
        if let array = object as? [JSONValue] {
            return array.compactMap { parseBooleanExpression(object: $0) }
        }
        return [parseBooleanExpression(object: object)].compactMap { $0 }
    }
    
    public func parseNumberExpression(object: JSONValue?) -> NumberExpression? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseNumberExpression(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseNumberExpression(object: component)
        }
        guard let object else { return nil }
        if let constant = object as? Int {
            return NumberConstant(constant: Double(constant))
        }
        if let constant = object as? Double {
            return NumberConstant(constant: constant)
        }
        if let string = object as? String, string.hasPrefix("$"), string.hasSuffix("$"), string.count > 2 {
            let variable = string.trimmingCharacters(in: .init(charactersIn: "$"))
            return NumberVariable(object: ["variable": variable, "default": 0], registrar: self)
        }
        guard let object = object as? JSONObject else { return nil }
        let typeName = object["type"] as! String
        let aType = numberExpressionTypes[typeName]!
        return aType.init(object: object, registrar: self)
    }
    
    public func parseNumberExpressions(object: JSONValue?) -> [NumberExpression]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseNumberExpressions(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseNumberExpressions(object: component)
        }
        if let array = object as? [JSONValue] {
            return array.compactMap { parseNumberExpression(object: $0) }
        }
        return [parseNumberExpression(object: object)].compactMap { $0 }
    }
    
    public func parseStringExpression(object: JSONValue?) -> StringExpression? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseStringExpression(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseStringExpression(object: component)
        }
        if let string = object as? String, string.hasPrefix("$"), string.hasSuffix("$"), string.count > 2 {
            let variable = string.trimmingCharacters(in: .init(charactersIn: "$"))
            return StringVariable(object: ["variable": variable, "default": ""], registrar: self)
        }
        if let constant = object as? String {
            return StringConstant(constant: constant)
        }
        guard let object = object as? JSONObject else { return nil }
        guard let typeName = object["type"] as? String else { return nil }
        guard let aType = stringExpressionTypes[typeName] else { return nil }
        return aType.init(object: object, registrar: self)
    }
    
    public func parseStringExpressions(object: JSONValue?) -> [StringExpression]? {
        if let object = object as? [String: JSONValue], object["iOS"] != nil || object["android"] != nil || object["web"] != nil {
            return parseStringExpressions(object: object["iOS"])
        }
        if let name = object as? String, name.starts(with: "library:"), let component = components[String(name.dropFirst(8))] {
            return parseStringExpressions(object: component)
        }
        if let array = object as? [JSONValue] {
            return array.compactMap { parseStringExpression(object: $0) }
        }
        return [parseStringExpression(object: object)].compactMap { $0 }
    }
}
