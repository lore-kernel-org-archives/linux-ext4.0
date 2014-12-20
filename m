From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 28/31] libext2fs: use fallocate for creating journals and
 hugefiles
Date: Sat, 20 Dec 2014 13:19:55 -0800
Message-ID: <20141220211955.25563.69309.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45453 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbaLTVUB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:20:01 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use the new fallocate API for creating the journal and the mk_hugefile
feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/mkjournal.c                |  134 +++++----------------------------
 misc/mk_hugefiles.c                   |   96 ++----------------------
 tests/f_opt_extent/expect             |   15 ----
 tests/r_32to64bit_meta/expect         |    4 -
 tests/r_32to64bit_move_itable/expect  |    4 -
 tests/r_64to32bit/expect              |    4 -
 tests/r_64to32bit_meta/expect         |    4 -
 tests/t_disable_mcsum_noinitbg/expect |    6 +
 tests/t_enable_mcsum/expect           |   15 ----
 tests/t_enable_mcsum_ext3/expect      |    8 +-
 tests/t_enable_mcsum_initbg/expect    |   11 +--
 tests/t_iexpand_full/expect           |    4 -
 12 files changed, 56 insertions(+), 249 deletions(-)


diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index c42cb98..02a65cb 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -227,89 +227,6 @@ errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 }
 
 /*
- * Helper function for creating the journal using direct I/O routines
- */
-struct mkjournal_struct {
-	int		num_blocks;
-	int		newblocks;
-	blk64_t		goal;
-	blk64_t		blk_to_zero;
-	int		zero_count;
-	int		flags;
-	char		*buf;
-	errcode_t	err;
-};
-
-static int mkjournal_proc(ext2_filsys	fs,
-			  blk64_t	*blocknr,
-			  e2_blkcnt_t	blockcnt,
-			  blk64_t	ref_block EXT2FS_ATTR((unused)),
-			  int		ref_offset EXT2FS_ATTR((unused)),
-			  void		*priv_data)
-{
-	struct mkjournal_struct *es = (struct mkjournal_struct *) priv_data;
-	blk64_t	new_blk;
-	errcode_t	retval;
-
-	if (*blocknr) {
-		es->goal = *blocknr;
-		return 0;
-	}
-	if (blockcnt &&
-	    (EXT2FS_B2C(fs, es->goal) == EXT2FS_B2C(fs, es->goal+1)))
-		new_blk = es->goal+1;
-	else {
-		es->goal &= ~EXT2FS_CLUSTER_MASK(fs);
-		retval = ext2fs_new_block2(fs, es->goal, 0, &new_blk);
-		if (retval) {
-			es->err = retval;
-			return BLOCK_ABORT;
-		}
-		ext2fs_block_alloc_stats2(fs, new_blk, +1);
-		es->newblocks++;
-	}
-	if (blockcnt >= 0)
-		es->num_blocks--;
-
-	retval = 0;
-	if (blockcnt <= 0)
-		retval = io_channel_write_blk64(fs->io, new_blk, 1, es->buf);
-	else if (!(es->flags & EXT2_MKJOURNAL_LAZYINIT)) {
-		if (es->zero_count) {
-			if ((es->blk_to_zero + es->zero_count == new_blk) &&
-			    (es->zero_count < 1024))
-				es->zero_count++;
-			else {
-				retval = ext2fs_zero_blocks2(fs,
-							     es->blk_to_zero,
-							     es->zero_count,
-							     0, 0);
-				es->zero_count = 0;
-			}
-		}
-		if (es->zero_count == 0) {
-			es->blk_to_zero = new_blk;
-			es->zero_count = 1;
-		}
-	}
-
-	if (blockcnt == 0)
-		memset(es->buf, 0, fs->blocksize);
-
-	if (retval) {
-		es->err = retval;
-		return BLOCK_ABORT;
-	}
-	*blocknr = es->goal = new_blk;
-
-	if (es->num_blocks == 0)
-		return (BLOCK_CHANGED | BLOCK_ABORT);
-	else
-		return BLOCK_CHANGED;
-
-}
-
-/*
  * Calculate the initial goal block to be roughly at the middle of the
  * filesystem.  Pick a group that has the largest number of free
  * blocks.
@@ -350,7 +267,8 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	errcode_t		retval;
 	struct ext2_inode	inode;
 	unsigned long long	inode_size;
-	struct mkjournal_struct	es;
+	int			falloc_flags = EXT2_FALLOCATE_FORCE_INIT;
+	blk64_t			zblk;
 
 	if ((retval = ext2fs_create_journal_superblock(fs, num_blocks, flags,
 						       &buf)))
@@ -367,40 +285,16 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 		goto out2;
 	}
 
-	es.num_blocks = num_blocks;
-	es.newblocks = 0;
-	es.buf = buf;
-	es.err = 0;
-	es.flags = flags;
-	es.zero_count = 0;
-	es.goal = (goal != ~0ULL) ? goal : get_midpoint_journal_block(fs);
+	if (goal == ~0ULL)
+		goal = get_midpoint_journal_block(fs);
 
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
 		inode.i_flags |= EXT4_EXTENTS_FL;
-		if ((retval = ext2fs_write_inode(fs, journal_ino, &inode)))
-			goto out2;
-	}
 
-	retval = ext2fs_block_iterate3(fs, journal_ino, BLOCK_FLAG_APPEND,
-				       0, mkjournal_proc, &es);
-	if (retval)
-		goto out2;
-	if (es.err) {
-		retval = es.err;
-		goto out2;
-	}
-	if (es.zero_count) {
-		retval = ext2fs_zero_blocks2(fs, es.blk_to_zero,
-					    es.zero_count, 0, 0);
-		if (retval)
-			goto out2;
-	}
-
-	if ((retval = ext2fs_read_inode(fs, journal_ino, &inode)))
-		goto out2;
+	if (!(flags & EXT2_MKJOURNAL_LAZYINIT))
+		falloc_flags |= EXT2_FALLOCATE_ZERO_BLOCKS;
 
 	inode_size = (unsigned long long)fs->blocksize * num_blocks;
-	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	inode.i_mtime = inode.i_ctime = fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
@@ -408,9 +302,21 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if (retval)
 		goto out2;
 
+	retval = ext2fs_fallocate(fs, falloc_flags, journal_ino,
+				  &inode, goal, 0, num_blocks);
+	if (retval)
+		goto out2;
+
 	if ((retval = ext2fs_write_new_inode(fs, journal_ino, &inode)))
 		goto out2;
-	retval = 0;
+
+	retval = ext2fs_bmap2(fs, journal_ino, &inode, NULL, 0, 0, NULL, &zblk);
+	if (retval)
+		goto out2;
+
+	retval = io_channel_write_blk64(fs->io, zblk, 1, buf);
+	if (retval)
+		goto out2;
 
 	memcpy(fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
 	fs->super->s_jnl_blocks[15] = inode.i_size_high;
diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index e42c0b9..0978d55 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -258,12 +258,7 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 {
 	errcode_t		retval;
-	blk64_t			lblk, bend = 0;
-	__u64			size;
-	blk64_t			left;
-	blk64_t			count = 0;
 	struct ext2_inode	inode;
-	ext2_extent_handle_t	handle;
 
 	retval = ext2fs_new_inode(fs, 0, LINUX_S_IFREG, NULL, ino);
 	if (retval)
@@ -283,85 +278,20 @@ static errcode_t mk_hugefile(ext2_filsys fs, blk64_t num,
 
 	ext2fs_inode_alloc_stats2(fs, *ino, +1, 0);
 
-	retval = ext2fs_extent_open2(fs, *ino, &inode, &handle);
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT3_FEATURE_INCOMPAT_EXTENTS))
+		inode.i_flags |= EXT4_EXTENTS_FL;
+	retval = ext2fs_fallocate(fs,
+				  EXT2_FALLOCATE_FORCE_INIT |
+				  EXT2_FALLOCATE_ZERO_BLOCKS,
+				  *ino, &inode, ~0ULL, 0, num);
 	if (retval)
 		return retval;
-
-	lblk = 0;
-	left = num ? num : 1;
-	while (left) {
-		blk64_t pblk, end;
-		blk64_t n = left;
-
-		retval =  ext2fs_find_first_zero_block_bitmap2(fs->block_map,
-			goal, ext2fs_blocks_count(fs->super) - 1, &end);
-		if (retval)
-			goto errout;
-		goal = end;
-
-		retval =  ext2fs_find_first_set_block_bitmap2(fs->block_map, goal,
-			       ext2fs_blocks_count(fs->super) - 1, &bend);
-		if (retval == ENOENT) {
-			bend = ext2fs_blocks_count(fs->super);
-			if (num == 0)
-				left = 0;
-		}
-		if (!num || bend - goal < left)
-			n = bend - goal;
-		pblk = goal;
-		if (num)
-			left -= n;
-		goal += n;
-		count += n;
-		ext2fs_block_alloc_stats_range(fs, pblk, n, +1);
-
-		if (zero_hugefile) {
-			blk64_t ret_blk;
-			retval = ext2fs_zero_blocks2(fs, pblk, n,
-						     &ret_blk, NULL);
-
-			if (retval)
-				com_err(program_name, retval,
-					_("while zeroing block %llu "
-					  "for hugefile"), ret_blk);
-		}
-
-		while (n) {
-			blk64_t l = n;
-			struct ext2fs_extent newextent;
-
-			if (l > EXT_INIT_MAX_LEN)
-				l = EXT_INIT_MAX_LEN;
-
-			newextent.e_len = l;
-			newextent.e_pblk = pblk;
-			newextent.e_lblk = lblk;
-			newextent.e_flags = 0;
-
-			retval = ext2fs_extent_insert(handle,
-					EXT2_EXTENT_INSERT_AFTER, &newextent);
-			if (retval)
-				return retval;
-			pblk += l;
-			lblk += l;
-			n -= l;
-		}
-	}
-
-	retval = ext2fs_read_inode(fs, *ino, &inode);
-	if (retval)
-		goto errout;
-
-	retval = ext2fs_iblk_add_blocks(fs, &inode,
-					count / EXT2FS_CLUSTER_RATIO(fs));
-	if (retval)
-		goto errout;
-	size = (__u64) count * fs->blocksize;
-	retval = ext2fs_inode_size_set(fs, &inode, size);
+	retval = ext2fs_inode_size_set(fs, &inode, num * fs->blocksize);
 	if (retval)
-		goto errout;
+		return retval;
 
-	retval = ext2fs_write_new_inode(fs, *ino, &inode);
+	retval = ext2fs_write_inode(fs, *ino, &inode);
 	if (retval)
 		goto errout;
 
@@ -379,13 +309,7 @@ retry:
 		goto retry;
 	}
 
-	if (retval)
-		goto errout;
-
 errout:
-	if (handle)
-		ext2fs_extent_free(handle);
-
 	return retval;
 }
 
diff --git a/tests/f_opt_extent/expect b/tests/f_opt_extent/expect
index 6d4863b..f4ed7ff 100644
--- a/tests/f_opt_extent/expect
+++ b/tests/f_opt_extent/expect
@@ -30,22 +30,11 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              570
-+Free blocks:              567
+-Free blocks:              569
++Free blocks:              566
  Free inodes:              65047
  First block:              1
  Block size:               1024
-@@ -47,8 +47,8 @@
-   Block bitmap at 262 (+261)
-   Inode bitmap at 278 (+277)
-   Inode table at 294-549 (+293)
--  21 free blocks, 535 free inodes, 3 directories, 535 unused inodes
--  Free blocks: 4414-4434
-+  18 free blocks, 535 free inodes, 3 directories, 535 unused inodes
-+  Free blocks: 4417-4434
-   Free inodes: 490-1024
- Group 1: (Blocks 8193-16384) [INODE_UNINIT]
-   Backup superblock at 8193, Group descriptors at 8194-8197
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
diff --git a/tests/r_32to64bit_meta/expect b/tests/r_32to64bit_meta/expect
index 0eacd45..8796503 100644
--- a/tests/r_32to64bit_meta/expect
+++ b/tests/r_32to64bit_meta/expect
@@ -35,8 +35,8 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              858
-+Free blocks:              852
+-Free blocks:              857
++Free blocks:              851
  Free inodes:              65046
  First block:              1
  Block size:               1024
diff --git a/tests/r_32to64bit_move_itable/expect b/tests/r_32to64bit_move_itable/expect
index b51663d..999bb8d 100644
--- a/tests/r_32to64bit_move_itable/expect
+++ b/tests/r_32to64bit_move_itable/expect
@@ -35,8 +35,8 @@ Change in FS metadata:
  Inode count:              98304
  Block count:              786432
  Reserved block count:     39321
--Free blocks:              764
-+Free blocks:              734
+-Free blocks:              763
++Free blocks:              733
  Free inodes:              97566
  First block:              1
  Block size:               1024
diff --git a/tests/r_64to32bit/expect b/tests/r_64to32bit/expect
index 13e94a2..5d2ea4b 100644
--- a/tests/r_64to32bit/expect
+++ b/tests/r_64to32bit/expect
@@ -35,8 +35,8 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              571
-+Free blocks:              589
+-Free blocks:              570
++Free blocks:              588
  Free inodes:              65048
  First block:              1
  Block size:               1024
diff --git a/tests/r_64to32bit_meta/expect b/tests/r_64to32bit_meta/expect
index d6e2dcc..1400c6b 100644
--- a/tests/r_64to32bit_meta/expect
+++ b/tests/r_64to32bit_meta/expect
@@ -35,8 +35,8 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              852
-+Free blocks:              858
+-Free blocks:              851
++Free blocks:              857
  Free inodes:              65046
  First block:              1
  Block size:               1024
diff --git a/tests/t_disable_mcsum_noinitbg/expect b/tests/t_disable_mcsum_noinitbg/expect
index a022631..09e4ff1 100644
--- a/tests/t_disable_mcsum_noinitbg/expect
+++ b/tests/t_disable_mcsum_noinitbg/expect
@@ -40,9 +40,9 @@ Change in FS metadata:
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
-+  21 free blocks, 536 free inodes, 2 directories
-   Free blocks: 4413-4433
+-  0 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  0 free blocks, 536 free inodes, 2 directories
+   Free blocks: 
    Free inodes: 489-1024
 -Group 1: (Blocks 8193-16384) [INODE_UNINIT]
 +Group 1: (Blocks 8193-16384)
diff --git a/tests/t_enable_mcsum/expect b/tests/t_enable_mcsum/expect
index 2ee3c27..81e1125 100644
--- a/tests/t_enable_mcsum/expect
+++ b/tests/t_enable_mcsum/expect
@@ -45,8 +45,8 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              571
-+Free blocks:              568
+-Free blocks:              570
++Free blocks:              567
  Free inodes:              65048
  First block:              1
  Block size:               1024
@@ -58,17 +58,6 @@ Change in FS metadata:
  Journal features:         (none)
  Journal size:             16M
  Journal length:           16384
-@@ -46,8 +47,8 @@
-   Block bitmap at 262 (+261)
-   Inode bitmap at 278 (+277)
-   Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
--  Free blocks: 4413-4433
-+  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
-+  Free blocks: 4413, 4417-4433
-   Free inodes: 489-1024
- Group 1: (Blocks 8193-16384) [INODE_UNINIT]
-   Backup superblock at 8193, Group descriptors at 8194-8197
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
diff --git a/tests/t_enable_mcsum_ext3/expect b/tests/t_enable_mcsum_ext3/expect
index 5460482..0f761a9 100644
--- a/tests/t_enable_mcsum_ext3/expect
+++ b/tests/t_enable_mcsum_ext3/expect
@@ -49,8 +49,8 @@ Change in FS metadata:
    Reserved GDT blocks at 4-259
    Block bitmap at 260 (+259)
 @@ -45,7 +46,7 @@
-   7789 free blocks, 1013 free inodes, 2 directories
-   Free blocks: 404-8192
+   0 free blocks, 1013 free inodes, 2 directories
+   Free blocks: 
    Free inodes: 12-1024
 -Group 1: (Blocks 8193-16384)
 +Group 1: (Blocks 8193-16384) [ITABLE_ZEROED]
@@ -58,8 +58,8 @@ Change in FS metadata:
    Reserved GDT blocks at 8196-8451
    Block bitmap at 8452 (+259)
 @@ -54,6 +55,6 @@
-   7803 free blocks, 1024 free inodes, 0 directories
-   Free blocks: 8582-16384
+   0 free blocks, 1024 free inodes, 0 directories
+   Free blocks: 
    Free inodes: 1025-2048
 -Group 2: (Blocks 16385-24576)
 +Group 2: (Blocks 16385-24576) [ITABLE_ZEROED]
diff --git a/tests/t_enable_mcsum_initbg/expect b/tests/t_enable_mcsum_initbg/expect
index d3b4444..3cbb98f 100644
--- a/tests/t_enable_mcsum_initbg/expect
+++ b/tests/t_enable_mcsum_initbg/expect
@@ -45,8 +45,8 @@ Change in FS metadata:
  Inode count:              65536
  Block count:              524288
  Reserved block count:     26214
--Free blocks:              571
-+Free blocks:              568
+-Free blocks:              570
++Free blocks:              567
  Free inodes:              65048
  First block:              1
  Block size:               1024
@@ -69,10 +69,9 @@ Change in FS metadata:
    Block bitmap at 262 (+261)
    Inode bitmap at 278 (+277)
    Inode table at 294-549 (+293)
--  21 free blocks, 536 free inodes, 2 directories
--  Free blocks: 4413-4433
-+  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
-+  Free blocks: 4413, 4417-4433
+-  0 free blocks, 536 free inodes, 2 directories
++  0 free blocks, 536 free inodes, 2 directories, 536 unused inodes
+   Free blocks: 
    Free inodes: 489-1024
 -Group 1: (Blocks 8193-16384)
 +Group 1: (Blocks 8193-16384) [INODE_UNINIT, ITABLE_ZEROED]
diff --git a/tests/t_iexpand_full/expect b/tests/t_iexpand_full/expect
index 3eb1715..0474827 100644
--- a/tests/t_iexpand_full/expect
+++ b/tests/t_iexpand_full/expect
@@ -21,8 +21,8 @@ Setting inode size 256
 Exit status is 0
 Change in FS metadata:
 @@ -13 +13 @@
--Free blocks:              12301
-+Free blocks:              12
+-Free blocks:              12299
++Free blocks:              10
 @@ -22 +22 @@
 -Inode blocks per group:   128
 +Inode blocks per group:   256

