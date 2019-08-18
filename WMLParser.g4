parser grammar WMLParser;

options { tokenVocab=WMLLexer; }
document : DEFAULT_WS_OR_NEWLINE* feature* EOF;
feature : (element); //future will be like (element | pre-processor | script)
element : (open_element | open_merge_element) (innerElement | attribute)* close_element ;
innerElement : (inner_open_element | inner_open_merge_element) (element | attribute)* close_element ;
open_element : OPEN_START_TAG open_element_tag_name OPEN_ELEMENT_NAME_CLOSE_TAG ;
inner_open_element : INNER_OPEN_START_TAG open_element_tag_name OPEN_ELEMENT_NAME_CLOSE_TAG ;
open_element_tag_name : OPEN_ELEMENT_NAME;
open_merge_element : OPEN_START_MERGE_TAG open_merge_element_tag_name OPEN_ELEMENT_NAME_CLOSE_TAG ;
inner_open_merge_element : INNER_OPEN_START_MERGE_TAG open_merge_element_tag_name OPEN_ELEMENT_NAME_CLOSE_TAG ;
open_merge_element_tag_name :  OPEN_ELEMENT_NAME; 
close_element : OPEN_END_TAG close_element_tag_name CLOSE_ELEMENT_NAME_CLOSE_TAG ;
close_element_tag_name : CLOSE_ELEMENT_NAME;


attribute : attribute_names ASSIGNMENT text_domain? attribute_value (LINE_CONTINUATION text_domain? attribute_value)*;
attribute_names: attribute_name (ADDITONAL_NAME attribute_name)* ;
attribute_name : ATTRIBUTE_NAME ;
attribute_value :	( string 
                    | translateable_string 
                    | strong_string 
                    | translateable_strong_string 
                    | number 
                    | object_name);


text_domain : ATTRIBUTE_TEXT_DOMAIN text_domain_name;
text_domain_name : TEXT_DOMAIN_NAME;
string : START_STRING string_value END_STRING;
translateable_string : START_TRANSLATEABLE_STRING string_value END_STRING ;
strong_string : START_STRONG_STRING strong_string_value END_STRONG_STRING;
translateable_strong_string: START_TRANSLATEABLE_STRONG_STRING strong_string_value END_STRONG_STRING;
object_name : OBJECT_NAME ;
string_value: STRING;
strong_string_value: STRONG_STRING;
number: NUMBER;
