/**
 *  Derived from the Haskell Language Specification
 *
 *  https://www.haskell.org/onlinereport/haskell2010/haskellch10.html#x17-17500010
 *
 *  author: Ali Afroozeh
 */

module haskell::specification::Haskell

extend haskell::specification::Lexical;

syntax Module	
     = "module" ModId Exports? "where" Body 
     | Body
     ;

syntax Body	
     = "{" ImpDecls ";" TopDecls "}"
 	 | "{" ImpDecls "}"
	 | "{" TopDecls "}"
     ; 

syntax ImpDecls	
     = { ImpDecl ";" }+
     ;
 
syntax Exports	
     = "(" {Export ","}* ","? ")"
     ;
 
syntax Export	
     = QVar
	 | QTyCon ( ("(" ".." ")") | ("(" { CName "," }* ")") )?
	 | QTyCls ( ("(" ".." ")") | ("(" { QVar ","}* ")") )?
	 | Module ModId
	 ;
 
syntax ImpDecl	
     = "import" "qualified"? ModId ("as" ModId)? ImpSpec?
	 |		    											
	 ;
 
syntax ImpSpec	
     = "(" {Import ","}* ","? ")"
	 | "hiding" "(" { Import ","}* ","? ")"
	 ;
 
syntax Import	
     = Var
	 | TyCon ( ("(" ".." ")") | ("(" { CName "," }* ")") )?
	 | TyCls ( ("(" ".." ")") | ("(" { Var "," }* ")") )?
	 ;

syntax CName	
     = Var 
     | Con
     ;
 
syntax TopDecls	
     = { TopDecl ";" }+
     ;

syntax TopDecl	
     = "type" SimpleType "=" Type
	 | "data" (Context "=\>")? SimpleType ("=" Constrs)? Deriving?
	 | "newtype" (Context "=\>")? SimpleType "=" NewConstr Deriving?
	 | "class" (SContext "=\>")? TyCls TyVar ("where" CDecls)?
	 | "instance" (SContext "=\>")? QTyCls Inst ("where" IDecls)?
	 | "default" {Type ","}*
	 | "foreign" FDecl
	 | Decl
	 ;
 
syntax Decls	
     = "{" { Decl ";"}* "}"
     ;

syntax Decl	
     = GenDecl
	 | (FunLHS | Pat) RHS
	 ;
 
syntax CDecls	
     = "{" {CDecl ";"}* "}"
     ;

syntax CDecl	
     = GenDecl
     | (FunLHS | Var) RHS
	 ;
 
syntax IDecls	
     = "{" {IDecl ";"}+ "}"
     ;

syntax IDecl	
     = (FunLHS | Var) RHS
	 |                              
	 ;
 
syntax GenDecl	
     = Vars "::" (Context "=\>")? Type	    
	 | Fixity Integer? Ops	    		    
	 |							    
	 ;
 
syntax Ops	
     = { Op "," }+
     ;

syntax Vars
     = { Var ","}+
     ;

syntax Fixity	
     = "infixl"
     | "infixr" 
     | "infix"
     ;
 
syntax Type	
     = BType ("-\>" Type)?	    
     ;
 
syntax BType	
     = BType? AType	    
     ;
 
syntax AType	
     = GTyCon
	 | TyVar
	 | "(" Type "," { Type "," }+ ")"	    
	 | "[" Type "]"	    				    
	 | "(" Type ")"	  				    
	 ;
 
syntax GTyCon	
     = QTyCon
	 | "(" ")"	    		
	 | "[" "]"	    		
	 | "(" "-\>" ")"	     
 	 | "(" ","+ ")"	     
 	 ;
 
syntax Context	
     = Class
	 | "(" {Class ","}* ")"	
	 ;

syntax Class	
     = QTyCls TyVar
	 | QTyCls "(" TyVar AType+ ")"	 
	 ;

syntax SContext	
     = SimpleClass
	 | "(" { SimpleClass "," }* ")"
	 ;

syntax SimpleClass	
     = QTyCls TyVar
     ;
 
syntax SimpleType	
     = TyCon TyVar*
     ;

syntax Constrs	
     = { Constr "|" }+
     ;

syntax Constr	
     = Con ("!"? AType)*                                   
	 | (BType | ("!"? AType)) ConOp (BType | ("!" AType))	    
	 | Con "{" { FieldDecl ","}* "}"
	 ;

syntax NewConstr	
     = Con AType
	 | Con "{" Var "::" Type "}"
	 ;

syntax FieldDecl	
     = Vars "::" (Type | ("!" AType))
     ;

syntax Deriving	
     = "deriving" (DClass | ("(" { DClass "," }* ")") )	    
     ;

syntax DClass	
     = QTyCls
     ;
 
syntax Inst	
     = GTyCon
	 | "(" GTyCon TyVar* ")"	              
	 | "(" TyVar "," { TyVar "," }+ ")"	    
	 | "[" TyVar "]"
	 | "(" TyVar "-\>" TyVar ")"	             
	 ;
 
