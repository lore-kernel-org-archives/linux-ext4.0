From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: memory leak: data=journal and {collapse,insert,zero}_range
Date: Fri, 20 Nov 2015 13:34:36 +0900
Message-ID: <000001d1234c$c37079b0$4a516d10$@samsung.com>
References: <20151017160230.GA19968@thunk.org>
 <009301d10b2f$b410e6b0$1c32b410$@samsung.com>
 <20151020155443.GM2972@thunk.org>
 <011f01d10be5$099d38d0$1cd7aa70$@samsung.com>
 <20151021145214.GC2165@thunk.org>
 <004301d11aae$72683a40$5738aec0$@samsung.com>
 <20151110144946.GB3156@quack.suse.cz>
 <005901d120f3$1d880410$58980c30$@samsung.com>
 <20151118213651.GI6097@quack.suse.cz> <20151119094240.GB18581@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: 'Jan Kara' <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:42810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410AbbKTEel (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Nov 2015 23:34:41 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NY301835JDQXO60@mailout3.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 20 Nov 2015 13:34:38 +0900 (KST)
In-reply-to: <20151119094240.GB18581@quack.suse.cz>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> 
> On Wed 18-11-15 22:36:51, Jan Kara wrote:
> > On Tue 17-11-15 13:47:50, Namjae Jeon wrote:
> > > > On Mon 09-11-15 14:21:11, Namjae Jeon wrote:
> > > > > >
> > > > > > On Wed, Oct 21, 2015 at 06:44:10PM +0900, Namjae Jeon wrote:
> > > > > > > > Interestingly we're not seeing these memory leaks on the truncate
> > > > > > > > path, so I suspect the issue is in how collapse range is clearing
> > > > > > > > pages from the page cache, especially pages that were freshly written
> > > > > > > > to the journal by the commit but which hadn't yet been writtten to
> > > > > > > > disk and then marked as complete so we can allow the relevant
> > > > > > > > transaction to be checkpointed.  (Although we're not leaking the
> > > > > > > > journal head structures, but only the buffer heads, so the story most
> > > > > > > > be a bit more complicated than that.)
> > > > > > >
> > > > > > > Okay, Thanks for sharing your view and points !!
> > > > > > >
> > > > > > > Currently I can reproduce memory leak issue without collase/insert/zero range.
> > > > > > > conditions like the following.(collase/insert/zero range are disable with -I -C -z option
> and
> > > > add -y
> > > > > > option instead of -W)
> > > > > > >   1. small size parition(1GB)
> > > > > > >   2. run fsx with these options "./fsx -N 30000 -o 128000 -l 500000 -r 4096 -t 512 -w 512
> -Z -R
> > > > -y -
> > > > > > I -C -z testfile"
> > > > > > > And same result with generic/091 is showing (buffer_head leak)
> > > > > > >
> > > > > > > So I am starting to find root-cause base on your points.
> > > > > > > I will share the result or the patch.
> > > > > >
> > > > > > Thanks, that's very interesting data point.  So this makes it appear
> > > > > > that the problem *is* probably with how we deal with checkpointing
> > > > > > buffers after the pages get discarded using either a truncate or a
> > > > > > collapse_range, since the 'y' option causes a lot fsync's, and hence
> > > > > > commits, some of which are happening after a truncate command.
> > > > > >
> > > > > > Thanks for a taking a look at this.  I really appreciate it.
> > > > > >
> > > > > > Cheers,
> > > > >
> > > > >
> > > > > Hi Ted,
> > > > >
> > > > > Could you review this patch?
> > > > >
> > > > > Thanks!
> > > > > ---------------------------------------------------------------------------------
> > > > > Subject: [PATCH] jbd2: try to free buffers from truncated page after
> > > > >  checkpoint
> > > > >
> > > > > when ext4 is mounted in data=journal mode, and truncate operation
> > > > > such as settatr(size), collopse, insert and zero range are used, there are
> > > > > are many truncated pages with NULL page->mapping. Such truncated pages
> > > > > pile up quickly due to truncate_pagecache on data pages associated with journal.
> > > > > As page->mapping is NULL for such truncated pages, they are not freed
> > > > > by drop cache(3) or umount. As a result, MemFree in /proc/meminfo decreases
> > > > > quickly and active buffer_head slab objects grow in /proc/slabinfo.
> > > > > This patch attempts to free buffers from such pages at the end of jbd2
> > > > > checkpoint, if pages do not have any busy buffers and NULL mapping.
> > > >
> > > > Hum, why such pages didn't get freed by release_buffer_page() call
> > > > happening when processing transaction's forget list? Because the idea is
> > > > that such pages should be discarded at that point...
> > > Hi Jan,
> > >
> > > When I checked this code, release_buffer_page is not called
> > > when buffer_jbddirty is true. Such buffers with JBD_Dirty are added
> > > to new checkpoint.
> > >
> > >                 if (buffer_jbddirty(bh)) {
> > >                        JBUFFER_TRACE(jh, "add to new checkpointing trans");
> > >                        __jbd2_journal_insert_checkpoint(jh, commit_transaction);
> > >                        if (is_journal_aborted(journal))
> > >                                clear_buffer_jbddirty(bh);
> > >                 } else {
> > >                        J_ASSERT_BH(bh, !buffer_dirty(bh));
> > >                        /*
> > >                         * The buffer on BJ_Forget list and not jbddirty means
> > >                         * it has been freed by this transaction and hence it
> > >                         * could not have been reallocated until this
> > >                         * transaction has committed. *BUT* it could be
> > >                         * reallocated once we have written all the data to
> > >                         * disk and before we process the buffer on BJ_Forget
> > >                         * list.
> > >                         */
> > >                        if (!jh->b_next_transaction)
> > >                                try_to_free = 1;
> > >                 }
> > >                 JBUFFER_TRACE(jh, "refile or unfile buffer");
> > >                 __jbd2_journal_refile_buffer(jh);
> > >                 jbd_unlock_bh_state(bh);
> > >
> > > Next buffer was unfiled by __jbd2_journal_refile_buffer, JBD_Dirty cleared and
> > > BH_Dirty was set in same function. Later it must have been written back as
> > > BH_Dirty was cleared.
> > > And ext4_wait_for_tail_page_commit-> __ext4_journalled_invalidatepage ->
> > > journal_unmap_buffer zaps the buffer:
> > >
> > >                 if (!buffer_dirty(bh)) {
> > >                         /* bdflush has written it.  We can drop it now */
> > >                         goto zap_buffer;
> > >                 }
> > >
> > > next, truncate_pagecache is called, which clears the page mapping.
> > > Eventually, remove checkpoint is called, but such page with NULL mapping was
> > > not freed. So, I had added release_buffer_page at the end of remove checkpoint
> > > to attempt to free such free buffer pages. Please let me know your opinion.
> >
> > OK, thanks for the detailed analysis. But when the buffer gets truncated,
> > jbd2_journal_invalidatepage() either removes the buffer from the
> > transaction (obviously didn't happen here) or it sets buffer_freed and
> > buffer_jbddirty should get cleared when processing the BJ_Forget list. So
> > why that didn't happen? Can you have a look into what
> > jbd2_journal_invalidatepage() did to buffer in that page?
> >
> > Generally truncated buffers should not enter checkpoint list since writing
> > them is just a waste of disk bandwidth...
> 
> I thought a bit more about this and my guess is that
> jbd2_journal_invalidatepage() fails to invalidate the partial page and
> returns EBUSY. However we should see warnings about that from
> ext4_journalled_invalidatepage(). Can you see them? This would perfectly
> match Ted's observation that the problem happens only for fallocate
> operations but not for truncate which does the dance with
> ext4_wait_for_tail_page_commit() but fallocate operations don't do it...
> 
> Now if I'm right and this is indeed the path we are hitting, we need to put
> more thought into how we handle truncation of partial pages in data=journal
> mode.
Actually, I can quickly create memleak with simple testcase like:
while(1000)
{
Random seek(max 500M) -> write 1M -> fsync ->truncate(random size)
}

As there is significant memleak in this situation also, I started focusing
on this simple testcase only. When use this testcase, I never saw EBUSY path
in jbd2_journal_invalidatepage() -> journal_unmap_buffer().

On the other hand(), for memleak pages jbd2_journal_invalidatepage() ->
journal_unmap_buffer() was almost bailing out every time from
                if (!buffer_dirty(bh)) {
                        /* bdflush has written it.  We can drop it now */
                        goto zap_buffer;
                }

As per debugging, NULL mapping page or buffer is created in below scenario:
Write(or Kjournald) -> jbd2_journal_commit_transaction
                    -> BH_JBDDirty buffer is added to forget list.
                    -> Buffer is added to new checkpoint,
                       additional reference count is taken on b_jcount which
                       keeps buffer busy until remove checkpoint.
                    -> Buffer is unfiled, removed from forget list, BH_JBDDirty
                       is cleared and BH_Dirty is set, it is exposed to VM. 


As BH_Dirty is set, buffer is written by ext4_writepage by flusher.
ext4_writepage finally clears BH_Dirty.

Now, ftruncate is called, almost every time code is returned from below path:
Ftruncate -> jbd2_journal_invalidatepage -> journal_unmap_buffer
                if (!buffer_dirty(bh)) {
                        /* bdflush has written it.  We can drop it now */
                        goto zap_buffer;
                }

page was not released by jbd2_journal_invalidatepage, mainly because b_jcount
was 2 on entry of jbd2_journal_invalidatepage (addional reference by insert
checkpoint above), buffer state was sane.
At exit time jbd2_journal_invalidatepage, b_jcount is still 1.

Next, truncate_pagecache is called which makes page mapping NULL.
Later, __jbd2_journal_remove_checkpoint is called, it makes b_jcount zero and
remove BH_JBD from buffer. Such pages with NULL mapping pages are not freed.
Previous patch fixed this leak if try release_page_buffer at the end of
checkpoint.

> 
> BTW: The ext4_force_commit() call in fallocate operations is definitely
> racy as pages can get dirtied and journalled in the running transaction
> anytime while we wait for transaction commit (which I suspect is happening
> in your testcase)... So that needs some more thought as well.
Need to check more on this. I can reproduce memleak without fsync
(i.e. ext4_force_commit), though it is less.

Thanks!
> 
> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

