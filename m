From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Add a norecovery option to ext3/4?
Date: Wed, 11 Apr 2007 16:09:32 -0400
Message-ID: <461D407C.3030706@tmr.com>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com> <461BDD48.2000904@cfl.rr.com> <461BE2FB.5090101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phillip Susi <psusi@cfl.rr.com>,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	joern@lazybastard.org, tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:35470 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030470AbXDKUWX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 16:22:23 -0400
In-Reply-To: <461BE2FB.5090101@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> Phillip Susi wrote:
>> Eric Sandeen wrote:

>>> In that case you are mounting the same filesystem uner 2 different
>>> operating systems simultaneously, which is, and always has been, a
>>> recipe for disaster.  Flagging the fs as "mounted already" would
>>> probably be a better solution, though it's harder than it sounds at
>>> first glance.
>> No, it has not been.  Prior to poorly behaved journal playback, it was 
>> perfectly safe to mount a filesystem read only even if it was mounted 
>> read-write by another system ( possibly fsck or defrag ).  You might not 
>> read the correct data from it, but you would not damage the underlying 
>> data simply by mounting it read-only.
> 
> You might not damage the underlying filesystem, but you could sure go
> off in the weeds trying to read it, if you stumbled upon some
> half-updated metadata... so while it may be safe for the filesystem, I'm
> not convinced that it's safe for the host reading the filesystem.
> 
Exactly. If the data are protected you can use other software to access 
it. For ext3 an explicit ext2 mount might do it... but if you corrupt 
the underlying information, there's no going back.

In practice Linux has had lots of practice mounting garbage, and isn't 
likely to suffer terminal damage.

I wonder what happens if the device is really read-only and the o/s 
tries to replay the journal as part of a r/o mount? I suspect the system 
will refuse totally with an i/o error, not what you want.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
