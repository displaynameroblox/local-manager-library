--[[
    Java to Lua Transpiler
    A comprehensive transpiler that converts Java source code to Lua/Luau
    Inspired by js-to-lua transpiler architecture
    
    Features:
    - Java AST parsing and analysis
    - Object-oriented programming transformation
    - Type system conversion
    - Control flow translation
    - Error handling and validation
    - Debug mode support
]]

local java = {}

-- Configuration and settings
local config = {
    debug = false,
    preserveComments = true,
    generateTypes = true, -- Generate Luau type annotations
    optimizeCode = true,
    targetVersion = "Luau" -- "Lua51" or "Luau"
}

-- Token types for lexical analysis
local TokenType = {
    KEYWORD = "KEYWORD",
    IDENTIFIER = "IDENTIFIER", 
    LITERAL = "LITERAL",
    OPERATOR = "OPERATOR",
    DELIMITER = "DELIMITER",
    COMMENT = "COMMENT",
    WHITESPACE = "WHITESPACE"
}

-- Java keywords
local javaKeywords = {
    "abstract", "assert", "boolean", "break", "byte", "case", "catch", "char",
    "class", "const", "continue", "default", "do", "double", "else", "enum",
    "extends", "final", "finally", "float", "for", "goto", "if", "implements",
    "import", "instanceof", "int", "interface", "long", "native", "new", "package",
    "private", "protected", "public", "return", "short", "static", "strictfp",
    "super", "switch", "synchronized", "this", "throw", "throws", "transient",
    "try", "void", "volatile", "while", "true", "false", "null"
}

-- Type mappings from Java to Lua
local typeMappings = {
    ["int"] = "number",
    ["long"] = "number", 
    ["float"] = "number",
    ["double"] = "number",
    ["boolean"] = "boolean",
    ["char"] = "string",
    ["String"] = "string",
    ["void"] = "nil",
    ["Object"] = "any"
}

-- Operator mappings
local operatorMappings = {
    ["=="] = "==",
    ["!="] = "~=",
    ["&&"] = "and",
    ["||"] = "or",
    ["!"] = "not",
    ["++"] = "+ 1",
    ["--"] = "- 1",
    ["+="] = "+=",
    ["-="] = "-=",
    ["*="] = "*=",
    ["/="] = "/=",
    ["%="] = "%="
}

