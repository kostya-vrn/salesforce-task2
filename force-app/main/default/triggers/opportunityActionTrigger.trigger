trigger opportunityActionTrigger on Opportunity (after insert, after delete, after update) {
    List<String> webOrderFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(Schema.SObjectType.WebOrder__c.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));
    List<String> opportunityFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(Schema.SObjectType.Opportunity.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));

    if (Trigger.isInsert) {
        List<WebOrder__C> newWebOrdersList = new List<WebOrder__c>();

        for(Opportunity opportunity : Trigger.New) {
            WebOrder__c newWebOrder = new WebOrder__c();
            newWebOrder = CopyObjectByFieldSetsHelper.putWebOrderFields(opportunity, opportunityFieldsList, webOrderFieldsList, newWebOrder);
            newWebOrdersList.add(newWebOrder);
        }
        insert newWebOrdersList;
    }

    if (Trigger.isUpdate) {
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.New)).keySet();
        String getWebOrdersQuery = 'SELECT Id, OpportunityId__c, ' + String.Join(webOrderFieldsList, ', ') + ' FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdsList';
        List<WebOrder__c> existedWebOrdersList = (List<WebOrder__c>)(Database.query(getWebOrdersQuery));

        List<WebOrder__C> webOrders = new List<WebOrder__c>();
        for(Opportunity opportunity : Trigger.New) {
            WebOrder__c webOrder = CopyObjectByFieldSetsHelper.getWebOrderByOpportunityId(opportunity.Id, existedWebOrdersList);

            if (webOrder == null || !CopyObjectByFieldSetsHelper.compareOpportunityAndWebObjectFields(opportunity, opportunityFieldsList, webOrderFieldsList, webOrder)) {
                System.debug(webOrder);
                webOrder = webOrder != null ? webOrder : new WebOrder__C();

                webOrder = CopyObjectByFieldSetsHelper.putWebOrderFields(opportunity, opportunityFieldsList, webOrderFieldsList, webOrder);
                webOrders.add(webOrder);
            }
        }

        upsert webOrders;
    }

    if (Trigger.isDelete) {
        System.debug('op Trigger.Old: ' + Trigger.Old);
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.Old)).keySet();
        System.debug('op opportunityIdsList: ' + opportunityIdsList);
        List<WebOrder__c> webOrdersList = [SELECT Id FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdsList];
        System.debug('op webOrdersList: ' + webOrdersList);
        delete webOrdersList;
    }
}

