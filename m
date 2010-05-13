From: jiayingz@google.com (Jiaying Zhang)
Subject: [PATCH, RFC] support discard in non-journal ext4
Date: Wed, 12 May 2010 22:00:14 -0700 (PDT)
Message-ID: <20100513050014.879651BC316@ruihe.smo.corp.google.com>
Cc: jiayingz@google.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:25248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0EMFAU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 May 2010 01:00:20 -0400
Received: from hpaq3.eem.corp.google.com (hpaq3.eem.corp.google.com [172.25.149.3])
	by smtp-out.google.com with ESMTP id o4D50ICI031445
	for <linux-ext4@vger.kernel.org>; Wed, 12 May 2010 22:00:19 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch issues discard request for freed blocks in ext4_free_blocks()
if ext4 is mounted with discard option and without journal.

Author: Jiaying Zhang <jiayingz@google.com>
Date:   Wed May 12 21:11:46 2010 -0700

    Issue discard request in ext4_free_blocks() when ext4 has no journal and
    is mounted with discard option.
    
    Signed-off-by: Jiaying Zhang <jiayingz@google.com>

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a291cc3..d51b79a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2513,6 +2513,22 @@ int ext4_mb_release(struct super_block *sb)
 	return 0;
 }
 
+static void ext4_issue_discard(struct super_block *sb, ext4_group_t block_group,
+		ext4_grpblk_t block, int count)
+{
+	int ret;
+	ext4_fsblk_t discard_block;
+
+	discard_block = block + ext4_group_first_block_no(sb, block_group);
+	trace_ext4_discard_blocks(sb,
+			(unsigned long long) discard_block, count);
+	ret = sb_issue_discard(sb, discard_block, count);
+	if (ret == EOPNOTSUPP) {
+		ext4_warning(sb, "discard not supported, disabling");
+		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
+	}
+}
+
 /*
  * This function is called by the jbd2 layer once the commit has finished,
  * so we know we can free the blocks that were released with that commit.
@@ -2532,22 +2548,9 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
-		if (test_opt(sb, DISCARD)) {
-			int ret;
-			ext4_fsblk_t discard_block;
-
-			discard_block = entry->start_blk +
-				ext4_group_first_block_no(sb, entry->group);
-			trace_ext4_discard_blocks(sb,
-					(unsigned long long)discard_block,
-					entry->count);
-			ret = sb_issue_discard(sb, discard_block, entry->count);
-			if (ret == EOPNOTSUPP) {
-				ext4_warning(sb,
-					"discard not supported, disabling");
-				clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
-			}
-		}
+		if (test_opt(sb, DISCARD))
+			ext4_issue_discard(sb, entry->group,
+					entry->start_blk, entry->count);
 
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
@@ -4600,6 +4603,8 @@ do_more:
 		mb_clear_bits(bitmap_bh->b_data, bit, count);
 		mb_free_blocks(inode, &e4b, bit, count);
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
+		if (test_opt(sb, DISCARD))
+			ext4_issue_discard(sb, block_group, bit, count);
 	}
 
 	ret = ext4_free_blks_count(sb, gdp) + count;
