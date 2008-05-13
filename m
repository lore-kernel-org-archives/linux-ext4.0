From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Mon, 12 May 2008 17:39:43 -0700
Message-ID: <1210639184.3661.43.camel@localhost.localdomain>
References: <20080306174209.GA14193@duck.suse.cz>
	 <1209166706.6040.20.camel@localhost.localdomain>
	 <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37860 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYEMAj4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 May 2008 20:39:56 -0400
In-Reply-To: <20080512155419.GD15856@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
>   Hello,
> 
> On Fri 09-05-08 15:27:52, Mingming Cao wrote:
> > > > I was able to reproduce the customer problem involving DIO
> > > > (invalidate_inode_pages2) problem by writing simple testcase
> > > > to keep writing to a file using buffered writes and DIO writes
> > > > forever in a loop. I see DIO writes fail with -EIO.
> > > > 
> > > > After a long debug, found 2 cases how this could happen.
> > > > These are race conditions with journal_try_to_free_buffers()
> > > > and journal_commit_transaction().
> > > > 
> > > > 1) journal_submit_data_buffers() tries to get bh_state lock. If
> > > > try lock fails, it drops the j_list_lock and sleeps for
> > > > bh_state lock, while holding a reference on the buffer.
> > > > In the meanwhile, journal_try_to_free_buffers() can clean up the
> > > > journal head could call try_to_free_buffers(). try_to_free_buffers()
> > > > would fail due to the reference held by journal_submit_data_buffers()
> > > > - which in turn causes failues for DIO (invalidate_inode_pages2()).
> > > > 
> > > > 2) When the buffer is on t_locked_list waiting for IO to finish,
> > > > we hold a reference and give up the cpu, if we can't get
> > > > bh_state lock. This causes try_to_free_buffers() to fail.
> > > > 
> > > > Fix is to drop the reference on the buffer if we can't get
> > > > bh_state lock, give up the cpu and re-try the whole operation -
> > > > instead of waiting for the vh_state lock.
> > > > 
> > > > Does this look like a resonable fix ?
> > >   As Mingming pointed out there are few other places where we could hold
> > > the bh reference. Note also that we accumulate references to buffers in the
> > > wbuf[] list and we need that for submit_bh() which consumes one bh
> > > reference. Generally, it seems to me as a too fragile and impractical
> > > rule "nobody can hold bh reference when not holding page lock" which is
> > > basically what it comes down to if you really want to be sure that
> > > journal_try_to_free_buffers() succeeds. And also note that in principle
> > > there are other places which hold references to buffers without holding the
> > > page lock - for example writepage() in ordered mode (although this one is
> > > in practice hardly triggerable). So how we could fix at least the races
> > > with commit code is to implement launder_page() callback for ext3/4 which
> > > would wait for the previous transaction commit in case the page has buffers
> > > that are part of that commit (I don't want this logic in
> > > journal_try_to_free_buffers() as that is called also on memory-reclaim
> > > path, but journal_launder_page() is fine with me). 
> > 
> > I am not sure how we are going to gurantee that by the time
> > journal_try_to_free_buffers() get called, the page has buffers are not
> > as part of the current transaction commit(which could be different than
> > the one we waited in ext3_launder_page())?  
>   Hmm, you are right. It is not enough to just wait in ext3_launder_page()
> because we don't have a transaction for direct_IO started yet. But if we
> actually released buffers from the page there, it should be fine.

Does this match what you are thinking? It certainly slow down the DIO
path, but the positive side is it doesn't disturb the other code path...
thanks for your feedback!

--------------------------------------------

An unexpected EIO error gets returned when writing to a file
using buffered writes and DIO writes at the same time.

We found there are a number of places where journal_try_to_free_buffers()
could race with journal_commit_transaction(), the later still
helds the reference to the buffers on the t_syncdata_list or t_locked_list
, while journal_try_to_free_buffers() tries to free them, which resulting an EIO
error returns back to the dio caller. 

The logic fix is to retry freeing if journal_try_to_free_buffers() to failed
to free those data buffers while journal_commit_transaction() is still
reference those buffers.
This is done via implement ext3 launder_page() callback, instead of inside
journal_try_to_free_buffers() itself, so that it doesn't affecting other code
path calling journal_try_to_free_buffers and only dio path get affected.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Index: linux-2.6.26-rc1/fs/ext3/inode.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
@@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
 	return __set_page_dirty_nobuffers(page);
 }
 
+static int ext3_launder_page(struct page *page)
+{
+        int ret;
+	int retry = 5;
+
+	while (retry --) {
+		ret = ext3_releasepage(page, GFP_KERNEL);
+		if (ret == 1)
+			break;
+		else
+			schedule();
+	}
+
+        return ret;
+}
+
+
 static const struct address_space_operations ext3_ordered_aops = {
 	.readpage	= ext3_readpage,
 	.readpages	= ext3_readpages,
@@ -1778,6 +1795,7 @@ static const struct address_space_operat
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.launder_page	= ext3_launder_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
@@ -1792,6 +1810,7 @@ static const struct address_space_operat
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.launder_page	= ext3_launder_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
@@ -1805,6 +1824,7 @@ static const struct address_space_operat
 	.bmap		= ext3_bmap,
 	.invalidatepage	= ext3_invalidatepage,
 	.releasepage	= ext3_releasepage,
+	.launder_page	= ext3_launder_page,
 };
 
 void ext3_set_aops(struct inode *inode)




