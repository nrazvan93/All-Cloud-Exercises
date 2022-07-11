// Test class for WeatherInfoBatch

@istest
public class WeatherInfoBatchTest {
  @isTest
  static void testBatch() {
    List<Account> accountList = new List<Account>();

    for (integer i = 0; i < 10; i++) {
      accountList.add(
        new Account(Name = 'Test account' + i)
      );
    }

    if (!accountList.isEmpty()) {
        insert accountList;
    }

    Test.setMock(HttpCalloutMock.class, new WeatherInfoBatchMock());
    WeatherInfoBatch batch = new WeatherInfoBatch();

    System.Test.startTest();
    database.executeBatch(batch, 100);
    System.Test.stopTest();
  }
}