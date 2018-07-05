/**
 *  Derived from  the main text of the Java Language Specification
 *
 *  author: Ali Afroozeh
 */
module java::JavaNatural

extend java::\lexical::ContextAware;


/************************************************************************************************************************
 * Types, Values, and Variables
 ***********************************************************************************************************************/

syntax Type 
     = PrimitiveType ("[" "]")*
     | ReferenceType ("[" "]")*
     ;

syntax PrimitiveType 
     = "byte"
     | "short"
     | "char"
     | "int"
     | "long"
     | "float"
     | "double"
     | "boolean"
     ;
     
syntax ReferenceType
     = Identifier TypeArguments? ( "." Identifier TypeArguments? )*
     ;
     
syntax TypeArguments 
     = "\<" {TypeArgument ","}+ "\>" 
     ;
        
syntax TypeArgument 
     = simpleTypeArgument:   Type
     | wildCardTypeArgument: "?" (("extends" | "super") Type)?  
     ;     

syntax TypeList
     = {Type ","}+
     ;
     
syntax NonWildTypeArguments
     = "\<" { Type ","}+ "\>"
     ;     
     
syntax TypeArgumentsOrDiamond 
     = "\<" "\>" 
     | TypeArguments
     ;     
     
syntax ReferenceTypeNonArrayType
     = TypeDeclSpecifier TypeArguments?
     ;
     
syntax TypeParameters 
     = "\<" {TypeParameter ","}+ "\>"
     ;

syntax TypeParameter 
     = Identifier TypeBound?
     ;     
     
syntax TypeBound 
     = "extends" {ReferenceType "&"}+
     ;      
      
syntax QualifiedIdentifier 
     = {Identifier "."}+;

syntax QualifiedIdentifierList 
     = {QualifiedIdentifier  ","}+;

/************************************************************************************************************************
 * Top level
 ***********************************************************************************************************************/

start syntax CompilationUnit 
    = PackageDeclaration? ImportDeclaration* TypeDeclaration*
      ;
  
syntax PackageDeclaration 
     = Annotation* "package"  QualifiedIdentifier ";" 
     ;  
  
syntax ImportDeclaration 
    = "import" "static"? {Identifier "."}+ ("." "*")? ";" 
    ;
  
syntax TypeDeclaration
    = ClassDeclaration
    | InterfaceDeclaration
    | ";"
    ;
    
syntax ClassDeclaration 
     = NormalClassDeclaration
     | EnumDeclaration
     ;
    
syntax InterfaceDeclaration 
     = NormalInterfaceDeclaration
     | AnnotationTypeDeclaration
     ;

syntax NormalClassDeclaration 
     = ClassModifier* "class" Identifier TypeParameters? ("extends" Type)? ("implements" TypeList)? ClassBody;
    

syntax EnumDeclaration
     = ClassModifier* "enum" Identifier ("implements" TypeList)? EnumBody
     ;
     
syntax NormalInterfaceDeclaration 
     = InterfaceModifier* "interface" Identifier TypeParameters? ("extends" TypeList)? InterfaceBody
     ;

syntax AnnotationTypeDeclaration 
     = InterfaceModifier* "@" "interface" Identifier AnnotationTypeBody
     ;
    
 /************************************************************************************************************************
 * Classes
 ***********************************************************************************************************************/
      

syntax ClassModifier
     = Annotation
     | "public"
     | "protected" 
     | "private"
     | "abstract" 
     | "static" 
     | "final" 
     | "strictfp"
     ;
     
syntax ConstructorModifier
     = Annotation 
     | "public"
     | "protected"
     | "private"
     ;
     
syntax InterfaceModifier
     = Annotation
     | "public"
     | "protected"
     | "private"
     | "abstract"
     | "static"
     | "strictfp"
     ;
     
syntax ConstantModifier
     = Annotation
     | "public"
     | "static"
     | "final"
     ;

syntax AbstractMethodModifier
     = Annotation
     | "public"
     | "abstract"
     ;          
     
syntax FieldModifier
     = Annotation 
     | "public" 
     | "protected" 
     | "private"
     | "static"
     | "final" 
     | "transient"
     | "volatile"
     ;

syntax MethodModifier 
     = Annotation
     | "public" 
     | "protected"
     | "private"
     | "abstract" 
     | "static"
     | "final"
     | "synchronized"
     | "native"
     | "strictfp"
     ;
     
syntax VariableModifier 
    = Annotation
    | "final"
    ;     
     
/************************************************************************************************************************
 * Annotations
 ***********************************************************************************************************************/
  
syntax Annotation 
    = "@" QualifiedIdentifier  ( "(" AnnotationElement? ")" )?
    ;
    
syntax AnnotationElement
    = { ElementValuePair "," }+
    | { ElementValue "," }+
    ;        

syntax ElementValuePair 
    = Identifier "=" ElementValue
    ;

syntax ElementValue 
    = Expression !ao
    | Annotation
    | ElementValueArrayInitializer
    ;

