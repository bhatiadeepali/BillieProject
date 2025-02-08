public with sharing class MostPublishedBooksScheduler implements Schedulable {
    public void execute(SchedulableContext ctx) {
            System.enqueueJob(new MostPublishedBooksQueueable());
        }
}