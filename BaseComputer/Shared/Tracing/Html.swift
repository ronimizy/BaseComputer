//
//  Html.swift
//  BaseComputer
//
//  Created by Георгий Круглов on 29.11.2020.
//

import SwiftUI

class Html {
    static func header(_ title: String = "Title") -> String {
        var header = ""

        header += "<!DOCTYPE html>\n"
        header += "<html lang=\"en\">\n"

        header += "<head>\n"


        header += "\t<meta charset = \"UTF-8\">\n"
        header += "\t<title>\(title)</title>\n"

        header += "\t<style>\n"

        header += "\t\ttable { \n\t\t\tborder-collapse: collapse; \n\t\t}"

        header += "\t</style>\n"


        header += "</head>"
        header += "\n<body>\r"

        return header
    }

    static func tableOpen(align: String = "center", color: String = "#d6d6d6", border: Int = 0, padding: Int = 2, spacing: Int = 0, width: Int = 100) -> String {
        "<table align = \"\(align)\" bgcolor=\"\(color)\" border = \"\(border)\" cellpadding = \"\(padding)\" cellspacing = \"\(spacing)\" width = \"\(width)%\">\n"
    }

    static func tableHeader(_ titles: [String], attributes: String = "") -> String {
        var result: String = "\t\t<tr \(attributes) >\r"

        for title in titles {
            result += "\t\t\t<th>\(title)</th>\r"
        }

        result += "\t\t</tr>\r"

        return result
    }

    static func tableRow(_ content: [String], attributes: String = "") -> String {
        var result: String = "\t\t<tr \(attributes) >\n\t\t"

        for i in content {
            result += "<td>\(i)</td>"
        }

        result += "</tr>\r"

        return result
    }
}
