From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fix oops in jbd2_journal_init_inode() on corrupted fs
Date: Mon, 19 Jan 2009 16:57:55 +0100
Message-ID: <1232380676-12359-1-git-send-email-jack@suse.cz>
References: <n>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	dmaciejak@fortinet.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:40891 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbZASP55 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Jan 2009 10:57:57 -0500
In-Reply-To: <n>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 32-bit system with CONFIG_LBD getblk can fail because provided block
number is too big. Make JBD2 gracefully handle that.

Reported by David Maciejak <dmaciejak@fortinet.com>
in http://bugzilla.kernel.org/show_bug.cgi?id=12370.

Signed-off-by: Jan Kara <jack@suse.cz>
CC: dmaciejak@fortinet.com
---
 fs/jbd2/journal.c |   40 +++++++++++++++++++++++++++-------------
 1 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f6bff9d..a263f76 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -650,6 +650,8 @@ struct journal_head *jbd2_journal_get_descriptor_buffer(journal_t *journal)
 		return NULL;
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	if (!bh)
+		return NULL;
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
 	set_buffer_uptodate(bh);
@@ -1035,15 +1037,14 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 
 	/* journal descriptor can store up to n blocks -bzzz */
 	journal->j_blocksize = blocksize;
+	jbd2_stats_proc_init(journal);
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
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
@@ -1053,14 +1054,22 @@ journal_t * jbd2_journal_init_dev(struct block_device *bdev,
 	p = journal->j_devname;
 	while ((p = strchr(p, '/')))
 		*p = '!';
-	jbd2_stats_proc_init(journal);
 
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
+	jbd2_stats_proc_exit(journal);
+	kfree(journal);
+	return NULL;
 }
 
 /**
@@ -1108,9 +1117,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
-		jbd2_stats_proc_exit(journal);
-		kfree(journal);
-		return NULL;
+		goto out_err;
 	}
 
 	err = jbd2_journal_bmap(journal, 0, &blocknr);
@@ -1118,17 +1125,24 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __func__);
-		jbd2_stats_proc_exit(journal);
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
+	jbd2_stats_proc_exit(journal);
+	kfree(journal);
+	return NULL;
 }
 
 /*
-- 
1.6.0.2

