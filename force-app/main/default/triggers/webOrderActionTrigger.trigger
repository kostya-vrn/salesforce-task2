trigger webOrderActionTrigger on WebOrder__C (before insert, after delete, after update) {
    List<String> webOrderFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(Schema.SObjectType.WebOrder__c.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));
    List<String> opportunityFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(Schema.SObjectType.Opportunity.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));

    /*List<WebOrder__c> webOrdersList = Trigger.isInsert || trigger.isUpdate ? Trigger.New : Trigger.Old;
    Set<Id> webOrderIdsList = (new Map<Id, WebOrder__c>(webOrdersList)).keySet();

    String getOpportunitiesQuery = 'SELECT Id, WebOrderId__c, ' + String.Join(opportunityFieldsList, ', ') + ' FROM Opportunity WHERE WebOrderId__c IN :webOrdersList';
    Map<Id, sObject> existedOpportunitiesMap = new Map<Id, sObject>(Database.query(getOpportunitiesQuery));
    System.debug('existedOpportunitiesMap: ' + existedOpportunitiesMap);*/

    if (Trigger.isInsert) {
        List<Opportunity> newOpportunitiesList = new List<Opportunity>();

        for(WebOrder__c webOrder : Trigger.New) {
            System.debug(webOrder.OpportunityId__c);
            if (webOrder.OpportunityId__c != null) {
                continue;
            }

            Opportunity newOpportunity = new Opportunity();
            newOpportunity = CopyObjectByFieldSetsHelper.putOpportunityFields(newOpportunity, opportunityFieldsList, webOrderFieldsList, webOrder);
            newOpportunitiesList.add(newOpportunity);
        }

        System.debug(newOpportunitiesList);
        if (newOpportunitiesList.size() > 0) {
            insert newOpportunitiesList;
            for(Integer webOrderIndex = 0; webOrderIndex < Trigger.New.size(); webOrderIndex++) {
                Trigger.New[webOrderIndex].OpportunityId__c = newOpportunitiesList[webOrderIndex].Id;
            }
        }
    }

    if (Trigger.isDelete) {
        System.debug('wo Trigger.Old: ' + Trigger.Old);
        List<Id> opportunityIdsList = new List<Id>();
        for(WebOrder__c webOrder : Trigger.Old) {
            System.debug('wo webOrder.OpportunityId__c: ' + webOrder.OpportunityId__c);
            opportunityIdsList.add(webOrder.OpportunityId__c);
        }
        List<Opportunity> opportunityList = [SELECT Id FROM Opportunity WHERE Id IN :opportunityIdsList];
        System.debug('wo opportunityList: ' + opportunityList);
        delete opportunityList;
    }
}