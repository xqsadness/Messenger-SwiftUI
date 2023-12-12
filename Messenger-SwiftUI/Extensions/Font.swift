
import SwiftUI

extension Font{
    static var custom = "Inter"
    public static func heavy(size: CGFloat) -> Font{
        //let font = custom(custom+"-Bold", size: size)
        return .system(size: size, weight: .heavy)
    }
    public static func bold(size: CGFloat) -> Font{
        //let font = custom(custom+"-Bold", size: size)
        return .custom(custom+"-Bold", size: size)
    }
    public static func semibold(size: CGFloat) -> Font{
        //let font = custom(custom+"-Bold", size: size)
        return .custom(custom+"-SemiBold", size: size)
    }
    public static func medium(size: CGFloat) -> Font{
        //custom(custom+"-Medium", size: size)
        return .custom(custom+"-Medium", size: size)
    }
    public static func light(size: CGFloat) -> Font{
        return .custom(custom+"-Light", size: size)
    }
    public static func regular(size: CGFloat) -> Font{
        return .custom(custom+"-Regular", size: size)
    }
    public static func thin(size: CGFloat) -> Font{
        return .custom(custom+"-Regular", size: size)
    }
}

extension UIFont{
    static var customFont = "SFProDisplay"
    public static func bold(size: CGFloat)->UIFont{
        return UIFont.init(name: customFont + "-Bold", size: size) ?? .systemFont(ofSize: size)
    }
}
