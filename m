From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: Re: [PATCH] jbd: don't abort if flushing file data failed
Date: Mon, 23 Jun 2008 20:04:00 +0900
Message-ID: <485F8320.7090204@hitachi.com>
References: <4859FD82.1000306@hitachi.com>
    <20080619080108.GB12244@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
	adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, Josef Bacik <jbacik@redhat.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39690 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYFWLET (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 07:04:19 -0400
In-Reply-To: <20080619080108.GB12244@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>  You can add Acked-by: Jan Kara <jack@suse.cz>
>
>   I have just one minor comment: Could you add device on which an error
> happened to the error message in journal_commit_transaction()? It could
> help the user in some cases...

It's good to me.  I fixed it.  Thanks!


Subject: [PATCH] jbd: don't abort if flushing file data failed

In ordered mode, the current jbd aborts the journal if a file data
buffer has an error.  But this behavior is unintended, and we found
that it has been adopted accidentally.

This patch undoes it and just calls printk() instead of aborting
the journal.  Additionally, set AS_EIO into the address_space
object of the failed buffer which is submitted by
journal_do_submit_data() so that fsync() can get -EIO.

Missing error checkings are also added to inform errors on file
data buffers to the user.  The following buffers are targeted.

  (a) the buffer which has already been written out by pdflush
  (b) the buffer which has been unlocked before scanned in the
      t_locked_list loop

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

Index: linux-2.6.26-rc5-mm3/fs/jbd/commit.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/fs/jbd/commit.c
+++ linux-2.6.26-rc5-mm3/fs/jbd/commit.c
@@ -172,7 +172,7 @@ static void journal_do_submit_data(struc
 /*
  *  Submit all the data buffers to disk
  */
-static void journal_submit_data_buffers(journal_t *journal,
+static int journal_submit_data_buffers(journal_t *journal,
 				transaction_t *commit_transaction)
 {
 	struct journal_head *jh;
@@ -180,6 +180,7 @@ static void journal_submit_data_buffers(
 	int locked;
 	int bufs = 0;
 	struct buffer_head **wbuf = journal->j_wbuf;
+	int err = 0;
 
 	/*
 	 * Whenever we unlock the journal and sleep, things can get added
@@ -253,6 +254,8 @@ write_out_data:
 			put_bh(bh);
 		} else {
 			BUFFER_TRACE(bh, "writeout complete: unfile");
+			if (unlikely(!buffer_uptodate(bh)))
+				err = -EIO;
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			if (locked)
@@ -271,6 +274,8 @@ write_out_data:
 	}
 	spin_unlock(&journal->j_list_lock);
 	journal_do_submit_data(wbuf, bufs);
+
+	return err;
 }
 
 /*
@@ -410,8 +415,7 @@ void journal_commit_transaction(journal_
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_data_buffers(journal, commit_transaction);
 
 	/*
 	 * Wait for all previously submitted IO to complete.
@@ -426,10 +430,21 @@ void journal_commit_transaction(journal_
 		if (buffer_locked(bh)) {
 			spin_unlock(&journal->j_list_lock);
 			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				err = -EIO;
 			spin_lock(&journal->j_list_lock);
 		}
+		if (unlikely(!buffer_uptodate(bh))) {
+			if (TestSetPageLocked(bh->b_page)) {
+				spin_unlock(&journal->j_list_lock);
+				lock_page(bh->b_page);
+				spin_lock(&journal->j_list_lock);
+			}
+			if (bh->b_page->mapping)
+				set_bit(AS_EIO, &bh->b_page->mapping->flags);
+
+			unlock_page(bh->b_page);
+			SetPageError(bh->b_page);
+			err = -EIO;
+		}
 		if (!inverted_lock(journal, bh)) {
 			put_bh(bh);
 			spin_lock(&journal->j_list_lock);
@@ -448,8 +463,14 @@ void journal_commit_transaction(journal_
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	if (err)
-		journal_abort(journal, err);
+	if (err) {
+		char b[BDEVNAME_SIZE];
+
+		printk(KERN_WARNING
+			"JBD: Detected IO errors during flushing file data "
+			"on %s\n", bdevname(journal->j_fs_dev, b));
+		err = 0;
+	}
 
 	journal_write_revoke_records(journal, commit_transaction);
 


