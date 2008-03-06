From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting a dirty read-only filesystem
Date: Thu,  6 Mar 2008 01:59:14 +0000
Message-ID: <1204768754-29655-7-git-send-email-duaneg@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
 <1204768754-29655-2-git-send-email-duaneg@dghda.com>
 <1204768754-29655-3-git-send-email-duaneg@dghda.com>
 <1204768754-29655-4-git-send-email-duaneg@dghda.com>
 <1204768754-29655-5-git-send-email-duaneg@dghda.com>
 <1204768754-29655-6-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:1438 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759867AbYCFCGO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Mar 2008 21:06:14 -0500
In-Reply-To: <1204768754-29655-6-git-send-email-duaneg@dghda.com>
Message-Id: <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com>
In-Reply-To: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a filesystem is being mounted read-only then load the journal read-only
(i.e. do not replay the log) and do not process the orphan list.

At present, when a dirty ext3 filesystem is mounted read-only, it writes to the
disk while replaying the journal log and cleaning up the orphan list. This
behaviour may surprise users and can potentially cause data corruption/loss
(e.g. if a system is suspended, booted into a different OS, then resumed).

Introduce block accessor wrapper functions that check for blocks requiring
translation and access them from the journal as needed. Convert the ext3 code
to use the wrappers anywhere that may be called on a read-only filesystem. Code
that is only called when writing to the filesystem is not converted.

For a discussion of the need for this feature, see:
http://marc.info/?l=linux-kernel&m=117607695406580

Tested by creating dirty filesystems, mounting a copy read-write, taking the
md5sum of all its files, mounting a different copy read-only, confirming the
md5sums match, unmounting it, then confirming the block device mounted
read-only has not been modified. Testing has been done with both internal and
external journals.

NOTE: For now I'm simply preventing filesystems requiring recovery from being
remounted read-write. This breaks booting with an uncleanly mounted root
filesystem!

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

I went back and forth on converting all code to use the accessors. In the end
it felt silly to shunt write code through a wrapper that was only useful in a
read-only filesystem. On the other hand, the inconsistency bothers me and
presumably increases the risks of future changes directly operating on
filesysem blocks when they need to go through the wrappers. I'd appreciate
second opinions on this point, in particular.

