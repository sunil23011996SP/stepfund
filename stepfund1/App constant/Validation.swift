//
//  Validation.swift
import UIKit

struct Validation{
    
    // MARK: - Firstname
    func isValidateFirstName(fname: String) -> Bool {
        let firstNameRegex =  "^[a-zA-Z]*$"
        let strfirstName = NSPredicate(format: "SELF MATCHES %@", firstNameRegex)
        return strfirstName.evaluate(with: fname)
    }
    
    // MARK: - Password
    func isPasswordValidate(value: String) -> Bool {
       //Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{6,}$"
        let strPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return strPassword.evaluate(with: value)
    }

    func isPasswordLenght(password: String) -> Bool {
        if (password.count >= 6) {
            return true
        } else {
            return false
        }
    }
    
    func isCardNumberLength(cardNumber: String) -> Bool {
        return (cardNumber.count >= 17) ? true : false
    }
    
    func isCVVLength(cvv: String) -> Bool {
        return (cvv.count >= 19) ? true : false
    }
    
    // Check if extention is document type
    func isDocumentFound(ext: String) -> Bool {
        if ext == "pdf" || ext == "docx" || ext == "doc" || ext == "ppt" || ext == "pptx" || ext == "xls" || ext == "xlsx" || ext == "txt"  || ext == "rtf" || ext == "odt" {
            return true
        } else {
            return false
        }
    }
    
    //MARK:- Email Valdation Methods
    func isEmailValidate(testStr: String) -> Bool {
        if testStr.contains("..") || testStr.contains("@@")
            || testStr.hasPrefix(".") || testStr.hasSuffix(".con"){
            return false
        }
        let emailFormat = "[A-Z0-9a-z.!#$%&'*+-/=?^_`{|}~]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: testStr)
    }

    // MARK: - Username
    func isUserNameValidate(_ stringName:String) -> Bool {
        var sepcialChar = false
        var temp = false
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ")
        if stringName.rangeOfCharacter(from: characterset.inverted) != nil {
            sepcialChar = true
        }
        else {
            temp = true
        }
        let phone = stringName.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if phone != "" || sepcialChar == true {
            temp = false
            for chr in stringName{
                if ((chr >= "a" && chr <= "z") || (chr >= "A" && chr <= "Z") ) {
                    temp = true
                    break
                }
            }
        }
        if temp == true {
            return true
        }
        else {
            return false
        }
    }

    // MARK: - Phonenumber
    func isPhoneNumberValidate(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    // MARK: - Name
    func isNameValidate(_ stringName:String) -> Bool {
        let nameRegex = "^[A-Za-z]+([ ]?)+([a-zA-Z0-9'_.-@#]?)*${5,}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: stringName)
    }
    
    func isFullNameValidate(stringName:String) -> Bool {
        let nameRegex = "/^[a-z ,.'-]+$/i"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: stringName)
    }
}

