part of ReCaptcha;

/**
 * Implementation of [ReCaptcha].
 */
class ReCaptchaImpl implements ReCaptcha {

  static final String HTTP_SERVER = "http://api-verify.recaptcha.net/verify";
  static final String HTTPS_SERVER = "https://api-verify.recaptcha.net/verify";
  
  String privateKey;
  String publicKey;
  String recaptchaServer;
  bool includeNoscript = false;
  HttpHelper httpLoader;
  
  ReCaptchaImpl(this.httpLoader);
  
  /**
   * Check answer with [challenge] and [response] on [remoteAddr] and return 
   * future with ReCaptchaResponse.
   */
  Future<ReCaptchaResponse> checkAnswer(String remoteAddr, String challenge, String response) {

    Completer<ReCaptchaResponse> completer = new Completer<ReCaptchaResponse>();
    
    Map postParameters = {
      "privatekey": privateKey,
      "remoteip": remoteAddr,
      "challenge": challenge,
      "response": response
    };

    httpLoader.httpPost(recaptchaServer, postParameters)
    .then((String message) {
      List<String> messages = message.split("\n");
      if (messages.length > 0) {
        bool valid = messages[0] == "true";
        String errorMessage = null;
        if (!valid) {
          if (messages.length > 1)
            errorMessage = messages[1];
          else
            errorMessage = "unknown-errror";
        }
        completer.complete(new ReCaptchaResponse(valid, errorMessage));
      } else {
        completer.complete(new ReCaptchaResponse(false, 
            "Incorrect answer returned from recaptcha: " + message));
      }
    }).catchError((e) {
      return completer.completeError(new ReCaptchaResponse(false, 
          "Cannot read from server: ${e.toString()}"));
    });
    return completer.future;
  }
}
