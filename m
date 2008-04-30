From: akpm@linux-foundation.org
Subject: - jdb2-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:17 -0700
Message-ID: <200804300552.m3U5qHXi030306@imap1.linux-foundation.org>
To: harvey.harrison@gmail.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926AbYD3GB3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jdb2: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     jdb2-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jdb2: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c     |   18 +++++++++---------
 fs/jbd2/revoke.c      |    2 +-
 fs/jbd2/transaction.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/jbd2/journal.c~jdb2-replace-remaining-__function__-occurrences fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jdb2-replace-remaining-__function__-occurrences
+++ a/fs/jbd2/journal.c
@@ -534,7 +534,7 @@ int jbd2_log_wait_commit(journal_t *jour
 	if (!tid_geq(journal->j_commit_request, tid)) {
 		printk(KERN_EMERG
 		       "%s: error: j_commit_request=%d, tid=%d\n",
-		       __FUNCTION__, journal->j_commit_request, tid);
+		       __func__, journal->j_commit_request, tid);
 	}
 	spin_unlock(&journal->j_state_lock);
 #endif
@@ -599,7 +599,7 @@ int jbd2_journal_bmap(journal_t *journal
 
 			printk(KERN_ALERT "%s: journal block not found "
 					"at offset %lu on %s\n",
-				__FUNCTION__,
+				__func__,
 				blocknr,
 				bdevname(journal->j_dev, b));
 			err = -EIO;
@@ -1037,7 +1037,7 @@ journal_t * jbd2_journal_init_dev(struct
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		journal = NULL;
 		goto out;
@@ -1093,7 +1093,7 @@ journal_t * jbd2_journal_init_inode (str
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -1102,7 +1102,7 @@ journal_t * jbd2_journal_init_inode (str
 	/* If that failed, give up */
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -1188,7 +1188,7 @@ int jbd2_journal_create(journal_t *journ
 		 */
 		printk(KERN_EMERG
 		       "%s: creation of journal on external device!\n",
-		       __FUNCTION__);
+		       __func__);
 		BUG();
 	}
 
@@ -2012,7 +2012,7 @@ static struct journal_head *journal_allo
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
-			       __FUNCTION__);
+			       __func__);
 			last_warning = jiffies;
 		}
 		while (!ret) {
@@ -2149,13 +2149,13 @@ static void __journal_remove_journal_hea
 			if (jh->b_frozen_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd2_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd2_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
diff -puN fs/jbd2/revoke.c~jdb2-replace-remaining-__function__-occurrences fs/jbd2/revoke.c
--- a/fs/jbd2/revoke.c~jdb2-replace-remaining-__function__-occurrences
+++ a/fs/jbd2/revoke.c
@@ -139,7 +139,7 @@ repeat:
 oom:
 	if (!journal_oom_retry)
 		return -ENOMEM;
-	jbd_debug(1, "ENOMEM in %s, retrying\n", __FUNCTION__);
+	jbd_debug(1, "ENOMEM in %s, retrying\n", __func__);
 	yield();
 	goto repeat;
 }
diff -puN fs/jbd2/transaction.c~jdb2-replace-remaining-__function__-occurrences fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jdb2-replace-remaining-__function__-occurrences
+++ a/fs/jbd2/transaction.c
@@ -696,7 +696,7 @@ repeat:
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
 					       "%s: OOM for frozen_buffer\n",
-					       __FUNCTION__);
+					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
 					error = -ENOMEM;
 					jbd_lock_bh_state(bh);
@@ -914,7 +914,7 @@ repeat:
 		committed_data = jbd2_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
-				__FUNCTION__);
+				__func__);
 			err = -ENOMEM;
 			goto out;
 		}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

