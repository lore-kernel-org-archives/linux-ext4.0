From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Crash after umount'ing a disconnected disk (Re: extfs reliability)
Date: Fri, 06 Aug 2010 17:23:46 +0400
Message-ID: <4C5C0CE2.7030009@vlnb.net>
References: <20100804180325.GL9453@thunk.org> <4C5B1137.1070001@vlnb.net> <20100805211758.GA12358@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976Ab0HFNXu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Aug 2010 09:23:50 -0400
In-Reply-To: <20100805211758.GA12358@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o, on 08/06/2010 01:17 AM wrote:
> On Thu, Aug 05, 2010 at 11:29:59PM +0400, Vladislav Bolkhovitin wrote:
>>> Have you had a chance to check out whether this patch solves the
>>> problem you were complaining with respect to yanking out the last
>>> iSCSI or FC link to a hard drive, and then umounting the disk
>>> afterwards?
>>
>> Looks like it works. I was able to reach that branch (see AAA in the
>> attached log) and it was handled well.
>
> OK, great!
>
>> I've also got other (see the attached log file):
>>
>> 1. A bunch of detected hung tasks with call traces.
>>
>
> Is this unique to ext4?  It looks like a problem where we're either
> (a) not getting an I/O error from the block device in time before we
> get the hung task timeout (which might be the right thing, if the link
> eventually comes back --- what I've seen is there's a no clear
> consensus how long the last FC or iSCSI link should be done before we
> give up on an I/O operation), or (b) for some reason we're not
> noticing the I/O error and waiting forever.  I believe (a) is more
> likely here, but it's possible it's (b).  Do you eventually get file
> system I/O errors that abort the journal transaction?  You should...

Yes, as you can see in the previously attached log.

>> 2. "JBD: recovery failed" I reported before.
>
> I've searched my mail archives, and I'm not sure what you're talking
> about here.  Maybe this was in an e-mail that you sent that perhaps
> got lost?

It's next to the message on which you originally replied. It was about 
ext3, but this time I saw it with ext4.

Thanks,
Vlad
