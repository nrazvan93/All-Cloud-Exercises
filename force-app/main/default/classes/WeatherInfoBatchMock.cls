// Handles the mock http callout for WeatherInfoBatch testing

@isTest
global class WeatherInfoBatchMock implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest request) {
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type','application/json');
    response.setBody('Success');
    response.setStatusCode(200);
    return response;
  }
}