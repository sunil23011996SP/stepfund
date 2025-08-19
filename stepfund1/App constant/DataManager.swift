//
//  DataManager.swift
//  Pharma247Store
//
//  Created by Sagar Chauhan on 07/10/19.
//  Copyright © 2019 TRooTech. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    
    //------------------------------------------------------------------------------
    // MARK:-
    // MARK:- Variables
    //------------------------------------------------------------------------------
    
    static let shared   = DataManager()
    let baseUrl         = WebServiceURL.live

    
    // MARK:- Custom Methods
    //------------------------------------------------------------------------------
    
    // Get API url with endpoints
    func getURL(_ endpoint: WSEndPoints) -> String {
        return baseUrl + endpoint.rawValue
    }
}


//------------------------------------------------------------------------------
// MARK:-
// MARK:- WebserviceURL
//------------------------------------------------------------------------------

struct WebServiceURL {
    static let live  = "http://44.204.4.225:8088/api/v1/"
}

//------------------------------------------------------------------------------
// MARK:-
// MARK:- WebserviceEndPoints
//------------------------------------------------------------------------------

enum WSEndPoints: String {
    case getAdminBank                              = "user/get_admin_bank"
    case getDecryption                           = "general/get_decryption"
    case getEncryption                      = "general/get_encryption"
    case addSubscription                     = "subscription/add_subscription"
    
    case getSubscription                     = "subscription/get_subscription"
    
    case getUser                     = "user/get_user"
    case getFAQ                     = "general/get_faq"
    case changePassword                     = "user/change_password"
    case addUpdateBank                     = "user/add_update_bank"
    case contactUs                     = "general/contact_us"
    case editProfile                     = "user/edit_profile"
    case DOKYC                     = "user/do_kyc"
    case TotalStepEarn                     = "user/total_step_n_earn"
    case GetKeysList                     = "general/get_keys_list"
    case login                     = "user/login"
    case forgotPassword                     = "user/forgot_password"
    case sendEmail                     = "general/send_email"
    case signup                     = "user/signup"
    case resetPassword                     = "user/reset_password"
    case checkDuplication                     = "user/check_duplication"

    case logout                     = "user/logout"
    case deleteAccount                     = "user/delete_account"

}

//------------------------------------------------------------------------------
// MARK:-
// MARK:- enum - Result
//------------------------------------------------------------------------------

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}


//------------------------------------------------------------------------------
// MARK:-
// MARK:- enum - APIError
//------------------------------------------------------------------------------

enum APIError: Error {
    case errorMessage(String)
    case requestFailed(String)
    case jsonConversionFailure(String)
    case invalidData(String)
    case responseUnsuccessful(String)
    case jsonParsingFailure(String)
    
    var localizedDescription: String {
        
        switch self {
            
        case.errorMessage(let msg):
            return msg
            
        case .requestFailed(let msg):
            return msg
            
        case .jsonConversionFailure(let msg):
            return msg
            
        case .invalidData(let msg):
            return msg
            
        case .responseUnsuccessful(let msg):
            return msg
            
        case .jsonParsingFailure(let msg):
            return msg
        }
    }
}

internal let DEFAULT_MIME_TYPE = "application/octet-stream"

internal let mimeTypes = [
    "html": "text/html",
    "htm": "text/html",
    "shtml": "text/html",
    "css": "text/css",
    "xml": "text/xml",
    "gif": "image/gif",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "js": "application/javascript",
    "atom": "application/atom+xml",
    "rss": "application/rss+xml",
    "mml": "text/mathml",
    "txt": "text/plain",
    "jad": "text/vnd.sun.j2me.app-descriptor",
    "wml": "text/vnd.wap.wml",
    "htc": "text/x-component",
    "png": "image/png",
    "tif": "image/tiff",
    "tiff": "image/tiff",
    "wbmp": "image/vnd.wap.wbmp",
    "ico": "image/x-icon",
    "jng": "image/x-jng",
    "bmp": "image/x-ms-bmp",
    "svg": "image/svg+xml",
    "svgz": "image/svg+xml",
    "webp": "image/webp",
    "woff": "application/font-woff",
    "jar": "application/java-archive",
    "war": "application/java-archive",
    "ear": "application/java-archive",
    "json": "application/json",
    "hqx": "application/mac-binhex40",
    "doc": "application/msword",
    "pdf": "application/pdf",
    "ps": "application/postscript",
    "eps": "application/postscript",
    "ai": "application/postscript",
    "rtf": "application/rtf",
    "m3u8": "application/vnd.apple.mpegurl",
    "xls": "application/vnd.ms-excel",
    "eot": "application/vnd.ms-fontobject",
    "ppt": "application/vnd.ms-powerpoint",
    "wmlc": "application/vnd.wap.wmlc",
    "kml": "application/vnd.google-earth.kml+xml",
    "kmz": "application/vnd.google-earth.kmz",
    "7z": "application/x-7z-compressed",
    "cco": "application/x-cocoa",
    "jardiff": "application/x-java-archive-diff",
    "jnlp": "application/x-java-jnlp-file",
    "run": "application/x-makeself",
    "pl": "application/x-perl",
    "pm": "application/x-perl",
    "prc": "application/x-pilot",
    "pdb": "application/x-pilot",
    "rar": "application/x-rar-compressed",
    "rpm": "application/x-redhat-package-manager",
    "sea": "application/x-sea",
    "swf": "application/x-shockwave-flash",
    "sit": "application/x-stuffit",
    "tcl": "application/x-tcl",
    "tk": "application/x-tcl",
    "der": "application/x-x509-ca-cert",
    "pem": "application/x-x509-ca-cert",
    "crt": "application/x-x509-ca-cert",
    "xpi": "application/x-xpinstall",
    "xhtml": "application/xhtml+xml",
    "xspf": "application/xspf+xml",
    "zip": "application/zip",
    "bin": "application/octet-stream",
    "exe": "application/octet-stream",
    "dll": "application/octet-stream",
    "deb": "application/octet-stream",
    "dmg": "application/octet-stream",
    "iso": "application/octet-stream",
    "img": "application/octet-stream",
    "msi": "application/octet-stream",
    "msp": "application/octet-stream",
    "msm": "application/octet-stream",
    "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "mid": "audio/midi",
    "midi": "audio/midi",
    "kar": "audio/midi",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
    "m4a": "audio/x-m4a",
    "ra": "audio/x-realaudio",
    "3gpp": "video/3gpp",
    "3gp": "video/3gpp",
    "ts": "video/mp2t",
    "mp4": "video/mp4",
    "mpeg": "video/mpeg",
    "mpg": "video/mpeg",
    "mov": "video/quicktime",
    "webm": "video/webm",
    "flv": "video/x-flv",
    "m4v": "video/x-m4v",
    "mng": "video/x-mng",
    "asx": "video/x-ms-asf",
    "asf": "video/x-ms-asf",
    "wmv": "video/x-ms-wmv",
    "avi": "video/x-msvideo"
]

internal func MimeType(ext: String?) -> String {
    if ext != nil, mimeTypes.contains(where: { $0.value.lowercased() == ext!.lowercased() }) {
        return mimeTypes[ext!.lowercased()]!
    }
    return DEFAULT_MIME_TYPE
}

extension NSURL {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}


extension NSString {
    public func mimeType() -> String {
        return MimeType(ext: self.pathExtension)
    }
}


