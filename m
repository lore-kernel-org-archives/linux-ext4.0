From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [RFC PATCH] ext4: validate number of meta clusters in group
Date: Fri, 1 Jul 2016 15:06:41 +0200
Message-ID: <57766AE1.1040508@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040407080308090806000206"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------040407080308090806000206
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've found that sbi->s_es->s_reserved_gdt_blocks is not validated before
being used, so e.g. a value of 25600 will overflow the buffer head and
corrupt random kernel memory (I've observed 20+ different stack traces
due to this bug! many of them long after the code has finished).

The following patch fixes it for me:

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3020fd7..1ea5054 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -208,6 +208,9 @@ static int ext4_init_block_bitmap(struct super_block 
*sb,
  	memset(bh->b_data, 0, sb->s_blocksize);

  	bit_max = ext4_num_base_meta_clusters(sb, block_group);
+	if ((bit_max >> 3) >= bh->b_size)
+		return -EFSCORRUPTED;
+
  	for (bit = 0; bit < bit_max; bit++)
  		ext4_set_bit(bit, bh->b_data);

However, I think there are potentially more bugs later in this function
where offsets are not validated so it needs to be reviewed carefully.

Another question is whether we should do the validation earlier, e.g. in
ext4_fill_super(). I'm not too familiar with the code, but maybe
something like the attached patch would be better? It does seem to fix
the issue as well.


Vegard

--------------040407080308090806000206
Content-Type: text/x-patch;
 name="0001-ext4-validate-number-of-base-meta-clusters-in-group.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ext4-validate-number-of-base-meta-clusters-in-group.pat";
 filename*1="ch"

>From efcee80eb78816a4d495224ffc624adf04217044 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@oracle.com>
Date: Fri, 1 Jul 2016 15:03:39 +0200
Subject: [PATCH] ext4: validate number of base meta clusters in group

---
 fs/ext4/balloc.c |  4 +---
 fs/ext4/ext4.h   |  2 ++
 fs/ext4/super.c  | 10 ++++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 3020fd7..ec03f01 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -22,8 +22,6 @@
 
 #include <trace/events/ext4.h>
 
-static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
-					    ext4_group_t block_group);
 /*
  * balloc.c contains the blocks allocation and deallocation routines
  */
@@ -817,7 +815,7 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
  * This function returns the number of file system metadata clusters at
  * the beginning of a block group, including the reserved gdt blocks.
  */
-static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+unsigned ext4_num_base_meta_clusters(struct super_block *sb,
 				     ext4_group_t block_group)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b84aa1ca..e492b0b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2270,6 +2270,8 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
 extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
+extern unsigned ext4_num_base_meta_clusters(struct super_block *sb,
+				     ext4_group_t block_group);
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 					 ext4_fsblk_t goal,
 					 unsigned int flags,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 563555e..b5a9d28 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3641,6 +3641,16 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 	sbi->s_groups_count = blocks_count;
+
+	for (i = 0; i < sbi->s_groups_count; ++i) {
+		int bit_max = ext4_num_base_meta_clusters(sb, i);
+		if ((bit_max >> 3) >= sb->s_blocksize) {
+			ext4_msg(sb, KERN_WARNING, "meta cluster base for "
+				"group %u exceeds block size", i);
+			goto failed_mount;
+		}
+	}
+
 	sbi->s_blockfile_groups = min_t(ext4_group_t, sbi->s_groups_count,
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
-- 
1.9.1


--------------040407080308090806000206--
