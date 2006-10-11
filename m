From: akpm@osdl.org
Subject: [patch 034/100] ext4 64 bit divide fix
Date: Wed, 11 Oct 2006 01:21:19 -0700
Message-ID: <200610110821.k9B8LJiA012040@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28549 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965185AbWJKIur (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 04:50:47 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k9B8oPb1024846
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2006 01:50:45 -0700
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

With CONFIG_LBD=n, sector_div() expands to a plain old divide.  But ext4 is
_not_ passing in a sector_t as the first argument, so...

fs/built-in.o: In function `ext4_get_group_no_and_offset':
fs/ext4/balloc.c:39: undefined reference to `__umoddi3'
fs/ext4/balloc.c:41: undefined reference to `__udivdi3'
fs/built-in.o: In function `find_group_orlov':
fs/ext4/ialloc.c:278: undefined reference to `__udivdi3'
fs/built-in.o: In function `ext4_fill_super':
fs/ext4/super.c:1488: undefined reference to `__udivdi3'
fs/ext4/super.c:1488: undefined reference to `__umoddi3'
fs/ext4/super.c:1594: undefined reference to `__udivdi3'
fs/ext4/super.c:1601: undefined reference to `__umoddi3'

Fix that up by calling do_div() directly.

Also cast the arg to u64.  do_div() is only defined on u64, and ext4_fsblk_t
is supposed to be opaque.

Note especially the changes to find_group_orlov().  It was attempting to do

	do_div(int, unsigned long long);

which is royally screwed up.  Switched it to plain old divide.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c |    2 +-
 fs/ext4/ialloc.c |    6 +++---
 fs/ext4/super.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-64-bit-divide-fix fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/balloc.c
@@ -34,7 +34,7 @@ void ext4_get_group_no_and_offset(struct
 	ext4_grpblk_t offset;
 
         blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	offset = do_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
 	if (offsetp)
 		*offsetp = offset;
 	if (blockgrpp)
diff -puN fs/ext4/ialloc.c~ext4-64-bit-divide-fix fs/ext4/ialloc.c
--- a/fs/ext4/ialloc.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/ialloc.c
@@ -275,7 +275,7 @@ static int find_group_orlov(struct super
 	avefreei = freei / ngroups;
 	freeb = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
 	avefreeb = freeb;
-	sector_div(avefreeb, ngroups);
+	do_div(avefreeb, ngroups);
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
 	if ((parent == sb->s_root->d_inode) ||
@@ -305,14 +305,14 @@ static int find_group_orlov(struct super
 	}
 
 	blocks_per_dir = ext4_blocks_count(es) - freeb;
-	sector_div(blocks_per_dir, ndirs);
+	do_div(blocks_per_dir, ndirs);
 
 	max_dirs = ndirs / ngroups + inodes_per_group / 16;
 	min_inodes = avefreei - inodes_per_group / 4;
 	min_blocks = avefreeb - EXT4_BLOCKS_PER_GROUP(sb) / 4;
 
 	max_debt = EXT4_BLOCKS_PER_GROUP(sb);
-	sector_div(max_debt, max(blocks_per_dir, (ext4_fsblk_t)BLOCK_COST));
+	max_debt /= max_t(int, blocks_per_dir, BLOCK_COST);
 	if (max_debt * INODE_COST > inodes_per_group)
 		max_debt = inodes_per_group / INODE_COST;
 	if (max_debt > 255)
diff -puN fs/ext4/super.c~ext4-64-bit-divide-fix fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-64-bit-divide-fix
+++ a/fs/ext4/super.c
@@ -1485,7 +1485,7 @@ static int ext4_fill_super (struct super
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
 		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = sector_div(logic_sb_block, blocksize);
+		offset = do_div(logic_sb_block, blocksize);
 	} else {
 		logic_sb_block = sb_block;
 	}
@@ -1591,7 +1591,7 @@ static int ext4_fill_super (struct super
 		brelse (bh);
 		sb_set_blocksize(sb, blocksize);
 		logic_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = sector_div(logic_sb_block, blocksize);
+		offset = do_div(logic_sb_block, blocksize);
 		bh = sb_bread(sb, logic_sb_block);
 		if (!bh) {
 			printk(KERN_ERR
_
