/**
 * 
 * Extracted from the OCaml reference manual 4.00
 *
 * Ali Afroozeh 
 * 
 */

module ocaml::specification::OCaml

extend ocaml::specification::Lexical;

// Top-level     		

syntax TopLevel = TopLevelPhrase*;

syntax TopLevelPhrase 
	 = Definition
   	 | Expr
   	 ;
   	 
syntax CompiliationUnit
     = Interface
     | Implementation
     ;    	 
   	 
syntax Interface = (Specification ";;"?)*; 
    	 
syntax Implementation = ModuleItems?;
   	      		
 
// Names
syntax ValuePath 
	 = valuePath: (ModulePath ".")? ValueName;

syntax ValueName 
	= LowercaseIdentifier 
	| "(" OperatorChar+ !>> [! : \< = \> ? @ ^ | ~] ")"   // This is added to cover cases such as let (!) x y = x + y
	| "(" ("mod"| "lsl" | "lsr" | "asr" | "mod" | "land" | "lor" | "lxor") ")" 
	;   

syntax TagName 
     = Ident
     ;

syntax TypeconstrName 
     = LowercaseIdentifier
     ;

syntax TypeConstr 
     = (ExtendedModulePath ".")? TypeconstrName
     ;

syntax ConstrName 
     = CapitalizedIdentifier
     ;

syntax LabelName 
     = LowercaseIdentifier
     ;

syntax ModuleName 
     = CapitalizedIdentifier
     ;

syntax FieldName 
     = LowercaseIdentifier
     ;

syntax ClassName 
     = LowercaseIdentifier
     ;

syntax InstVarName 
     = LowercaseIdentifier
     ;

syntax MethodName 
     = LowercaseIdentifier
     ;

syntax ModTypeName 
     = Ident
     ;

syntax ModulePath 
     = (ModuleName ".")* ModuleName
     ;

syntax Constr 
     = (ModulePath ".")? ConstrName 
     ;

syntax Field 
     = (ModulePath ".")? FieldName
     ;

syntax ClassPath 
     = (ModulePath "." )? ClassName
     ;

syntax ModTypePath 
     = (ExtendedModulePath "." )? ModTypName
     ;

syntax ModTypName 
     = Ident
     ;

syntax ExtendedModulePath 
     = (ExtendedModulePath ".")? ModuleName
     | ExtendedModulePath "(" ExtendedModulePath ")"
     ;


// Type expressions

syntax Typexpr 
	 = typexprConstr1: Typexpr TypeConstr
	 > non-assoc star: Typexpr "*" {Typexpr !star !arrow1 "*"}+
	 > right (arrow1: Typexpr "-\>" Typexpr
	 |        arrow2: "?"? LabelName ":" Typexpr !arrow1 "-\>" Typexpr)
	 > typexprAsId: Typexpr "as" "\'" Ident 
	 > typexprPrivate: "private" Typexpr
	 | tagg: "\'" Ident
     | anyTypexpr: "_" !>> [a-zA-Z0-9]
     | typeExprBrackets: "(" Typexpr ")"
     | typexprConstr2: TypeConstr
  	 | typeExprBrackets2: "(" Typexpr ("," Typexpr)+ ")" TypeConstr
  	 | polymorphicVariantType: PolymorphicVariantType
  	 | typexprEmptyAngleBrackets: "\<" ".."? "\>"
  	 | typexprAngleBrackets: "\<" {MethodType ";"}+ (";" "..")? "\>"
  	 | typexprHash1: "#" ClassPath
  	 | typexprHash2: Typexpr "#" ClassPath
  	 | typexprHash3: "(" {Typexpr ","}+ ")" "#" ClassPath
  	 | typexprPackage: "(" "module" PackageType ")"  
     ;

    
syntax PolymorphicVariantType
 	 = "[" "|"? {TagSpec "|"}* "]"
     | "[\>" {TagSpec "|"}* "]"
     | "[\<"  "|"? {TagSpecFull "|"}+ ("\>" ("`" TagName)+ )?  "]"
     ;
       
syntax PolyTypExpr 
	 = Typexpr
     | ("\'" Ident)+ "." Typexpr
     ;
       
syntax MethodType 
	= MethodName ":" PolyTypExpr;
       
       
