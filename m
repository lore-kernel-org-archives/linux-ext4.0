From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] ext3: Replace lock/unlock_super() with an explicit lock
 for resizing
Date: Mon, 14 Dec 2009 13:01:05 -0600
Message-ID: <4B268B71.6020207@redhat.com>
References: <4B268A3C.8060708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379AbZLNTBB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Dec 2009 14:01:01 -0500
In-Reply-To: <4B268A3C.8060708@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Theodore Ts'o <tytso@mit.edu>

Use a separate lock to protect s_groups_count and the other block
group descriptors which get changed via an on-line resize operation,
so we can stop overloading the use of lock_super().

Crossport of 32ed5058ce90024efcd811254b4b1de0468099df

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext3/resize.c           |   35 ++++++++++++++++++-----------------
 fs/ext3/super.c            |    1 +
 include/linux/ext3_fs_sb.h |    1 +
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index 8359e7b..57a5bc9 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -209,7 +209,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_resize_lock);
 	if (input->group != sbi->s_groups_count) {
 		err = -EBUSY;
 		goto exit_journal;
@@ -324,7 +324,7 @@ exit_bh:
 	brelse(bh);
 
 exit_journal:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_resize_lock);
 	if ((err2 = ext3_journal_stop(handle)) && !err)
 		err = err2;
 
@@ -662,11 +662,12 @@ exit_free:
  * important part is that the new block and inode counts are in the backup
  * superblocks, and the location of the new group metadata in the GDT backups.
  *
- * We do not need lock_super() for this, because these blocks are not
- * otherwise touched by the filesystem code when it is mounted.  We don't
- * need to worry about last changing from sbi->s_groups_count, because the
- * worst that can happen is that we do not copy the full number of backups
- * at this time.  The resize which changed s_groups_count will backup again.
+ * We do not need take the s_resize_lock for this, because these
+ * blocks are not otherwise touched by the filesystem code when it is
+ * mounted.  We don't need to worry about last changing from
+ * sbi->s_groups_count, because the worst that can happen is that we
+ * do not copy the full number of backups at this time.  The resize
+ * which changed s_groups_count will backup again.
  */
 static void update_backups(struct super_block *sb,
 			   int blk_off, char *data, int size)
@@ -825,7 +826,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 		goto exit_put;
 	}
 
-	lock_super(sb);
+	mutex_lock(&sbi->s_resize_lock);
 	if (input->group != sbi->s_groups_count) {
 		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
@@ -856,7 +857,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	/*
 	 * OK, now we've set up the new group.  Time to make it active.
 	 *
-	 * Current kernels don't lock all allocations via lock_super(),
+	 * We do not lock all allocations via s_resize_lock
 	 * so we have to be safe wrt. concurrent accesses the group
 	 * data.  So we need to be careful to set all of the relevant
 	 * group descriptor data etc. *before* we enable the group.
@@ -900,12 +901,12 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	 *
 	 * The precise rules we use are:
 	 *
-	 * * Writers of s_groups_count *must* hold lock_super
+	 * * Writers of s_groups_count *must* hold s_resize_lock
 	 * AND
 	 * * Writers must perform a smp_wmb() after updating all dependent
 	 *   data and before modifying the groups count
 	 *
-	 * * Readers must hold lock_super() over the access
+	 * * Readers must hold s_resize_lock over the access
 	 * OR
 	 * * Readers must perform an smp_rmb() after reading the groups count
 	 *   and before reading any dependent data.
@@ -936,7 +937,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	ext3_journal_dirty_metadata(handle, sbi->s_sbh);
 
 exit_journal:
-	unlock_super(sb);
+	mutex_unlock(&sbi->s_resize_lock);
 	if ((err2 = ext3_journal_stop(handle)) && !err)
 		err = err2;
 	if (!err) {
@@ -973,7 +974,7 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 
 	/* We don't need to worry about locking wrt other resizers just
 	 * yet: we're going to revalidate es->s_blocks_count after
-	 * taking lock_super() below. */
+	 * taking the s_resize_lock below. */
 	o_blocks_count = le32_to_cpu(es->s_blocks_count);
 	o_groups_count = EXT3_SB(sb)->s_groups_count;
 
@@ -1045,11 +1046,11 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 		goto exit_put;
 	}
 
-	lock_super(sb);
+	mutex_lock(&EXT3_SB(sb)->s_resize_lock);
 	if (o_blocks_count != le32_to_cpu(es->s_blocks_count)) {
 		ext3_warning(sb, __func__,
 			     "multiple resizers run on filesystem!");
-		unlock_super(sb);
+		mutex_unlock(&EXT3_SB(sb)->s_resize_lock);
 		ext3_journal_stop(handle);
 		err = -EBUSY;
 		goto exit_put;
@@ -1059,13 +1060,13 @@ int ext3_group_extend(struct super_block *sb, struct ext3_super_block *es,
 						 EXT3_SB(sb)->s_sbh))) {
 		ext3_warning(sb, __func__,
 			     "error %d on journal write access", err);
-		unlock_super(sb);
+		mutex_unlock(&EXT3_SB(sb)->s_resize_lock);
 		ext3_journal_stop(handle);
 		goto exit_put;
 	}
 	es->s_blocks_count = cpu_to_le32(o_blocks_count + add);
 	ext3_journal_dirty_metadata(handle, EXT3_SB(sb)->s_sbh);
-	unlock_super(sb);
+	mutex_unlock(&EXT3_SB(sb)->s_resize_lock);
 	ext3_debug("freeing blocks %lu through "E3FSBLK"\n", o_blocks_count,
 		   o_blocks_count + add);
 	ext3_free_blocks_sb(handle, sb, o_blocks_count, add, &freed_blocks);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 534557c..53d3c53 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1891,6 +1891,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 #endif
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
+	mutex_init(&sbi->s_resize_lock);
 
 	sb->s_root = NULL;
 
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index dd61d83..258088a 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -73,6 +73,7 @@ struct ext3_sb_info {
 	struct journal_s * s_journal;
 	struct list_head s_orphan;
 	struct mutex s_orphan_lock;
+	struct mutex s_resize_lock;
 	unsigned long s_commit_interval;
 	struct block_device *journal_bdev;
 #ifdef CONFIG_JBD_DEBUG
-- 1.6.0.6

