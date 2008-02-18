From: akpm@linux-foundation.org
Subject: + ext3-use-ext3_group_first_block_no.patch added to -mm tree
Date: Mon, 18 Feb 2008 02:16:38 -0800
Message-ID: <200802181017.m1IAHaAe019831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: use ext3_group_first_block_no()
has been added to the -mm tree.  Its filename is
     ext3-use-ext3_group_first_block_no.patch

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
Subject: ext3: use ext3_group_first_block_no()
From: Akinobu Mita <akinobu.mita@gmail.com>

Use ext3_group_first_block_no()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/super.c |    5 ++---
 fs/ext3/xattr.c |    6 ++----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/ext3/super.c~ext3-use-ext3_group_first_block_no fs/ext3/super.c
--- a/fs/ext3/super.c~ext3-use-ext3_group_first_block_no
+++ a/fs/ext3/super.c
@@ -1253,14 +1253,14 @@ static int ext3_setup_super(struct super
 static int ext3_check_descriptors(struct super_block *sb)
 {
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
-	ext3_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
-	ext3_fsblk_t last_block;
 	int i;
 
 	ext3_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++) {
 		struct ext3_group_desc *gdp = ext3_get_group_desc(sb, i, NULL);
+		ext3_fsblk_t first_block = ext3_group_first_block_no(sb, i);
+		ext3_fsblk_t last_block;
 
 		if (i == sbi->s_groups_count - 1)
 			last_block = le32_to_cpu(sbi->s_es->s_blocks_count) - 1;
@@ -1299,7 +1299,6 @@ static int ext3_check_descriptors(struct
 					le32_to_cpu(gdp->bg_inode_table));
 			return 0;
 		}
-		first_block += EXT3_BLOCKS_PER_GROUP(sb);
 	}
 
 	sbi->s_es->s_free_blocks_count=cpu_to_le32(ext3_count_free_blocks(sb));
diff -puN fs/ext3/xattr.c~ext3-use-ext3_group_first_block_no fs/ext3/xattr.c
--- a/fs/ext3/xattr.c~ext3-use-ext3_group_first_block_no
+++ a/fs/ext3/xattr.c
@@ -799,10 +799,8 @@ inserted:
 			get_bh(new_bh);
 		} else {
 			/* We need to allocate a new block */
-			ext3_fsblk_t goal = le32_to_cpu(
-					EXT3_SB(sb)->s_es->s_first_data_block) +
-				(ext3_fsblk_t)EXT3_I(inode)->i_block_group *
-				EXT3_BLOCKS_PER_GROUP(sb);
+			ext3_fsblk_t goal = ext3_group_first_block_no(sb,
+						EXT3_I(inode)->i_block_group);
 			ext3_fsblk_t block = ext3_new_block(handle, inode,
 							goal, &error);
 			if (error)
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
