// Retrieves the weather description based on BillingCity and populates the Current_Weather__c field on every Account

global class WeatherInfoBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
  global Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'SELECT Id, BillingCity FROM Account';
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Account> accountList) {
    if (accountList.size() > 0) {
      List<Account> accountsToUpdate = new List<Account>();
      for (Account account : accountList) {
        try {
          String description;
          String accountBillingCity = account.BillingCity;
          String apiKey = 'd283e155bc873b33808fdd07c0e65232';
          String requestEndPoint = 'https://api.openweathermap.org/data/2.5/weather?q=';

          requestEndPoint += accountBillingCity + '&appid=' + apiKey;

          // Create and send the request
          Http http = new Http();
          HttpRequest request = new HttpRequest();
          request.setEndpoint(requestEndPoint);
          request.setMethod('GET');
          HttpResponse response = http.send(request);

          // Handle the response and populate the Current Weather field
          if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            while (parser.nextToken() != null) {
              if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                if (parser.getCurrentName() == 'description') {
                  description = parser.getText();
                  system.debug('description from request ' + description);
                  break;
                }
              }
            }
            account.Current_Weather__c = description;
          } else {
            account.Current_Weather__c = '';
          }
          accountsToUpdate.add(account);
        } catch (Exception ex) {
          system.debug(
            'Exception is: ' +
            ex.getMessage() +
            ' at line number: ' +
            ex.getLineNumber()
          );
        }
      }
      update (accountsToUpdate);
    }
  }

  global void finish(Database.BatchableContext BC) {
  }
}
