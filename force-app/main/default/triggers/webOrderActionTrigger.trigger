trigger webOrderActionTrigger on WebOrder__C (after insert, after delete, after update) {
    List<String> opportunityFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(Schema.SObjectType.Opportunity.fieldSets.getMap().get('Web_Order_Sync_To_Opportunity'));
    Set<String> webOrderFieldsList = Schema.SObjectType.WebOrder__c.fields.getMap().keySet();

    if (Trigger.isInsert) {
        List<Opportunity> newOpportunitiesList = new List<Opportunity>();

        for(WebOrder__c webOrder : Trigger.New) {
            System.debug(webOrder.OpportunityId__c);
            if (webOrder.OpportunityId__c != null) {
                continue;
            }

            Opportunity newOpportunity = CopyObjectByFieldSetsHelper.patchOpportunity(null, webOrderFieldsList, opportunityFieldsList, webOrder);
            newOpportunitiesList.add(newOpportunity);
        }

        insert newOpportunitiesList;
    }

    if (Trigger.isUpdate) {
        Set<Id> webOrderIdsList = (new Map<Id, WebOrder__c>(Trigger.New)).keySet();
        List<Id> opportunityIdsList = CopyObjectByFieldSetsHelper.getOpportunityIdList(Trigger.New);

        String opportunityQuery = 'SELECT Id, WebOrderId__c, ' + String.Join(opportunityFieldsList, ', ') + ' FROM Opportunity WHERE WebOrderId__c IN :webOrderIdsList OR Id IN :opportunityIdsList';
        List<Opportunity> existedOpportunityList = (List<Opportunity>)(Database.query(opportunityQuery));

        List<Opportunity> opportunitiesList = new List<Opportunity>();
        for(WebOrder__c webOrder : Trigger.New) {
            Opportunity opportunity = CopyObjectByFieldSetsHelper.getOpportunityByWebOrderId(webOrder.Id, existedOpportunityList);

            if (opportunity == null || !CopyObjectByFieldSetsHelper.compareWebObjectAndOpportunityFields(opportunity, webOrderFieldsList, opportunityFieldsList, webOrder)) {
                System.debug(webOrderFieldsList);
                System.debug(opportunityFieldsList);
                System.debug('Update');
                opportunity = opportunity != null ? opportunity : new Opportunity();

                opportunity = CopyObjectByFieldSetsHelper.patchOpportunity(opportunity, webOrderFieldsList, opportunityFieldsList, webOrder);
                opportunitiesList.add(opportunity);
            }
        }

        System.debug(opportunitiesList);
        upsert opportunitiesList;
    }

    if (Trigger.isDelete) {
        Set<Id> webOrderIdList = (new Map<Id, WebOrder__c>(Trigger.Old)).keySet();
        List<Id> opportunityIdsList = CopyObjectByFieldSetsHelper.getOpportunityIdList(Trigger.Old);

        List<Opportunity> opportunityList = [SELECT Id FROM Opportunity WHERE WebOrderId__c IN :webOrderIdList OR Id IN :opportunityIdsList];
        delete opportunityList;
    }
}