syntax ElementValueArrayInitializer 
    = "{" { ElementValue "," }* ","? "}"
    ;
    
syntax ClassBody 
    = "{" ClassBodyDeclaration* "}"
    ;

syntax ClassBodyDeclaration
     = Initializer
     | ConstructorDeclaration
     | FieldDeclaration 
     | MethodDeclaration 
     | ClassDeclaration 
     | InterfaceDeclaration
     | ";"
     ;
     
syntax Initializer
     = "static"? Block
     ;     
     
syntax ConstructorDeclaration
     = ConstructorModifier* TypeParameters? Identifier "(" FormalParameterList? ")" Throws? Block
     ;
     
/************************************************************************************************************************
 * Interfaces
 ***********************************************************************************************************************/	 
	           
syntax InterfaceBody
     = "{" InterfaceMemberDeclaration* "}"
     ;
     
syntax InterfaceMemberDeclaration
     = ConstantDeclaration 
     | AbstractMethodDeclaration 
     | ClassDeclaration 
     | InterfaceDeclaration
     | ";"
     ;
     
syntax ConstantDeclaration
     = ConstantModifier* Type {VariableDeclarator ","}+ ";"
     ;
          
syntax AbstractMethodDeclaration
     = AbstractMethodModifier* TypeParameters? Result MethodDeclarator Throws? ";"
     ;
          
syntax AnnotationTypeBody
     = "{" AnnotationTypeElementDeclaration* "}"
     ;

syntax AnnotationTypeElementDeclaration 
     = AbstractMethodModifier* Type Identifier "(" ")" ("[" "]")* DefaultValue? ";" 
     | ConstantDeclaration
     | ClassDeclaration
     | InterfaceDeclaration
     | AnnotationTypeDeclaration
     | ";"
     ;
     
syntax DefaultValue
     = "default" ElementValue
     ;
	 
/************************************************************************************************************************
 * Fields
 ***********************************************************************************************************************/
	 
syntax FieldDeclaration
     = FieldModifier* Type {VariableDeclarator ","}+ ";"
     ;

syntax VariableDeclarator
     = VariableDeclaratorId ("=" VariableInitializer)?
     ;
     
syntax VariableDeclaratorId 
    = Identifier ("[" "]")*
    ;

syntax VariableInitializer 
    = ArrayInitializer
    | Expression
    ;
    
syntax ArrayInitializer 
    = "{"  {VariableInitializer ","}* ","? "}"
    ;
    
/************************************************************************************************************************
 * Methods
 ***********************************************************************************************************************/

syntax MethodDeclaration
     = MethodModifier* TypeParameters? Result MethodDeclarator Throws? MethodBody
     ;
     
syntax MethodDeclarator
     = Identifier "(" FormalParameterList? ")" ("[" "]")*
     ;
     
syntax FormalParameterList
     = (FormalParameter ",")* LastFormalParameter
     ;
     
syntax FormalParameter
     = VariableModifier* Type VariableDeclaratorId
     ;

syntax LastFormalParameter
     = VariableModifier* Type "..." VariableDeclaratorId
     | FormalParameter
     ;
     
syntax Result
     = Type
     | "void"
     ;

syntax Throws
     = "throws" {QualifiedIdentifier ","}+
     ;
     
syntax MethodBody
     = Block
     | ";"
     ;

/************************************************************************************************************************
 * Enums
 ***********************************************************************************************************************/
     
syntax EnumBody
     = "{" {EnumConstant ","}* ","? EnumBodyDeclarations? "}"
     ;     
     
syntax EnumConstant
     = Annotation* Identifier Arguments? ClassBody?
     ;
     
syntax Arguments
     = "(" ArgumentList? ")"
     ;
     
syntax EnumBodyDeclarations
     = ";" ClassBodyDeclaration*
     ;

/************************************************************************************************************************
 * Statements
 ***********************************************************************************************************************/

syntax Block 
     = "{" BlockStatement* "}"
     ;

syntax BlockStatement 
     = LocalVariableDeclarationStatement
     | ClassDeclaration
     | Statement
     ;

syntax LocalVariableDeclarationStatement 
     = VariableModifier* Type {VariableDeclarator ","}+ ";"
     ;

syntax Statement
     = Block
     | ";" 
     | expressionStmt: Expression ";"
     | assertStmt: "assert" Expression (":" Expression)? ";" 
     | switchStmt: "switch" "(" Expression ")" "{" SwitchBlockStatementGroup* SwitchLabel* "}" 
     | doStmt: "do" Statement "while" "(" Expression ")" ";" 
     | breakStmt: "break" Identifier? ";" 
     | continueStmt: "continue" Identifier? ";" 
     | returnStmt: "return" Expression? ";" 
     | synchronizedStmt: "synchronized" "(" Expression ")" Block 
     | throwStmt: "throw" Expression ";" 
     | tryStmt: "try" Block (CatchClause+ | (CatchClause* Finally))
     | tryWithResourcesStmt: "try" ResourceSpecification Block CatchClause* Finally? 
     | labelStmt: Identifier ":" Statement
     | ifStmt: "if" "(" Expression ")" Statement !>>> "else"
     | ifElseStmt: "if" "(" Expression ")" Statement "else" Statement
     | whileStmt: "while" "(" Expression ")" Statement
     | forStmt: "for" "(" ForControl ")" Statement
     ;

