public class Twilio_Conversation_API_Controller {
    @InvocableMethod
    public static void CreateConversation(List<id> CampaignIDs){
        CreateConversationCallout(CampaignIDs);
    }
    
    @future(callout=true)
    public static void CreateConversationCallout(List<id> CampaignIDs){
        List<Campaign> Campaigns = [select Id, Name from Campaign where id in: CampaignIDs];
        String Endpoint = 'https://conversations.twilio.com/v1/Conversations';
        String ACCOUNT_SID = Label.Twilio_Account_SID;
        String AUTH_TOKEN = Label.Twilio_Auth_Token;
        Map<string, string> HeaderMap = new Map<String, String>{'Content-Type' => 'application/json','Authorization' => 'Basic '+EncodingUtil.Base64Encode(Blob.valueOf(ACCOUNT_SID+':'+AUTH_TOKEN))};
        for(Campaign Cmp : Campaigns){
            String JsonBody = '{"friendlyName" : "'+Cmp.Name+'"}';
            HTTPResponse Resp = Callout_Utility.doCallout(Endpoint, 'POST', HeaderMap, JsonBody, 12000 );
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