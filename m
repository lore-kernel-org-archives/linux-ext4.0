From: akpm@linux-foundation.org
Subject: + jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch added to -mm tree
Date: Mon, 26 Jan 2009 23:34:33 -0800
Message-ID: <200901270734.n0R7YXCj001118@imap1.linux-foundation.org>
Cc: jack@suse.cz, dmaciejak@fortinet.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58108 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZA0HfN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jan 2009 02:35:13 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     jbd: fix oops in jbd_journal_init_inode() on corrupted fs
has been added to the -mm tree.  Its filename is
     jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -632,6 +632,8 @@ struct journal_head *journal_get_descrip
 		return NULL;
 
 	bh = __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	if (!bh)
+		return NULL;
 	lock_buffer(bh);
 	memset(bh->b_data, 0, journal->j_blocksize);
 	set_buffer_uptodate(bh);
@@ -728,9 +730,7 @@ journal_t * journal_init_dev(struct bloc
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
@@ -738,11 +738,19 @@ journal_t * journal_init_dev(struct bloc
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
@@ -782,8 +790,7 @@ journal_t * journal_init_inode (struct i
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
-		kfree(journal);
-		return NULL;
+		goto out_err;
 	}
 
 	err = journal_bmap(journal, 0, &blocknr);
@@ -791,16 +798,23 @@ journal_t * journal_init_inode (struct i
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

linux-next.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
jbd-fix-oops-in-jbd_journal_init_inode-on-corrupted-fs.patch

