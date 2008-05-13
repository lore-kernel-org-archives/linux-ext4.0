From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] jbd_commit_transaction() races with
	journal_try_to_drop_buffers() causing DIO failures
Date: Tue, 13 May 2008 15:23:09 -0700
Message-ID: <1210717389.3638.24.camel@localhost.localdomain>
References: <20080428122626.GC17054@duck.suse.cz>
	 <1209402694.23575.5.camel@badari-desktop>
	 <20080428180932.GI17054@duck.suse.cz>
	 <1209409764.11872.6.camel@localhost.localdomain>
	 <20080429124321.GD1987@duck.suse.cz>
	 <1209654981.27240.19.camel@badari-desktop>
	 <20080505170636.GK25722@duck.suse.cz>
	 <1210372072.3639.52.camel@localhost.localdomain>
	 <20080512155419.GD15856@duck.suse.cz>
	 <1210639184.3661.43.camel@localhost.localdomain>
	 <20080513145449.GC20806@duck.suse.cz>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Badari Pulavarty <pbadari@us.ibm.com>, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58205 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770AbYEMWXS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 May 2008 18:23:18 -0400
In-Reply-To: <20080513145449.GC20806@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-05-13 at 16:54 +0200, Jan Kara wrote:
> On Mon 12-05-08 17:39:43, Mingming Cao wrote:
> > On Mon, 2008-05-12 at 17:54 +0200, Jan Kara wrote:
> > Does this match what you are thinking? It certainly slow down the DIO
> > path, but the positive side is it doesn't disturb the other code path...
> > thanks for your feedback!
> > 
> > --------------------------------------------
> > 
> > An unexpected EIO error gets returned when writing to a file
> > using buffered writes and DIO writes at the same time.
> > 
> > We found there are a number of places where journal_try_to_free_buffers()
> > could race with journal_commit_transaction(), the later still
> > helds the reference to the buffers on the t_syncdata_list or t_locked_list
> > , while journal_try_to_free_buffers() tries to free them, which resulting an EIO
> > error returns back to the dio caller. 
> > 
> > The logic fix is to retry freeing if journal_try_to_free_buffers() to failed
> > to free those data buffers while journal_commit_transaction() is still
> > reference those buffers.
> > This is done via implement ext3 launder_page() callback, instead of inside
> > journal_try_to_free_buffers() itself, so that it doesn't affecting other code
> > path calling journal_try_to_free_buffers and only dio path get affected.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > Index: linux-2.6.26-rc1/fs/ext3/inode.c
> > ===================================================================
> > --- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-03 11:59:44.000000000 -0700
> > +++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-12 12:41:27.000000000 -0700
> > @@ -1766,6 +1766,23 @@ static int ext3_journalled_set_page_dirt
> >  	return __set_page_dirty_nobuffers(page);
> >  }
> >  
> > +static int ext3_launder_page(struct page *page)
> > +{
> > +        int ret;
> > +	int retry = 5;
> > +
> > +	while (retry --) {
> > +		ret = ext3_releasepage(page, GFP_KERNEL);
> > +		if (ret == 1)
> > +			break;
> > +		else
> > +			schedule();
> > +	}
> > +
> > +        return ret;
> > +}
> > +
> > +
>   Yes, I meant something like this. We could be more clever and do:
> 
> 	head = bh = page_buffers(page);
> 	do {
> 		wait_on_buffer(bh);
> 		bh = bh->b_this_page;
> 	} while (bh != head);
> 	/*
> 	 * Now commit code should have been able to proceed and release
>          * those buffers
> 	 */
>         schedule();
> 

Bummer, we can't free buffers in ext3_launder_page() before calling
try_to_free_page, as later
invalidate_complete_page2()->try_to_free_page() expecting the page
buffers are still here, and will return EIO if it launder_page() has
already freed those buffers.:(

Doing wait_on_buffer() alone in launder_page() is not enough as it
doesn't wait for buffer reference drop to 0.

> or we could do simple:
> 	log_wait_commit(...);
> 
> That would impose larger perf. penalty but on the other hand you shouldn't
> hit this path too often. 

Guess this is the last it worth give a try to see how bad it is, here is
a draft patch. Do you see any obvious problems?

Mingming


Signed-off-by: Mingming Cao <cmm@us.ibm.com>
 fs/ext3/inode.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

Index: linux-2.6.26-rc1/fs/ext3/inode.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/ext3/inode.c	2008-05-13 13:35:27.000000000 -0700
+++ linux-2.6.26-rc1/fs/ext3/inode.c	2008-05-13 14:33:55.000000000 -0700
@@ -1766,6 +1766,53 @@ static int ext3_journalled_set_page_dirt
 	return __set_page_dirty_nobuffers(page);
 }
 
