public with sharing class CopyObjectByFieldSetsHelper {

    public static String FieldNameCustomPart = '__c';

    public static WebOrder__c getWebOrderByOpportunityId(Id opportunityId, List<WebOrder__c> webOrdersList) {
        for(WebOrder__c webOrder : webOrdersList) {
            if (webOrder.OpportunityId__c == opportunityId) {
                return webOrder;
            }
        }

        return null;
    }

    public static Opportunity getOpportunityByWebOrderId(Id webOrderId, List<Opportunity> opportunityList) {
        for(Opportunity opportunity : opportunityList) {
            if (opportunity.WebOrderId__c == webOrderId) {
                return opportunity;
            }
        }

        return null;
    }

    public static boolean compareOpportunityAndWebObjectFields(Opportunity opportunity, Set<String> fromFieldsList, List<String> toFieldsList, WebOrder__c webOrder) {
        for(String webOrderField : toFieldsList) {
            String ooprtunityField = getWebOrderFieldApi(webOrderField, fromFieldsList);

            if (opportunity.get(ooprtunityField) != webOrder.get(webOrderField)) {
                return false;
            }
        }

        return true;
    }

    public static boolean compareWebObjectAndOpportunityFields(Opportunity opportunity, Set<String> fromFieldsList, List<String> toFieldsList, WebOrder__c webOrder) {
        for(String ooprtunityField : toFieldsList) {
            String webOrderField = getOpportunityFieldApi(ooprtunityField, fromFieldsList);

            if (opportunity.get(ooprtunityField) != webOrder.get(webOrderField)) {
                return false;
            }
        }

        return true;
    }

    public static WebOrder__c putWebOrderFields(Opportunity opportunity, Set<String> fromFieldsList, List<String> toFieldsList, WebOrder__c webOrder) {
        webOrder = webOrder != null ? webOrder : new WebOrder__c();

        for(String webOrderField : toFieldsList) {
            String ooprtunityField = getWebOrderFieldApi(webOrderField, fromFieldsList);

            if (ooprtunityField != null) {
                webOrder.put(webOrderField, opportunity.get(ooprtunityField));
            }
        }

        webOrder.OpportunityId__c = opportunity.Id;
        return webOrder;
    }

    public static Opportunity putOpportunityFields(Opportunity opportunity, Set<String> fromFieldsList, List<String> toFieldsList, WebOrder__c webOrder) {
        opportunity = opportunity != null ? opportunity : new Opportunity();

        for(String opportunityField : toFieldsList) {
            String webOrderField = getOpportunityFieldApi(opportunityField, fromFieldsList);

            System.debug('webOrderField: ' + webOrderField + ' opportunityField: ' + opportunityField);
            if (webOrderField != null) {
                opportunity.put(opportunityField, webOrder.get(webOrderField));
            }
        }
        opportunity.WebOrderId__c = webOrder.Id;
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

    public static String getWebOrderFieldApi(String searchFieldName, Set<String> fieldNameCollection) {
        if (fieldNameCollection.contains(searchFieldName.toLowerCase())) { return searchFieldName; }

        String cutedFieldName = searchFieldName.removeEnd(FieldNameCustomPart);
        if (fieldNameCollection.contains(cutedFieldName.toLowerCase())) { return cutedFieldName; }

        return null;
    }

    public static String getOpportunityFieldApi(String searchFieldName, Set<String> fieldNameCollection) {
        if (fieldNameCollection.contains(searchFieldName.toLowerCase())) { return searchFieldName; }

        String fullFieldName = searchFieldName + FieldNameCustomPart;
        if (fieldNameCollection.contains(fullFieldName.toLowerCase())) { return fullFieldName; }

        return null;
    }
}
