@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
   //Implement http mock callout here
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
        response.setStatusCode(401);
        return response; 
    }
}