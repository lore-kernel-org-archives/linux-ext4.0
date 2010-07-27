From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: implement SECRM functionality
Date: Tue, 27 Jul 2010 18:37:38 +0400
Message-ID: <1280241458-13552-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33438 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab0G0Ohr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2010 10:37:47 -0400
Received: by ewy23 with SMTP id 23so1273995ewy.19
        for <linux-ext4@vger.kernel.org>; Tue, 27 Jul 2010 07:37:46 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some people do care about stale data. Most obvious way is to
explicitly zeroout data on freeing. But if underling device has
discard support with zeroing we may avoid unnecessary io.

Off course that feature comes with the cost, but only if user actually
use it by setting SECRM flag on inode (which is not the case by default).

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/mballoc.c |   56 ++++++++++++++++++++++++++++++++++++++--------------
 fs/ext4/mballoc.h |    2 +
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a75de7d..7d42dcc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2557,19 +2557,45 @@ int ext4_mb_release(struct super_block *sb)
 	return 0;
 }
 
-static inline void ext4_issue_discard(struct super_block *sb,
-		ext4_group_t block_group, ext4_grpblk_t block, int count)
+static void ext4_discard_blocks(struct super_block *sb,
+				ext4_group_t block_group, ext4_grpblk_t block,
+				sector_t count, int sec_del)
 {
-	int ret;
+	int ret = 0;
 	ext4_fsblk_t discard_block;
 
 	discard_block = block + ext4_group_first_block_no(sb, block_group);
-	trace_ext4_discard_blocks(sb,
-			(unsigned long long) discard_block, count);
-	ret = sb_issue_discard(sb, discard_block, count);
-	if (ret == EOPNOTSUPP) {
-		ext4_warning(sb, "discard not supported, disabling");
-		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+	discard_block <<= (sb->s_blocksize_bits - 9);
+	count <<= (sb->s_blocksize_bits - 9);
+
+	if (sec_del) {
+		int zd = queue_discard_zeroes_data(bdev_get_queue(sb->s_bdev));
+		/*
+		  Ok, this is security deletion request. If device has zero
+		  data on discard feature then simple discard request is
+		  sufficient.
+		*/
+		if (test_opt(sb, DISCARD) && zd) {
+			goto issue_discard;
+		} else {
+			/* Explicitly zeroout is necessery */
+			ret = blkdev_issue_zeroout(sb->s_bdev, discard_block,
+					count, GFP_NOIO, BLKDEV_IFL_WAIT);
+			if (ret)
+				ext4_std_error(sb, ret);
+		}
+	}
+issue_discard:
+	if (test_opt(sb, DISCARD)) {
+		trace_ext4_discard_blocks(sb,
+				(unsigned long long) discard_block, count);
+		ret = blkdev_issue_discard(sb->s_bdev, discard_block,
+					count, GFP_NOIO,
+					BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+		if (ret == EOPNOTSUPP) {
+			ext4_warning(sb, "discard not supported, disabling");
+			clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+		}
 	}
 }
 
@@ -2592,9 +2618,8 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
-		if (test_opt(sb, DISCARD))
-			ext4_issue_discard(sb, entry->group,
-					entry->start_blk, entry->count);
+		ext4_discard_blocks(sb, entry->group,
+				entry->start_blk, entry->count, entry->secdel);
 
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
@@ -4628,7 +4653,8 @@ do_more:
 		new_entry->group  = block_group;
 		new_entry->count = count;
 		new_entry->t_tid = handle->h_transaction->t_tid;
-
+		new_entry->secdel = !!ext4_test_inode_flag(inode,
+							EXT4_INODE_SECRM);
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		ext4_mb_free_metadata(handle, &e4b, new_entry);
@@ -4641,8 +4667,8 @@ do_more:
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
-		if (test_opt(sb, DISCARD))
-			ext4_issue_discard(sb, block_group, bit, count);
+		ext4_discard_blocks(sb, block_group, bit, count,
+				ext4_test_inode_flag(inode,EXT4_INODE_SECRM));
 	}
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index b619322..e80386e 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -111,6 +111,8 @@ struct ext4_free_data {
 
 	/* transaction which freed this extent */
 	tid_t	t_tid;
+
+	unsigned secdel:1; /* Secure deletion */
 };
 
 struct ext4_prealloc_space {
-- 
1.6.6.1