syntax TagSpec
     = "`" TagName ("of" Typexpr)?
	 | Typexpr
	 ;

syntax TagSpecFull 
	 = "`" TagName ("of" Typexpr)? ("&" Typexpr)*
     | Typexpr
     ;


// Expressions

syntax Expr 
	 = prefix: 				PrefixSymbol Expr !valuePath
	 > non-assoc field: 			Expr "." Field  
	 | non-assoc dotBracket1: 		Expr ".(" Expr ")"
	 | non-assoc dotBracket2: 		Expr ".[" Expr "]"
	 | non-assoc dotBracket3: 		Expr ".{" Expr "}"
	 > hash: 				Expr "#" MethodName
     > non-assoc 
     (
     functionApplication: 	Expr  Arg+
     //| constrExp: 			Constr Expr    To avoid ambiguities with Expr Arg+ as Expr can derive Constr
     //| polyVariant:	 		"`" TagName Expr  To Avoid ambiguities with Constant("`" TagName) Arg(Expr)
     | lazy: 				"lazy" Expr
     | assertExpr: 			"assert" Expr
     )
     > unaryMinus: 			"-"  Expr | floatUnaryMinus: "-." Expr
     > right infix1: 		Expr InfixSymbol1 Expr
     > left  infix2: 		Expr InfixSymbol2 Expr
     > left  infix3: 		Expr InfixSymbol3 Expr   // to disambiguate [|   5.2026032092;     19132e-10;  -39e-10 |];
     > right coloncolon:	Expr "::" Expr
     > right infix4: 		Expr InfixSymbol4 Expr
     > left  infix5: 		Expr InfixSymbol5 Expr
     | left  uneq:   		Expr "!=" Expr
     > right infix6: 		Expr InfixSymbol6 Expr
     > right infix7: 		Expr InfixSymbol7 Expr
     > non-assoc comma: 	Expr ("," Expr !comma !sep)+
     > right 
     (
       assign1: 			Expr "." Field "\<-" Expr
     | assign2:		 		Expr ".(" Expr ")" "\<-" Expr
     | assign3: 	 		Expr ".[" Expr "]" "\<-" Expr
     | assign4: 	 		Expr ".{" Expr "}" "\<-" Expr
     | assign5:		 		InstVarName "\<-" Expr
     )
     > right infix8: 		Expr InfixSymbol8 Expr
     > ifThenElse: 	 		"if" Expr  "then" Expr !sep "else" Expr
     | ifThen: 		 		"if"  Expr "then" Expr !>>> "else"
     //> semicolon: 	 		Expr ";" !>>  ";"
     > right sep: 	 		Expr ";" Expr
     > match: 		 		"match" Expr "with" PatternMatching
     | function: 	 		"function" PatternMatching
     | fun: 		 		"fun" MultipleMatching
     | tryBlock: 	 		"try" Expr "with" PatternMatching     
     | letbinding: 	 		"let" "rec"? {LetBinding "and"}+ "in" Expr
     | letModule:	 		"let" "module" ModuleName "="  ModuleExpr "in"  Expr 
     | letOpen:             "let" "open" ModulePath "in"  Expr
     | brackets: 			"(" Expr ")"
  	 | beginEnd: 	 		"begin" Expr ";"? "end"
  	 | brackets1: 	 		"(" Expr ":" Typexpr ")"
  	 | brackets2:	 		"(" Expr ":\>"  Typexpr ")"  
 	 | brackets3: 	 		"(" Expr ":"  Typexpr ":\>"  Typexpr ")"  
 	 | brackets4: 	 		"{\<" InstVarName "=" Expr !sep  (";" InstVarName "="  Expr)*  ";"? "\>}"  
  	 | tupl: 		 		"["  {Expr !sep ";"}+ ";"? "]"
     | array: 		 		"[|" {Expr !sep ";"}+ ";"? "|]"
     | record1:	     		"{" Field ("=" Expr !sep)? (";" Field ("=" Expr !sep)?)* ";"? "}"
     | record2: 	 		"{" Expr "with" Field ("=" Expr !sep )? (";" Field ("=" Expr !sep)?)* ";"? "}"
     | whileloop: 	 		"while" Expr "do" Expr ";"? "done"
     | forloop: 			"for" Ident "=" Expr ("to" | "downto") Expr "do" Expr ";"? "done"
     | new: 				"new" ClassPath
     | object: 		 		"object" ClassBody "end"  
     | moduleExpr: 	 		"(" "module" ModuleExpr  (":" PackageType)? ")"  
     //| valuePath: 	 		ValuePath
     | 						ValueName
	 | constant: 			Constant 
	 //| 						InstVarName
     ; 
     
  
     
