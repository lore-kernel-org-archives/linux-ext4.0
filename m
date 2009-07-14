From: Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH 1/2] HACK: ext3: mount fast even when recovering
Date: Tue, 14 Jul 2009 17:05:54 +0300
Message-ID: <20090714140554.26116.54779.sendpatchset@ahunter-tower>
References: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
Cc: Adrian Hunter <adrian.hunter@nokia.com>,
	linux-ext4@vger.kernel.org,
	Artem Bityutskiy <artem.bityutskiy@nokia.com>
To: Stephen Tweedie <sct@redhat.com>, Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:52400 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbZGNOEE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jul 2009 10:04:04 -0400
In-Reply-To: <20090714140548.26116.2919.sendpatchset@ahunter-tower>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>From 40c3dac03ac40d03d987b2b1385ab3e68277067b Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 3 Jul 2009 15:25:13 +0300
Subject: [PATCH] HACK: ext3: mount fast even when recovering

Speed up ext3 recovery mount time by not sync'ing the
block device.  Instead place all dirty buffers into the
I/O queue and add a write barrier.  This ensures that
no subsequent write will reach the disk before all the
recovery writes, but that we do not have to wait for the
I/O.

Note that ext3 reads sectors the correct way: through the
buffer cache, so there is no risk of reading old metadata.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 fs/ext3/super.c         |   66 ++++++++++++++++++++++++++++++++++++++++++----
 fs/jbd/journal.c        |   23 ++++++++++++----
 fs/jbd/recovery.c       |   19 +++++++++++++-
 include/linux/ext3_fs.h |    1 +
 include/linux/jbd.h     |    1 +
 5 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index f4be66e..59efefb 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1263,7 +1263,13 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
 	ext3_update_dynamic_rev(sb);
 	EXT3_SET_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 
-	ext3_commit_super(sb, es, 1);
+	/*
+	 * If we are in a hurry, we do not need to wait for the super block to
+	 * reach the disk.  We just need to make sure that all previous writes
+	 * arrive before it.  Setting the sync parameter to 2 will cause a
+	 * write barrier to be added but will not wait for the I/O to complete.
+	 */
+	ext3_commit_super(sb, es, test_opt(sb, FAST) ? 2 : 1);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_INFO "[EXT3 FS bs=%lu, gc=%lu, "
 				"bpg=%lu, ipg=%lu, mo=%04lx]\n",
@@ -1622,6 +1628,14 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 
 	set_opt(sbi->s_mount_opt, RESERVATION);
 
+	/*
+	 * Set an option to indicate that we want to mount fast even
+	 * when recovering.  That is achieved by not sync'ing the
+	 * block device, but instead placing all dirty buffers into
+	 * the I/O queue and adding a write barrier.
+	 */
+	set_opt(sbi->s_mount_opt, FAST);
+
 	if (!parse_options ((char *) data, sb, &journal_inum, &journal_devnum,
 			    NULL, 0))
 		goto failed_mount;
@@ -2007,6 +2021,12 @@ static void ext3_init_journal_params(struct super_block *sb, journal_t *journal)
 		journal->j_flags |= JFS_ABORT_ON_SYNCDATA_ERR;
 	else
 		journal->j_flags &= ~JFS_ABORT_ON_SYNCDATA_ERR;
+	/*
+	 * Tell the journal about our fast mounting scheme, so it can
+	 * play its part.
+	 */
+	if (test_opt(sb, FAST))
+		journal->j_flags |= JFS_LOAD_FAST;
 	spin_unlock(&journal->j_state_lock);
 }
 
@@ -2224,7 +2244,13 @@ static int ext3_load_journal(struct super_block *sb,
 		mark_sb_dirty(sb);
 
 		/* Make sure we flush the recovery flag to disk. */
-		ext3_commit_super(sb, es, 1);
+		/*
+		 * The super gets committed later by 'ext3_setup_super()'
+		 * or 'ext3_maek_recovery_complete()' anyway, so if we are
+		 * in a hurry we can skip it here.
+		 */
+		if (!test_opt(sb, FAST))
+			ext3_commit_super(sb, es, 1);
 	}
 
 	return 0;
@@ -2285,7 +2311,16 @@ static void ext3_commit_super (struct super_block * sb,
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
-	if (sync)
+	if (sync == 2) {
+		/*
+		 * Caller has requested that a barrier is used, so that this
+		 * write will not reach the disk before any previous ones,
+		 * and we will not have to wait for it either.
+		 */
+		set_buffer_ordered(sbh);
+		ll_rw_block(SWRITE, 1, &sbh);
+		clear_buffer_ordered(sbh);
+	} else if (sync)
 		sync_dirty_buffer(sbh);
 }
 
@@ -2301,15 +2336,29 @@ static void ext3_mark_recovery_complete(struct super_block * sb,
 	journal_t *journal = EXT3_SB(sb)->s_journal;
 
 	journal_lock_updates(journal);
-	if (journal_flush(journal) < 0)
+
+	/*
+	 * There is no need to flush the journal so skip it if we are in a
+	 * hurry.
+	 */
+	if (!test_opt(sb, FAST) && journal_flush(journal) < 0)
 		goto out;
 
 	lock_super(sb);
 	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
 	    sb->s_flags & MS_RDONLY) {
+		/*
+		 * If we are in a hurry, we do not need to wait for the super
+		 * block to reach the disk.  We just need to make sure that
+		 * all previous writes arrive before it.  Setting the sync
+		 * parameter to 2 will cause a write barrier to be added but
+		 * will not wait for the I/O to complete.
+		 */
+		int sync = test_opt(sb, FAST) ? 2 : 1;
+
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
 		mark_sb_clean(sb);
-		ext3_commit_super(sb, es, 1);
+		ext3_commit_super(sb, es, sync);
 	}
 	unlock_super(sb);
 
