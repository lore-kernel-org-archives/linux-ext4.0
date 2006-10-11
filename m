From: akpm@osdl.org
Subject: [patch 035/100] ext4: rename logic_sb_block
Date: Wed, 11 Oct 2006 01:21:20 -0700
Message-ID: <200610110821.k9B8LK38012044@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28037 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965186AbWJKIuq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 04:50:46 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k9B8oPax024846
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2006 01:50:44 -0700
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

I assume this means "logical sb block".  So call it that.

I still don't understand the name though.  A block is a block.  What's
different about this one?

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/super.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN fs/ext4/super.c~ext4-rename-logic_sb_block fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-rename-logic_sb_block
+++ a/fs/ext4/super.c
@@ -1423,8 +1423,7 @@ static loff_t ext4_max_size(int bits)
 }
 
 static ext4_fsblk_t descriptor_loc(struct super_block *sb,
-				    ext4_fsblk_t logic_sb_block,
-				    int nr)
+				ext4_fsblk_t logical_sb_block, int nr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned long bg, first_meta_bg;
@@ -1434,7 +1433,7 @@ static ext4_fsblk_t descriptor_loc(struc
 
 	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG) ||
 	    nr < first_meta_bg)
-		return (logic_sb_block + nr + 1);
+		return logical_sb_block + nr + 1;
 	bg = sbi->s_desc_per_block * nr;
 	if (ext4_bg_has_super(sb, bg))
 		has_super = 1;
@@ -1449,7 +1448,7 @@ static int ext4_fill_super (struct super
 	struct ext4_sb_info *sbi;
 	ext4_fsblk_t block;
 	ext4_fsblk_t sb_block = get_sb_block(&data);
-	ext4_fsblk_t logic_sb_block;
+	ext4_fsblk_t logical_sb_block;
 	unsigned long offset = 0;
 	unsigned int journal_inum = 0;
 	unsigned long journal_devnum = 0;
@@ -1484,13 +1483,13 @@ static int ext4_fill_super (struct super
 	 * block sizes.  We need to calculate the offset from buffer start.
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
-		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logic_sb_block, blocksize);
+		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
+		offset = do_div(logical_sb_block, blocksize);
 	} else {
-		logic_sb_block = sb_block;
+		logical_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logic_sb_block))) {
+	if (!(bh = sb_bread(sb, logical_sb_block))) {
 		printk (KERN_ERR "EXT4-fs: unable to read superblock\n");
 		goto out_fail;
 	}
@@ -1590,9 +1589,9 @@ static int ext4_fill_super (struct super
 
 		brelse (bh);
 		sb_set_blocksize(sb, blocksize);
-		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logic_sb_block, blocksize);
-		bh = sb_bread(sb, logic_sb_block);
+		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
+		offset = do_div(logical_sb_block, blocksize);
+		bh = sb_bread(sb, logical_sb_block);
 		if (!bh) {
 			printk(KERN_ERR
 			       "EXT4-fs: Can't read superblock on 2nd try.\n");
@@ -1711,7 +1710,7 @@ static int ext4_fill_super (struct super
 	bgl_lock_init(&sbi->s_blockgroup_lock);
 
 	for (i = 0; i < db_count; i++) {
-		block = descriptor_loc(sb, logic_sb_block, i);
+		block = descriptor_loc(sb, logical_sb_block, i);
 		sbi->s_group_desc[i] = sb_bread(sb, block);
 		if (!sbi->s_group_desc[i]) {
 			printk (KERN_ERR "EXT4-fs: "
_
