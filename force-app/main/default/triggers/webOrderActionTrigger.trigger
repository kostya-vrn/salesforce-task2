trigger webOrderActionTrigger on Web_Order__c (after insert, after delete, after update) {
    List<String> opportunityFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(
        Schema.SObjectType.Opportunity.fieldSets.getMap().get('Web_Order_Sync_To_Opportunity'));
    Set<String> webOrderFieldsList = Schema.SObjectType.Web_Order__c.fields.getMap().keySet();

    if (Trigger.isInsert) {
        List<Opportunity> newOpportunitiesList = new List<Opportunity>();

        for(Web_Order__c webOrder: Trigger.New) {
            if (webOrder.OpportunityId__c != null) {
                continue;
            }

            Opportunity newOpportunity = CopyObjectByFieldSetsHelper.patchOpportunity(null, webOrderFieldsList, opportunityFieldsList, webOrder);
            newOpportunitiesList.add(newOpportunity);
        }

        insert newOpportunitiesList;
    }

    if (Trigger.isUpdate) {
        Set<Id> webOrderIdsList = (new Map<Id, Web_Order__c>(Trigger.New)).keySet();
        List<Id> opportunityIdsList = CopyObjectByFieldSetsHelper.getOpportunityIdList(Trigger.New);

        String opportunityQuery = 'SELECT Id, WebOrderId__c, ' + 
                                    String.Join(opportunityFieldsList, ', ') + 
                                    ' FROM Opportunity WHERE WebOrderId__c IN :webOrderIdsList OR Id IN :opportunityIdsList';
        List<Opportunity> existedOpportunityList = (List<Opportunity>)(Database.query(opportunityQuery));

        System.debug('existedOpportunityList: ' + existedOpportunityList);

        List<Opportunity> opportunitiesList = new List<Opportunity>();
        for(Web_Order__c webOrder: Trigger.New) {
            Opportunity opportunity = CopyObjectByFieldSetsHelper.getOpportunityByWebOrder(webOrder, existedOpportunityList);
        System.debug('opportunity: ' + opportunity);
            if (opportunity == null || 
                !CopyObjectByFieldSetsHelper.compareWebObjectAndOpportunityFields(
                    opportunity, 
                    webOrderFieldsList, 
                    opportunityFieldsList, 
                    webOrder)
            ) {
                System.debug('inside webOrder: ' + opportunity);
                opportunity = opportunity != null ? opportunity : new Opportunity();

                opportunity = CopyObjectByFieldSetsHelper.patchOpportunity(opportunity, webOrderFieldsList, opportunityFieldsList, webOrder);
                opportunitiesList.add(opportunity);
            }
        }

        upsert opportunitiesList;
    }

    if (Trigger.isDelete) {
        Set<Id> webOrderIdList = (new Map<Id, Web_Order__c>(Trigger.Old)).keySet();
        List<Id> opportunityIdsList = CopyObjectByFieldSetsHelper.getOpportunityIdList(Trigger.Old);

        List<Opportunity> opportunityList = [SELECT Id FROM Opportunity WHERE WebOrderId__c IN :webOrderIdList OR Id IN :opportunityIdsList];

        delete opportunityList;
    }
}