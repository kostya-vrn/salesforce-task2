trigger opportunityActionTrigger on Opportunity (after insert, after delete, after update) {
    List<String> webOrderFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(
        Schema.SObjectType.WebOrder__c.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));
    Set<String> opportunityFieldsList = Schema.SObjectType.Opportunity.fields.getMap().keySet();

    if (Trigger.isInsert) {
        List<WebOrder__C> newWebOrdersList = new List<WebOrder__c>();

        for(Opportunity opportunity: Trigger.New) {
            if (opportunity.WebOrderId__c != null) {
                continue;
            }

            WebOrder__c newWebOrder = CopyObjectByFieldSetsHelper.patchWebOrder(opportunity, opportunityFieldsList, webOrderFieldsList, null);
            newWebOrdersList.add(newWebOrder);
        }

        insert newWebOrdersList;
    }

    if (Trigger.isUpdate) {
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.New)).keySet();
        List<Id> webOrderIdList = CopyObjectByFieldSetsHelper.getWebOrderIdList(Trigger.New);

        String webOrdersQuery = 'SELECT Id, OpportunityId__c, ' + 
                                String.Join(webOrderFieldsList, ', ') + 
                                ' FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdsList OR Id IN :webOrderIdList';
        List<WebOrder__c> existedWebOrdersList = (List<WebOrder__c>)(Database.query(webOrdersQuery));

        List<WebOrder__C> webOrders = new List<WebOrder__c>();
        for(Opportunity opportunity: Trigger.New) {
            WebOrder__c webOrder = CopyObjectByFieldSetsHelper.getWebOrderByOpportunityId(opportunity.Id, existedWebOrdersList);

            if (webOrder == null || 
                !CopyObjectByFieldSetsHelper.compareOpportunityAndWebObjectFields(
                    opportunity, 
                    opportunityFieldsList, 
                    webOrderFieldsList, 
                    webOrder)
            ) {
                webOrder = webOrder != null ? webOrder : new WebOrder__C();

                webOrder = CopyObjectByFieldSetsHelper.patchWebOrder(opportunity, opportunityFieldsList, webOrderFieldsList, webOrder);
                webOrders.add(webOrder);
            }
        }

        upsert webOrders;
    }

    if (Trigger.isDelete) {
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.Old)).keySet();
        List<Id> webOrderIdList = CopyObjectByFieldSetsHelper.getWebOrderIdList(Trigger.Old);

        List<WebOrder__c> webOrdersList = [SELECT Id FROM WebOrder__c WHERE OpportunityId__c IN :opportunityIdsList OR Id IN :webOrderIdList];

        delete webOrdersList;
    }
}