Also, would it perhaps be better to split this into separate patches to
introduce the accessors and add the no-replay code?

 fs/ext3/balloc.c        |    2 +-
 fs/ext3/ialloc.c        |    2 +-
 fs/ext3/inode.c         |    8 ++--
 fs/ext3/resize.c        |    2 +-
 fs/ext3/super.c         |  123 +++++++++++++++++++++++++++++++----------------
 fs/ext3/xattr.c         |    8 ++--
 include/linux/ext3_fs.h |    7 +++
 7 files changed, 99 insertions(+), 53 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index da0cb2c..1b42154 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -145,7 +145,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	if (!desc)
 		return NULL;
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
-	bh = sb_getblk(sb, bitmap_blk);
+	bh = ext3_sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
 		ext3_error(sb, __FUNCTION__,
 			    "Cannot read block bitmap - "
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4f4020c..7de791c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -60,7 +60,7 @@ read_inode_bitmap(struct super_block * sb, unsigned long block_group)
 	if (!desc)
 		goto error_out;
 
-	bh = sb_bread(sb, le32_to_cpu(desc->bg_inode_bitmap));
+	bh = ext3_sb_bread(sb, le32_to_cpu(desc->bg_inode_bitmap));
 	if (!bh)
 		ext3_error(sb, "read_inode_bitmap",
 			    "Cannot read inode bitmap - "
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..75fcf9e 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -364,7 +364,7 @@ static Indirect *ext3_get_branch(struct inode *inode, int depth, int *offsets,
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_bread(sb, le32_to_cpu(p->key));
+		bh = ext3_sb_bread(sb, le32_to_cpu(p->key));
 		if (!bh)
 			goto failure;
 		/* Reader: pointers */
@@ -1009,7 +1009,7 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 	*errp = err;
 	if (!err && buffer_mapped(&dummy)) {
 		struct buffer_head *bh;
-		bh = sb_getblk(inode->i_sb, dummy.b_blocknr);
+		bh = ext3_sb_getblk(inode->i_sb, dummy.b_blocknr);
 		if (!bh) {
 			*errp = -EIO;
 			goto err;
@@ -2514,7 +2514,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
 	if (!block)
 		return -EIO;
 
-	bh = sb_getblk(inode->i_sb, block);
+	bh = ext3_sb_getblk(inode->i_sb, block);
 	if (!bh) {
 		ext3_error (inode->i_sb, "ext3_get_inode_loc",
 				"unable to read inode block - "
@@ -2557,7 +2557,7 @@ static int __ext3_get_inode_loc(struct inode *inode,
 			if (!desc)
 				goto make_io;
 
-			bitmap_bh = sb_getblk(inode->i_sb,
+			bitmap_bh = ext3_sb_getblk(inode->i_sb,
 					le32_to_cpu(desc->bg_inode_bitmap));
 			if (!bitmap_bh)
 				goto make_io;
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 9397d77..2f9799b 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -236,7 +236,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 		if (err)
 			goto exit_bh;
 
-		gdb = sb_getblk(sb, block);
+		gdb = ext3_sb_getblk(sb, block);
 		if (!gdb) {
 			err = -EIO;
 			goto exit_bh;
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 4b9ff65..c333dac 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -64,6 +64,40 @@ static void ext3_unlockfs(struct super_block *sb);
 static void ext3_write_super (struct super_block * sb);
 static void ext3_write_super_lockfs(struct super_block *sb);
 
+struct buffer_head *ext3_sb_bread(struct super_block *sb, sector_t block)
+{
+	sector_t blocknr;
+	journal_t *journal = EXT3_SB(sb)->s_journal;
+	if (journal_translate_block(journal, block, &blocknr))
+		return __bread(journal->j_dev, blocknr, journal->j_blocksize);
+	else
+		return sb_bread(sb, block);
+}
+
+struct buffer_head *ext3_sb_getblk(struct super_block *sb, sector_t block)
+{
+	sector_t blocknr;
+	journal_t *journal = EXT3_SB(sb)->s_journal;
+	if (journal_translate_block(journal, block, &blocknr))
+		return __getblk(journal->j_dev, blocknr, journal->j_blocksize);
+	else
+		return sb_getblk(sb, block);
+}
+
+void ext3_map_bh(struct buffer_head *bh, struct super_block *sb, sector_t block)
+{
+	sector_t blocknr;
+	journal_t *journal = EXT3_SB(sb)->s_journal;
+	if (journal_translate_block(journal, block, &blocknr)) {
+		set_buffer_mapped(bh);
+		bh->b_bdev = journal->j_dev;
+		bh->b_blocknr = blocknr;
+		bh->b_size = journal->j_blocksize;
+	} else {
+		map_bh(bh, sb, block);
+	}
+}
+
 /*
  * Wrappers for journal_start/end.
  *
@@ -1328,7 +1362,6 @@ static int ext3_check_descriptors(struct super_block *sb)
 static void ext3_orphan_cleanup (struct super_block * sb,
 				 struct ext3_super_block * es)
 {
-	unsigned int s_flags = sb->s_flags;
 	int nr_orphans = 0, nr_truncates = 0;
 #ifdef CONFIG_QUOTA
 	int i;
@@ -1338,9 +1371,9 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		return;
 	}
 
-	if (bdev_read_only(sb->s_bdev)) {
-		printk(KERN_ERR "EXT3-fs: write access "
-			"unavailable, skipping orphan cleanup.\n");
+	if (sb->s_flags & MS_RDONLY) {
+		printk(KERN_INFO "EXT3-fs: %s: skipping orphan cleanup on "
+		       "readonly fs\n", sb->s_id);
 		return;
 	}
 
@@ -1353,11 +1386,6 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 		return;
 	}
 
-	if (s_flags & MS_RDONLY) {
-		printk(KERN_INFO "EXT3-fs: %s: orphan cleanup on readonly fs\n",
-		       sb->s_id);
-		sb->s_flags &= ~MS_RDONLY;
-	}
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
 	sb->s_flags |= MS_ACTIVE;
@@ -1418,7 +1446,6 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 			vfs_quota_off(sb, i);
 	}
 #endif
-	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
 
 /*
@@ -1838,8 +1865,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount3;
 	}
 
-	/* We have now updated the journal if required, so we can
-	 * validate the data journaling mode. */
+	/* We have now updated the journal or mapped unrecovered blocks as
+	 * required, so we can validate the data journaling mode. */
 	switch (test_opt(sb, DATA_FLAGS)) {
 	case 0:
 		/* No mode set, assume a default based on the journal
@@ -1872,8 +1899,8 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		}
 	}
 	/*
-	 * The journal_load will have done any necessary log recovery,
-	 * so we can safely mount the rest of the filesystem now.
+	 * The journal_load will have done any necessary log recovery or block
+	 * remapping, so we can safely mount the rest of the filesystem now.
 	 */
 
 	root = ext3_iget(sb, EXT3_ROOT_INO);
@@ -1907,9 +1934,16 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	EXT3_SB(sb)->s_mount_state |= EXT3_ORPHAN_FS;
 	ext3_orphan_cleanup(sb, es);
 	EXT3_SB(sb)->s_mount_state &= ~EXT3_ORPHAN_FS;
-	if (needs_recovery)
-		printk (KERN_INFO "EXT3-fs: recovery complete.\n");
-	ext3_mark_recovery_complete(sb, es);
+
+	if (needs_recovery) {
+		if (sb->s_flags & MS_RDONLY) {
+			printk(KERN_INFO "EXT3-fs: recovery skipped on "
+				"read-only filesystem.\n");
+		} else {
+			ext3_mark_recovery_complete(sb, es);
+			printk(KERN_INFO "EXT3-fs: recovery complete.\n");
+		}
+	}
 	printk (KERN_INFO "EXT3-fs: mounted filesystem with %s data mode.\n",
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
 		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
@@ -2110,7 +2144,6 @@ static int ext3_load_journal(struct super_block *sb,
 	unsigned int journal_inum = le32_to_cpu(es->s_journal_inum);
 	dev_t journal_dev;
 	int err = 0;
-	int really_read_only;
 
 	if (journal_devnum &&
 	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
@@ -2120,26 +2153,16 @@ static int ext3_load_journal(struct super_block *sb,
 	} else
 		journal_dev = new_decode_dev(le32_to_cpu(es->s_journal_dev));
 
-	really_read_only = bdev_read_only(sb->s_bdev);
-
 	/*
 	 * Are we loading a blank journal or performing recovery after a
 	 * crash?  For recovery, we need to check in advance whether we
 	 * can get read-write access to the device.
 	 */
 
-	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER)) {
-		if (sb->s_flags & MS_RDONLY) {
-			printk(KERN_INFO "EXT3-fs: INFO: recovery "
-					"required on readonly filesystem.\n");
-			if (really_read_only) {
-				printk(KERN_ERR "EXT3-fs: write access "
-					"unavailable, cannot proceed.\n");
-				return -EROFS;
-			}
-			printk (KERN_INFO "EXT3-fs: write access will "
-					"be enabled during recovery.\n");
-		}
+	if (EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	    sb->s_flags & MS_RDONLY) {
+		printk(KERN_INFO "EXT3-fs: INFO: skipping recovery "
+		       "on readonly filesystem.\n");
 	}
 
 	if (journal_inum && journal_dev) {
@@ -2156,7 +2179,7 @@ static int ext3_load_journal(struct super_block *sb,
 			return -EINVAL;
 	}
 
-	if (!really_read_only && test_opt(sb, UPDATE_JOURNAL)) {
+	if (!(sb->s_flags & MS_RDONLY) && test_opt(sb, UPDATE_JOURNAL)) {
 		err = journal_update_format(journal);
 		if (err)  {
 			printk(KERN_ERR "EXT3-fs: error updating journal.\n");
@@ -2166,9 +2189,9 @@ static int ext3_load_journal(struct super_block *sb,
 	}
 
 	if (!EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER))
-		err = journal_wipe(journal, !really_read_only);
+		err = journal_wipe(journal, !(sb->s_flags & MS_RDONLY));
 	if (!err)
-		err = journal_load(journal, !really_read_only);
+		err = journal_load(journal, !(sb->s_flags & MS_RDONLY));
 
 	if (err) {
 		printk(KERN_ERR "EXT3-fs: error loading journal.\n");
@@ -2177,15 +2200,17 @@ static int ext3_load_journal(struct super_block *sb,
 	}
 
 	EXT3_SB(sb)->s_journal = journal;
-	ext3_clear_journal_err(sb, es);
+	if (!(sb->s_flags & MS_RDONLY)) {
+		ext3_clear_journal_err(sb, es);
 
-	if (journal_devnum &&
-	    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
-		es->s_journal_dev = cpu_to_le32(journal_devnum);
-		sb->s_dirt = 1;
+		if (journal_devnum &&
+		    journal_devnum != le32_to_cpu(es->s_journal_dev)) {
+			es->s_journal_dev = cpu_to_le32(journal_devnum);
+			sb->s_dirt = 1;
 
-		/* Make sure we flush the recovery flag to disk. */
-		ext3_commit_super(sb, es, 1);
+			/* Make sure we flush the recovery flag to disk. */
+			ext3_commit_super(sb, es, 1);
+		}
 	}
 
 	return 0;
@@ -2494,6 +2519,20 @@ static int ext3_remount (struct super_block * sb, int * flags, char * data)
 			}
 
 			/*
+			 * If we have unrecovered journal transactions hanging
+			 * around require a full umount/remount for now.
+			 */
+			if (sbi->s_journal->j_bt_hash) {
+				printk(KERN_WARNING "EXT3-fs: %s: couldn't "
+				       "remount RDWR because of unrecovered "
+				       "journal transactions.  Please "
+				       "umount/remount instead.\n",
+				       sb->s_id);
+				err = -EINVAL;
+				goto restore_opts;
+			}
+
+			/*
 			 * Mounting a RDONLY partition read-write, so reread
 			 * and store the current valid flag.  (It may have
 			 * been changed by e2fsck since we originally mounted
diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
index fb89c29..6d0ef6f 100644
--- a/fs/ext3/xattr.c
+++ b/fs/ext3/xattr.c
@@ -226,7 +226,7 @@ ext3_xattr_block_get(struct inode *inode, int name_index, const char *name,
 	if (!EXT3_I(inode)->i_file_acl)
 		goto cleanup;
 	ea_idebug(inode, "reading block %u", EXT3_I(inode)->i_file_acl);
-	bh = sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
+	bh = ext3_sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
 	if (!bh)
 		goto cleanup;
 	ea_bdebug(bh, "b_count=%d, refcount=%d",
@@ -367,7 +367,7 @@ ext3_xattr_block_list(struct inode *inode, char *buffer, size_t buffer_size)
 	if (!EXT3_I(inode)->i_file_acl)
 		goto cleanup;
 	ea_idebug(inode, "reading block %u", EXT3_I(inode)->i_file_acl);
-	bh = sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
+	bh = ext3_sb_bread(inode->i_sb, EXT3_I(inode)->i_file_acl);
 	error = -EIO;
 	if (!bh)
 		goto cleanup;
@@ -641,7 +641,7 @@ ext3_xattr_block_find(struct inode *inode, struct ext3_xattr_info *i,
 
 	if (EXT3_I(inode)->i_file_acl) {
 		/* The inode already has an extended attribute block. */
-		bs->bh = sb_bread(sb, EXT3_I(inode)->i_file_acl);
+		bs->bh = ext3_sb_bread(sb, EXT3_I(inode)->i_file_acl);
 		error = -EIO;
 		if (!bs->bh)
 			goto cleanup;
@@ -1213,7 +1213,7 @@ again:
 				goto again;
 			break;
 		}
-		bh = sb_bread(inode->i_sb, ce->e_block);
+		bh = ext3_sb_bread(inode->i_sb, ce->e_block);
 		if (!bh) {
 			ext3_error(inode->i_sb, __FUNCTION__,
 				"inode %lu: block %lu read error",
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..c5732e1 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -864,6 +864,13 @@ extern void ext3_abort (struct super_block *, const char *, const char *, ...)
 extern void ext3_warning (struct super_block *, const char *, const char *, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern void ext3_update_dynamic_rev (struct super_block *sb);
+extern struct buffer_head *ext3_sb_bread(struct super_block *sb,
+	sector_t block);
+extern struct buffer_head *ext3_sb_getblk(struct super_block *sb,
+	sector_t block);
+extern void ext3_map_bh(struct buffer_head *bh,
+	struct super_block *sb, sector_t block);
+
 
 #define ext3_std_error(sb, errno)				\
 do {								\
-- 
1.5.3.7

