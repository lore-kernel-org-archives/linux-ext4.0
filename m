From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 15:53:01 -0600
Message-ID: <4D5C473D.5030009@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com> <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca> <4D5C252B.2010102@redhat.com> <20110216214910.GB26780@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1BPVxF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 16:53:05 -0500
In-Reply-To: <20110216214910.GB26780@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/16/11 3:49 PM, Ted Ts'o wrote:
> On Wed, Feb 16, 2011 at 01:27:39PM -0600, Eric Sandeen wrote:
>> On 2/16/11 1:15 PM, Andreas Dilger wrote:
>>> On 2011-02-16, at 11:21, Eric Sandeen wrote:
>>>> User namespace xattrs are generally useful, and I think extN
>>>> is the only filesystem requiring a special mount option to
>>>> enable them, when xattrs are otherwise available.  So this
>>>> change sets that mount option into the defaults.
>>>>
>>>
>>> Wouldn't it be more useful to change this in the kernel, instead of only changing it in the superblock for new filesystems?
>>>
>>
>> I thought about that; maybe it should happen in both places?
> 
> Yes, agreed.  Maybe we should do the same thing with posix ACL's as
> well?  ACL's can only take away access as compared to the unix
> permission bits, so it's safe to enable ACL's.
> 
> 	   	    	      	 	- Ted
> 

Whoops, I didn't realize that acls were in the same boat, of "config on and then turn on with a mount option"

Ok, sure, adding that makes sense to me too...

Is sticking it in the _initialize() function ok with you?  It's a little odd, but ...

-Eric
