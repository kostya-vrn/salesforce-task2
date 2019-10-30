public with sharing class CopyObjectByFieldSetsHelper {

    public static WebOrder__c getWebOrderByOpportunityId(Id opportunityId, List<WebOrder__c> webOrdersList) {
        for(WebOrder__c webOrder : webOrdersList) {
            if (webOrder.OpportunityId__c == opportunityId) {
                return webOrder;
            }
        }

        return null;
    }
    public static boolean compareOpportunityAndWebObjectFields(Opportunity opportunity, List<String> fromFieldList, List<String> toFieldsList, WebOrder__c webOrder) {
        for(Integer fieldNumber = 0; fieldNumber < Math.min(fromFieldList.size(), toFieldsList.size()); fieldNumber++) {
            String opportunityFieldPath = fromFieldList[fieldNumber];
            String webOrderFieldPath = toFieldsList[fieldNumber];

            System.debug(opportunity.get(opportunityFieldPath));
            System.debug(webOrder.get(webOrderFieldPath));
            System.debug(opportunity.get(opportunityFieldPath) != webOrder.get(webOrderFieldPath));
            if (opportunity.get(opportunityFieldPath) != webOrder.get(webOrderFieldPath)) {
                return false;
            }
        }

        return true;
    }

    public static WebOrder__c putWebOrderFields(Opportunity opportunity, List<String> fromFieldList, List<String> toFieldsList, WebOrder__c webOrder) {
        for(Integer fieldNumber = 0; fieldNumber < Math.min(fromFieldList.size(), toFieldsList.size()); fieldNumber++) {
            String opportunityFieldPath = fromFieldList[fieldNumber];
            String webOrderFieldPath = toFieldsList[fieldNumber];

            if (hasSObjectField(opportunityFieldPath, opportunity)) {
                webOrder.put(webOrderFieldPath, opportunity.get(opportunityFieldPath));
            }
        }

        System.debug('webOrder.OpportunityId__c' + opportunity.Id);
        webOrder.OpportunityId__c = opportunity.Id;
        return webOrder;
    }

    public static Opportunity putOpportunityFields(Opportunity opportunity, List<String> fromFieldList, List<String> toFieldsList, WebOrder__c webOrder) {
        for(Integer fieldNumber = 0; fieldNumber < Math.min(fromFieldList.size(), toFieldsList.size()); fieldNumber++) {
            String opportunityFieldPath = fromFieldList[fieldNumber];
            String webOrderFieldPath = toFieldsList[fieldNumber];

            if (hasSObjectField(webOrderFieldPath, webOrder)) {
                opportunity.put(opportunityFieldPath, webOrder.get(webOrderFieldPath));
            }
        }

        return opportunity;
    }

    public static List<String> getFieldSetFieldsPath(Schema.FieldSet fieldSet) {
        List<Schema.FieldSetMember> fieldMembers = fieldSet.getFields();

        List<String> fieldPathsList = new List<String>();
        for(Schema.FieldSetMember field : fieldMembers) {
            fieldPathsList.add(field.getFieldPath());
        }

        return fieldPathsList;
    }

    public static boolean hasSObjectField(String fieldName, SObject so){
                return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
    }
}
