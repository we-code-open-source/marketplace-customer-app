import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static m0(foodname) => "تمت إزالة ${foodname} من سلة التسوق";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "about": MessageLookupByLibrary.simpleMessage("نبذة"),
        "default_": MessageLookupByLibrary.simpleMessage("افتراضي"),
        "tapAgainToLeave":
            MessageLookupByLibrary.simpleMessage("اضغط مرتين للخروج"),
        "add": MessageLookupByLibrary.simpleMessage("اضافة"),
        "add_delivery_address":
            MessageLookupByLibrary.simpleMessage("اضافة عنوان للتوصيل"),
        "oneOrMoreFoodsInYourCartNotDeliverable":
            MessageLookupByLibrary.simpleMessage(
                "واحد أو أكثر من الأطعمة في عربة التسوق الخاصة بك غير قابلة للتسليم."),
        "deliverable": MessageLookupByLibrary.simpleMessage("متاح للتوصيل"),
        "code_not_send": MessageLookupByLibrary.simpleMessage(
            "هنالك مشكلة في ارسال الرسالة حاول في وقت لاحق"),
        "not_deliverable":
            MessageLookupByLibrary.simpleMessage("غير متاح للتوصيل"),
        "add_to_cart": MessageLookupByLibrary.simpleMessage("أضف إلى سلة "),
        "address": MessageLookupByLibrary.simpleMessage(" اسم العنوان"),
        "addresses": MessageLookupByLibrary.simpleMessage("العناوين"),
        "filter": MessageLookupByLibrary.simpleMessage("فلتر"),
        "all": MessageLookupByLibrary.simpleMessage("الكل"),
        "all_menu": MessageLookupByLibrary.simpleMessage("القائمة"),
        "detect_location": MessageLookupByLibrary.simpleMessage("تحديد الموقع"),
        "address_ex": MessageLookupByLibrary.simpleMessage("مثال : منزل 1"),
        "add_New_address": MessageLookupByLibrary.simpleMessage("اضافة عنوان"),
        "addresses_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث العناوين بنجاح"),
        "app_language": MessageLookupByLibrary.simpleMessage("لغة التطبيق"),
        "app_settings": MessageLookupByLibrary.simpleMessage("إعدادات التطبيق"),
        "application_preferences":
            MessageLookupByLibrary.simpleMessage("تفضيلات التطبيق"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "delivery_price": MessageLookupByLibrary.simpleMessage("سعر التوصيل"),
        "cancelOrder": MessageLookupByLibrary.simpleMessage("الغاء الطلب"),
        "canceled": MessageLookupByLibrary.simpleMessage("ملغي"),
        "cart": MessageLookupByLibrary.simpleMessage("سلة التسوق"),
        "clear": MessageLookupByLibrary.simpleMessage("مسح"),
        "areYouSureYouWantToCancelThisOrder":
            MessageLookupByLibrary.simpleMessage(
                "هل أنت متأكد أنك تريد إلغاء هذا الطلب؟"),
        "km": MessageLookupByLibrary.simpleMessage("كم"),
        "minute": MessageLookupByLibrary.simpleMessage("دقيقة"),
        "click_to_confirm_your_address_and_pay_or_long_press":
            MessageLookupByLibrary.simpleMessage("انقر لتأكيد عنوانك "),
        "youDontHaveAnyOrder":
            MessageLookupByLibrary.simpleMessage("لايوجد لديك اي طلبات"),
        "near_to": MessageLookupByLibrary.simpleMessage("قريب من"),
        "near_to_your_current_location":
            MessageLookupByLibrary.simpleMessage("بالقرب من موقعك الحالي"),
        "clickOnTheFoodToGetMoreDetailsAboutIt":
            MessageLookupByLibrary.simpleMessage(
                "انقر فوق الطعام للحصول على مزيد من التفاصيل حوله"),
        "delivery_or_pickup":
            MessageLookupByLibrary.simpleMessage("توصيل او استلام"),
        "opened_restaurants":
            MessageLookupByLibrary.simpleMessage("المطاعم المفتوحة"),
        "carts_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث العربة بنجاح"),
        "cash_on_delivery":
            MessageLookupByLibrary.simpleMessage("الدفع عند الاستلام"),
        "category": MessageLookupByLibrary.simpleMessage("الفئة"),
        "category_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث الفئة بنجاح"),
        "checkout": MessageLookupByLibrary.simpleMessage("الدفع"),
        "clickToPayWithRazorpayMethod": MessageLookupByLibrary.simpleMessage(
            "Click to pay with RazorPay method"),
        "click_on_the_stars_below_to_leave_comments":
            MessageLookupByLibrary.simpleMessage(
                "انقر على النجوم أدناه لترك التعليقات"),
        "close": MessageLookupByLibrary.simpleMessage("اغلاق"),
        "open": MessageLookupByLibrary.simpleMessage("مفتوح"),
        "apply_filters": MessageLookupByLibrary.simpleMessage("بحث"),
        "filter": MessageLookupByLibrary.simpleMessage("فلتر"),
        "details": MessageLookupByLibrary.simpleMessage("تفاصيل"),
        "view": MessageLookupByLibrary.simpleMessage("عرض"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("عرض التفاصيل"),
        "forMoreDetailsPleaseChatWithOurManagers":
            MessageLookupByLibrary.simpleMessage(
                "لمزيد من التفاصيل ، يرجى الدردشة معنا "),
        "orderDetails": MessageLookupByLibrary.simpleMessage("تفاصيل طلب"),
        "order": MessageLookupByLibrary.simpleMessage("الطلبية"),
        "items": MessageLookupByLibrary.simpleMessage("قطع"),
        "you_can_contact":
            MessageLookupByLibrary.simpleMessage("يمكنك التواصل مع "),
        "last_seen": MessageLookupByLibrary.simpleMessage("أخر ظهور"),
        "closed": MessageLookupByLibrary.simpleMessage("مغلق"),
        "completeYourProfileDetailsToContinue":
            MessageLookupByLibrary.simpleMessage(
                "أكمل تفاصيل ملفك الشخصي للمتابعة"),
        "confirm_payment": MessageLookupByLibrary.simpleMessage("تأكيد الدفع"),
        "re_order": MessageLookupByLibrary.simpleMessage("إعادة طلب"),
        "confirmation": MessageLookupByLibrary.simpleMessage("التأكيد"),
        "cuisines": MessageLookupByLibrary.simpleMessage("المطابخ"),
        "dark_mode": MessageLookupByLibrary.simpleMessage("الوضع الداكن"),
        "default_credit_card":
            MessageLookupByLibrary.simpleMessage("بطاقة الائتمان الافتراضية"),
        "delivery_addresses":
            MessageLookupByLibrary.simpleMessage("عناوين التوصيل"),
        "delivery_address":
            MessageLookupByLibrary.simpleMessage("عنوان التوصيل"),
        "delivery_fee": MessageLookupByLibrary.simpleMessage("رسوم التوصيل"),
        "description": MessageLookupByLibrary.simpleMessage("الوصف"),
        "click_to_pay_cash_on_delivery": MessageLookupByLibrary.simpleMessage(
            "انقر للدفع نقدًا عند التسليم"),
        "delivery": MessageLookupByLibrary.simpleMessage("توصيل"),
        "yes": MessageLookupByLibrary.simpleMessage("نعم"),
        "deliveryMethodNotAllowed": MessageLookupByLibrary.simpleMessage(
            "طريقة التوصيل غير مسموح بها!"),
        "deliveryAddressOutsideTheDeliveryRangeOfThisRestaurants":
            MessageLookupByLibrary.simpleMessage(
                "عنوان التسليم خارج نطاق التسليم لهذه المطاعم."),
        "thisRestaurantNotSupportDeliveryMethod":
            MessageLookupByLibrary.simpleMessage(
                "هذا المطعم لا يدعم طريقة التوصيل."),
        "thisFoodWasAddedToFavorite": MessageLookupByLibrary.simpleMessage(
            "تمت إضافة هذا الطعام إلى المفضلة"),
        "thisFoodWasRemovedFromFavorites": MessageLookupByLibrary.simpleMessage(
            "تمت إزالة هذا الطعام من المفضلة"),
        "this_food_was_added_to_cart": MessageLookupByLibrary.simpleMessage(
            "تمت إضافة هذا الطعام إلى عربة التسوق"),
        "tell_us_about_this_food":
            MessageLookupByLibrary.simpleMessage("أخبرنا عن هذه الوجبة"),
        "Please_choose_meals_from_the_same_restaurant":
            MessageLookupByLibrary.simpleMessage(
                "الرجاء اختيار الوجبات من نفس المطعم"),
        "how_would_you_rate_this_restaurant_":
            MessageLookupByLibrary.simpleMessage("كيف تقيم هذا المطعم ؟"),
        "how_would_you_rate_this_driver":
            MessageLookupByLibrary.simpleMessage("كيف تقيم هذا السائق ؟"),
        "tell_us_about_this_drive":
            MessageLookupByLibrary.simpleMessage("أخبرنا عن هذا السائق"),
        "tell_us_about_this_restaurant":
            MessageLookupByLibrary.simpleMessage("أخبرنا عن هذا المطعم"),
        "dont_have_any_item_in_your_fav":
            MessageLookupByLibrary.simpleMessage("قائمة الطعام المفضلة فارغة"),
        "ok": MessageLookupByLibrary.simpleMessage("حسنا"),
        "warning": MessageLookupByLibrary.simpleMessage("تنبيه"),
        "driver": MessageLookupByLibrary.simpleMessage("السائق"),
        "driver_not_available": MessageLookupByLibrary.simpleMessage(
            "بيانات السائق غير متوفرة حاليا!"),
        "discover__explorer": MessageLookupByLibrary.simpleMessage("استكشاف"),
        "dont_have_any_item_in_the_notification_list":
            MessageLookupByLibrary.simpleMessage("قائمة الاشعارات فارغة"),
        "dont_have_any_item_in_your_cart":
            MessageLookupByLibrary.simpleMessage("سلة التسوق فارغة"),
        "double_click_on_the_food_to_add_it_to_the":
            MessageLookupByLibrary.simpleMessage(
                "انقر مرتين على المنتج لإضافته إلى سلة التسوق"),
        "edit": MessageLookupByLibrary.simpleMessage("تعديل"),
        "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "email_address":
            MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "phone_to_reset_password":
            MessageLookupByLibrary.simpleMessage("استعادة كلمة المرور"),
        "english": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
        "phone_number_not_found":
            MessageLookupByLibrary.simpleMessage("رقم الهاتف غير مسجل لدينا"),
        "this_phone_account_exists":
            MessageLookupByLibrary.simpleMessage("رقم الهاتف مسجل لدينا"),
        "verification": MessageLookupByLibrary.simpleMessage("تحقق"),
        "send": MessageLookupByLibrary.simpleMessage("ارسال"),
        "extras": MessageLookupByLibrary.simpleMessage("إضافات"),
        "faq": MessageLookupByLibrary.simpleMessage("الاسئلة الشائعة"),
        "faqsRefreshedSuccessfuly": MessageLookupByLibrary.simpleMessage(
            "تم تحديث الأسئلة الشائعة بنجاح"),
        "favorite_foods":
            MessageLookupByLibrary.simpleMessage("المنتجات المفضلة"),
        "favorites": MessageLookupByLibrary.simpleMessage("المفضلة"),
        "favorites_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث المفضلة بنجاح"),
        "featured_foods":
            MessageLookupByLibrary.simpleMessage("المنتجات المميزة"),
        "foodRefreshedSuccessfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث الطعام بنجاح"),
        "food_categories": MessageLookupByLibrary.simpleMessage("الفئات"),
        "forMoreDetailsPleaseChatWithOurManagers":
            MessageLookupByLibrary.simpleMessage(
                "لمزيد من التفاصيل ، يرجى الدردشة مع مديرينا"),
        "full_address": MessageLookupByLibrary.simpleMessage("العنوان بالكامل"),
        "full_name": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
        "g": MessageLookupByLibrary.simpleMessage("جم"),
        "delivery_address_removed_successfully":
            MessageLookupByLibrary.simpleMessage("تم حذف العنوان بنجاح"),
        "guest": MessageLookupByLibrary.simpleMessage("زائر"),
        "haveCouponCode":
            MessageLookupByLibrary.simpleMessage("هل لديك كوبون تخفيض؟"),
        "help__support": MessageLookupByLibrary.simpleMessage("المساعدة"),
        "help_support": MessageLookupByLibrary.simpleMessage("المساعدة"),
        "help_supports": MessageLookupByLibrary.simpleMessage("المساعدة"),
        "hint_full_address": MessageLookupByLibrary.simpleMessage(
            "المدينة المنورة ، حي الازهري ، الشارع العام ، خلف مكتبة الحرمين"),
        "home": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "home_address": MessageLookupByLibrary.simpleMessage("المنزل"),
        "how_would_you_rate_this_restaurant":
            MessageLookupByLibrary.simpleMessage("كيف تقيم هذا المطعم ؟"),
        "i_dont_have_an_account":
            MessageLookupByLibrary.simpleMessage("ليس لدي حساب"),
        "i_forgot_password":
            MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
        "i_have_account_back_to_login": MessageLookupByLibrary.simpleMessage(
            "لدي حساب، العودة لتسجيل الدخول"),
        "i_remember_my_password_return_to_login":
            MessageLookupByLibrary.simpleMessage(
                "تذكرت كلمة المرور، ارجع لشاشة الدخول"),
        "information": MessageLookupByLibrary.simpleMessage("معلومات"),
        "ingredients": MessageLookupByLibrary.simpleMessage("المكونات"),
        "invalidCouponCode":
            MessageLookupByLibrary.simpleMessage("كوبون غير صالح"),
        "john_doe": MessageLookupByLibrary.simpleMessage("فلان الفلاني"),
        "keep_your_old_meals_of_this_restaurant":
            MessageLookupByLibrary.simpleMessage(
                "لا تفرغ السلة واحتفظ باختياراتي السابقة"),
        "keep_your_old_meals_of_this_store":
            MessageLookupByLibrary.simpleMessage(
                "لا تفرغ السلة واحتفظ باختياراتي السابقة"),
        "languages": MessageLookupByLibrary.simpleMessage("اللغات"),
        "coupon": MessageLookupByLibrary.simpleMessage("قيمة الكوبون"),
        "re_send": MessageLookupByLibrary.simpleMessage("إعادة ارسال"),
        "lets_start_with_login":
            MessageLookupByLibrary.simpleMessage("لنبدأ بتسجيل الدخول!"),
        "lets_start_with_register":
            MessageLookupByLibrary.simpleMessage("لنبدأ بالتسجيل!"),
        "light_mode": MessageLookupByLibrary.simpleMessage("الوضع الفاتح"),
        "log_out": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
        "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "long_press_to_edit_item_swipe_item_to_delete_it":
            MessageLookupByLibrary.simpleMessage(
                "اضغط مطولا لتحرير العنصر، اسحب الى الجنب لحذفه"),
        "longpress_on_the_food_to_add_suplements":
            MessageLookupByLibrary.simpleMessage(" إضغط على المنتج لإضافة"),
        "makeItDefault": MessageLookupByLibrary.simpleMessage("افتراضي"),
        "maps_explorer": MessageLookupByLibrary.simpleMessage("مستكشف الخرائط"),
        "menu": MessageLookupByLibrary.simpleMessage("القائمة"),
        "featured_Restaurants":
            MessageLookupByLibrary.simpleMessage("المطاعم المميزة"),
        "featured_Stores":
            MessageLookupByLibrary.simpleMessage("المتاجر المميزة"),
        "nearby_restaurants":
            MessageLookupByLibrary.simpleMessage("المطاعم القريبة"),
        "nearby_stores":
            MessageLookupByLibrary.simpleMessage("المتاجر القريبة"),
        "messages": MessageLookupByLibrary.simpleMessage("الرسائل"),
        "most_popular": MessageLookupByLibrary.simpleMessage("الأكثر شعبية"),
        "multirestaurants": MessageLookupByLibrary.simpleMessage("عدة مطابخ"),
        "my_orders": MessageLookupByLibrary.simpleMessage("طلباتي"),
        "newMessageFrom":
            MessageLookupByLibrary.simpleMessage("رسالة جديدة من"),
        "new_address_added_successfully": MessageLookupByLibrary.simpleMessage(
            "تمت اضافة العنوان الجديد بنجاح"),
        "new_order_from_client":
            MessageLookupByLibrary.simpleMessage("طلب جديد من زبون"),
        "notValidAddress":
            MessageLookupByLibrary.simpleMessage("عنوان غير صالح"),
        "not_a_valid_address":
            MessageLookupByLibrary.simpleMessage("العنوان غير صالح"),
        "not_a_valid_biography":
            MessageLookupByLibrary.simpleMessage("نبذة غير صالحة"),
        "not_a_valid_cvc":
            MessageLookupByLibrary.simpleMessage("سيرة ذاتية غير صالحة"),
        "not_a_valid_date":
            MessageLookupByLibrary.simpleMessage("تاريخ غير صالح"),
        "not_a_valid_email":
            MessageLookupByLibrary.simpleMessage("بريد الكتروني غير صالح"),
        "not_a_valid_full_name":
            MessageLookupByLibrary.simpleMessage("اسم غير صالح"),
        "not_a_valid_number":
            MessageLookupByLibrary.simpleMessage("رقم غير صحيح"),
        "not_a_valid_phone":
            MessageLookupByLibrary.simpleMessage("رقم الجوال غير صالح"),
        "restaurants_results":
            MessageLookupByLibrary.simpleMessage("نتائج المطاعم"),
        "foods_results": MessageLookupByLibrary.simpleMessage("نتائج الوجبات"),
        "processing_time":
            MessageLookupByLibrary.simpleMessage("الوقت المتوقع لتجهيز طلبك :"),
        "notificationWasRemoved":
            MessageLookupByLibrary.simpleMessage("تم حذف التنبية"),
        "notifications": MessageLookupByLibrary.simpleMessage("الاشعارات"),
        "notifications_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث الإشعارات بنجاح"),
        "nutrition": MessageLookupByLibrary.simpleMessage("العناصر الغذائية"),
        "or_checkout_with": MessageLookupByLibrary.simpleMessage("او ادفع مع"),
        "order_id": MessageLookupByLibrary.simpleMessage("رمز الطلب"),
        "order_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث الطلب بنجاح"),
        "order_status_changed":
            MessageLookupByLibrary.simpleMessage("تم تغير حالة طلب"),
        "ordered_by_nearby_first":
            MessageLookupByLibrary.simpleMessage("مرتبة حسب الاقرب"),
        "orders_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث الطلبات بنجاح"),
        "password": MessageLookupByLibrary.simpleMessage("كلمه المرور"),
        "payment_mode": MessageLookupByLibrary.simpleMessage("طريقة الدفع"),
        "payment_options": MessageLookupByLibrary.simpleMessage("خيارات الدفع"),
        "payment_settings":
            MessageLookupByLibrary.simpleMessage("إعدادات الدفع"),
        "payment_settings_updated_successfully":
            MessageLookupByLibrary.simpleMessage(
                "تم تحديث إعدادات الدفع بنجاح"),
        "payments_settings":
            MessageLookupByLibrary.simpleMessage("إعدادات الدفع"),
        "paypal_payment":
            MessageLookupByLibrary.simpleMessage("الدفع بواسطة Paypal"),
        "phone": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
        "phone_ex": MessageLookupByLibrary.simpleMessage("09XXXXXXXX"),
        "profile": MessageLookupByLibrary.simpleMessage("الملف الشخصي"),
        "profile_settings":
            MessageLookupByLibrary.simpleMessage("إعدادات الملف الشخصي"),
        "profile_settings_updated_successfully":
            MessageLookupByLibrary.simpleMessage(
                "تم تحديث إعدادات الملف الشخصي بنجاح"),
        "quantity": MessageLookupByLibrary.simpleMessage("الكمية"),
        "razorpay": MessageLookupByLibrary.simpleMessage("RazorPay"),
        "razorpayPayment":
            MessageLookupByLibrary.simpleMessage("RazorPay Payment"),
        "recent_orders":
            MessageLookupByLibrary.simpleMessage("الطلبات الأخيرة"),
        "recent_reviews":
            MessageLookupByLibrary.simpleMessage("التعليقات الأخيرة"),
        "recents_search":
            MessageLookupByLibrary.simpleMessage("عمليات البحث الأخيرة"),
        "register": MessageLookupByLibrary.simpleMessage("تسجيل"),
        "reset": MessageLookupByLibrary.simpleMessage("إعادة تعيين"),
        "reset_cart":
            MessageLookupByLibrary.simpleMessage("إعادة تعيين سلة التسوق"),
        "reset_your_cart_and_order_meals_form_this_restaurant":
            MessageLookupByLibrary.simpleMessage(
                "افرغ سلة التسوق واضف اختياراتي من هذا المطعم"),
        "reset_your_cart_and_order_meals_form_this_store":
            MessageLookupByLibrary.simpleMessage(
                "افرغ سلة التسوق واضف اختياراتي من هذا المتجر"),
        "restaurant_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث المطبخ بنجاح"),
        "reviews": MessageLookupByLibrary.simpleMessage("التعليقات"),
        "reviews_refreshed_successfully":
            MessageLookupByLibrary.simpleMessage("تم تحديث المراجعات بنجاح!"),
        "save": MessageLookupByLibrary.simpleMessage("حفظ"),
        "search": MessageLookupByLibrary.simpleMessage("بحث"),
        "search_for_restaurants_or_foods":
            MessageLookupByLibrary.simpleMessage("البحث "),
        "search_for_stores_or_foods":
            MessageLookupByLibrary.simpleMessage("البحث "),
        "select_extras_to_add_them_on_the_food":
            MessageLookupByLibrary.simpleMessage("اختر الاضافات"),
        "select_your_preferred_languages":
            MessageLookupByLibrary.simpleMessage("اختر لغتك المفضلة"),
        "select_your_preferred_payment_mode":
            MessageLookupByLibrary.simpleMessage("اختر طريقة الدفع المفضلة"),
        "send_password_reset_link": MessageLookupByLibrary.simpleMessage(
            "ارسل رمز استعادة كلمة المرور"),
        "verification_code": MessageLookupByLibrary.simpleMessage("رمز التحقق"),
        "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "reset_new_password":
            MessageLookupByLibrary.simpleMessage("كلمة السر الجديدة"),
        "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "please_enter_new_password":
            MessageLookupByLibrary.simpleMessage("رجاء ادخل كلمة السر الجديدة"),
        "please_enter_phone_number":
            MessageLookupByLibrary.simpleMessage("رجاء ادخل رقم الهاتف"),
        "no_address": MessageLookupByLibrary.simpleMessage("لايوجد عنوان"),
        "To_add_a_new_address": MessageLookupByLibrary.simpleMessage(
            "لاضافة عنوان جديد اضغط علي علامة +"),
        "shopping_cart": MessageLookupByLibrary.simpleMessage("سلة التسوق"),
        "should_be_a_valid_email": MessageLookupByLibrary.simpleMessage(
            "يجب أن يكون بريد إلكتروني صالح"),
        "should_be_more_than_3_characters":
            MessageLookupByLibrary.simpleMessage("يجب أن يكون أكثر من 3 أحرف"),
        "should_be_more_than_3_letters":
            MessageLookupByLibrary.simpleMessage("يجب أن يكون أكثر من 3 أحرف"),
        "should_be_more_than_10_letters": MessageLookupByLibrary.simpleMessage(
            "يجب أن يتكون رقم الهاتف من 10 ارقام"),
        "should_be_more_than_6_letters":
            MessageLookupByLibrary.simpleMessage("يجب أن يكون أكثر من 6 أحرف"),
        "signinToChatWithOurManagers": MessageLookupByLibrary.simpleMessage(
            "سجل دخولك لكي تتمكن من ارسال رسائل"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطى"),
        "start_exploring": MessageLookupByLibrary.simpleMessage("استكشف الآن"),
        "submit": MessageLookupByLibrary.simpleMessage("ارسال"),
        "subtotal": MessageLookupByLibrary.simpleMessage("تكلفة الطلبية"),
        "swipeLeftTheNotificationToDeleteOrReadUnreadIt":
            MessageLookupByLibrary.simpleMessage(
                "اسحب إلى اليسار الإشعار لحذفه أو قراءته / إلغاء قراءته"),
        "tax": MessageLookupByLibrary.simpleMessage("ضريبة"),
        "tell_us_about_this_food":
            MessageLookupByLibrary.simpleMessage("أخبرنا عن هذه الوجبة"),
        "the_address_updated_successfully":
            MessageLookupByLibrary.simpleMessage("تم تحديث العنوان بنجاح"),
        "the_food_has_been_rated_successfully":
            MessageLookupByLibrary.simpleMessage("تم تقيم الوجبة بنجاح"),
        "the_driver_has_been_rated_successfully":
            MessageLookupByLibrary.simpleMessage("تم تقيم السائق بنجاح"),
        "the_food_was_removed_from_your_cart": m0,
        "the_restaurant_has_been_rated_successfully":
            MessageLookupByLibrary.simpleMessage("تم تقيم المطعم بنجاح"),
        "thisFoodWasAddedToFavorite": MessageLookupByLibrary.simpleMessage(
            "تمت إضافة هذا الطعام إلى المفضلة"),
        "thisFoodWasRemovedFromFavorites": MessageLookupByLibrary.simpleMessage(
            "تمت إزالة هذا الطعام من المفضلة"),
        "thisNotificationHasMarkedAsRead": MessageLookupByLibrary.simpleMessage(
            "تم وضع علامة مقروءة على هذا الإخطار"),
        "thisNotificationHasMarkedAsUnread":
            MessageLookupByLibrary.simpleMessage(
                "تم تعليم هذا الإخطار على أنه غير مقروء"),
        "top_restaurants": MessageLookupByLibrary.simpleMessage("أفضل المطاعم"),
        "total": MessageLookupByLibrary.simpleMessage("الإجمالي"),
        "tracking_order": MessageLookupByLibrary.simpleMessage("تتبع الطلب"),
        "tracking_refreshed_successfuly":
            MessageLookupByLibrary.simpleMessage("تم تحديث قائمة التتبع بنجاح"),
        "trending_this_week":
            MessageLookupByLibrary.simpleMessage("الاعلى هذا الأسبوع"),
        "typeToStartChat":
            MessageLookupByLibrary.simpleMessage("اكتب لبدء الدردشة"),
        "unknown": MessageLookupByLibrary.simpleMessage("مجهول"),
        "validCouponCode": MessageLookupByLibrary.simpleMessage("قسيمة صالحة"),
        "verify": MessageLookupByLibrary.simpleMessage("التحقق"),
        "verify_your_internet_connection":
            MessageLookupByLibrary.simpleMessage(" تحقق من الاتصال بالانترنت"),
        "verify_your_quantity_and_click_checkout":
            MessageLookupByLibrary.simpleMessage(
                "تحقق من الكمية واضغط على الدفع"),
        "version": MessageLookupByLibrary.simpleMessage("الإصدار"),
        "welcome": MessageLookupByLibrary.simpleMessage("مرحبا"),
        "reset_password_success":
            MessageLookupByLibrary.simpleMessage("تم تغير كلمة السر بالنجاح"),
        "this_account_not_exist":
            MessageLookupByLibrary.simpleMessage("هذا الحساب غير موجود"),
        "what_they_say":
            MessageLookupByLibrary.simpleMessage("ماذا يقول عملائنا ؟"),
        "wrong_phone_or_password": MessageLookupByLibrary.simpleMessage(
            "رقم الهاتف أو كلمة مرور خاطئة"),
        "youDontHaveAnyConversations":
            MessageLookupByLibrary.simpleMessage("لايوجد محادثات"),
        "you_can_discover_restaurants": MessageLookupByLibrary.simpleMessage(
            "يمكنك استكتشاف المطابخ المحيطة بك واختيار أفضل وجبة لك"),
        "you_must_add_foods_of_the_same_restaurants_choose_one":
            MessageLookupByLibrary.simpleMessage(
                "فضلا اختيار الاصناف من مطعم واحد في كل طلب"),
        "you_must_add_foods_of_the_same_stores_choose_one":
            MessageLookupByLibrary.simpleMessage(
                "فضلا اختيار الاصناف من متجر واحد في كل طلب"),
        "you_must_signin_to_access_to_this_section":
            MessageLookupByLibrary.simpleMessage(
                "يجب تسجيل الدخول لمشاهدة هذه الصفحة"),
        "your_address": MessageLookupByLibrary.simpleMessage("عنوانك"),
        "your_biography": MessageLookupByLibrary.simpleMessage("نبذة عنك"),
        "pay_on_pickup":
            MessageLookupByLibrary.simpleMessage("الاستلام من المطعم"),
        "click_to_pay_on_pickup": MessageLookupByLibrary.simpleMessage(
            "الضغط علي الاستلام من المطعم"),
        "your_order_has_been_successfully_submitted":
            MessageLookupByLibrary.simpleMessage("تم تقديم طلبك بنجاح!"),
        "your_reset_link_has_been_sent_to_your_email":
            MessageLookupByLibrary.simpleMessage(
                "تم ارسال رابط استعادة كلمة المرور الى البريد الالكتروني الخاص بك"),
        "pickup": MessageLookupByLibrary.simpleMessage("استلام"),
        "change_address": MessageLookupByLibrary.simpleMessage("تغير العنوان"),
        "We_have_not_reached_your_area_yet":
            MessageLookupByLibrary.simpleMessage("لم نصل الي منطقتك بعد"),
        "but_we_are_still_working_on_expanding_our_service":
            MessageLookupByLibrary.simpleMessage(
                "لكننا لازلنا نعمل علي توسيع نطاق خدمتنا"),
        "address_selected_error": MessageLookupByLibrary.simpleMessage(
            "هنالك خطا في تحديد العنوان حاول مجددا"),
        "address_selected_successfully":
            MessageLookupByLibrary.simpleMessage("تم تحديد العنوان بنجاح"),
        "pickup_your_food_from_the_restaurant":
            MessageLookupByLibrary.simpleMessage("استلام وجبة من مطعم"),
      };
}
