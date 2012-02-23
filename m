From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] libext2: clear BG_BLOCK_UNINIT in any group containing metadata
Date: Thu, 23 Feb 2012 12:20:15 -0600
Message-ID: <4F46835F.5080009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab2BWSUS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Feb 2012 13:20:18 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q1NIKIAM022703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 23 Feb 2012 13:20:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Running a test like the m_uninit test runs:

# mke2fs -F -o Linux -O uninit_bg testfs 131072

results in groups which have blocks allocated for metadata, but
which still have the BLOCK_UNINIT flag set:

Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0x17c2, unused inodes 2048
  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
  Inode table at 16387-16642 (+2)

however, e2fsck doesn't find this error - which seems like another bug.

Doing another test like this:

mkfs.ext4 -I 256 -b 4096 -N 256 -G 1 -g 256 /dev/loop0 1024
mount /dev/loop0 /mnt/test
mkdir /mnt/test/dir
umount /mnt/test
fsck.ext4 -fn /dev/loop0

does find the error on fsck, I think because BLOCK_UNINIT gets
cleared, and the group isn't ignored at fsck time:

Free blocks count wrong for group #2 (253, counted=249).

In the first case, flex_bg is not set; in the 2nd it is set,
but s_log_groups_per_flex == 0 (due to -G 1), so in neither
case is flexbg_size set in ext2fs_allocate_group_table().

This leads to skipping the code which clears BLOCK_UNINIT after
the metadata is allocated.

I think the fix is to unconditionally clear the BLOCK_UNINIT flag
in whatever block group gets metadata allocated to it, as follows.

the m_uninit test needs to be fixed up too, as does e2fsck it seems,
to catch this error in the first place?

Sorry for the long commit message, if the patch looks right I can
try to do better ;)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 9f3d4e0..3462e85 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -88,6 +88,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	blk64_t		group_blk, start_blk, last_blk, new_blk, blk;
 	dgrp_t		last_grp = 0;
 	int		rem_grps = 0, flexbg_size = 0;
+	dgrp_t		gr;
 
 	group_blk = ext2fs_group_first_block2(fs, group);
 	last_blk = ext2fs_group_last_block2(fs, group);
@@ -141,13 +142,13 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_block_bitmap_loc_set(fs, group, new_blk);
+		gr = ext2fs_group_of_blk2(fs, new_blk);
+		ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_group_desc_csum_set(fs, gr);
 		}
+		ext2fs_group_desc_csum_set(fs, gr);
 	}
 
 	if (flexbg_size) {
@@ -172,13 +173,13 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap2(bmap, new_blk);
 		ext2fs_inode_bitmap_loc_set(fs, group, new_blk);
+		gr = ext2fs_group_of_blk2(fs, new_blk);
+		ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
-			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
-			ext2fs_group_desc_csum_set(fs, gr);
 		}
+		ext2fs_group_desc_csum_set(fs, gr);
 	}
 
 	/*
@@ -209,14 +210,13 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++) {
 			ext2fs_mark_block_bitmap2(bmap, blk);
+			gr = ext2fs_group_of_blk2(fs, blk);
+			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 			if (flexbg_size) {
-				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
 				ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 				ext2fs_free_blocks_count_add(fs->super, -1);
-				ext2fs_bg_flags_clear(fs, gr,
-						     EXT2_BG_BLOCK_UNINIT);
-				ext2fs_group_desc_csum_set(fs, gr);
 			}
+			ext2fs_group_desc_csum_set(fs, gr);
 		}
 		ext2fs_inode_table_loc_set(fs, group, new_blk);
 	}

