/*
 
 Copyright (c) 2013, SMB Phone Inc.
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

#import <Foundation/Foundation.h>

#include <openpeer/core/types.h>
#include <openpeer/core/ICache.h>

#import "HOPProtocols.h"

using namespace openpeer;
using namespace openpeer::core;

@class HOPCache;

/**
 Wrapper Class that creates delegate object used in core.
 */
class OpenPeerCacheDelegate : public ICacheDelegate
{
protected:
    id<HOPCacheDelegate> cacheDelegate;
    
    OpenPeerCacheDelegate(id<HOPCacheDelegate> inCacheDelegate);
public:
    /**
     Create OpenPeerCacheDelegate object packed in boost shared pointer.
     @returns OpenPeerCacheDelegate object boost shared object
     */
    static boost::shared_ptr<OpenPeerCacheDelegate>  create(id<HOPCacheDelegate> inCacheDelegate);
    
    virtual String fetch(const char *cookieNamePath);
    virtual SecureByteBlockPtr fetchBinary(const char *cookieNamePath);

    virtual void store(const char *cookieNamePath,Time expires,const char *str);
    virtual void storeBinary(const char *cookieNamePath,Time expires,const SecureByteBlock &buffer);

    virtual void clear(const char *cookieNamePath);
    
};