From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 3/3] ext4: update writeback_index based on last page scanned
Date: Tue, 26 Oct 2010 09:57:14 -0500
Message-ID: <4CC6EC4A.9070702@redhat.com>
References: <4CC2023A.7060607@redhat.com> <4CC205ED.4090007@redhat.com> <20101025213550.GK16981@thunk.org> <4CC5F8FE.6000100@redhat.com> <20101026141454.GL16981@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759687Ab0JZO5U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Oct 2010 10:57:20 -0400
In-Reply-To: <20101026141454.GL16981@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted Ts'o wrote:
> On Mon, Oct 25, 2010 at 04:39:10PM -0500, Eric Sandeen wrote:
>> Not compilebench specifically, but I did do some benchmarking
>> with out of cache buffered IO; to be honest I didn't see
>> striking performance differences, but I did see the writeback
>> behave better in terms of not wandering all over, even if it
>> might recover well.
>>
>> I can try compilebench; do you have specific concerns?
> 
> My specific concern is that what happens if __mpage_da_writepage()
> accumulates 200 pages, but then we were only able to accumulate 50
> pages, and we only write 50 pages.

Be patient with me, but how do we accumulate 200 pages but then only
accumulate 50 pages?

> In the long run what I really want to do is to not call
> clear_page_dirty_for_io() in the renamed write_cache_pages_da(), but
> rather be as greedy as possible about finding dirty/delayed allocate
> pages, and then try to allocate pages for all of them.
> 
> We would then scan the pages for PAGECACHE_TAG_TOWRITE in
> mpage_submit_data_io(), and then write out whatever number of pages we
> need.  At that point we will be a good citizen and writing back what
> the writeback system asks of us --- but we'll be allocating as much
> pages as possible so that the block allocations are sane.  (At that
> point we may find out that the core writeback is screwing us because
> it's not asking us to write back enough; note that XFS decides on its
> own how many pages to writeback in the first call to xfs_writepage(),
> and even if writeback is silly enough to think that XFS should write
> 4MB, then switch to another inode, write 4MB, then write to another
> inode, etc., XFS ignores what writeback asks of it.  But we'll cross
> that road when we get to it....)

Since it works for xfs, we should probably try that direction, but my
early feeble attempts got bogged down in a lot of tangled code.

> So the bottom line is that I believe that what we were doing before is
> wrong; and what we're doing is still wrong, even after your patches.
> I just want to make sure that our performance doesn't go crashing
> through the floor in order to avoid the livelock problem.  (Which I
> agree is a real problem, but we've lived it for quite a while, and I
> haven't seen any evidence of it showing up in production.)

Well, I have a partner-filed bug for that one so I'm motivated ;)

Why would fsync writing only TOWRITE tagged pages cause performance
to crash through the floor?

Note patch 3 doesn't really require patch 2 or vice versa, they
are addressing 2 pretty orthogonal things.

-Eric

> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

