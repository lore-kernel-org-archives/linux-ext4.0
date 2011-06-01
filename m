From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/2] ext4: arrange ext4_*_bit() macros
Date: Wed,  1 Jun 2011 23:36:48 +0900
Message-ID: <1306939009-11283-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:59503 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1FAOgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 10:36:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 - remove unused ext4_{set,clear}_bit_atomic and ext4_find_first_zero_bit
 - rename ext4_{set,clear}_bit to ext4_test_and_{set,clear}_bit
 - reintroduce ext4_{set,clear}_bit for __{set,clear}_bit_le

This changes ext4_{set,clear}_bit safely, because if someone uses
these macros without noticing the change, new ext4_{set,clear}_bit
don't have return value and causes compiler errors where the return
value is used.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
v2: rewritten to keep ext4_*_bit() macros

 fs/ext4/balloc.c  |    8 ++++----
 fs/ext4/ext4.h    |    9 ++++-----
 fs/ext4/ialloc.c  |    9 ++++-----
 fs/ext4/mballoc.c |    4 ++--
 fs/ext4/resize.c  |   12 ++++++------
 5 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 264f694..b6747e4 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -144,7 +144,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		int flex_bg = 0;
 
 		for (bit = 0; bit < bit_max; bit++)
-			ext4_set_bit(bit, bh->b_data);
+			ext4_test_and_set_bit(bit, bh->b_data);
 
 		start = ext4_group_first_block_no(sb, block_group);
 
@@ -155,18 +155,18 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		/* Set bits for block and inode bitmaps, and inode table */
 		tmp = ext4_block_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
-			ext4_set_bit(tmp - start, bh->b_data);
+			ext4_test_and_set_bit(tmp - start, bh->b_data);
 
 		tmp = ext4_inode_bitmap(sb, gdp);
 		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
-			ext4_set_bit(tmp - start, bh->b_data);
+			ext4_test_and_set_bit(tmp - start, bh->b_data);
 
 		tmp = ext4_inode_table(sb, gdp);
 		for (; tmp < ext4_inode_table(sb, gdp) +
 				sbi->s_itb_per_group; tmp++) {
 			if (!flex_bg ||
 				ext4_block_in_group(sb, tmp, block_group))
-				ext4_set_bit(tmp - start, bh->b_data);
+				ext4_test_and_set_bit(tmp - start, bh->b_data);
 		}
 		/*
 		 * Also if the number of blocks within the group is
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..04db84f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -930,12 +930,11 @@ struct ext4_inode_info {
 #define test_opt2(sb, opt)		(EXT4_SB(sb)->s_mount_opt2 & \
 					 EXT4_MOUNT2_##opt)
 
-#define ext4_set_bit			__test_and_set_bit_le
-#define ext4_set_bit_atomic		ext2_set_bit_atomic
-#define ext4_clear_bit			__test_and_clear_bit_le
-#define ext4_clear_bit_atomic		ext2_clear_bit_atomic
+#define ext4_test_and_set_bit		__test_and_set_bit_le
+#define ext4_set_bit			__set_bit_le
+#define ext4_test_and_clear_bit		__test_and_clear_bit_le
+#define ext4_clear_bit			__clear_bit_le
 #define ext4_test_bit			test_bit_le
-#define ext4_find_first_zero_bit	find_first_zero_bit_le
 #define ext4_find_next_zero_bit		find_next_zero_bit_le
 #define ext4_find_next_bit		find_next_bit_le
 
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..90bef6b 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -59,7 +59,7 @@ void ext4_mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 
 	ext4_debug("mark end bits +%d through +%d used\n", start_bit, end_bit);
 	for (i = start_bit; i < ((start_bit + 7) & ~7UL); i++)
-		ext4_set_bit(i, bitmap);
+		ext4_test_and_set_bit(i, bitmap);
 	if (i < end_bit)
 		memset(bitmap + (i >> 3), 0xff, (end_bit - i) >> 3);
 }
@@ -252,7 +252,7 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 		fatal = ext4_journal_get_write_access(handle, bh2);
 	}
 	ext4_lock_group(sb, block_group);
-	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	cleared = ext4_test_and_clear_bit(bit, bitmap_bh->b_data);
 	if (fatal || !cleared) {
 		ext4_unlock_group(sb, block_group);
 		goto out;
@@ -729,7 +729,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	 */
 	down_read(&grp->alloc_sem);
 	ext4_lock_group(sb, group);
