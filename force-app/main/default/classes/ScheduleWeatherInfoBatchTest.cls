// Test class for ScheduleWeatherInfoBatch

@isTest
class ScheduleWeatherInfoBatchTest {
    @isTest
    public static void testSchedule() {
        Test.startTest();
        ScheduleWeatherInfoBatch scheduler = new ScheduleWeatherInfoBatch();
        String schedule = '0 0 0 * * ?';
        system.schedule('Test status', schedule, scheduler);
        scheduler.execute(null);
        Test.stopTest();
    }
}
