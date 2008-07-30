From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 2/2] jbd: ordered data integrity fix
Date: Wed, 30 Jul 2008 12:01:33 +0900
Message-ID: <488FD98D.3080708@hitachi.com>
References: <488FD756.9060106@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: adilger@clusterfs.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
	cmm@us.ibm.com, tytso@mit.edu, snitzer@gmail.com,
	tglx@linutronix.de, yumiko.sugita.yf@hitachi.com,
	satoshi.oshima.fk@hitachi.com
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41920 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYG3DBo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2008 23:01:44 -0400
In-Reply-To: <488FD756.9060106@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ordered mode, if a file data buffer being dirtied exists in
the committing transaction, we write the buffer to the disk, move
it from the committing transaction to the running transaction,
then dirty it.  But we don't have to remove the buffer from the
committing transaction when the buffer couldn't be written out,
otherwise it would miss the error and the committing transaction
would not abort.

This patch adds an error check before removing the buffer from the
committing transaction.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
---
This patch is the same as patch 2/5 of possible filesystem corruption
fixes (take 2).  It can be found at:
http://kerneltrap.org/mailarchive/linux-kernel/2008/6/2/2002144

 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6.27-rc1/fs/jbd/transaction.c
===================================================================
--- linux-2.6.27-rc1.orig/fs/jbd/transaction.c
+++ linux-2.6.27-rc1/fs/jbd/transaction.c
@@ -954,9 +954,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1067,7 +1068,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We cannot remove the buffer with io error from the
+			 * committing transaction, because otherwise it would
+			 * miss the error and the commit would not abort.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1108,7 +1118,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**


