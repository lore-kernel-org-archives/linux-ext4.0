From: hao.bigrat@gmail.com
Subject: [PATCH bigalloc] e2fsprogs: change root-inode to extent-mapped
Date: Wed, 20 Jul 2011 13:38:31 +0800
Message-ID: <1311140311-20242-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Ted Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47431 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1GTFio (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jul 2011 01:38:44 -0400
Received: by iwn6 with SMTP id 6so4673176iwn.19
        for <linux-ext4@vger.kernel.org>; Tue, 19 Jul 2011 22:38:44 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

After creating more than 1000 files in root directory on ext4 of bigalloc,
the kernel reports many error messages like:

[181126.730911] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc
[181126.735945] EXT4-fs error (device sda4): ext4_ind_map_blocks:1015: inode #2: comm falloc: Can't allocate blocks for non-extent mapped inodes with bigalloc

because the root inode of a new ext4 filesystem is type of block-mapped
even use mke2fs with "-O extent,bigalloc".

So change root inode to extent-mapped when do "mke2fs" if the option has "extent".

Signed-off-by: Robin Dong <sanbai@taobao.com>
Cc: Ted Ts'o <tytso@mit.edu>
---
 lib/ext2fs/mkdir.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 86c65da..d4b8d37 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -39,6 +39,9 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	ext2_ino_t		scratch_ino;
 	blk64_t			blk;
 	char			*block = 0;
+	int			max;
+	struct ext3_extent	*ex;
+	struct ext3_extent_header *eh;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -84,7 +87,23 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	inode.i_uid = inode.i_gid = 0;
 	ext2fs_iblk_set(fs, &inode, 1);
 	/* FIXME-64 */
-	inode.i_block[0] = blk;
+	if (fs->super->s_feature_incompat &
+	    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		eh = (struct ext3_extent_header *) &inode.i_block[0];
+		eh->eh_depth = 0;
+		eh->eh_entries = 1;
+		eh->eh_magic = ext2fs_cpu_to_le16(EXT3_EXT_MAGIC);
+		max = (sizeof(inode.i_block) - sizeof(*eh)) /
+			sizeof(struct ext3_extent);
+		eh->eh_max =  ext2fs_cpu_to_le16(max);
+		ex = EXT_FIRST_EXTENT(eh);
+		ex->ee_block = 0;
+		ex->ee_start = ext2fs_cpu_to_le32(blk & 0xFFFFFFFF);
+		ex->ee_start_hi = ext2fs_cpu_to_le16(blk >> 32);
+		ex->ee_len = 1;
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	} else
+		inode.i_block[0] = blk;
 	inode.i_links_count = 2;
 	inode.i_size = fs->blocksize;
 
-- 
1.7.3.2

