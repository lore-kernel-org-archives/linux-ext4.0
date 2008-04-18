From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [PATCH 2/4] jbd: ordered data integrity fix
Date: Fri, 18 Apr 2008 22:37:18 +0900
Message-ID: <4808A40E.7010200@hitachi.com>
References: <48089B86.5020108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz, sugita <yumiko.sugita.yf@hitachi.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
To: akpm@linux-foundation.org, sct@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758646AbYDRNh4@vger.kernel.org>
In-Reply-To: <48089B86.5020108@hitachi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Subject: [PATCH 2/4] jbd: ordered data integrity fix

In ordered mode, if a buffer being dirtied exists in the committing
transaction, we write the buffer to the disk, move it from the
committing transaction to the running transaction, then dirty it.
But we don't have to remove the buffer from the committing
transaction when the buffer couldn't be written out, otherwise it
breaks the ordered mode rule.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
---
 fs/jbd/transaction.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

Index: linux-2.6.25/fs/jbd/transaction.c
===================================================================
--- linux-2.6.25.orig/fs/jbd/transaction.c
+++ linux-2.6.25/fs/jbd/transaction.c
@@ -941,9 +941,10 @@ int journal_dirty_data(handle_t *handle,
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_brelse = 0;
 	struct journal_head *jh;
+	int ret = 0;
 
 	if (is_handle_aborted(handle))
-		return 0;
+		return ret;
 
 	jh = journal_add_journal_head(bh);
 	JBUFFER_TRACE(jh, "entry");
@@ -1054,7 +1055,16 @@ int journal_dirty_data(handle_t *handle,
 				   time if it is redirtied */
 			}
 
-			/* journal_clean_data_list() may have got there first */
+			/*
+			 * We shouldn't remove the buffer from the committing
+			 * transaction if it has failed to be written.
+			 * Otherwise, it breaks the ordered mode rule.
+			 */
+			if (unlikely(!buffer_uptodate(bh))) {
+				ret = -EIO;
+				goto no_journal;
+			}
+
 			if (jh->b_transaction != NULL) {
 				JBUFFER_TRACE(jh, "unfile from commit");
 				__journal_temp_unlink_buffer(jh);
@@ -1095,7 +1105,7 @@ no_journal:
 	}
 	JBUFFER_TRACE(jh, "exit");
 	journal_put_journal_head(jh);
-	return 0;
+	return ret;
 }
 
 /**