syntax Arg 
 	 =                Expr !functionApplication !constrExp !polyVariant !lazy !assertExpr !unaryMinus !floatUnaryMinus !infix1 !infix2 !infix3 
 	                       !coloncolon !infix4 !infix5 !uneq !infix6 !infix7 !comma !assign1 !assign2 !assign3 !assign4 !assign5 
 	                       !infix8 !ifThenElse !ifThen !sep !match !function !fun !tryBlock !letbinding !letModule 
 	 | label: 		  Label
     | labelColon:    LabelColon Expr !functionApplication !polyVariant !lazy !assertExpr !unaryMinus !floatUnaryMinus !infix1 !infix2 !infix3 
 	                       			  !coloncolon !infix4 !infix5 !uneq !infix6 !infix7 !comma !assign1 !assign2 !assign3 !assign4 !assign5 
 	                       			  !infix8 !ifThenElse !ifThen !sep !match !function !fun !tryBlock !letbinding !letModule
     | optlabel:      OptLabel
     | optlabelColon: OptLabelColon Expr !functionApplication !polyVariant !lazy !assertExpr !unaryMinus !floatUnaryMinus !infix1 !infix2 !infix3 
 	                       				 !coloncolon !infix4 !infix5 !uneq !infix6 !infix7 !comma !assign1 !assign2 !assign3 !assign4 !assign5 
 	                       				 !infix8 !ifThenElse !ifThen !sep !match !function !fun !tryBlock !letbinding !letModule
     ;
           
syntax PatternMatching 
     =  "|"? Pattern ("when" Expr)? "-\>" Expr InnerPatternMatching* !>>> "|" 
     ;
     
syntax InnerPatternMatching
	 = ";"? "|" Pattern ("when" Expr)? "-\>" Expr
	 ;     
           
syntax LetBinding 
     =                  Pattern !patternValueName "="  Expr  
	 | letBinding:      ValueName Parameter* (":" PolyTypExpr)? (":\>" Typexpr)? "=" Expr 
	 | bindingNew:		ValueName ":" "type"  TypeConstr* "."  Typexpr "="  Expr
	 ;
	 
syntax MultipleMatching
     = multipleMatching: Parameter+ ("when" Expr)? "-\>" Expr;	 

syntax Parameter 
	 = patternParam: Pattern !constrPattern  // Paramter always comes in lists and can match another pattern
     | param1: 		 Label 
     | param2:		 "~" "(" LabelName (":" Typexpr)? ")"
     | param3:		 LabelColon Pattern
     | param4:		 OptLabel 
     | param5:		 "?" "(" LabelName (":" Typexpr)? ("=" Expr)? ")"
     | param6: 		 OptLabelColon Pattern
     | param7: 		 OptLabelColon "(" Pattern ":" Typexpr "=" Expr ")"
     | typeParam:	 "(" "type" TypeconstrName ")"  
     ;

// Patterns

syntax Pattern 
	 = constrPattern: 		  Constr Pattern
	 > tagNamePattern: 		  "`" TagName Pattern
	 > right listCons: 		  Pattern "::" Pattern
	 > non-assoc patterns: 	  Pattern "," {Pattern !patterns !patternBar !patternAs !lazyPattern ","}+
	 > left patternBar: 	  Pattern "|" Pattern
	 > patternAs: 			  Pattern "as" ValueName
	 | patternValueName: 	  ValueName
     | anyPattern: 			  "_" !>> [a-zA-Z0-9]   // To enforce longest match with identifiers
     | patternConstant: 	  Constant
     |                        NegativeIntegerLiteral
     | patternRange: 		  CharLiteral ".." CharLiteral   // Extensions
     | patternBrackets: 	  "(" Pattern ")"
     | patternTypxprBrackets: "(" Pattern ":" Typexpr ")"
     | patternHash: 		  "#" TypeconstrName
     | patternRec: 			  "{" Field ("=" Pattern)? (";" Field "=" Pattern)* ";"? "}"
     | patternTuple: 		  "["  {Pattern ";"}+ ";"? "]"
     | patternArray: 		  "[|" {Pattern ";"}+ ";"? "|]"
     | lazyPattern: 		  "lazy" Pattern
     | patternPackage: 		  "(" "module" ModuleName  (":" PackageType)? ")"  
     ;       
         