-	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
+	if (ext4_test_and_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
 		retval = 1;
 		goto err_ret;
@@ -884,8 +884,7 @@ got_group:
 			goto fail;
 
 repeat_in_this_group:
-		ino = ext4_find_next_zero_bit((unsigned long *)
-					      inode_bitmap_bh->b_data,
+		ino = ext4_find_next_zero_bit(inode_bitmap_bh->b_data,
 					      EXT4_INODES_PER_GROUP(sb), ino);
 
 		if (ino < EXT4_INODES_PER_GROUP(sb)) {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 859f2ae..b423adf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -384,13 +384,13 @@ static inline int mb_test_bit(int bit, void *addr)
 static inline void mb_set_bit(int bit, void *addr)
 {
 	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_set_bit(bit, addr);
+	ext4_test_and_set_bit(bit, addr);
 }
 
 static inline void mb_clear_bit(int bit, void *addr)
 {
 	addr = mb_correct_addr_and_bit(&bit, addr);
-	ext4_clear_bit(bit, addr);
+	ext4_test_and_clear_bit(bit, addr);
 }
 
 static inline int mb_find_next_zero_bit(void *addr, int max, int start)
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 80bbc9c..cc40963 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -194,7 +194,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 
 	if (ext4_bg_has_super(sb, input->group)) {
 		ext4_debug("mark backup superblock %#04llx (+0)\n", start);
-		ext4_set_bit(0, bh->b_data);
+		ext4_test_and_set_bit(0, bh->b_data);
 	}
 
 	/* Copy all of the GDT blocks into the backup in this group */
@@ -225,7 +225,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 			brelse(gdb);
 			goto exit_bh;
 		}
-		ext4_set_bit(bit, bh->b_data);
+		ext4_test_and_set_bit(bit, bh->b_data);
 		brelse(gdb);
 	}
 
@@ -237,14 +237,14 @@ static int setup_new_group_blocks(struct super_block *sb,
 	if (err)
 		goto exit_bh;
 	for (i = 0, bit = gdblocks + 1; i < reserved_gdb; i++, bit++)
-		ext4_set_bit(bit, bh->b_data);
+		ext4_test_and_set_bit(bit, bh->b_data);
 
 	ext4_debug("mark block bitmap %#04llx (+%llu)\n", input->block_bitmap,
 		   input->block_bitmap - start);
-	ext4_set_bit(input->block_bitmap - start, bh->b_data);
+	ext4_test_and_set_bit(input->block_bitmap - start, bh->b_data);
 	ext4_debug("mark inode bitmap %#04llx (+%llu)\n", input->inode_bitmap,
 		   input->inode_bitmap - start);
-	ext4_set_bit(input->inode_bitmap - start, bh->b_data);
+	ext4_test_and_set_bit(input->inode_bitmap - start, bh->b_data);
 
 	/* Zero out all of the inode table blocks */
 	block = input->inode_table;
@@ -255,7 +255,7 @@ static int setup_new_group_blocks(struct super_block *sb,
 		goto exit_bh;
 	for (i = 0, bit = input->inode_table - start;
 	     i < sbi->s_itb_per_group; i++, bit++)
-		ext4_set_bit(bit, bh->b_data);
+		ext4_test_and_set_bit(bit, bh->b_data);
 
 	if ((err = extend_or_restart_transaction(handle, 2, bh)))
 		goto exit_bh;
-- 
1.7.4.4

