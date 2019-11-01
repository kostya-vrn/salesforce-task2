trigger opportunityActionTrigger on Opportunity (after insert, after delete, after update) {
    List<String> webOrderFieldsList = CopyObjectByFieldSetsHelper.getFieldSetFieldsPath(
        Schema.SObjectType.Web_Order__c.fieldSets.getMap().get('Opportunity_Sync_To_Web_Order'));
    Set<String> opportunityFieldsList = Schema.SObjectType.Opportunity.fields.getMap().keySet();

    if (Trigger.isInsert) {
        List<Web_Order__c> newWebOrdersList = new List<Web_Order__c>();

        for(Opportunity opportunity: Trigger.New) {
            if (opportunity.WebOrderId__c != null) {
                continue;
            }

            Web_Order__c newWebOrder = CopyObjectByFieldSetsHelper.patchWebOrder(opportunity, opportunityFieldsList, webOrderFieldsList, null);
            newWebOrdersList.add(newWebOrder);
        }

        insert newWebOrdersList;
    }

    if (Trigger.isUpdate) {
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.New)).keySet();
        List<Id> webOrderIdList = CopyObjectByFieldSetsHelper.getWebOrderIdList(Trigger.New);

        String webOrdersQuery = 'SELECT Id, OpportunityId__c, ' + 
                                String.Join(webOrderFieldsList, ', ') + 
                                ' FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdsList OR Id IN :webOrderIdList';
        List<Web_Order__c> existedWebOrdersList = (List<Web_Order__c>)(Database.query(webOrdersQuery));

        System.debug('existedWebOrdersList: ' + existedWebOrdersList);

        List<Web_Order__c> webOrders = new List<Web_Order__c>();
        for(Opportunity opportunity: Trigger.New) {
            Web_Order__c webOrder = CopyObjectByFieldSetsHelper.getWebOrderByOpportunity(opportunity, existedWebOrdersList);

        System.debug('webOrder: ' + webOrder);
            if (webOrder == null || 
                !CopyObjectByFieldSetsHelper.compareOpportunityAndWebObjectFields(
                    opportunity, 
                    opportunityFieldsList, 
                    webOrderFieldsList, 
                    webOrder)
            ) {
                System.debug('inside opportunity: ' + opportunity);

                webOrder = webOrder != null ? webOrder : new Web_Order__c();

                webOrder = CopyObjectByFieldSetsHelper.patchWebOrder(opportunity, opportunityFieldsList, webOrderFieldsList, webOrder);
                webOrders.add(webOrder);
            }
        }

        upsert webOrders;
    }

    if (Trigger.isDelete) {
        Set<Id> opportunityIdsList = (new Map<Id, Opportunity>(Trigger.Old)).keySet();
        List<Id> webOrderIdList = CopyObjectByFieldSetsHelper.getWebOrderIdList(Trigger.Old);

        List<Web_Order__c> webOrdersList = [SELECT Id FROM Web_Order__c WHERE OpportunityId__c IN :opportunityIdsList OR Id IN :webOrderIdList];

        delete webOrdersList;
    }
}

