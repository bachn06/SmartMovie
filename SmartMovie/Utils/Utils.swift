//
//  Utils.swift
//  SmartMovie
//
//  Created by BachNguyen on 04/04/2023.
//

import UIKit

func timeMovie(_ time: Int) -> String {
    var result = ""
    if time <= 0 {
        result = "No duration"
    } else {
        let hours = Int(time / 60)
        let minutes = time - (hours * 60)
        let minuteStr = String(format: "%02d", minutes)
        if hours > 0 {
            result = "\(hours)h \(minuteStr)mins"
        } else {
            result = "\(minutes)mins"
        }
    }
    return result
}

func setStar(_ voteAverage: Double, _ stackView: UIStackView) {
    let listRating = Int(voteAverage / 2)
    for index in 0..<5 {
        let imageView = stackView.arrangedSubviews[index] as? UIImageView
        if index < listRating {
            imageView?.image = UIImage(named: "star.fill")
        } else {
            imageView?.image = UIImage(named: "star")
        }
    }
}

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
func changeLanguage(_ language: String) -> String {
    switch language {
    case "en":
        return "English"
    case "vi":
        return "Vietnamese"
    case "ja":
        return "Japanese"
    case "ko":
        return "Korean"
    case "zh":
        return "Chinese"
    case "fr":
        return "French"
    case "de":
        return "German"
    case "es":
        return "Spanish"
    case "it":
        return "Italian"
    case "ru":
        return "Russian"
    case "th":
        return "Thai"
    case "hi":
        return "Hindi"
    case "ar":
        return "Arabic"
    case "pt":
        return "Portuguese"
    case "tr":
        return "Turkish"
    case "id":
        return "Indonesian"
    case "ms":
        return "Malay"
    case "pl":
        return "Polish"
    case "fa":
        return "Persian"
    case "he":
        return "Hebrew"
    case "uk":
        return "Ukrainian"
    case "ro":
        return "Romanian"
    case "da":
        return "Danish"
    case "sv":
        return "Swedish"
    case "hu":
        return "Hungarian"
    case "nl":
        return "Dutch"
    case "no":
        return "Norwegian"
    case "fi":
        return "Finnish"
    case "cs":
        return "Czech"
    case "el":
        return "Greek"
    case "sk":
        return "Slovak"
    case "bg":
        return "Bulgarian"
    case "sl":
        return "Slovenian"
    case "af":
        return "Afrikaans"
    case "az":
        return "Azerbaijani"
    case "be":
        return "Belarusian"
    case "ca":
        return "Catalan"
    case "hr":
        return "Croatian"
    case "cy":
        return "Welsh"
    case "fil":
        return "Filipino"
    case "ga":
        return "Irish"
    case "is":
        return "Icelandic"
    case "la":
        return "Latin"
    case "lv":
        return "Latvian"
    case "lt":
        return "Lithuanian"
    case "mt":
        return "Maltese"
    case "mn":
        return "Mongolian"
    case "ne":
        return "Nepali"
    case "ps":
        return "Pashto"
    case "sr":
        return "Serbian"
    case "si":
        return "Sinhala"
    case "so":
        return "Somali"
    case "sw":
        return "Swahili"
    case "tg":
        return "Tajik"
    case "ta":
        return "Tamil"
    case "te":
        return "Telugu"
    case "uz":
        return "Uzbek"
    case "xh":
        return "Xhosa"
    case "yi":
        return "Yiddish"
    case "yo":
        return "Yoruba"
    case "zu":
        return "Zulu"
    case "am":
        return "Amharic"
    case "bs":
        return "Bosnian"
    case "ceb":
        return "Cebuano"
    case "co":
        return "Corsican"
    case "gl":
        return "Galician"
    case "haw":
        return "Hawaiian"
    case "ht":
        return "Haitian Creole"
    case "ig":
        return "Igbo"
    case "ka":
        return "Georgian"
    case "ky":
        return "Kyrgyz"
    case "lo":
        return "Lao"
    case "lb":
        return "Luxembourgish"
    case "mi":
        return "Maori"
    case "mr":
        return "Marathi"
    case "my":
        return "Burmese"
    case "ny":
        return "Chichewa"
    case "pa":
        return "Punjabi"
    case "sm":
        return "Samoan"
    case "sn":
        return "Shona"
    case "sd":
        return "Sindhi"
    case "su":
        return "Sundanese"
    case "tt":
        return "Tatar"
    case "tk":
        return "Turkmen"
    case "ug":
        return "Uyghur"
    case "fy":
        return "Western Frisian"
    case "ur":
        return "Urdu"
    default:
        return "No languge found"
    }
}
// swiftlint:enable cyclomatic_complexity
// swiftlint:enable function_body_length
