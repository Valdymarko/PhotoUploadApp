//
//  TimeFormat.swift
//  PhotoUploadApp
//
//  Created by Volodymyr Ilkiv on 10.08.2022.
//

import Foundation

enum TimeFormat: String {
    case weekFormat = "EEEE, dd MMMM"
    case photoFormat = "yyyy-MM-dd'T'HH:mm:ss"
    case dueDateFormat = "dd.MM.yyyy"
    case shortWithWhitespaces = "dd MMM yyyy"
    case powerOfAuthorityFormat = "MM/dd/yyyy"
    case prescriptionMonthFormat = "MM"
    case shortFormat = "yyyy-MM-dd"
    case periodDateFormat = "d MMM yyyy"
}
