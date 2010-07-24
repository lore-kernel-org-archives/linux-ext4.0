From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Ext4: batched discard support - simplified version
Date: Sat, 24 Jul 2010 12:31:48 -0400
Message-ID: <4C4B1574.4050608@redhat.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com> <20100723143604.GF13090@thunk.org> <x49hbjqjknj.fsf@segfault.boston.devel.redhat.com> <20100723151925.GI13090@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>, eshishki@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969Ab0GXQck (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Jul 2010 12:32:40 -0400
In-Reply-To: <20100723151925.GI13090@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/23/2010 11:19 AM, Ted Ts'o wrote:
> On Fri, Jul 23, 2010 at 11:13:52AM -0400, Jeff Moyer wrote:
>    
>> I don't think so.  In all of the configurations tested, I'm pretty sure
>> we saw a performance hit from doing the TRIMs right away.  The queue
>> flush really hurts.  Of course, I have no idea what you had in mind for
>> the amount of time in between batched discards.
>>      
> Sure, but not all the world is SATA-attached SSD's.  I'm thinking in
> particular of PCIe-attached SSD's, where the TRIM command might be
> very fast indeed...  I believe Ric Wheeler tells me you have TMS
> RamSan SSD's in house that you are testing?  And of course those
> aren't the only PCIe-attached flash devices out there....
>
>         	   		      	    	    	- Ted
>    

I think that some of the PCI-e cards might want that information right 
away, a lot of high end arrays actually prefer fewer larger chunks.

One other user might be virtual devices or some remote replication 
mechanism. I wonder if the drbd people for example might (do?) use these?

ric

