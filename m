From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][5/15] e2fsprogs-uninit-fixes.patch
Date: Mon, 06 Oct 2008 16:01:10 +0530
Message-ID: <1223289070.4007.85.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_m06oa7WAV8ASw0fqmn3b3A)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:38285 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbYJFKbi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:31:38 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AVauJ004361
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:31:36 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00M01BS36U00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:31:36 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_m06oa7WAV8ASw0fqmn3b3A)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Bug fixes for uninit_bg feature:
- display correct inode number during BG_INO_UNINIT and INOREF_IN_USED
errors
- restart e2fsck only once in case of above errors
- initialize bitmaps properly considering whether block group is uninit
or not (needed for e2freefrag)

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>

--Boundary_(ID_m06oa7WAV8ASw0fqmn3b3A)
Content-type: text/x-patch; charset=UTF-8; name=e2fsprogs-uninit-fixes.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-uninit-fixes.patch

Bug fixes for uninit_bg feature:
- display correct inode number during BG_INO_UNINIT and INOREF_IN_USED errors
- restart e2fsck only once in case of above errors
- initialize bitmaps properly considering uninit or not (needed for e2freefrag)

Index: e2fsprogs-1.41.1/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.41.1.orig/debugfs/set_fields.c
+++ e2fsprogs-1.41.1/debugfs/set_fields.c
@@ -566,6 +566,7 @@ void do_set_block_group_descriptor(int a
 	}
 
 	set_gd = current_fs->group_desc[set_bg];
+	set_sb = *current_fs->super;
 
 	if (ss->func(ss, argv[3]) == 0) {
 		current_fs->group_desc[set_bg] = set_gd;
Index: e2fsprogs-1.41.1/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.1/e2fsck/problem.c
@@ -1301,12 +1301,12 @@ static struct e2fsck_problem problem_tab
 
 	/* Inode found in group where _INODE_UNINIT is set */
 	{ PR_2_INOREF_BG_INO_UNINIT,
-	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
+	  N_("@i %N found in @g %g where _INODE_UNINIT is set.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Inode found in group unused inodes area */
 	{ PR_2_INOREF_IN_UNUSED,
-	  N_("@i %i found in @g %g unused inodes area.  "),
+	  N_("@i %N found in @g %g unused inodes area.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Pass 3 errors */
Index: e2fsprogs-1.41.1/lib/ext2fs/rw_bitmaps.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/rw_bitmaps.c
+++ e2fsprogs-1.41.1/lib/ext2fs/rw_bitmaps.c
@@ -133,6 +133,36 @@ static errcode_t write_bitmaps(ext2_fils
 	return 0;
 }
 
+static void get_uninit_block_bitmap(ext2_filsys fs, dgrp_t group,
+				    char *block_bitmap)
+{
+	blk_t super_blk, old_desc_blk, new_desc_blk;
+	int block_nbytes = (int) EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
+	int i;
+
+	memset(block_bitmap, 0, block_nbytes);
+
+	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
+				  &old_desc_blk, &new_desc_blk, 0);
+
+	if (super_blk)
+		ext2fs_mark_block_bitmap(fs->block_map, super_blk);
+	if (old_desc_blk)
+		for (i = 0; i < fs->desc_blocks +
+		     fs->super->s_reserved_gdt_blocks; i++)
+			ext2fs_mark_block_bitmap(fs->block_map, old_desc_blk+i);
+	if (new_desc_blk)
+		ext2fs_mark_block_bitmap(fs->block_map, new_desc_blk);
+
+	ext2fs_mark_block_bitmap(fs->block_map,
+				 fs->group_desc[group].bg_block_bitmap);
+	ext2fs_mark_block_bitmap(fs->block_map,
+				 fs->group_desc[group].bg_inode_bitmap);
+	for (i = 0; i < fs->inode_blocks_per_group; i++)
+		ext2fs_mark_block_bitmap(fs->block_map,
+				fs->group_desc[group].bg_inode_table + i);
+}
+
 static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 {
 	dgrp_t i;
@@ -247,8 +277,15 @@ static errcode_t read_bitmaps(ext2_filsy
 					retval = EXT2_ET_BLOCK_BITMAP_READ;
 					goto cleanup;
 				}
-			} else
-				memset(block_bitmap, 0xff, block_nbytes);
+			} else {
+				if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+						EXT2_FEATURE_COMPAT_LAZY_BG) &&
+				    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+						EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+					memset(block_bitmap, 0xff, block_nbytes);
+				else
+					get_uninit_block_bitmap(fs, i, block_bitmap);
+			}
 			cnt = block_nbytes << 3;
 			retval = ext2fs_set_block_bitmap_range(fs->block_map,
 					       blk_itr, cnt, block_bitmap);
@@ -269,8 +306,15 @@ static errcode_t read_bitmaps(ext2_filsy
 					retval = EXT2_ET_INODE_BITMAP_READ;
 					goto cleanup;
 				}
-			} else
-				memset(inode_bitmap, 0xff, inode_nbytes);
+			} else {
+				if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+						EXT2_FEATURE_COMPAT_LAZY_BG) &&
+				    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+						EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+					memset(inode_bitmap, 0xff, inode_nbytes);
+				else
+					memset(inode_bitmap, 0, inode_nbytes);
+			}
 			cnt = inode_nbytes << 3;
 			retval = ext2fs_set_inode_bitmap_range(fs->inode_map,
 					       ino_itr, cnt, inode_bitmap);
