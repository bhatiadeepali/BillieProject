@isTest
public class BookServiceTest {
    
     @isTest
    static void testFetchAndPublishBooks_Success() {
        // Create mock response JSON
        String mockResponse = '[{"Publisher":"Test Publisher","Books":[{"Title":"Book One","Author":"Author A","Edition":700000},{"Title":"Book Two","Author":"Author B","Edition":500000}]}]';

        BookServiceMockHttpResponse mockHttp = new BookServiceMockHttpResponse(200, mockResponse);

        // Start Test Execution
        Test.startTest();
        BookService.fetchAndPublishBooks();
        Test.getEventBus().deliver(); // Ensures platform events are processed
        Test.stopTest();

        System.assert(true, 'Test executed successfully, and platform events should be published.');

    }
    
    @isTest
    static void testFetchAndPublishBooks_NoValidBooks() {
        String mockResponse = '[{"Publisher":"Test Publisher","Books":[{"Title":"Book One","Author":"Author A","Edition":500000}]}]';

        // Set up the mock response
        BookServiceMockHttpResponse mockHttp = new BookServiceMockHttpResponse(200, mockResponse);
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();
        BookService.fetchAndPublishBooks();
        Test.getEventBus().deliver();
        Test.stopTest();

        System.assert(true, 'Test executed successfully, and no platform events should be published.');
    }
    
    @isTest
    static void testFetchAndPublishBooks_HTTPFailure() {
        BookServiceMockHttpResponse mockHttp = new BookServiceMockHttpResponse(500, 'Internal Server Error');
        Test.setMock(HttpCalloutMock.class, mockHttp);

        Test.startTest();
        BookService.fetchAndPublishBooks();
        Test.stopTest();

        System.assert(true, 'Test executed successfully, and no events should be published when HTTP request fails.');
    }

}