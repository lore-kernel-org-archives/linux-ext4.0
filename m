From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] jbd2: Speedup jbd2_journal_get_[write|undo]_access()
Date: Thu, 18 Jun 2015 10:52:35 +0200
Message-ID: <20150618085235.GB21820@quack.suse.cz>
References: <1427983100-29889-1-git-send-email-jack@suse.cz>
 <1427983100-29889-5-git-send-email-jack@suse.cz>
 <20150608164726.GM19168@thunk.org>
 <20150617165646.GG1614@quack.suse.cz>
 <CAA1ppbhojR0aaDr-BUWQLWQDo5+sO9Tc6b=Dxf5XrRAr2DT0oQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Jerry Lee <jerrylee@qnap.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50848 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbFRIwl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jun 2015 04:52:41 -0400
Content-Disposition: inline
In-Reply-To: <CAA1ppbhojR0aaDr-BUWQLWQDo5+sO9Tc6b=Dxf5XrRAr2DT0oQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 18-06-15 15:59:33, Jerry Lee wrote:
> Hi:
> 
> I found that there may be a typo in the attached patch 5/5:
> 
> +        /*
> +         * If it's in our transaction it must be in BJ_Metadata list.
> +         * The assertion is unreliable since we may see jh in
> +         * inconsistent state unless we grab bh_state lock. But this
> +         * is crutial to catch bugs so let's do a reliable check until
> +         * the lockless handling is fully proven.
> +         */
> +        if (jh->b_transaction == transaction &&
> +            jh->b_jlist != BJ_Metadata) {
> +            jbd_lock_bh_state(bh);
> +            J_ASSERT_JH(jh, jh->b_transaction != transaction ||
> +                    jh->b_jlist == BJ_Metadata);
> +            jbd_lock_bh_state(bh);
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +        }
> +        goto out;
> 
> Does the highlight part should be "jbd_unlock_bh_state(bh)"?
  Yeah, thanks for catching this. I was apparently pretty lucky in this
passing all the tests... Attached is the new version of the patch.

								Honza

> On Thu, Jun 18, 2015 at 12:56 AM, Jan Kara <jack@suse.cz> wrote:
> 
> > On Mon 08-06-15 12:47:26, Ted Tso wrote:
> > > On Thu, Apr 02, 2015 at 03:58:19PM +0200, Jan Kara wrote:
> > > > jbd2_journal_get_write_access() and jbd2_journal_get_create_access()
> > are
> > > > frequently called for buffers that are already part of the running
> > > > transaction - most frequently it is the case for bitmaps, inode table
> > > > blocks, and superblock. Since in such cases we have nothing to do, it
> > is
> > > > unfortunate we still grab reference to journal head, lock the bh, lock
> > > > bh_state only to find out there's nothing to do.
> > > >
> > > > Improving this is a bit subtle though since until we find out journal
> > > > head is attached to the running transaction, it can disappear from
> > under
> > > > us because checkpointing / commit decided it's no longer needed. We
> > deal
> > > > with this by protecting journal_head slab with RCU. We still have to be
> > > > careful about journal head being freed & reallocated within slab and
> > > > about exposing journal head in consistent state (in particular
> > > > b_modified and b_frozen_data must be in correct state before we allow
> > > > user to touch the buffer).
> > > >
> > > > FIXME: Performance data.
> > > >
> > > > Signed-off-by: Jan Kara <jack@suse.cz>
> > >
> > > Applied, so we can start getting some testing on this patch.  Did you
> > > ever get performance data?
> >
> > Yes. Here are results for reaim fserver workload for 32 core machine with
> > 128 GB of ram with ext4 on ramdisk:
> > Procs Vanilla    Patched
> > 1      20420.688  21155.556
> > 21     49684.704 178934.074
> > 41     84630.364 196647.482
> > 61    106344.284 204831.652
> > 81    120751.370 214842.428
> > 101   131585.450 208761.832
> > 121   138092.078 212741.648
> > 141   142271.578 212118.502
> > 161   146008.364 213731.388
> > 181   149569.494 216121.444
> >
> > Numbers are operations per second so larger is better. You can see that
> > for 21 processes we get increase by 260% in the number operations. Also the
> > total maximum of operations the machine is able to achieve increases by
> > 44% because of overall lower CPU overhead.
> >
> >                                                                 Honza
> > --
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--J/dobhs11T7y2rNN
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0005-jbd2-Speedup-jbd2_journal_dirty_metadata.patch"

>From a19a4452879743eb7c8db593adbf60fc9ff0427c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 18 Mar 2015 14:29:13 +0100
Subject: [PATCH 5/5] jbd2: Speedup jbd2_journal_dirty_metadata()

It is often the case that we mark buffer as having dirty metadata when
the buffer is already in that state (frequent for bitmaps, inode table
blocks, superblock). Thus it is unnecessary to contend on grabbing
journal head reference and bh_state lock. Avoid that by checking whether
any modification to the buffer is needed before grabbing any locks or
references.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a91f639af6c3..5887c880422b 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1290,8 +1290,6 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
 	triggers->t_abort(triggers, jh2bh(jh));
 }
 
-
-
 /**
  * int jbd2_journal_dirty_metadata() -  mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
@@ -1325,12 +1323,36 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	WARN_ON(!transaction);
 	if (is_handle_aborted(handle))
 		return -EROFS;
-	journal = transaction->t_journal;
-	jh = jbd2_journal_grab_journal_head(bh);
-	if (!jh) {
+	if (!buffer_jbd(bh)) {
 		ret = -EUCLEAN;
 		goto out;
 	}
+	/*
+	 * We don't grab jh reference here since the buffer must be part
+	 * of the running transaction.
+	 */
+	jh = bh2jh(bh);
+	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
+			jh->b_next_transaction == transaction);
+	if (jh->b_modified == 1) {
+		/*
+		 * If it's in our transaction it must be in BJ_Metadata list.
+		 * The assertion is unreliable since we may see jh in
+		 * inconsistent state unless we grab bh_state lock. But this
+		 * is crutial to catch bugs so let's do a reliable check until
+		 * the lockless handling is fully proven.
+		 */
+		if (jh->b_transaction == transaction &&
+		    jh->b_jlist != BJ_Metadata) {
+			jbd_lock_bh_state(bh);
+			J_ASSERT_JH(jh, jh->b_transaction != transaction ||
+					jh->b_jlist == BJ_Metadata);
+			jbd_unlock_bh_state(bh);
+		}
+		goto out;
+	}
+
+	journal = transaction->t_journal;
 	jbd_debug(5, "journal_head %p\n", jh);
 	JBUFFER_TRACE(jh, "entry");
 
@@ -1421,7 +1443,6 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	spin_unlock(&journal->j_list_lock);
 out_unlock_bh:
 	jbd_unlock_bh_state(bh);
-	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
 	return ret;
-- 
2.1.4


--J/dobhs11T7y2rNN--
