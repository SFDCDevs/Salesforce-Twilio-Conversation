/*****************************************************
 * Name : Test_Twilio_Conversation_API_Controller
 * Developer: Vinay Vernekar
 * Reference: https://www.fiverr.com/kingofwebhost/do-standard-or-custom-development-in-salesforce
 * Website: https://sfdcdevelopers.com
 * Email: support@sfdcdevelopers.com
 * Purpose: Test class for Twilio_Conversation_API_Controller apex class
 * Date: 5 March 2020
 * Last Modified Date: 5 March 2020
*******************************************************/
@isTest
public class Test_Twilio_Conversation_API_Controller {
    static TestMethod void CoverClass(){
        //Create Campaign
        Campaign C = new Campaign(Name = 'test campaign 1');
        insert C;
        System.assert(C.id != null);
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();
        Twilio_Conversation_API_Controller.CreateConversation(new list<Id>{C.id});
        Test.stopTest();
    }
}