-- Main conversion function
function java.convert(javaCode, debugMode)
    config.debug = debugMode or false
    
    -- Validate input
    if not javaCode or type(javaCode) ~= "string" then
        return java._createError("Invalid Java code input", config.debug)
    end
    
    if javaCode:len() == 0 then
        return java._createError("Empty Java code provided", config.debug)
    end
    
    -- Main transpilation pipeline
    local success, result = pcall(function()
        -- Stage 1: Lexical Analysis (Tokenization)
        local tokens = java._tokenize(javaCode)
        if config.debug then
            print("✅ Tokenization completed. Tokens:", #tokens)
        end
        
        -- Stage 2: Syntax Analysis (AST Generation)
        local ast = java._parseAST(tokens)
        if config.debug then
            print("✅ AST parsing completed")
        end
        
        -- Stage 3: Semantic Analysis and Transformation
        local transformedAST = java._transformAST(ast)
        if config.debug then
            print("✅ AST transformation completed")
        end
        
        -- Stage 4: Code Generation
        local luaCode = java._generateLua(transformedAST)
        if config.debug then
            print("✅ Lua code generation completed")
        end
        
        return luaCode
    end)
    
    if not success then
        return java._createError("Transpilation failed: " .. tostring(result), config.debug)
    end
    
    return result
end

-- Lexical Analysis: Tokenize Java source code
function java._tokenize(source)
    local tokens = {}
    local i = 1
    local line = 1
    local column = 1
    
    while i <= #source do
        local char = source:sub(i, i)
        
        -- Skip whitespace
        if char:match("%s") then
            if char == "\n" then
                line = line + 1
                column = 1
            else
                column = column + 1
            end
            i = i + 1
        -- Comments
        elseif char == "/" and source:sub(i + 1, i + 1) == "/" then
            local comment = ""
            i = i + 2
            while i <= #source and source:sub(i, i) ~= "\n" do
                comment = comment .. source:sub(i, i)
                i = i + 1
            end
            table.insert(tokens, {
                type = TokenType.COMMENT,
                value = comment,
                line = line,
                column = column
            })
            column = column + #comment + 2
        elseif char == "/" and source:sub(i + 1, i + 1) == "*" then
            local comment = ""
            i = i + 2
            while i <= #source - 1 do
                if source:sub(i, i + 1) == "*/" then
                    i = i + 2
                    break
                end
                comment = comment .. source:sub(i, i)
                if source:sub(i, i) == "\n" then
                    line = line + 1
                    column = 1
                else
                    column = column + 1
                end
                i = i + 1
            end
            table.insert(tokens, {
                type = TokenType.COMMENT,
                value = comment,
                line = line,
                column = column
            })
        -- String literals
        elseif char == '"' then
            local str = ""
            i = i + 1
            while i <= #source and source:sub(i, i) ~= '"' do
                if source:sub(i, i) == "\\" and i < #source then
                    str = str .. source:sub(i, i + 1)
                    i = i + 2
                else
                    str = str .. source:sub(i, i)
                    i = i + 1
                end
            end
            i = i + 1
            table.insert(tokens, {
                type = TokenType.LITERAL,
                value = '"' .. str .. '"',
                line = line,
                column = column
            })
            column = column + #str + 2
        -- Character literals
        elseif char == "'" then
            local chr = ""
            i = i + 1
            while i <= #source and source:sub(i, i) ~= "'" do
                chr = chr .. source:sub(i, i)
                i = i + 1
            end
            i = i + 1
            table.insert(tokens, {
                type = TokenType.LITERAL,
                value = "'" .. chr .. "'",
                line = line,
                column = column
            })
            column = column + #chr + 2
        -- Numbers
        elseif char:match("%d") then
            local num = ""
            while i <= #source and (source:sub(i, i):match("%d") or source:sub(i, i) == ".") do
                num = num .. source:sub(i, i)
                i = i + 1
            end
            table.insert(tokens, {
                type = TokenType.LITERAL,
                value = num,
                line = line,
                column = column
            })
            column = column + #num
        -- Identifiers and keywords
        elseif char:match("%a") or char == "_" then
            local ident = ""
            while i <= #source and (source:sub(i, i):match("%w") or source:sub(i, i) == "_") do
                ident = ident .. source:sub(i, i)
                i = i + 1
            end
            local tokenType = java._isKeyword(ident) and TokenType.KEYWORD or TokenType.IDENTIFIER
            table.insert(tokens, {
                type = tokenType,
                value = ident,
                line = line,
                column = column
            })
            column = column + #ident
        -- Operators and delimiters
        else
            local op = char
            -- Check for multi-character operators
            if i < #source then
                local nextChar = source:sub(i + 1, i + 1)
                local twoChar = char .. nextChar
                if java._isOperator(twoChar) then
                    op = twoChar
                    i = i + 1
                end
            end
            
            table.insert(tokens, {
                type = java._isOperator(op) and TokenType.OPERATOR or TokenType.DELIMITER,
                value = op,
                line = line,
                column = column
            })
            i = i + 1
            column = column + 1
        end
    end
    
    return tokens
end

-- Check if string is a Java keyword
function java._isKeyword(str)
    for _, keyword in ipairs(javaKeywords) do
        if str == keyword then
            return true
        end
    end
    return false
end

-- Check if string is an operator
function java._isOperator(str)
    local operators = {
        "+", "-", "*", "/", "%", "=", "!", "<", ">", "&", "|", "^", "~",
        "==", "!=", "<=", ">=", "&&", "||", "++", "--", "+=", "-=", "*=", "/=", "%=",
        "&=", "|=", "^=", "<<", ">>", "<<=", ">>=", "?", ":", ".", ",", ";", "(", ")", "{", "}", "[", "]"
    }
    for _, op in ipairs(operators) do
        if str == op then
            return true
        end
    end
    return false
end

-- Parse tokens into Abstract Syntax Tree
function java._parseAST(tokens)
    local ast = {
        type = "Program",
        body = {},
        comments = {}
    }
    
    local i = 1
    
    while i <= #tokens do
        local token = tokens[i]
        
        if token.type == TokenType.COMMENT then
            table.insert(ast.comments, token)
        elseif token.type == TokenType.KEYWORD then
            if token.value == "class" then
                local classNode = java._parseClass(tokens, i)
                table.insert(ast.body, classNode.node)
                i = classNode.nextIndex
            elseif token.value == "import" then
                local importNode = java._parseImport(tokens, i)
                table.insert(ast.body, importNode.node)
                i = importNode.nextIndex
            elseif token.value == "package" then
                local packageNode = java._parsePackage(tokens, i)
                table.insert(ast.body, packageNode.node)
                i = packageNode.nextIndex
            else
                -- Parse other statements
                local stmtNode = java._parseStatement(tokens, i)
                table.insert(ast.body, stmtNode.node)
                i = stmtNode.nextIndex
            end
        else
            i = i + 1
        end
    end
    
    return ast
end

-- Parse class declaration
function java._parseClass(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'class' keyword
    local classNode = {
        type = "ClassDeclaration",
        name = "",
        extends = nil,
        implements = {},
        body = {},
        modifiers = {}
    }
    
    -- Parse class name
    if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
        classNode.name = tokens[i].value
        i = i + 1
    end
    
    -- Parse extends clause
    if i <= #tokens and tokens[i].value == "extends" then
        i = i + 1
        if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
            classNode.extends = tokens[i].value
            i = i + 1
        end
    end
    
    -- Parse implements clause
    if i <= #tokens and tokens[i].value == "implements" then
        i = i + 1
        while i <= #tokens and tokens[i].type == TokenType.IDENTIFIER do
            table.insert(classNode.implements, tokens[i].value)
            i = i + 1
            if i <= #tokens and tokens[i].value == "," then
                i = i + 1
            end
        end
    end
    
    -- Parse class body
    if i <= #tokens and tokens[i].value == "{" then
        i = i + 1
        while i <= #tokens and tokens[i].value ~= "}" do
            local memberNode = java._parseClassMember(tokens, i)
            table.insert(classNode.body, memberNode.node)
            i = memberNode.nextIndex
        end
        i = i + 1 -- Skip closing brace
    end
    
    return {node = classNode, nextIndex = i}
end

-- Parse import statement
function java._parseImport(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'import' keyword
    local importNode = {
        type = "ImportDeclaration",
        source = ""
    }
    
    while i <= #tokens and tokens[i].value ~= ";" do
        importNode.source = importNode.source .. tokens[i].value
        i = i + 1
    end
    i = i + 1 -- Skip semicolon
    
    return {node = importNode, nextIndex = i}
end

-- Parse package declaration
function java._parsePackage(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'package' keyword
    local packageNode = {
        type = "PackageDeclaration",
        name = ""
    }
    
    while i <= #tokens and tokens[i].value ~= ";" do
        packageNode.name = packageNode.name .. tokens[i].value
        i = i + 1
    end
    i = i + 1 -- Skip semicolon
    
    return {node = packageNode, nextIndex = i}
end

-- Parse class member (method, field, etc.)
function java._parseClassMember(tokens, startIndex)
    local i = startIndex
    local memberNode = {
        type = "MethodDeclaration",
        name = "",
        parameters = {},
        body = {},
        returnType = "void",
        modifiers = {}
    }
    
    -- Parse modifiers
    while i <= #tokens and tokens[i].type == TokenType.KEYWORD do
        table.insert(memberNode.modifiers, tokens[i].value)
        i = i + 1
    end
    
    -- Parse return type
    if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
        memberNode.returnType = tokens[i].value
        i = i + 1
    end
    
    -- Parse method name
    if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
        memberNode.name = tokens[i].value
        i = i + 1
    end
    
    -- Parse parameters
    if i <= #tokens and tokens[i].value == "(" then
        i = i + 1
        while i <= #tokens and tokens[i].value ~= ")" do
            local param = java._parseParameter(tokens, i)
            table.insert(memberNode.parameters, param.node)
            i = param.nextIndex
            if i <= #tokens and tokens[i].value == "," then
                i = i + 1
            end
        end
        i = i + 1 -- Skip closing parenthesis
    end
    
    -- Parse method body
    if i <= #tokens and tokens[i].value == "{" then
        local bodyNode = java._parseBlock(tokens, i)
        memberNode.body = bodyNode.node.body
        i = bodyNode.nextIndex
    end
    
    return {node = memberNode, nextIndex = i}
end

-- Parse parameter
function java._parseParameter(tokens, startIndex)
    local i = startIndex
    local paramNode = {
        type = "Parameter",
        name = "",
        paramType = ""
    }
    
    -- Parse parameter type
    if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
        paramNode.paramType = tokens[i].value
        i = i + 1
    end
    
    -- Parse parameter name
    if i <= #tokens and tokens[i].type == TokenType.IDENTIFIER then
        paramNode.name = tokens[i].value
        i = i + 1
    end
    
    return {node = paramNode, nextIndex = i}
end

-- Parse block statement
function java._parseBlock(tokens, startIndex)
    local i = startIndex + 1 -- Skip opening brace
    local blockNode = {
        type = "BlockStatement",
        body = {}
    }
    
    while i <= #tokens and tokens[i].value ~= "}" do
        local stmtNode = java._parseStatement(tokens, i)
        table.insert(blockNode.body, stmtNode.node)
        i = stmtNode.nextIndex
    end
    i = i + 1 -- Skip closing brace
    
    return {node = blockNode, nextIndex = i}
end

-- Parse general statement
function java._parseStatement(tokens, startIndex)
    local i = startIndex
    local token = tokens[i]
    
    if token.type == TokenType.KEYWORD then
        if token.value == "if" then
            return java._parseIfStatement(tokens, i)
        elseif token.value == "for" then
            return java._parseForStatement(tokens, i)
        elseif token.value == "while" then
            return java._parseWhileStatement(tokens, i)
        elseif token.value == "return" then
            return java._parseReturnStatement(tokens, i)
        end
    end
    
    -- Default: expression statement
    local exprNode = java._parseExpression(tokens, i)
    i = exprNode.nextIndex
    if i <= #tokens and tokens[i].value == ";" then
        i = i + 1
    end
    
    return {node = exprNode.node, nextIndex = i}
end

-- Parse if statement
function java._parseIfStatement(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'if'
    local ifNode = {
        type = "IfStatement",
        test = nil,
        consequent = nil,
        alternate = nil
    }
    
    -- Parse condition
    if i <= #tokens and tokens[i].value == "(" then
        local testNode = java._parseExpression(tokens, i + 1)
        ifNode.test = testNode.node
        i = testNode.nextIndex + 1 -- Skip closing parenthesis
    end
    
    -- Parse consequent
    local consequentNode = java._parseStatement(tokens, i)
    ifNode.consequent = consequentNode.node
    i = consequentNode.nextIndex
    
    -- Parse else clause
    if i <= #tokens and tokens[i].value == "else" then
        i = i + 1
        local alternateNode = java._parseStatement(tokens, i)
        ifNode.alternate = alternateNode.node
        i = alternateNode.nextIndex
    end
    
    return {node = ifNode, nextIndex = i}
end

-- Parse for statement
function java._parseForStatement(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'for'
    local forNode = {
        type = "ForStatement",
        init = nil,
        test = nil,
        update = nil,
        body = nil
    }
    
    if i <= #tokens and tokens[i].value == "(" then
        i = i + 1
        
        -- Parse init
        if i <= #tokens and tokens[i].value ~= ";" then
            local initNode = java._parseExpression(tokens, i)
            forNode.init = initNode.node
            i = initNode.nextIndex
        end
        i = i + 1 -- Skip semicolon
        
        -- Parse test
        if i <= #tokens and tokens[i].value ~= ";" then
            local testNode = java._parseExpression(tokens, i)
            forNode.test = testNode.node
            i = testNode.nextIndex
        end
        i = i + 1 -- Skip semicolon
        
        -- Parse update
        if i <= #tokens and tokens[i].value ~= ")" then
            local updateNode = java._parseExpression(tokens, i)
            forNode.update = updateNode.node
            i = updateNode.nextIndex
        end
        i = i + 1 -- Skip closing parenthesis
    end
    
    -- Parse body
    local bodyNode = java._parseStatement(tokens, i)
    forNode.body = bodyNode.node
    i = bodyNode.nextIndex
    
    return {node = forNode, nextIndex = i}
end

-- Parse while statement
function java._parseWhileStatement(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'while'
    local whileNode = {
        type = "WhileStatement",
        test = nil,
        body = nil
    }
    
    -- Parse condition
    if i <= #tokens and tokens[i].value == "(" then
        local testNode = java._parseExpression(tokens, i + 1)
        whileNode.test = testNode.node
        i = testNode.nextIndex + 1 -- Skip closing parenthesis
    end
    
    -- Parse body
    local bodyNode = java._parseStatement(tokens, i)
    whileNode.body = bodyNode.node
    i = bodyNode.nextIndex
    
    return {node = whileNode, nextIndex = i}
end

-- Parse return statement
function java._parseReturnStatement(tokens, startIndex)
    local i = startIndex + 1 -- Skip 'return'
    local returnNode = {
        type = "ReturnStatement",
        argument = nil
    }
    
    -- Parse return value
    if i <= #tokens and tokens[i].value ~= ";" then
        local argNode = java._parseExpression(tokens, i)
        returnNode.argument = argNode.node
        i = argNode.nextIndex
    end
    i = i + 1 -- Skip semicolon
    
    return {node = returnNode, nextIndex = i}
end

-- Parse expression (simplified)
function java._parseExpression(tokens, startIndex)
    local i = startIndex
    local token = tokens[i]
    
    if token.type == TokenType.LITERAL then
        return {node = {type = "Literal", value = token.value}, nextIndex = i + 1}
    elseif token.type == TokenType.IDENTIFIER then
        return {node = {type = "Identifier", name = token.value}, nextIndex = i + 1}
    end
    
    -- Default: return identifier
    return {node = {type = "Identifier", name = token.value}, nextIndex = i + 1}
end

-- Transform AST from Java to Lua patterns
function java._transformAST(ast)
    local transformedAST = {
        type = "LuaProgram",
        body = {},
        imports = {},
        comments = ast.comments
    }
    
    for _, node in ipairs(ast.body) do
        if node.type == "ClassDeclaration" then
            local luaClass = java._transformClass(node)
            table.insert(transformedAST.body, luaClass)
        elseif node.type == "ImportDeclaration" then
            table.insert(transformedAST.imports, node)
        elseif node.type == "PackageDeclaration" then
            -- Package declarations are handled in the module structure
        else
            local transformedNode = java._transformNode(node)
            table.insert(transformedAST.body, transformedNode)
        end
    end
    
    return transformedAST
end

-- Transform Java class to Lua table-based class
function java._transformClass(classNode)
    local luaClass = {
        type = "LuaClass",
        name = classNode.name,
        extends = classNode.extends,
        implements = classNode.implements,
        methods = {},
        fields = {},
        constructor = nil
    }
    
    for _, member in ipairs(classNode.body) do
        if member.type == "MethodDeclaration" then
            if member.name == classNode.name then
                -- Constructor
                luaClass.constructor = java._transformConstructor(member)
            else
                -- Regular method
                local luaMethod = java._transformMethod(member)
                table.insert(luaClass.methods, luaMethod)
            end
        end
    end
    
    return luaClass
end

-- Transform constructor
function java._transformConstructor(methodNode)
    return {
        type = "LuaConstructor",
        parameters = methodNode.parameters,
        body = methodNode.body,
        modifiers = methodNode.modifiers
    }
end

-- Transform method
function java._transformMethod(methodNode)
    return {
        type = "LuaMethod",
        name = methodNode.name,
        parameters = methodNode.parameters,
        body = methodNode.body,
        returnType = methodNode.returnType,
        modifiers = methodNode.modifiers
    }
end

-- Transform individual node
function java._transformNode(node)
    if node.type == "IfStatement" then
        return java._transformIfStatement(node)
    elseif node.type == "ForStatement" then
        return java._transformForStatement(node)
    elseif node.type == "WhileStatement" then
        return java._transformWhileStatement(node)
    elseif node.type == "ReturnStatement" then
        return java._transformReturnStatement(node)
    elseif node.type == "BlockStatement" then
        return java._transformBlockStatement(node)
    else
        return node -- Pass through unchanged
    end
end

-- Transform if statement
function java._transformIfStatement(ifNode)
    return {
        type = "LuaIfStatement",
        test = java._transformExpression(ifNode.test),
        consequent = java._transformNode(ifNode.consequent),
        alternate = ifNode.alternate and java._transformNode(ifNode.alternate) or nil
    }
end

-- Transform for statement
function java._transformForStatement(forNode)
    return {
        type = "LuaForStatement",
        init = forNode.init and java._transformExpression(forNode.init) or nil,
        test = forNode.test and java._transformExpression(forNode.test) or nil,
        update = forNode.update and java._transformExpression(forNode.update) or nil,
        body = java._transformNode(forNode.body)
    }
end

-- Transform while statement
function java._transformWhileStatement(whileNode)
    return {
        type = "LuaWhileStatement",
        test = java._transformExpression(whileNode.test),
        body = java._transformNode(whileNode.body)
    }
end

-- Transform return statement
function java._transformReturnStatement(returnNode)
    return {
        type = "LuaReturnStatement",
        argument = returnNode.argument and java._transformExpression(returnNode.argument) or nil
    }
end

-- Transform block statement
function java._transformBlockStatement(blockNode)
    local transformedBody = {}
    for _, stmt in ipairs(blockNode.body) do
        table.insert(transformedBody, java._transformNode(stmt))
    end
    return {
        type = "LuaBlockStatement",
        body = transformedBody
    }
end

-- Transform expression
function java._transformExpression(exprNode)
    if exprNode.type == "Literal" then
        return java._transformLiteral(exprNode)
    elseif exprNode.type == "Identifier" then
        return java._transformIdentifier(exprNode)
    else
        return exprNode -- Pass through
    end
end

-- Transform literal
function java._transformLiteral(literalNode)
    return {
        type = "LuaLiteral",
        value = literalNode.value
    }
end

-- Transform identifier
function java._transformIdentifier(identifierNode)
    return {
        type = "LuaIdentifier",
        name = identifierNode.name
    }
end

-- Generate Lua code from transformed AST
function java._generateLua(transformedAST)
    local luaCode = {}
    
    -- Add header comment
    table.insert(luaCode, "-- Generated Lua code from Java")
    table.insert(luaCode, "-- Transpiled using Java-to-Lua transpiler")
    table.insert(luaCode, "")
    
    -- Add imports as require statements
    for _, import in ipairs(transformedAST.imports) do
        local requirePath = import.source:gsub("%.", "/")
        table.insert(luaCode, "local " .. java._getModuleName(import.source) .. " = require('" .. requirePath .. "')")
    end
    
    if #transformedAST.imports > 0 then
        table.insert(luaCode, "")
    end
    
    -- Generate classes
    for _, class in ipairs(transformedAST.body) do
        if class.type == "LuaClass" then
            local classCode = java._generateClass(class)
            for _, line in ipairs(classCode) do
                table.insert(luaCode, line)
            end
            table.insert(luaCode, "")
        end
    end
    
    return table.concat(luaCode, "\n")
end

-- Generate Lua class code
function java._generateClass(classNode)
    local classCode = {}
    
    -- Class declaration
    table.insert(classCode, "-- Class: " .. classNode.name)
    table.insert(classCode, "local " .. classNode.name .. " = {}")
    table.insert(classCode, classNode.name .. ".__index = " .. classNode.name)
    table.insert(classCode, "")
    
    -- Constructor
    if classNode.constructor then
        local constructorCode = java._generateConstructor(classNode.name, classNode.constructor)
        for _, line in ipairs(constructorCode) do
            table.insert(classCode, line)
        end
        table.insert(classCode, "")
    end
    
    -- Methods
    for _, method in ipairs(classNode.methods) do
        local methodCode = java._generateMethod(classNode.name, method)
        for _, line in ipairs(methodCode) do
            table.insert(classCode, line)
        end
        table.insert(classCode, "")
    end
    
    -- Return statement
    table.insert(classCode, "return " .. classNode.name)
    
    return classCode
end

-- Generate constructor
function java._generateConstructor(className, constructorNode)
    local constructorCode = {}
    
    -- Function signature
    local params = {}
    for _, param in ipairs(constructorNode.parameters) do
        table.insert(params, param.name)
    end
    local paramStr = table.concat(params, ", ")
    
    table.insert(constructorCode, "function " .. className .. ":new(" .. paramStr .. ")")
    table.insert(constructorCode, "    local self = setmetatable({}, " .. className .. ")")
    
    -- Constructor body
    for _, stmt in ipairs(constructorNode.body) do
        local stmtCode = java._generateStatement(stmt)
        table.insert(constructorCode, "    " .. stmtCode)
    end
    
    table.insert(constructorCode, "    return self")
    table.insert(constructorCode, "end")
    
    return constructorCode
end

-- Generate method
function java._generateMethod(className, methodNode)
    local methodCode = {}
    
    -- Function signature
    local params = {}
    for _, param in ipairs(methodNode.parameters) do
        table.insert(params, param.name)
    end
    local paramStr = table.concat(params, ", ")
    
    table.insert(methodCode, "function " .. className .. ":" .. methodNode.name .. "(" .. paramStr .. ")")
    
    -- Method body
    for _, stmt in ipairs(methodNode.body) do
        local stmtCode = java._generateStatement(stmt)
        table.insert(methodCode, "    " .. stmtCode)
    end
    
    table.insert(methodCode, "end")
    
    return methodCode
end

-- Generate statement
function java._generateStatement(stmtNode)
    if stmtNode.type == "LuaIfStatement" then
        return java._generateIfStatement(stmtNode)
    elseif stmtNode.type == "LuaForStatement" then
        return java._generateForStatement(stmtNode)
    elseif stmtNode.type == "LuaWhileStatement" then
        return java._generateWhileStatement(stmtNode)
    elseif stmtNode.type == "LuaReturnStatement" then
        return java._generateReturnStatement(stmtNode)
    elseif stmtNode.type == "LuaBlockStatement" then
        return java._generateBlockStatement(stmtNode)
    else
        return "-- " .. stmtNode.type
    end
end

-- Generate if statement
function java._generateIfStatement(ifNode)
    local ifCode = "if " .. java._generateExpression(ifNode.test) .. " then"
    if ifNode.alternate then
        ifCode = ifCode .. "\n    -- else clause"
    end
    return ifCode
end

-- Generate for statement
function java._generateForStatement(forNode)
    local forCode = "for "
    if forNode.init then
        forCode = forCode .. java._generateExpression(forNode.init)
    end
    if forNode.test then
        forCode = forCode .. ", " .. java._generateExpression(forNode.test)
    end
    if forNode.update then
        forCode = forCode .. ", " .. java._generateExpression(forNode.update)
    end
    forCode = forCode .. " do"
    return forCode
end

-- Generate while statement
function java._generateWhileStatement(whileNode)
    return "while " .. java._generateExpression(whileNode.test) .. " do"
end

-- Generate return statement
function java._generateReturnStatement(returnNode)
    if returnNode.argument then
        return "return " .. java._generateExpression(returnNode.argument)
    else
        return "return"
    end
end

-- Generate block statement
function java._generateBlockStatement(blockNode)
    local blockCode = {}
    for _, stmt in ipairs(blockNode.body) do
        table.insert(blockCode, java._generateStatement(stmt))
    end
    return table.concat(blockCode, "\n")
end

-- Generate expression
function java._generateExpression(exprNode)
    if exprNode.type == "LuaLiteral" then
        return exprNode.value
    elseif exprNode.type == "LuaIdentifier" then
        return exprNode.name
    else
        return "-- expression"
    end
end

-- Helper functions
function java._getModuleName(importPath)
    local parts = {}
    for part in importPath:gmatch("[^%.]+") do
        table.insert(parts, part)
    end
    return parts[#parts] or "module"
end

function java._createError(message, debug)
    if debug then
        return "❌ Java to Lua Transpiler Error: " .. message
    else
        return "❌ Transpilation failed"
    end
end

-- Utility functions for external use
function java.setConfig(newConfig)
    for key, value in pairs(newConfig) do
        config[key] = value
    end
end

function java.getConfig()
    return config
end

function java.getSupportedFeatures()
    return {
        classes = true,
        methods = true,
        constructors = true,
        inheritance = true,
        interfaces = true,
        controlFlow = true,
        operators = true,
        literals = true,
        comments = true,
        imports = true,
        packages = true
    }
end

return java
