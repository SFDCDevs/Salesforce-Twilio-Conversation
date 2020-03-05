/*****************************************************
 * Name : MockHttpResponseGenerator
 * Developer: Vinay Vernekar
 * Reference: https://www.fiverr.com/kingofwebhost/do-standard-or-custom-development-in-salesforce
 * Website: https://sfdcdevelopers.com
 * Email: support@sfdcdevelopers.com
 * Purpose: Mock class for testing callouts
 * Date: 5 March 2020
 * Last Modified Date: 5 March 2020
*******************************************************/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"sid":"testsid"}');
        res.setStatusCode(201);
        return res;
    }
}