+/*
+ * There are a number of places where journal_try_to_free_buffers()
+ * could race with journal_commit_transaction(), the later still
+ * helds the reference to the buffers on the t_syncdata_list or t_locked_list
+ * while journal_try_to_free_buffers() tries to free them,
+ * which resulting an EIO error returns back to the generic_file_direct_IO()
+ *
+ * It is also possible that mapped IO could re-dirty the page and buffers
+ * after direct IO has waited dirty pages have been flush to disk.
+ * When the journal_try_to_free_buffers() is called from the direct IO
+ * path, it may failed to free the buffers as the buffer may be locked again
+ *
+ * To fix this problem, we add a ext3_launder_page() callback which
+ * is only called on direct IO path, to wait for the buffer unlocked
+ * and waiting for the jbd finish commit those data buffers.
+ *
+ * This will impact the direct IO perf, but this alows direct IO and
+ * buffered IO could be performed concurrently.
+ *
+ * returns 0 in sucess case, and non zero in failure case.
+ */
+static int ext3_launder_page(struct page *page)
+{
+	int ret = 0;
+	struct buffer_head *head;
+	struct buffer_head *bh;
+	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
+
+	head = bh = page_buffers(page);
+	do {
+		/*
+		 * it's possible mapped IO re-dirty and locked the
+		 * buffer again when we came here
+		 */
+		if (buffer_locked(bh)) {
+			get_bh(bh);
+			wait_on_buffer(bh);
+			put_bh(bh);
+		}
+
+		journal_wait_commit_buffer(journal, bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+        return ret;
+}
+
 static const struct address_space_operations ext3_ordered_aops = {
 	.readpage	= ext3_readpage,
 	.readpages	= ext3_readpages,
@@ -1778,6 +1825,7 @@ static const struct address_space_operat
 	.releasepage	= ext3_releasepage,
 	.direct_IO	= ext3_direct_IO,
 	.migratepage	= buffer_migrate_page,
+	.launder_page	= ext3_launder_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
Index: linux-2.6.26-rc1/fs/jbd/journal.c
===================================================================
--- linux-2.6.26-rc1.orig/fs/jbd/journal.c	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/fs/jbd/journal.c	2008-05-13 14:43:47.000000000 -0700
@@ -74,6 +74,7 @@ EXPORT_SYMBOL(journal_errno);
 EXPORT_SYMBOL(journal_ack_err);
 EXPORT_SYMBOL(journal_clear_err);
 EXPORT_SYMBOL(log_wait_commit);
+EXPORT_SYMBOL(journal_wait_commit_buffer);
 EXPORT_SYMBOL(journal_start_commit);
 EXPORT_SYMBOL(journal_force_commit_nested);
 EXPORT_SYMBOL(journal_wipe);
@@ -558,6 +559,46 @@ int log_wait_commit(journal_t *journal, 
 }
 
 /*
+ * Wait for a specific buffer has committed to the log
+ */
+int journal_wait_commit_buffer(journal_t *journal, struct buffer_head *bh)
+{
+	int ret = 0;
+	struct journal_head * jh;
+	transaction_t *t;
+	tid_t tid;
+
+	jbd_lock_bh_state(bh);
+	spin_lock(&journal->j_list_lock);
+	jh = journal_grab_journal_head(bh);
+
+	if (!jh)
+		goto unlock;
+
+	t = jh->b_transaction;
+
+	if (!t)
+		goto release;
+
+	tid = t->t_tid;
+
+	journal_put_journal_head(jh);
+	spin_unlock(&journal->j_list_lock);
+	jbd_unlock_bh_state(bh);
+
+	log_start_commit(journal, tid);
+	ret = log_wait_commit(journal, tid);
+	return ret;
+
+release:
+	journal_put_journal_head(jh);
+unlock:
+	spin_unlock(&journal->j_list_lock);
+	jbd_unlock_bh_state(bh);
+	return ret;
+}
+
+/*
  * Log buffer allocation routines:
  */
 
Index: linux-2.6.26-rc1/include/linux/jbd.h
===================================================================
--- linux-2.6.26-rc1.orig/include/linux/jbd.h	2008-05-03 11:59:44.000000000 -0700
+++ linux-2.6.26-rc1/include/linux/jbd.h	2008-05-13 14:42:45.000000000 -0700
@@ -974,6 +974,7 @@ int __log_start_commit(journal_t *journa
 int journal_start_commit(journal_t *journal, tid_t *tid);
 int journal_force_commit_nested(journal_t *journal);
 int log_wait_commit(journal_t *journal, tid_t tid);
+int journal_wait_commit_buffer(journal_t *journal, struct buffer_head *bh);
 int log_do_checkpoint(journal_t *journal);
 
 void __log_wait_for_space(journal_t *journal);


