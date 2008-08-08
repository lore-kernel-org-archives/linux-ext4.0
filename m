From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] jbd jbd2: fix dio write
	returningEIOwhentry_to_release_page fails
Date: Fri, 08 Aug 2008 08:54:15 -0400
Message-ID: <1218200055.15342.230.camel@think.oraclecorp.com>
References: <6.0.0.20.2.20080804185338.03bcd488@172.19.0.2>
	 <20080804145047.04794bf3.akpm@linux-foundation.org>
	 <1217907353.7611.39.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080805134429.044569a0@172.19.0.2>
	 <1217953055.7899.11.camel@think.oraclecorp.com>
	 <1217971027.7516.20.camel@mingming-laptop>
	 <1218029114.15342.58.camel@think.oraclecorp.com>
	 <20080806135337.GA3615@duck.suse.cz>
	 <1218063477.6383.41.camel@mingming-laptop>
	 <6.0.0.20.2.20080807115853.03f95b78@172.19.0.2>
	 <1218104494.15342.171.camel@think.oraclecorp.com>
	 <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:17815 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYHHNBO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2008 09:01:14 -0400
In-Reply-To: <6.0.0.20.2.20080808113605.04141328@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-08-08 at 12:28 +0900, Hisashi Hifumi wrote:
> At 19:21 08/08/07, Chris Mason wrote:
> >On Thu, 2008-08-07 at 12:15 +0900, Hisashi Hifumi wrote:
> >> >/*
> >> > * This is like invalidate_complete_page(), except it ignores the page's
> >> > * refcount.  We do this because invalidate_inode_pages2() needs
> >> >stronger
> >> > * invalidation guarantees, and cannot afford to leave pages behind
> >> >because
> >> > * shrink_page_list() has a temp ref on them, or because they're
> >> >transiently
> >> > * sitting in the lru_cache_add() pagevecs.
> >> > */
> >> >
> >> >
> >> >I am wondering why we need stronger invalidate hurantees for DIO->
> >> >invalidate_inode_pages_range(),which force the page being removed from
> >> >page cache? In case of bh is busy due to ext3 writeout,
> >> >journal_try_to_free_buffers() could return different error number(EBUSY)
> >> >to try_to_releasepage() (instead of EIO).  In that case,  could we just
> >> >leave the page in the cache, clean pageuptodate() (to force later buffer
> >> >read to read from disk) and then invalidate_complete_page2() return
> >> >successfully? Any issue with this way?
> >> 
> >> My idea is that journal_try_to_free_buffers returns EBUSY if it fails due to
> >> bh busy, and dio write falls back to buffered write. This is easy to fix.
> >> 
> >> 
> >
> >What about the invalidates done after the DIO has already run
> >non-buffered?
> 
> Dio write falls back to buffered IO when writing to a hole on ext3, I think. I want to 
> apply this mechanism to fix this issue. When try_to_release_page fails on a page 
> due to bh busy, dio write does buffered write, sync_page_range, and 
> wait_on_page_writeback, imvalidates page cache to preserve dio semantics. 
> Even if page invalidation that is carried out after wait_on_page_writeback fails, 
> there is no inconsistency between HDD and page cache.
> 

Sorry, I'm sure I wasn't very clear, I was referencing this code from
mm/filemap.c:

        written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);

        /*
         * Finally, try again to invalidate clean pages which might have been
         * cached by non-direct readahead, or faulted in by get_user_pages()
         * if the source of the write was an mmap'ed region of the file
         * we're writing.  Either one is a pretty crazy thing to do,
         * so we don't support it 100%.  If this invalidation
         * fails, tough, the write still worked...
         */
        if (mapping->nrpages) {
                invalidate_inode_pages2_range(mapping,
                                              pos >> PAGE_CACHE_SHIFT, end);
        }

If this second invalidate fails during a DIO write, we'll have up to
date pages in cache that don't match the data on disk.  It is unlikely
to fail because the conditions that make jbd unable to free a buffer are
rare, but it can still happen with the write combination of mmap usage.

The good news is the second invalidate doesn't make O_DIRECT return
-EIO.  But, it sounds like fixing do_launder_page to always call into
the FS can fix all of these problems.  Am I missing something?

-chris


