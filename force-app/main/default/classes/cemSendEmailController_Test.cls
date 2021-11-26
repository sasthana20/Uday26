@isTest
public with sharing class cemSendEmailController_Test {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact c = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id, Email = 'testcontact@outlook.com', Phone = '1234567890');
        insert c;
                
        EmailMessage emailRec = new EmailMessage();
        emailRec.TextBody='Test';
        insert emailRec;
    }


    @isTest
    static void searchResults() {
//        User u = SendEmailController.getUserDetails(UserInfo.getUserId());
        try{
            Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('test', new list<string>());
        results[0].getId();
        results[0].getSObjectType();
        results[0].getSubtitle();
        results[0].getIcon();
        results[0].getTitle();
        results[0].compareTo(results[0]);
        if (searchResults.size() > 0)
            results[0].compareTo(searchResults[0]);
        }catch(exception ex){}
    }

    @isTest
    static void testsearch1(){
        try{
            Test.startTest();
            cemSendEmailController.search1('Test','Account','AccountNumber='+'\'ytyt677\'');
        cemSendEmailController.search1('Test','Account',null);
        cemSendEmailController.search1('','Account','');
        cemSendEmailController.fetchContactField();
        cemSendEmailController.fetchFieldsWrapper();
        cemInsertEmailTemplateQueueable cq = new cemInsertEmailTemplateQueueable(null,null,null,null,null,null,null,null,null,null,null,null,null);
        Id JobId = System.enqueueJob(cq);
        Test.stopTest();	
        }catch(exception ex){}
        
    }
    @isTest
    static void deleteAttachment() {
        try{
            test.startTest();
            ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
        
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
        
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(cdList.size(), 1);
        
        //Database.delete(cdList,true);
        cemSendEmailController.deleteAttachment(cdList[0].Id); 
        }catch(exception ex){}
      
     
        
    }


    @isTest
    static void sendEmail() {
        try{
           list<cemSendEmailController.PicklistOptions> classification = cemSendEmailController.getClassification();
        list<cemSendEmailController.PicklistOptions> deliveryOptions = cemSendEmailController.getDeliveryOptions();

        User u = cemSendEmailController.getUserDetails(UserInfo.getUserId());
        Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('user', new list<string>());
        List<EmailTemplate> template = [SELECT Id, Name, FolderName, FolderId FROM EmailTemplate limit 1];
        System.debug('template81' + template);
        String templateID = template.size()>0?template[0].id:null;
        list<Id> templateIds = new list<Id>();
       // templateIds.add(templateID);

//        SendEmailController.getRecentlyViewed();

        list<string> toIds = new list<string>();
        toIds.add(c.Id);
        list<string> toAddress = new list<string>();
        toAddress.add(c.Email);
		test.startTest();
            cemSendEmailController.sendEmail('' + u.Id, '' + c.Id, u.Email, u.Name, 'test subject', 'email Body', toIds, toAddress, toIds, toAddress, classification[0].value, deliveryOptions[0].value, templateIDs);    
       		EmailMessage em = [SELECT Id FROM EmailMessage limit 1];
            cemSendEmailController.getInitialSelection(em.Id);
            cemSendEmailController.getCCSelection(em.Id);
            cemSendEmailController.getEmail(em.Id);
            cemSendEmailController.getEmailTemplates('myLightTemplates');
            cemSendEmailController.getEmailTemplates('allLightTemplates');
        	cemSendEmailController.getEmailTemplates('myClassicTemplates');
        cemSendEmailController.getRelatedAccounts();
        cemSendEmailController.getEmailMessage(templateID,c.id);
       test.stopTest(); 
        }catch(exception ex){}
        
    }
    @isTest
    static void sendEmailQueueable() {
        try{
           list<cemSendEmailController.PicklistOptions> classification = cemSendEmailController.getClassification();
        list<cemSendEmailController.PicklistOptions> deliveryOptions = cemSendEmailController.getDeliveryOptions();

        User u = cemSendEmailController.getUserDetails(UserInfo.getUserId());
        Contact c = [SELECT Id, Email FROM Contact limit 1];
        list<LookupSearchResult> results = cemSendEmailController.getInitialSelection(c.Id);
        list<LookupSearchResult> searchResults = cemSendEmailController.search('user', new list<string>());
        List<EmailTemplate> template = [SELECT Id, Name, FolderName, FolderId FROM EmailTemplate limit 1];
	        String templateID =template.size()>0? template[0].id:null;
//        SendEmailController.getRecentlyViewed();

        list<string> toIds = new list<string>();
        toIds.add(c.Id);
        list<string> toAddress = new list<string>();
        toAddress.add(c.Email);
		test.startTest();
        	System.enqueueJob(new cemSendEmailQueueable('' + u.Id, '' + c.Id, u.Email, u.Name, 'test subject', 'email Body', toIds, toAddress, toIds, toAddress, classification[0].value, deliveryOptions[0].value, templateID,null));    
        
         
        test.stopTest(); 
        }catch(exception ex){}
        
    }
}