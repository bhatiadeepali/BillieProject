public with sharing class BookService {
    
    private static final String ENDPOINT_URL = 'https://eoheai3ashoyzos.m.pipedream.net';
    public static void fetchAndPublishBooks() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint('callout:MostPublishedBooks');
        request.setEndpoint(ENDPOINT_URL);
        request.setMethod('GET');
        request.setTimeout(60000);
        HttpResponse response ;
        try {
            response = http.send(request);
            if(response.getStatusCode() == 200) {
                
                System.debug('Response Body: ' + response.getBody());
                List<Publisher> publishers = processResponse(response.getBody());
                List<MostPublishedBooks__e> events = new List<MostPublishedBooks__e>();
                
                for(Publisher publisher : publishers) {
                   // Filter books with edition > 600,000
                    List<Publisher.Book> filteredBooks = new List<Publisher.Book>();
                    for (Publisher.Book book : publisher.Books) {
                        if (book.Edition > 600000) {
                            filteredBooks.add(book);
                        }
                    }
                    
                     // Sort books by edition in descending order (highest edition first)
                	filteredBooks.sort(new BookEditionComparator());
                    System.debug('FilteredBooks: ' +filteredBooks);
                    
                    // Create platform events for each book
                    for (Publisher.Book book : filteredBooks) {
                        MostPublishedBooks__e event = new MostPublishedBooks__e(
                            Author__c = book.Author,
                            Title__c = book.Title,
                            Edition__c = book.Edition,
                            Publisher__c = publisher.Publisher
                        );
                        events.add(event);
                    }

                }
                System.debug('Events: ' +events);
                
                if (!events.isEmpty()) {
                    EventBus.publish(events);
                }
            } else {
                System.debug('Callout failed: '+ response.getStatusCode() + ' ' + response.getBody());
            }
        } catch(Exception e) {
            System.debug('Exception during callout: ' + e.getMessage());
        }
    }
    
    private static List<Publisher> processResponse(String responseBody) {
        List<MostPublishedBooks__e> eventList = new List<MostPublishedBooks__e>();
        
        //List<Map<String, Object>> books = (List<Map<String, Object>>) JSON.deserializeUntyped(responseBody);
        List<Publisher> publishers = (List<Publisher>)JSON.deserialize(responseBody, List<Publisher>.class);
        System.debug('Publishers: ' +publishers);
        
        // Iterate over each publisher and check if Books is null
        for (Publisher publisher : publishers) {
            if (publisher.Books == null) {
                publisher.Books = new List<Publisher.Book>();  // Initialize an empty list if Books is null
            }
        }
    	return publishers;
         
    }
    
    private class BookEditionComparator implements Comparator<Publisher.Book> {
        public Integer compare(Publisher.Book book1, Publisher.Book book2) {
            // Sort by Edition in descending order
            return book2.Edition - book1.Edition;
    	}
    }

}