@@ -2348,7 +2397,12 @@ static void ext3_clear_journal_err(struct super_block * sb,
 
 		EXT3_SB(sb)->s_mount_state |= EXT3_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT3_ERROR_FS);
-		ext3_commit_super (sb, es, 1);
+		/*
+		 * The super gets committed later by 'ext3_setup_super()'
+		 * anyway, so if we are in a hurry we can skip it here.
+		 */
+		if (!test_opt(sb, FAST))
+			ext3_commit_super (sb, es, 1);
 
 		journal_clear_err(journal);
 	}
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9e4fa52..3fd14ef 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -822,7 +822,7 @@ static void journal_fail_superblock (journal_t *journal)
  * subsequent use.
  */
 
-static int journal_reset(journal_t *journal)
+static int journal_reset(journal_t *journal, int wait)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 	unsigned long first, last;
@@ -844,7 +844,7 @@ static int journal_reset(journal_t *journal)
 	journal->j_max_transaction_buffers = journal->j_maxlen / 4;
 
 	/* Add the dynamic fields and write it to disk. */
-	journal_update_superblock(journal, 1);
+	journal_update_superblock(journal, wait);
 	return journal_start_thread(journal);
 }
 
@@ -916,13 +916,14 @@ int journal_create(journal_t *journal)
 	journal->j_flags &= ~JFS_ABORT;
 	journal->j_format_version = 2;
 
-	return journal_reset(journal);
+	return journal_reset(journal, 1);
 }
 
 /**
  * void journal_update_superblock() - Update journal sb on disk.
  * @journal: The journal to update.
  * @wait: Set to '0' if you don't want to wait for IO completion.
+ *        Note that a write barrier is used in that case.
  *
  * Update a journal's dynamic superblock fields and write it to disk,
  * optionally waiting for the IO to complete.
@@ -961,8 +962,11 @@ void journal_update_superblock(journal_t *journal, int wait)
 	mark_buffer_dirty(bh);
 	if (wait)
 		sync_dirty_buffer(bh);
-	else
+	else {
+		set_buffer_ordered(bh);
 		ll_rw_block(SWRITE, 1, &bh);
+		clear_buffer_ordered(bh);
+	}
 
 out:
 	/* If we have just flushed the log (by marking s_start==0), then
@@ -1073,7 +1077,7 @@ static int load_superblock(journal_t *journal)
  */
 int journal_load(journal_t *journal)
 {
-	int err;
+	int err, wait;
 	journal_superblock_t *sb;
 
 	err = load_superblock(journal);
@@ -1103,7 +1107,14 @@ int journal_load(journal_t *journal)
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
 	 * and reset them on disk. */
-	if (journal_reset(journal))
+	/*
+	 * If we are in a hurry, tell the reset not to wait, which will
+	 * cause the journal superblock buffer to be placed into the I/O
+	 * queue with a barrier, but we will not wait for the I/O to
+	 * complete.
+	 */
+	wait = journal->j_flags & JFS_LOAD_FAST ? 0 : 1;
+	if (journal_reset(journal, wait))
 		goto recovery_error;
 
 	journal->j_flags &= ~JFS_ABORT;
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index db5e982..a245c36 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -261,7 +261,24 @@ int journal_recover(journal_t *journal)
 	journal->j_transaction_sequence = ++info.end_transaction;
 
 	journal_clear_revoke(journal);
-	err2 = sync_blockdev(journal->j_fs_dev);
+	/*
+	 * We can massively speed-up the recovery mount time by avoiding
+	 * synchronizing the block device.  Instead, we just throw all the
+	 * dirty buffers into the I/O queue, and rely on callers to add
+	 * a write barrier.
+	 */
+	if (journal->j_flags & JFS_LOAD_FAST) {
+		struct block_device *bdev = journal->j_fs_dev;
+
+		err2 = 0;
+		if (bdev) {
+			struct address_space *mapping = bdev->bd_inode->i_mapping;
+
+			if (mapping->nrpages)
+				err2 = filemap_fdatawrite(mapping);
+		}
+	} else
+		err2 = sync_blockdev(journal->j_fs_dev);
 	if (!err)
 		err = err2;
 
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index d14f029..117e7a1 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -382,6 +382,7 @@ struct ext3_inode {
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
 #define EXT3_MOUNT_DATA_ERR_ABORT	0x400000 /* Abort on file data write
 						  * error in ordered mode */
+#define EXT3_MOUNT_FAST			0x800000 /* Do not sync during recovery */
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 346e2b8..06459ca 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -819,6 +819,7 @@ struct journal_s
 #define JFS_ABORT_ON_SYNCDATA_ERR	0x040  /* Abort the journal on file
 						* data write error in ordered
 						* mode */
+#define JFS_LOAD_FAST	0x080	/* Do not sync during recovery */
 
 /*
  * Function declarations for the journaling transaction and buffer
-- 
1.5.6.3