Index: e2fsprogs-1.41.1/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.41.1.orig/misc/mke2fs.c
+++ e2fsprogs-1.41.1/misc/mke2fs.c
@@ -274,6 +274,8 @@ _("Warning: the backup superblock/group 
 				ext2fs_group_desc_csum_set(fs, group);
 				fs->super->s_free_blocks_count++;
 			}
+			/* The kernel doesn't need to zero the itable blocks */
+			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 		}
 		group_block += fs->super->s_blocks_per_group;
 	}
@@ -2066,6 +2068,8 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
+	if (!super_only)
+		ext2fs_set_gdt_csum(fs);
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
Index: e2fsprogs-1.41.1/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass2.c
+++ e2fsprogs-1.41.1/e2fsck/pass2.c
@@ -153,6 +153,12 @@ void e2fsck_pass2(e2fsck_t ctx)
 						&cd);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return;
+
+	if (ctx->flags & E2F_FLAG_RESTART_LATER) {
+		ctx->flags |= E2F_FLAG_RESTART;
+		return;
+	}
+
 	if (cd.pctx.errcode) {
 		fix_problem(ctx, PR_2_DBLIST_ITERATE, &cd.pctx);
 		ctx->flags |= E2F_FLAG_ABORT;
@@ -981,32 +987,32 @@ out_htree:
 
 		/*
 		 * Check if the inode was missed out because _INODE_UNINIT
-		 * flag was set or bg_itable_unused was incorrect.
-		 * If that is the case restart e2fsck.
-		 * XXX Optimisations TODO:
-		 * 1. only restart e2fsck once
-		 * 2. only exposed inodes are checked again.
+		 * flag was set or bg_itable_unused was incorrect. If that is
+		 * the case restart e2fsck, but this is done only once after
+		 * checking all directory blocks.
+		 * XXX Optimizations TODO:
+		 * 1. only exposed inodes are checked again.
 		 */
 		if (fs->group_desc[group].bg_flags & EXT2_BG_INODE_UNINIT) {
+			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_BG_INO_UNINIT,
 					&cd->pctx)){
 				fs->group_desc[group].bg_flags &=
 					~EXT2_BG_INODE_UNINIT;
-				ctx->flags |= E2F_FLAG_RESTART |
-					E2F_FLAG_SIGNAL_MASK;
+				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {
 				ext2fs_unmark_valid(fs);
 				if (problem == PR_2_BAD_INO)
 					goto next;
 			}
 		} else if (dirent->inode >= first_unused_inode) {
+			pctx.num = dirent->inode;
 			if (fix_problem(ctx, PR_2_INOREF_IN_UNUSED, &cd->pctx)){
 				fs->group_desc[group].bg_itable_unused = 0;
 				fs->group_desc[group].bg_flags &=
 					~EXT2_BG_INODE_UNINIT;
 				ext2fs_mark_super_dirty(fs);
-				ctx->flags |= E2F_FLAG_RESTART;
-				goto restart_fsck;
+				ctx->flags |= E2F_FLAG_RESTART_LATER;
 			} else {
 				ext2fs_unmark_valid(fs);
 				if (problem == PR_2_BAD_INO)
@@ -1147,7 +1153,6 @@ out_htree:
 	return 0;
 abort_free_dict:
 	ctx->flags |= E2F_FLAG_ABORT;
-restart_fsck:
 	dict_free_nodes(&de_dict);
 	return DIRENT_ABORT;
 }
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.h
@@ -163,6 +163,7 @@ struct resource_track {
 #define E2F_FLAG_CANCEL		0x0002 /* Cancel signaled */
 #define E2F_FLAG_SIGNAL_MASK	0x0003
 #define E2F_FLAG_RESTART	0x0004 /* Restart signaled */
+#define E2F_FLAG_RESTART_LATER	0x0008 /* Restart after all iterations done */
 
 #define E2F_FLAG_SETJMP_OK	0x0010 /* Setjmp valid for abort */
 
Index: e2fsprogs-1.41.1/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/closefs.c
+++ e2fsprogs-1.41.1/lib/ext2fs/closefs.c
@@ -126,6 +126,86 @@ int ext2fs_super_and_bgd_loc(ext2_filsys
 	return (numblocks);
 }
 
+/*
+ * ext2fs_super_and_bgd_loc2()
+ * @fs:		 ext2 fs pointer
+ * @group	       given block group
+ * @ret_super_blk:      if !NULL, returns super block location
+ * @ret_old_desc_blk:   if !NULL, returns location of the old block
+ *		      group descriptor
+ * @ret_new_desc_blk:   if !NULL, returns location of meta_bg block
+ *		      group descriptor
+ * @ret_used_blks:      if !NULL, returns number of blocks used by
+ *		      super block and group_descriptors.
+ *
+ * Returns errcode_t of 0
+ *
+ * ret_used_blks returns the number of blocks used by the superblock and
+ * group descriptors and unlike ext2fs_uper_and_bgd_loc2() it does not make the
+ * assumption that inode table and bitmaps will be in the same group.
+ *
+ * XXX: Remove this when we upgrade our e2fsprogs patches. Also blk64_t has been
+ * changed to blk_t here since this version does not have 64-bit support.
+ */
+errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
+				    dgrp_t group,
+				    blk_t *ret_super_blk,
+				    blk_t *ret_old_desc_blk,
+				    blk_t *ret_new_desc_blk,
+				    blk_t *ret_used_blks)
+{
+	blk_t group_block, super_blk = 0, old_desc_blk = 0, new_desc_blk = 0;
+	unsigned int meta_bg, meta_bg_size;
+	blk_t   numblocks = 0;
+	blk_t old_desc_blocks;
+	int     has_super;
+
+	group_block = fs->super->s_first_data_block +
+				(group * fs->super->s_blocks_per_group);
+
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	else
+		old_desc_blocks =
+			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
+
+	has_super = ext2fs_bg_has_super(fs, group);
+
+	if (has_super) {
+		super_blk = group_block;
+		numblocks++;
+	}
+	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
+	meta_bg = group / meta_bg_size;
+
+	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
+	    (meta_bg < fs->super->s_first_meta_bg)) {
+		if (has_super) {
+			old_desc_blk = group_block + 1;
+			numblocks += old_desc_blocks;
+		}
+	} else {
+		if (((group % meta_bg_size) == 0) ||
+		    ((group % meta_bg_size) == 1) ||
+		    ((group % meta_bg_size) == (meta_bg_size-1))) {
+			if (has_super)
+				has_super = 1;
+			new_desc_blk = group_block + has_super;
+			numblocks++;
+		}
+	}
+
+	if (ret_super_blk)
+		*ret_super_blk = super_blk;
+	if (ret_old_desc_blk)
+		*ret_old_desc_blk = old_desc_blk;
+	if (ret_new_desc_blk)
+		*ret_new_desc_blk = new_desc_blk;
+	if (ret_used_blks)
+		*ret_used_blks = numblocks;
+
+	return 0;
+}
 
 /*
  * This function forces out the primary superblock.  We need to only
Index: e2fsprogs-1.41.1/tests/m_uninit/expect.1
===================================================================
--- e2fsprogs-1.41.1.orig/tests/m_uninit/expect.1
+++ e2fsprogs-1.41.1/tests/m_uninit/expect.1
@@ -71,13 +71,13 @@ Group 1: (Blocks 8193-16384) [INODE_UNIN
   Inode table at 8453-8708 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 8709-16384
-  Free inodes: 
+  Free inodes: 2049-4096
 Group 2: (Blocks 16385-24576) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
   Inode table at 16387-16642 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 16385-24576
+  Free inodes: 4097-6144
 Group 3: (Blocks 24577-32768) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 24577, Group descriptors at 24578-24578
   Reserved GDT blocks at 24579-24834
@@ -85,13 +85,13 @@ Group 3: (Blocks 24577-32768) [INODE_UNI
   Inode table at 24837-25092 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 25093-32768
-  Free inodes: 
+  Free inodes: 6145-8192
 Group 4: (Blocks 32769-40960) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
   Inode table at 32771-33026 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 32769-40960
+  Free inodes: 8193-10240
 Group 5: (Blocks 40961-49152) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 40961, Group descriptors at 40962-40962
   Reserved GDT blocks at 40963-41218
@@ -99,13 +99,13 @@ Group 5: (Blocks 40961-49152) [INODE_UNI
   Inode table at 41221-41476 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 41477-49152
-  Free inodes: 
+  Free inodes: 10241-12288
 Group 6: (Blocks 49153-57344) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
   Inode table at 49155-49410 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 49153-57344
+  Free inodes: 12289-14336
 Group 7: (Blocks 57345-65536) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 57345, Group descriptors at 57346-57346
   Reserved GDT blocks at 57347-57602
@@ -113,13 +113,13 @@ Group 7: (Blocks 57345-65536) [INODE_UNI
   Inode table at 57605-57860 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 57861-65536
-  Free inodes: 
+  Free inodes: 14337-16384
 Group 8: (Blocks 65537-73728) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
   Inode table at 65539-65794 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 65537-73728
+  Free inodes: 16385-18432
 Group 9: (Blocks 73729-81920) [INODE_UNINIT, ITABLE_ZEROED]
   Backup superblock at 73729, Group descriptors at 73730-73730
   Reserved GDT blocks at 73731-73986
@@ -127,40 +127,40 @@ Group 9: (Blocks 73729-81920) [INODE_UNI
   Inode table at 73989-74244 (+260)
   7676 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 74245-81920
-  Free inodes: 
+  Free inodes: 18433-20480
 Group 10: (Blocks 81921-90112) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
   Inode table at 81923-82178 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 81921-90112
+  Free inodes: 20481-22528
 Group 11: (Blocks 90113-98304) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
   Inode table at 90115-90370 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 90113-98304
+  Free inodes: 22529-24576
 Group 12: (Blocks 98305-106496) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
   Inode table at 98307-98562 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 98305-106496
+  Free inodes: 24577-26624
 Group 13: (Blocks 106497-114688) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
   Inode table at 106499-106754 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 106497-114688
+  Free inodes: 26625-28672
 Group 14: (Blocks 114689-122880) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
   Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
   Inode table at 114691-114946 (+2)
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
-  Free inodes: 
+  Free blocks: 114689-122880
+  Free inodes: 28673-30720
 Group 15: (Blocks 122881-131071) [INODE_UNINIT, ITABLE_ZEROED]
   Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
   Inode table at 122883-123138 (+2)
   7933 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 123139-131071
-  Free inodes: 
+  Free inodes: 30721-32768

--Boundary_(ID_m06oa7WAV8ASw0fqmn3b3A)--