syntax ForControl
	= ForInit? ";" Expression? ";" ForUpdate?
	| FormalParameter ":" Expression
	;

    
syntax CatchClause 
    = "catch" "(" VariableModifier* CatchType Identifier ")" Block
    ;

syntax CatchType  
    =  {QualifiedIdentifier "|"}+
    ;

syntax Finally 
    = "finally" Block
    ;

syntax ResourceSpecification 
    = "(" Resources ";"? ")"
    ;

syntax Resources 
    = {Resource ";"}+
    ;

syntax Resource 
     = VariableModifier* ReferenceType VariableDeclaratorId "=" Expression
     ; 

syntax SwitchBlockStatementGroup 
	     = SwitchLabel+ BlockStatement+
     ;

syntax SwitchLabel 
     = "case" ConstantExpression ":"
     | "default" ":"
     ;

syntax LocalVariableDeclaration 
    = VariableModifier* Type { VariableDeclarator ","}+
    ;

syntax ForInit 
     = {Expression ","}+
     | LocalVariableDeclaration
     ;
     
syntax ForUpdate 
     = {Expression ","}+
     ;    

/************************************************************************************************************************
 * Expressions
 ***********************************************************************************************************************/

syntax Expression
     = Expression "." Identifier
     | Expression "." "this"
	 | Expression "." "new" TypeArguments? Identifier TypeArgumentsOrDiamond? "(" ArgumentList? ")" ClassBody?
	 | Expression "." NonWildTypeArguments ExplicitGenericInvocationSuffix     
     | Expression "." "super" ("." Identifier)? Arguments
	 | methodCall: Expression !brackets "(" ArgumentList? ")"     
     | arrayAccess: Expression "[" Expression "]"
     | postfix: Expression ("++" | "--")
     > unaryPlusMinus: ("+" !>> "+" | "-" !>> "-") Expression
     | prefix: ("++" | "--" | "!" | "~") Expression
     | newClass: "new" ClassInstanceCreationExpression
     | newArray: "new" ArrayCreationExpression
     | caseExpr: "(" Type ")" Expression !unaryPlusMinus
     > left Expression ("*" | "/" | "%") Expression 
     > left Expression ("+" !>> "+" | "-" !>> "-") Expression
     > left shiftExpr: Expression ("\<\<" | "\>\>" !>> "\>" | "\>\>\>") Expression 
     > left comparisonExpr: Expression ("\<" !>> "=" !>> "\<" | "\>" !>> "=" !>> "\>" | "\<=" | "\>=")  Expression
     > instanceOfExpr:   Expression "instanceof" Type
     > left  Expression ("==" | "!=") Expression
     > left  Expression "&" !>> "&" Expression
     > left  Expression "^" Expression
     > left  Expression "|" !>> "|" Expression 
     > left  Expression "&&" Expression
     > left  Expression "||" Expression
     > right conditionalExpr: Expression "?" Expression ":" Expression 
     > right ao: Expression !comparisonExpr AssignmentOperator Expression
     | brackets: "(" Expression ")"
     | primary: Primary
     ;
     
syntax FieldAccess
	= Expression "." Identifier
     | Expression "." "this"
	 | Expression "." "new" TypeArguments? Identifier TypeArgumentsOrDiamond? "(" ArgumentList? ")" ClassBody?
	 | Expression "." NonWildTypeArguments ExplicitGenericInvocationSuffix     
     | Expression "." "super" ("." Identifier)? Arguments
     ;     
     
syntax Primary
	 = Literal
     | "this"
     | "super"
     | Identifier
     | Type "." "class"
     | "void" "." "class"
     ;     

syntax ClassInstanceCreationExpression
     =  TypeArguments? TypeDeclSpecifier TypeArgumentsOrDiamond? "(" ArgumentList? ")" ClassBody? 
     ;
          
syntax ArgumentList
     = {Expression ","}+
     ;     

syntax ArrayCreationExpression
	 = (PrimitiveType | ReferenceType) DimExpr+ ("[" "]")*
	 | (PrimitiveType | ReferenceTypeNonArrayType) ("[" "]")+ ArrayInitializer
     ;

syntax DimExpr
     = "[" Expression "]"
     ;
     
syntax ConstantExpression
     = Expression
     ;
     
syntax ClassName
	 = QualifiedIdentifier
	 ;
	 
syntax MethodName
     = QualifiedIdentifier
     ;
     
syntax TypeDeclSpecifier
     = Identifier (TypeArguments? "." Identifier)*
     ;     

syntax SuperSuffix 
     =  Arguments 
     | "." Identifier Arguments?
     ;

 syntax ExplicitGenericInvocationSuffix 
 	  = "super" SuperSuffix
 	  | Identifier Arguments
 	  ;
     
     