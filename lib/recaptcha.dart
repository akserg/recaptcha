library ReCaptcha;

import 'dart:async';
import 'package:http/http.dart';

part "recaptcha_impl.dart";
part "httphelper_impl.dart";

/**
 * Response class returns result of ReCaptcha validation request.
 */
class ReCaptchaResponse {

  // Validation result
  final bool valid;
  
  // Error message if error was happened
  final String errorMessage;

  /**
   * Create new instance of [ReCaptchaResponse] with [valid] state and
   * optional [this.errorMessage]
   */
  ReCaptchaResponse(this.valid, this.errorMessage);
}

/**
 * Abstract ReCaptcha interface defines contract between client side and ReCaptcha.
 */
abstract class ReCaptcha {

  /**
   * Validates a reCaptcha [challenge] and [response] came from specified [remoteAddr]
   * and return future value of [ReCaptchaResponse].
   */
  Future<ReCaptchaResponse> checkAnswer(String remoteAddr, String challenge, String response); 
  
  /**
   * Create an instance of ReCaptcha client with [publicKey] and [privateKey] 
   * pairs of security key generated via API key generator.
   */
  factory ReCaptcha(String publicKey, String privateKey, 
      {bool includeNoscript:true, bool secureProtocol:false}) {
    ReCaptchaImpl recaptcha = new ReCaptchaImpl(new HttpHelper());
    recaptcha.includeNoscript = includeNoscript;
    recaptcha.privateKey = privateKey;
    recaptcha.publicKey = publicKey;
    if (secureProtocol) {
      recaptcha.recaptchaServer = ReCaptchaImpl.HTTPS_SERVER;
    } else {
      recaptcha.recaptchaServer = ReCaptchaImpl.HTTP_SERVER;
    }
    return recaptcha;
  }

}

/**
 * GET and POST request helper class.
 */
abstract class HttpHelper {

  /**
   * Make a POST request with [postdata] on specified [url].
   */
  Future<String> httpPost(String url, Map postdata);
  
  /**
   * Make a GET request on specified [url].
   */
  Future<String> httpGet(String url);
  
  /**
   * Creqate and instance of HttpLoader via factory method.
   */
  factory HttpHelper() {
    return new HttpLoaderImpl();
  }
}