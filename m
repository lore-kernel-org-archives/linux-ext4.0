From: akpm@linux-foundation.org
Subject: [merged] jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:33:44 -0700
Message-ID: <200904061933.n36JXikj011217@imap1.linux-foundation.org>
To: jack@suse.cz, dmaciejak@fortinet.com, linux-ext4@vger.kernel.org,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475AbZDFTgl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 15:36:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: fix oops in jbd_journal_init_inode() on corrupted fs
has been removed from the -mm tree.  Its filename was
     jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: fix oops in jbd_journal_init_inode() on corrupted fs
From: Jan Kara <jack@suse.cz>

On 32-bit system with CONFIG_LBD getblk can fail because provided block
number is too big. Make JBD gracefully handle that.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <dmaciejak@fortinet.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff -puN fs/jbd/journal.c~jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs
+++ a/fs/jbd/journal.c
@@ -637,6 +637,8 @@ struct journal_head *journal_get_descrip
 		return NULL;
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	if (!bh)
+		return NULL;
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
 	set_buffer_uptodate(bh);
@@ -733,9 +735,7 @@ journal_t * journal_init_dev(struct bloc
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
-		kfree(journal);
-		journal = NULL;
-		goto out;
+		goto out_err;
 	}
 	journal->j_dev = bdev;
 	journal->j_fs_dev = fs_dev;
@@ -743,11 +743,19 @@ journal_t * journal_init_dev(struct bloc
 	journal->j_maxlen = len;
 
 	bh = __getblk(journal->j_dev, start, journal->j_blocksize);
-	J_ASSERT(bh != NULL);
+	if (!bh) {
+		printk(KERN_ERR
+		       "%s: Cannot get buffer for journal superblock\n",
+		       __func__);
+		goto out_err;
+	}
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
-out:
+
 	return journal;
+out_err:
+	kfree(journal);
+	return NULL;
 }
 
 /**
@@ -787,8 +795,7 @@ journal_t * journal_init_inode (struct i
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
-		kfree(journal);
-		return NULL;
+		goto out_err;
 	}
 
 	err = journal_bmap(journal, 0, &blocknr);
@@ -796,16 +803,23 @@ journal_t * journal_init_inode (struct i
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __func__);
-		kfree(journal);
-		return NULL;
+		goto out_err;
 	}
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
-	J_ASSERT(bh != NULL);
+	if (!bh) {
+		printk(KERN_ERR
+		       "%s: Cannot get buffer for journal superblock\n",
+		       __func__);
+		goto out_err;
+	}
 	journal->j_sb_buffer = bh;
 	journal->j_superblock = (journal_superblock_t *)bh->b_data;
 
 	return journal;
+out_err:
+	kfree(journal);
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
reiser4-update-names-of-quota-methods.patch

