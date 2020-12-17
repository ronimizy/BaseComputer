//
//  Html.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

class HTML
{
    static func header(_ title: String = "Title") -> String {
        return "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n\t<meta charset = \"UTF-8\">\n\t<title>\(title)</title>\n</head>\n<body>\r"
    }
    
    static func tableOpen() -> String {
        return "<table align = \"center\" border = \"1\" cellpadding = \"0\" cellspacing = \"0\" width = \"100%\">\n"
    }
    
    static func tableHeader(_ titles: [String]) -> String {
        var result: String = "\t\t<tr>\r"
        
        for title in titles {
            result += "\t\t\t<th>\(title)</th>\r"
        }
        
        result += "\t\t</tr>\r"
        
        return result
    }
    
    static func tableRow(_ content: [String]) -> String {
        var result: String = "\t\t<tr>\n\t\t"
        
        for i in content {
            result += "<td>\(i)</td>"
        }
        
        result += "</tr>\r"
        
        return result
    }
}
