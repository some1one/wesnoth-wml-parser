lexer grammar WMLLexer;

//todo: inline and in-element commments
//macros

fragment INT: '0' | [1-9] ([0-9])* ;
fragment CR : '\r';
fragment NL : '\n';
fragment WS  : (' '|[\t]);
fragment NEWLINE : ('\r'? '\n'); 

mode DEFAULT_MODE;

DEFAULT_WS_OR_NEWLINE : (WS | NEWLINE) -> skip;
OPEN_START_TAG: '[' -> pushMode(OPEN_ELEMENT_NAME_MODE);
OPEN_START_MERGE_TAG: '[+' -> pushMode(OPEN_ELEMENT_NAME_MODE);
SKIP_ONE_LINE_PP: ('#undef' | '#warning' | '#error' | '#po' ) .*? NEWLINE -> skip;
BEGIN_PRE_PROCESSOR_TAG: ('#' | '{') -> pushMode(SKIP_PRE_PROCESSOR), skip;

mode OPEN_ELEMENT_NAME_MODE;

OPEN_ELEMENT_NAME : (~([[\]{\r\n"+/#]))+ ;
OPEN_ELEMENT_NAME_CLOSE_TAG: ']' -> pushMode(ELEMENT_MODE) ;

mode ELEMENT_MODE;

ELEMENT_WS_OR_NEWLINE : (WS | NEWLINE) -> skip;
ADDITONAL_NAME: WS* ',' WS*;
ATTRIBUTE_NAME : (~([[\]{}\r\n\t"+=/,<># ]))+;
ASSIGNMENT : WS* '=' WS* -> pushMode(ATTRIBUTE_MODE);
LINE_CONTINUATION : '+' WS* NEWLINE -> pushMode(ATTRIBUTE_MODE);
OPEN_END_TAG: '[/' -> pushMode(CLOSE_ELEMENT_NAME_MODE); 
INNER_OPEN_START_TAG: '[' -> pushMode(OPEN_ELEMENT_NAME_MODE);
INNER_OPEN_START_MERGE_TAG: '[+' -> pushMode(OPEN_ELEMENT_NAME_MODE);

mode CLOSE_ELEMENT_NAME_MODE;

CLOSE_ELEMENT_NAME : (~([[\]{\r\n"+#/]))+ ;
CLOSE_ELEMENT_NAME_CLOSE_TAG: ']' -> popMode, popMode, popMode ;

mode ATTRIBUTE_MODE;
ATTRIBUTE_TEXT_DOMAIN: WS* '#textdomain' WS* -> pushMode(TEXT_DOMAIN_MODE);
NUMBER : '-'? INT ('.' ([0-9])+)? -> popMode;
START_STRING : '"' -> pushMode(STRING_MODE) ;
START_TRANSLATEABLE_STRING: WS* '_' WS* '"' -> pushMode(STRING_MODE) ;
START_STRONG_STRING: '<<' -> pushMode(STRONG_STRING_MODE) ;
START_TRANSLATEABLE_STRONG_STRING: WS* '_' WS* '<<' -> pushMode(STRONG_STRING_MODE) ;
OBJECT_NAME : ((~([[\]{}\r\n\t"+=/_<>,# ])) (~([[\]{}\r\n\t"+=/<>,# ]))+) -> popMode;

mode TEXT_DOMAIN_MODE;

TEXT_DOMAIN_NAME: (~([[\]{}\r\n\t"+=/<>,# ]))+ WS* -> popMode;

mode STRING_MODE;

STRING: (~([\r\n"#+]))+; //TODO: make safe
END_STRING: '"' -> popMode, popMode;

mode STRONG_STRING_MODE;

STRONG_STRING: (~([>]))+; //TODO: make safe
END_STRONG_STRING: '>>' -> popMode, popMode;

mode SKIP_PRE_PROCESSOR;

INNER_PP_START: ('#ifdef' | '#ifndef' | '#ifhave' | '#ifnhave' | '#ifver' | '#ifnver' | '#define' | '{') -> pushMode(SKIP_PRE_PROCESSOR), skip;
END_MACRO: (~'}'*? '}') -> popMode, skip;
END_PP_BLOCK: (.*? '#end' ~([\r\n])* NEWLINE) -> popMode, skip;
SKIP_COMMENT: (~([\r\n])* NEWLINE) -> popMode, skip;