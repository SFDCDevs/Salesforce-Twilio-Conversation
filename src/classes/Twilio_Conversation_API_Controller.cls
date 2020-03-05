/*****************************************************
 * Name : Twilio_Conversation_API_Controller
 * Developer: Vinay Vernekar
 * Reference: https://www.fiverr.com/kingofwebhost/do-standard-or-custom-development-in-salesforce
 * Website: https://sfdcdevelopers.com
 * Email: support@sfdcdevelopers.com
 * Purpose: Controller to send conversation initiative in Twilio
 * Date: 5 March 2020
 * Last Modified Date: 5 March 2020
*******************************************************/
public class Twilio_Conversation_API_Controller {
    @InvocableMethod
    public static void CreateConversation(List<id> CampaignIDs){
        CreateConversationCallout(CampaignIDs);
    }
    
    @future(callout=true)
    public static void CreateConversationCallout(List<id> CampaignIDs){
        List<Campaign> Campaigns = [select Id, Name from Campaign where id in: CampaignIDs];
        for(Campaign Cmp : Campaigns){
            String JsonBody = '{"friendlyName" : "'+Cmp.Name+'"}';
            
            //construct Http request
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Twilio_Conversation');
            req.setMethod('POST');
            req.setBody(JsonBody);
            Http http = new Http();
            HTTPResponse Resp = http.send(req);

            //validate response
            if(Resp.getStatusCode() == 201){
                Object RespObj = (Object)JSON.deserializeUntyped(Resp.getBody());
                Map<String, Object> RespObjMap = (Map<String, Object>)RespObj;
                if(RespObjMap.containsKey('sid')){
                    Cmp.Twilio_Conversation_ID__c = (String)RespObjMap.get('sid');
                    Cmp.Twilio_API_Log__c = 'Conversation initiated successfully!';
                }
                else
                   Cmp.Twilio_API_Log__c = 'Conversation SID is not generated'; 
            }
            else{
                Cmp.Twilio_Conversation_ID__c = 'ERROR_OCCURED';
                Cmp.Twilio_API_Log__c = 'Error occured while initiating conversation. Error Code: '+Resp.getStatus(); 
            }
        }
        if(!Campaigns.isEmpty()){
            List<Database.SaveResult> srList = Database.update(Campaigns, false);
			for (Database.SaveResult sr : srList) {
                if (sr.isSuccess())
                    System.debug('Successfully updated campaign. Campaign ID: ' + sr.getId());
                else {
                    System.debug('The following error has occurred.');             
                    for(Database.Error err : sr.getErrors())               
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                }
            }
        }
    }
}