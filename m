From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: query about truncate and orphan list
Date: Thu, 30 Aug 2012 14:54:33 +0530
Message-ID: <CAOiN93=g-Fj-7+BbFEi2D0O8dRkLCCKttSD7MsuLODgqLUP8hQ@mail.gmail.com>
References: <CAOiN93=uvi37EMuOYvd+Nr2up=giPikL+sLEOFTpqOzyHi+Tfw@mail.gmail.com>
	<20120829131758.GA21169@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64892 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2H3JYe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2012 05:24:34 -0400
Received: by vcbfk26 with SMTP id fk26so1629033vcb.19
        for <linux-ext4@vger.kernel.org>; Thu, 30 Aug 2012 02:24:33 -0700 (PDT)
In-Reply-To: <20120829131758.GA21169@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 29, 2012 at 6:47 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 29-08-12 14:52:22, Ashish Sangwan wrote:
>> I have a query about orphan list and truncate.
>> Currently these steps are performed in ext4_ext_truncate():
>> a) Start journal handle.
>> b) add inode to orphan list.
>> c) i_disksize is updated and inode is mark dirty.
>> d) actual truncate happen.
>> e) remove inode from orphan list.
>> f) handle stop.
>>
>> If system crash during step d) will i_disksize is actually updated on disk?
>> AFAIK i_disksize might be updated on the journal but not on its
>> original location because the transaction is not commited yet.
>   Yes, that can happen.
>
Ok,
To test it, I inserted a 10 seconds sleep between d) and e)
I created a 10MB file on new ext4 partition and tried to truncate it to 10KB.
After waiting for 10 seconds, unplug the device.
On remount, the inode was not present on the orphan list.
No matter how many times I repeat this operation, result is same.

After that I inserted a call to ext4_journal_restart() between step c)
and d.) and repeat the above operation.
This time the inode was present on orphan list and i_disksize was
updated (10KB) correctly too.
Is it the correct thing to do?

pardon me if my question seems silly. I am just trying to learn basics
about ext4 journalling.

Thanks,
Ashish
>> If this is the case than what is the use of re-starting truncate
>> operation while processing orphan inode list?
>   Because it can be on disk (noone guarantees when a transaction commits)
> and in that case we have to perform the truncate because some of the blocks
> might have been already freed by a transaction which is also committed.
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
