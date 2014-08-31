part of ReCaptcha;

/**
 * Implementation of [HttpHelper].
 */
class HttpLoaderImpl implements HttpHelper {
  
  Client client;
  
  /**
   * Create new instance of [HttpLoaderImpl].
   */
  HttpLoaderImpl() {
    client = new Client();
  }
  
  /**
   * Make a GET request on specified [url] and return future string response.
   */
  Future<String> httpGet(String url) {
    return client.get(url).then((Response response){
      return response.body;
    });
  }
  
  /**
   * Make a POST request wint [postdata] on specified [url] and return future 
   * string response.
   */
  Future<String> httpPost(String url, Map postdata) {
    return client.post(url, body:postdata).then((Response response){
      return response.body;
    });
  }
}

