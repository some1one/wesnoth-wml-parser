

Function Get-ENVPathFolders {     
    #.Synopsis Split $env:Path into an array
    #.Notes      
    #  - Handle 1) folders ending in a backslash 2) double-quoted folders 3) folders with semicolons 4) folders with spaces 5) double-semicolons I.e. blanks
    #  - Example path: 'C:\WINDOWS\;"C:\Path with semicolon; in the middle";"E:\Path with semicolon at the end;";;C:\Program Files;'
    #  - 2018/01/30 by Chad.Simmons@CatapultSystems.com - Created
    $PathArray = @()
    $env:Path.ToString().TrimEnd(';') -split '(?=["])' | ForEach-Object { #remove a trailing semicolon from the path then split it into an array using a double-quote as the delimiter keeping the delimiter
       If ($_ -eq '";') { # throw away a blank line
       } ElseIf ($_.ToString().StartsWith('";')) { # if line starts with "; remove the "; and any trailing backslash
          $PathArray += ($_.ToString().TrimStart('";')).TrimEnd('\')
       } ElseIf ($_.ToString().StartsWith('"')) {  # if line starts with " remove the " and any trailing backslash
          $PathArray += ($_.ToString().TrimStart('"')).TrimEnd('\') #$_ + '"'
       } Else {                                    # split by semicolon and remove any trailing backslash
          $_.ToString().Split(';') | ForEach-Object { If ($_.Length -gt 0) { $PathArray += $_.TrimEnd('\') } }
       }
    }
    Return $PathArray
 }

 $exists = $false

Get-ENVPathFolders | ForEach-Object { 
    If (Test-Path -Path $_\java.exe) {
         $exists = $true
    }
 }

 if(-not $exists) {
    throw "java.exe not found in path."
 }

 Invoke-WebRequest  https://www.antlr.org/download/antlr-4.7.2-complete.jar -OutFile .\antlr-complete-4.7.2.jar

 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=CSharp -Xexact-output-dir -o .\bin\CSharp -package Wesnoth.WML.Parser -Werror .\WMLLexer.g4
 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=CSharp -Xexact-output-dir -o .\bin\CSharp -package Wesnoth.WML.Parser -Werror .\WMLParser.g4

 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=JavaScript -Xexact-output-dir -o .\bin\JavaScript -package Wesnoth.WML.Parser -Werror .\WMLLexer.g4
 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=JavaScript -Xexact-output-dir -o .\bin\JavaScript -package Wesnoth.WML.Parser -Werror .\WMLParser.g4

 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Java -Xexact-output-dir -o .\bin\Java -package Wesnoth.WML.Parser -Werror .\WMLLexer.g4
 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Java -Xexact-output-dir -o .\bin\Java -package Wesnoth.WML.Parser -Werror .\WMLParser.g4

 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Python3 -Xexact-output-dir -o .\bin\Python3 -package Wesnoth.WML.Parser -Werror .\WMLLexer.g4
 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Python3 -Xexact-output-dir -o .\bin\Python3 -package Wesnoth.WML.Parser -Werror .\WMLParser.g4

 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Cpp -Xexact-output-dir -o .\bin\Cpp -package Wesnoth.WML.Parser -Werror .\WMLLexer.g4
 java.exe -jar .\antlr-complete-4.7.2.jar -Dlanguage=Cpp -Xexact-output-dir -o .\bin\Cpp -package Wesnoth.WML.Parser -Werror .\WMLParser.g4