syntax Constant 
     = posInt: 			IntegerLiteral
     | floatLiteral: 	FloatLiteral
     | charLiteral: 	CharLiteral
     | stringLiteral: 	StringLiteral1
     | constr: 			Constr
     | falseConstant: 	"false"
     | trueConstant: 	"true"
     | emptyParenthesis: "(" ")"
	 | emptyBrackets:	"[" "]"
	 | emptyArray: 		"[|" "|]"
	 | emptyCurly: 		"{\<" "\>}"
     | 					"`" TagName
     | int32: 			Int32Literal  
	 | int64: 			Int64Literal  
     | nativeInt: 		NativeIntLiteral
     ;

// ModuleExpressions 

syntax Definition 
     = "let" "rec"? LetBinding  ("and" LetBinding)* 
     | "val" ValueName ":" Typexpr
     | "external" ValueName ":" Typexpr "=" ExternalDeclaration
     | TypeDefinition
     | ExceptionDefinition
     | ClassDefinition
     | ClassTypeDefinition
     | "module" ModuleName ( "(" ModuleName ":" ModuleType ")" )* ( ":" ModuleType )? "=" ModuleExpr
     | "module" ModuleName ("(" ModuleName ":" ModuleType ")")* ":" ModuleType
     | "module" "type" ModTypeName "=" ModuleType
     | "module" "type" ModTypeName
     | "module" "rec" ModuleName ":"  ModuleType "="  ModuleExpr  ("and" ModuleName ":"  ModuleType "="  ModuleExpr)*
     | "module" "rec" ModuleName ":"  ModuleType  ("and" ModuleName ":"  ModuleType)*
     | "open" ModulePath
     | "include" ModuleExpr
     ;
     
syntax ModuleExpr 
     = ModulePath
     | "struct" ModuleItems? "end"
     | "functor" "(" ModuleName ":" ModuleType ")" "-\>" ModuleExpr
     | ModuleExpr "(" ModuleExpr ")"
     | "(" ModuleExpr ")"
     | "(" ModuleExpr ":" ModuleType ")"
     | "(" "val" Expr  (":" PackageType)? ")" 
     ;      
     
syntax ModuleItems
     = ";;"? ( (Definition ";"?) | Expr) ((";;"? Definition ";"?) | (";;" Expr))* ";;"?
     ;     
     
// ModuleTypes
 	
syntax Specification 
	 = ClassSpecification
     | Definition
     ;
     
     
syntax ModuleType 
     = modTypePath:       ModTypePath
     | sig:               "sig" ( Specification ";;"? )* "end"
     | modTypeOf:         "module" "type" "of" ModuleExpr
     | modTypeWith:       ModuleType "with" ModConstraint ("and" ModConstraint)*
     | bracketModType2:   ModuleType !modTypeWith "(" ModuleType ")"
     > functor:           "functor" "(" ModuleName ":" ModuleType ")" "-\>" ModuleType
     | bracketModType1:   "(" ModuleType ")"
     ;


syntax ModConstraint 
	 = "type" TypeParams? TypeConstr "=" Typexpr
	 | "type" TypeParameters?  TypeconstrName ":="  TypeParameters?  TypeConstr
     | "module" ModulePath "=" ExtendedModulePath
 	 | "module" ModuleName ":="  ExtendedModulePath  
     ; 	


// Type And Exceptions

syntax TypeDefinition 
     = typeDefinition: "type" {TypeDef "and"}+;
     
syntax TypeDef 
     = TypeParams? TypeconstrName TypeInformation
     ;

syntax TypeInformation 
     = TypeEquation? TypeRepresentation? TypeConstraint*
     ;

syntax TypeEquation 
     = "=" Typexpr
     ;
          