syntax FDecl	
     = "import" CallConv Safety? Impent Var "::" FType	    
	 | "export" CallConv Expent Var "::" FType	         
	 ;

syntax CallConv
     = "ccall" 
     | "stdcall" 
     | "cplusplus"
	 | "jvm" 
     | "dotnet"
//	| system-specific calling conventions
	 ;

syntax Impent	
     = String?	    
     ;

syntax Expent
     = String?	    
     ;

syntax Safety	
     = "unsafe" 
     | "safe"
     ;
 
syntax FType	
     = FRType
	 | FAType  "-\>"  FType
	 ;

syntax FRType	
     = FAType
	 | "("")"
	 ;

syntax FAType	
     = QTyCon AType*
     ;
 
syntax FunLHS
     = Var APat APat*
	 | Pat VarOp Pat
	 | "(" FunLHS ")" APat "{" APat "}"
	 ;
 
syntax RHS	
     = "=" Exp ("where" Decls)?
	 | GDRHS ("where" Decls)?
	 ;
 
syntax GDRHS
     = Guards "=" Exp GDRHS?
     ;
 
syntax Guards	
     = "|" { Guard "," }+
     ;

syntax Guard	
     = Pat "\<-" InfixExp	    
	 | "let" Decls	         
	 | InfixExp	         
	 ;
 
syntax Exp	
     = InfixExp "::" ( Context "=\>")? Type	    
	 | InfixExp
	 ;
 
syntax InfixExp	
     = LExp QOp InfixExp	    
	 | "-" InfixExp	         
	 | LExp
	 ;
 
syntax LExp	
     = "\\" APat+ "-\>" Exp	                             
	 | "let" Decls "in" Exp                           
	 | "if" Exp ";"? "then" Exp ";"? "else" Exp	    
	 | "case" Exp "of" "{" Alts "}"	              
	 | "do" "{" Stmts "}"	                        
	 | FExp
	 ; 

syntax FExp	
     = FExp? AExp	    
     ;
 
syntax AExp	
     = QVar	                             
	 | GCon	                             
	 | Literal
	 | "(" Exp ")"	    
	 | "(" Exp "," { Exp "," }+ ")"	    
	 | "[" { Exp ","}+ "]"
	 | "[" Exp ("," Exp)? ".." Exp? "]"	    
	 | "[" Exp "|" { Qual "," }+ "]"
	 | "(" InfixExp QOp ")"
	 | "(" QOp \ "-" InfixExp ")" 
 	 | QCon "{" { FBind "," }* "}"	    
	 | AExp \ QCon "{" { FBind "," }+ "}"	    
	 ;
 
syntax Qual	
     = Pat "\<-" Exp
	 | "let" Decls
	 | Exp	    
	 ;
 
syntax Alts	
     = { Alt ";" }+
     ;

syntax Alt
     = Pat "-\>" Exp ("where" Decls)?
	| Pat GDPat ("where" Decls)?
	|
	;
 
syntax GDPat	
     = Guards "-\>" Exp GDPat?
     ;
 
syntax Stmts	
     = Stmt* Exp ";"?
     ;

syntax Stmt
     = Exp ";"
	 | Pat "\<-" Exp ";"
	 | "let" Decls ";"
	 | ";"
	 ;
 
syntax FBind	
     = QVar "=" Exp
     ;
 
syntax Pat	
     = LPat QConOp Pat
	 | LPat
	 ;
 
syntax LPat	
     = APat
	 | "-" (Integer | Float)
	 | GCon APat+
	 ;
 
syntax APat
     = Var ( "@" APat)?
	 | GCon
	 | QCon "{" { FPat "," }* "}"
	 | Literal
	 | "_"
	 | "(" Pat ")"
	 | "(" Pat "," {Pat ","}+ ")"
	 | "[" { Pat "," }+
	 | "~" APat
	 ;
 
syntax FPat	
     = QVar "=" Pat
     ;
 
syntax GCon
     = "(" ")"
	 | "[" "]"
	 | "(" ","+ ")"
	 | QCon
	 ;
 
syntax Var	
     = VarId 
     | "(" VarSym ")"
     ;

syntax QVar	
     = QVarId 
     | "(" QVarSym ")"
     ;

syntax Con	
     = ConId 
     | "(" ConSym ")"
     ;

syntax QCon	
     = QConId 
     | "(" GConSym ")"
     ;

syntax VarOp
     = VarSym 
     | "`"  VarId "`"
     ;

syntax QVarOp	
     = QVarSym 
     | "`" QVarId "`"
     ;

syntax ConOp	
     = ConSym 
     | "`" ConId "`"
     ;

syntax QConOp
     = GConSym 
     | "`" QConId "`"
     ;

syntax Op	
     = VarOp 
     | ConOp
     ;

syntax QOp	
     = QVarOp 
     | QConOp
     ;

syntax GConSym	
     = ":" 
     | QConSym
     ;
