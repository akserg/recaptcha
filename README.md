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

To use reCAPTCHA, you need to [sign up for API](http://www.google.com/recaptcha/admin#whyrecaptcha) keys for your site. To take full advatages of ReCaptcha please read documentation from original [web site](https://developers.google.com/recaptcha).

By default, all keys work on "localhost" (or "127.0.0.1"), so you can always develop and test on your local machine.


Integration
-----------

Once you've signed up for API keys, adding reCAPTCHA to your site consists of two steps and optionally a third step where you customize the widget:

1. Required step on client side to displaying the reCAPTCHA Widget
2. Required step on server side to verifying the solution
3. Optional step like customizations

ReCaptcha library implemented as server side proxy to check validation of reCAPTCHA solution. If you are interesting in [display](https://developers.google.com/recaptcha/docs/display) and [verify](https://developers.google.com/recaptcha/docs/verify) reCAPTCHA solution direclty from Google API web site please refer to original links. 

Challenge and Non-JavaScript API
--------------------------------

To make the reCAPTCHA widget appear when your page loads, you will need to insert this snippet of JavaScript & non-JavaScript code in your `<form>` element and replace your_public_key with your public key:

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

- recaptcha_challenge_field is a hidden field that describes the CAPTCHA which the user is solving. It corresponds to the "challenge" parameter required by the reCAPTCHA verification API.
- recaptcha_response_field is a text field where the user enters their solution. It corresponds to the "response" parameter required by the reCAPTCHA verification API.

These two fields will be passed to the server side ReCaptcha Dart library on your server that processes this form and verifies the reCAPTCHA solution via the reCAPTCHA verification API.

Server Side validation
----------------------

The response from ReCaptcha verify is a ReCaptchaResponse class instance contains valid flag and error message. 

