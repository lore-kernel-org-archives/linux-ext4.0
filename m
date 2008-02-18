From: akpm@linux-foundation.org
Subject: + ext3-use-ext3_get_group_desc.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:16:48 -0800
Message-ID: <200802181017.m1IAHkZg019839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: use ext3_get_group_desc()
has been added to the -mm tree.  Its filename is
     ext3-use-ext3_get_group_desc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: use ext3_get_group_desc()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext3_get_group_desc()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN fs/ext3/inode.c~ext3-use-ext3_get_group_desc fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-use-ext3_get_group_desc
+++ a/fs/ext3/inode.c
@@ -2454,11 +2454,10 @@ out_stop:
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
 		unsigned long ino, struct ext3_iloc *iloc)
 {
-	unsigned long desc, group_desc, block_group;
+	unsigned long block_group;
 	unsigned long offset;
 	ext3_fsblk_t block;
-	struct buffer_head *bh;
-	struct ext3_group_desc * gdp;
+	struct ext3_group_desc *gdp;
 
 	if (!ext3_valid_inum(sb, ino)) {
 		/*
@@ -2470,27 +2469,15 @@ static ext3_fsblk_t ext3_get_inode_block
 	}
 
 	block_group = (ino - 1) / EXT3_INODES_PER_GROUP(sb);
-	if (block_group >= EXT3_SB(sb)->s_groups_count) {
-		ext3_error(sb,"ext3_get_inode_block","group >= groups count");
-		return 0;
-	}
-	smp_rmb();
-	group_desc = block_group >> EXT3_DESC_PER_BLOCK_BITS(sb);
-	desc = block_group & (EXT3_DESC_PER_BLOCK(sb) - 1);
-	bh = EXT3_SB(sb)->s_group_desc[group_desc];
-	if (!bh) {
-		ext3_error (sb, "ext3_get_inode_block",
-			    "Descriptor not loaded");
+	gdp = ext3_get_group_desc(sb, block_group, NULL);
+	if (!gdp)
 		return 0;
-	}
-
-	gdp = (struct ext3_group_desc *)bh->b_data;
 	/*
 	 * Figure out the offset within the block group inode table
 	 */
 	offset = ((ino - 1) % EXT3_INODES_PER_GROUP(sb)) *
 		EXT3_INODE_SIZE(sb);
-	block = le32_to_cpu(gdp[desc].bg_inode_table) +
+	block = le32_to_cpu(gdp->bg_inode_table) +
 		(offset >> EXT3_BLOCK_SIZE_BITS(sb));
 
 	iloc->block_group = block_group;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-dvb.patch
ext2-improve-ext2_readdir-return-value.patch
ext2-use-ext2_group_first_block_no.patch
ext2-use-ext2_fsblk_t-type.patch
ext3-use-ext3_group_first_block_no.patch
ext3-add-missing-ext3_journal_stop.patch
ext3-use-ext3_get_group_desc.patch
ext3-check-ext3_journal_get_write_access-errors.patch
ext4-use-ext4_group_first_block_no.patch
ext4-add-missing-ext4_journal_stop.patch
ext4-use-ext4_get_group_desc.patch
ext4-check-ext4_journal_get_write_access-errors.patch
