ReCaptcha
=========

ReCaptcha is a server side Dart library for interfacing with [ReCAPTCHA](https://developers.google.com/recaptcha) service from Google.

Installation
------------

Add this package to your pubspec.yaml file:

    dependencies:
      recaptcha: any

Then, run `pub get` to download and link in the package.

API Keys
--------

To use reCAPTCHA, you need to [sign up for API](http://www.google.com/recaptcha/admin#whyrecaptcha) keys for your site. To take full advantages of ReCaptcha please read documentation from original [web site](https://developers.google.com/recaptcha).

By default, all keys work on "localhost" (or "127.0.0.1"), so you can always develop and test on your local machine.


Integration
-----------

Once you've signed up for API keys, adding reCAPTCHA to your site consists of two steps and optionally a third step where you customize the widget:

1. Required step on client side to displaying the reCAPTCHA Widget
2. Required step on server side to verifying the solution
3. Optional step like customizations

ReCaptcha library implemented as server side proxy to check validation of reCAPTCHA solution. If you are interesting in [display](https://developers.google.com/recaptcha/docs/display) and [verify](https://developers.google.com/recaptcha/docs/verify) reCAPTCHA solution directly from Google API web site please refer to original links. 

Client Side Integration
-----------------------

To make the reCAPTCHA widget appear when your page loads, you will need to insert this snippet of JavaScript & non-JavaScript code in your `<form>` element and replace `your_public_key` with your public key:

```html
<!-- ... your HTML content ... -->

<form action="" method="post">

  <!-- ... your form code here ... -->

  <script type="text/javascript" 
    src="http://www.google.com/recaptcha/api/challenge?k=your_public_key"></script>
  <noscript>
    <iframe src="http://www.google.com/recaptcha/api/noscript?k=your_public_key" 
      height="300" width="500" frameborder="0"></iframe><br>
    <textarea name="recaptcha_challenge_field" rows="3" cols="40"></textarea>
    <input type="hidden" name="recaptcha_response_field" value="manual_challenge">
  </noscript>

  <!-- ... more of your form code here ... -->

</form>

<!-- ... more of your HTML content ... -->
```

There are two form fields:

- **recaptcha_challenge_field** is a hidden field that describes the CAPTCHA which the user is solving. It corresponds to the "challenge" parameter required by the reCAPTCHA verification API.
- **recaptcha_response_field** is a text field where the user enters their solution. It corresponds to the "response" parameter required by the reCAPTCHA verification API.

These two fields will be passed to the server side ReCaptcha Dart library on your server that processes this form and verifies the reCAPTCHA solution via the reCAPTCHA verification API.

Server Side Integration
-----------------------

ReCaptcha can be quickly integrated with any Dart server solution via calling checkAnswer method of ReCaptcha class. You need send remote URL, challenge and response come from a client. 
Here is an example of how registration form with reCAPTCHA widget can be served on server side:

```dart
serveRegister(HttpRequest request) {
  HttpResponse response = request.response;
  request.listen((List<int> buffer) {
    String strBuffer = new String.fromCharCodes(buffer);
    Map data = postToMap(strBuffer);
    //
    String userName = data.containsKey('username') ? data['username'] : '';
    String password = data.containsKey('password') ? data['password'] : '';
    String cptChallenge = data.containsKey('recaptcha_challenge_field') ? data['recaptcha_challenge_field'] : '';
    String cptResponse = data.containsKey('recaptcha_response_field') ? data['recaptcha_response_field'] : '';
    reCaptcha.checkAnswer(request.uri.host, cptChallenge, cptResponse).then((ReCaptchaResponse cptResponse) {
      response.statusCode = HttpStatus.OK;
      setCORSHeader(response);
      if (cptResponse.valid) {
        response.write("Registration success.");
      } else {
        response.write(MESSAGES[cptResponse.errorCode]);
      }
      response.close();
    });
  });
}
```

Server Side validation
----------------------

A ReCaptcha returns result of verification as instance of class `ReCaptchaResponse` with error code. All error codes return from ReCaptcha is similar to error codes form reCAPTCHA:

Code | Description
-----|------------
invalid-site-private-key | Incorrect private key
invalid-request-cookie | The challenge parameter of the verify script was incorrect
incorrect-captcha-sol | The CAPTCHA solution was incorrect
captcha-timeout | The solution was received after the CAPTCHA timed out
recaptcha-not-reachable | Unknown error in CAPTCHA

All error codes could be easily internalized if necessary.

## Contributing to the project

Your contribution is welcome! 

