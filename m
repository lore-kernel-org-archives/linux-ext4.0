From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: use lazy inode init on some discard-able devices
Date: Mon, 23 Aug 2010 09:32:40 -0500
Message-ID: <4C728688.6080007@redhat.com>
References: <4C6EF67A.5080502@redhat.com> <D416033E-58F9-46F8-B8B0-546C949CB6BE@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab0HWOcq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Aug 2010 10:32:46 -0400
In-Reply-To: <D416033E-58F9-46F8-B8B0-546C949CB6BE@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Aug 20, 2010, at 5:41 PM, Eric Sandeen wrote:
> 
>> If a device supports discard -and- returns 0s for discarded blocks,
>> then we can skip the inode table initialization -and- the inode table
>> zeroing at mkfs time, and skip the lazy init as well since they are
>> already zeroed out.
>> 
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> This needs to be configurable in /etc/mke2fs.conf.  Without naming 
> the manufacturer, I'm aware of at least one device which claims that
> discard works, and will even return zeros --- but after a power
> cycle, if the block has not been reallocated, will once again return
> the old, pre-discard values that had been stored in that block.
> 
> In other words, the discard is not power-cycle persistent...
> 
> -- Ted
> 
> 

yes, I've seen issues like that too.

TBH in that case I'd rather just drop the patch than make another
tunable for the user to figure out...

Making tunables for every permutation of broken hardware doesn't 
scale IMHO. Users will get it wrong often as not, if they even know 
it's there (they'll find out it's there via some web forum or other, 
and it'll become a meme like "set this to go faster" rather than 
understanding all the implications.)

-Eric
