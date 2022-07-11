// Scheduler for WeatherInfoBatch (scheduled to run the batch every hour)

public with sharing class ScheduleWeatherInfoBatch implements Schedulable {
    public void execute(SchedulableContext sc) {
        ID BatchId = Database.executeBatch(new WeatherInfoBatch(), 100);
    }
}