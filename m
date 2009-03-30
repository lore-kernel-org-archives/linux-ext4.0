From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext3: Avoid false EIO errors
Date: Mon, 30 Mar 2009 10:12:41 -0500
Message-ID: <49D0E169.7020101@redhat.com>
References: <1238091711-23464-1-git-send-email-jack@suse.cz> <20090327180806.GB2810@skywalker> <20090327202421.GB31071@duck.suse.cz> <20090330082532.GA15488@skywalker> <49D0CEE6.2060409@redhat.com> <20090330144523.GA14489@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbZC3POA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Mar 2009 11:14:00 -0400
In-Reply-To: <20090330144523.GA14489@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Mar 30, 2009 at 08:53:42AM -0500, Eric Sandeen wrote:
>> Aneesh Kumar K.V wrote:
>>
>>> We do a vmtruncate if we failed to allocate blocks in
>>> ext3_write_begin. That is done after the closing the current
>>> transaction. If we crash in between (ie, after committing the
>>> transaction allocating blocks and before committing the transaction that
>>> is doing truncate) we would only have  some data blocks leaking. But
>>> that would be better than user seeing zero's in the file ?. Also if we
>>> happen to add the inode to the orphan list and crash, the recovery would
>>> truncate it properly. So by doing a vmtruncate I guess the window would be
>>> small and we are already doing that in ext3_write_begin.
>> I don't agree that leaking data blocks is better than exposing zeros...
>> the former is a security flaw, the latter a (significant) annoyance.
>>
> 
> Even when we fail to track few data blocks we do zero them using 
> page_zero_new_buffers. So it should not imply a security flaw. I guess
> if we crash failing to commit the truncate fsck will look at the bitmap
> and find the blocks which are not tracked by any inode and will mark them
> free.

Oh, perhaps I misunderstood.  I thought you meant leaking data in
uninitialized blocks, but you meant losing track of those blocks'
allocation, I guess.  Sorry for the confusion...

-Eric