syntax TypeRepresentation 
 	 = "=" "private"? "|"? {ConstrDecl "|"}+
     | "=" "private"? "{" {FieldDecl ";"}+ ";"? "}"
     ;

syntax TypeParams 
     = TypeParam
     | "(" {TypeParam ","}+ ")"
     ;

syntax TypeParam 
     = Variance? "\'" Ident
     | Variance? "_" !>> [a-zA-Z0-9]
     ;     
     
syntax Variance 
     = "+" 
     | "-";
     
syntax ConstrDecl 
     = ConstrName ("of" { Typexpr !star !arrow1 "*"}+)?
     | ConstrName ":" { Typexpr !star !arrow1 "*" }+ "-\>"  Typexpr
     ;

syntax FieldDecl 
	 = "mutable"? FieldName ":" PolyTypExpr
	 ;

syntax TypeConstraint 
	 = "constraint" "\'" Ident "=" Typexpr;
     
syntax ExceptionDefinition 
	 = "exception" ConstrName ("of" Typexpr !star !arrow1 ("*" Typexpr !star !arrow1)* )?
     | "exception" ConstrName "=" Constr
     ;
     
// Classes

syntax ClassType 
     = (("?"? LabelName ":")? Typexpr "-\>")* ClassBodyType;

syntax ClassBodyType 
     = "object" ("(" Typexpr ")")? ClassFieldSpec* "end"
     | ("[" Typexpr ("," Typexpr)* "]")? ClassPath
     ;

syntax ClassFieldSpec 
     = "inherit" ClassType
     | "val" "mutable"? "virtual"? InstVarName ":" PolyTypExpr
     | "method" "private"? "virtual"? MethodName ":" PolyTypExpr
     | "constraint" Typexpr "=" Typexpr
     ;
     
syntax ClassExpr 
     = ClassPath
	 | classExprBrackets1: "[" Typexpr ("," Typexpr)* "]" ClassPath
	 | classExprBrackets2: "(" ClassExpr ")"
	 | classExprBrackets3: "(" ClassExpr ":" ClassType ")"
	 | classArgs: ClassExpr ! classArgs Arg+
	 | classFun: "fun" Parameter+ "-\>" ClassExpr
	 | letClass: "let" "rec"? LetBinding ("and" LetBinding)* "in" ClassExpr
	 | object: "object" ClassBody "end"
	 ;

syntax ClassField 
     = ("inherit" | "inherit!") ClassExpr ("as" ValueName)?
     | ("val"|"val!") "mutable"? InstVarName (":" Typexpr)? "=" Expr
     | "val" "mutable"? "virtual" InstVarName ":" Typexpr
     | ("method" | "method!") "private"? MethodName Parameter* (":" PolyTypExpr)? "=" Expr     
     | "method" "private"? "virtual" MethodName ":" PolyTypExpr
     | "constraint" Typexpr "=" Typexpr
     | "initializer" Expr
     ;
     
syntax ClassDefinition 
	 = "class" {ClassBinding "and"}+
	 ;     
     
syntax ClassBody 
	 = ("(" Pattern (":" Typexpr)? ")")? ClassField*
	 ;

syntax ClassBinding 
	 = "virtual"? ("[" TypeParameters "]")? ClassName Parameter* (":" ClassType)? "=" ClassExpr
	 ;

syntax TypeParameters 
	 = "\'" Ident ("," "\'" Ident)*
	 ;
	 
syntax ClassSpecification 
	 = "class" ClassSpec ("and" ClassSpec)*
	 ;

syntax ClassSpec 
	 = "virtual"? ("[" TypeParameters "]")? ClassName ":" ClassType
	 ;

syntax ClassTypeDefinition 
	 = "class" "type" ClasstypeDef ("and" ClasstypeDef)*
	 ;

syntax ClasstypeDef 
	 = "virtual"? ("[" TypeParameters "]")? ClassName "=" ClassBodyType
	 ;
     
syntax ExternalDeclaration 
     = StringLiteral1+
     ;	 
     

// Extensions

syntax PackageType
	 =	ModTypePath  
	 |	ModTypePath "with"  PackageConstraint  ("and" PackageConstraint)*
 	 ;  

syntax PackageConstraint
     = "type" TypeConstr "="  Typexpr
     ;