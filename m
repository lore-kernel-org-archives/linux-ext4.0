From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Fix oops in jbd_journal_init_inode() on corrupted fs
Date: Mon, 19 Jan 2009 16:57:56 +0100
Message-ID: <1232380676-12359-2-git-send-email-jack@suse.cz>
References: <n>
 <1232380676-12359-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	dmaciejak@fortinet.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40893 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537AbZASP55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2009 10:57:57 -0500
In-Reply-To: <1232380676-12359-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit system with CONFIG_LBD getblk can fail because provided block
number is too big. Make JBD gracefully handle that.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: dmaciejak@fortinet.com
---
 fs/jbd/journal.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9e4fa52..04eb7c8 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -632,6 +632,8 @@ struct journal_head *journal_get_descriptor_buffer(journal_t *journal)
 		return NULL;
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	if (!bh)
+		return NULL;
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
 	set_buffer_uptodate(bh);
@@ -728,9 +730,7 @@ journal_t * journal_init_dev(struct block_device *bdev,
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
@@ -738,11 +738,19 @@ journal_t * journal_init_dev(struct block_device *bdev,
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
@@ -782,8 +790,7 @@ journal_t * journal_init_inode (struct inode *inode)
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
-		kfree(journal);
-		return NULL;
+		goto out_err;
 	}
 
 	err = journal_bmap(journal, 0, &blocknr);
@@ -791,16 +798,23 @@ journal_t * journal_init_inode (struct inode *inode)
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
-- 
1.6.0.2

