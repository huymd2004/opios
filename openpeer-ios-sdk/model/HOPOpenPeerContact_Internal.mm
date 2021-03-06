/*
 
 Copyright (c) 2014, Hookflash Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */

#import "HOPOpenPeerContact_Internal.h"
#import <openpeer/core/IHelper.h>
#import "OpenPeerStorageManager.h"
#import "HOPContact.h"
#import "HOPModelManager_Internal.h"
#import "HOPIdentityContact_Internal.h"

@implementation HOPOpenPeerContact

@dynamic stableID;
@dynamic apnsData;
@dynamic identityContacts;
@dynamic publicPeerFile;
@dynamic sessionRecords;
@dynamic participants;

+ (id) createOpenPeerContacFromCoreContact:(IContactPtr) contactPtr conversationThread:(IConversationThreadPtr) conversationThreadPtr
{
    HOPOpenPeerContact* ret = nil;
    
    IdentityContactListPtr identityContactListPtr = conversationThreadPtr->getIdentityContactList(contactPtr);
    
    for (IdentityContactList::iterator identityContactInfo = identityContactListPtr->begin(); identityContactInfo != identityContactListPtr->end(); ++identityContactInfo)
    {
        IdentityContact identityContact = *identityContactInfo;
        if (identityContact.hasData())
        {
            NSString* identityURI = [NSString stringWithUTF8String:identityContact.mIdentityURI];
            HOPIdentityContact* hopIdentityContact = [[HOPModelManager sharedModelManager] getIdentityContactWithIdentityURI:identityURI];
            
            if (!hopIdentityContact)
            {
                NSManagedObject* managedObject = [[HOPModelManager sharedModelManager] createObjectForEntity:@"HOPIdentityContact"];
                if (managedObject && [managedObject isKindOfClass:[HOPIdentityContact class]])
                {
                    hopIdentityContact = (HOPIdentityContact*) managedObject;
                }
            }
            
            if (hopIdentityContact)
            {
                [hopIdentityContact updateWithIdentityContact:identityContact];
                
                ret = [[HOPModelManager sharedModelManager]  getOpenPeerContactForIdentityContact:identityContact];
                if (ret)
                    [ret addIdentityContactsObject:hopIdentityContact];
                else
                    ret = [[HOPModelManager sharedModelManager] createOpenPeerContactForIdentityContact:identityContact];
            }
            
        }
    }
    
    return ret;
}

@end
