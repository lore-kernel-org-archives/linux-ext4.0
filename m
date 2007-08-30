From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 8/8][e2fsprogs] change access to the free blocks counter
Date: Thu, 30 Aug 2007 17:43:26 +0200
Message-ID: <1188488606.15770.61.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43872 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760AbXH3N04 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:56 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch replaces all references to super->s_free_blocks_count by
ext2_free_blocks_count(super) in preparation for 64-bit support.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 e2fsck/pass5.c           |    6 +++---
 e2fsck/super.c           |    6 +++---
 e2fsck/unix.c            |    4 ++--
 lib/ext2fs/alloc_stats.c |    3 ++-
 lib/ext2fs/initialize.c  |    5 +++--
 misc/mke2fs.c            |    6 ++++--
 misc/tune2fs.c           |    3 ++-
 misc/util.c              |    3 ++-
 resize/resize2fs.c       |   19 +++++++++++--------
 9 files changed, 32 insertions(+), 23 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 7e3f5ee..40612e2 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -291,13 +291,13 @@ redo_counts:
 				ext2fs_unmark_valid(fs);
 		}
 	}
-	if (free_blocks != fs->super->s_free_blocks_count) {
+	if (free_blocks != ext2_free_blocks_count(fs->super)) {
 		pctx.group = 0;
-		pctx.blk = fs->super->s_free_blocks_count;
+		pctx.blk = ext2_free_blocks_count(fs->super);
 		pctx.blk2 = free_blocks;
 
 		if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT, &pctx)) {
-			fs->super->s_free_blocks_count = free_blocks;
+			ext2_free_blocks_count_set(fs->super, free_blocks);
 			ext2fs_mark_super_dirty(fs);
 		} else
 			ext2fs_unmark_valid(fs);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index f7e4e89..5501ba9 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -630,18 +630,18 @@ void check_super_block(e2fsck_t ctx)
 	 * inodes; if the filesystem is not unmounted cleanly, the
 	 * global counts may not be accurate.
 	 */
-	if ((free_blocks != sb->s_free_blocks_count) ||
+	if ((free_blocks != ext2_free_blocks_count(sb)) ||
 	    (free_inodes != sb->s_free_inodes_count)) {
 		if (ctx->options & E2F_OPT_READONLY)
 			ext2fs_unmark_valid(fs);
 		else {
-			sb->s_free_blocks_count = free_blocks;
+			ext2_free_blocks_count_set(sb, free_blocks);
 			sb->s_free_inodes_count = free_inodes;
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
 	
-	if ((sb->s_free_blocks_count > ext2_blocks_count(sb)) ||
+	if ((ext2_free_blocks_count(sb) > ext2_blocks_count(sb)) ||
 	    (sb->s_free_inodes_count > sb->s_inodes_count))
 		ext2fs_unmark_valid(fs);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 610712f..42037a4 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -112,7 +112,7 @@ static void show_stats(e2fsck_t	ctx)
 		       fs->super->s_free_inodes_count);
 	blocks = ext2_blocks_count(fs->super);
 	blocks_used = (ext2_blocks_count(fs->super) -
-		       fs->super->s_free_blocks_count);
+		       ext2_free_blocks_count(fs->super));
 
 	frag_percent = (10000 * ctx->fs_fragmented) / inodes_used;
 	frag_percent = (frag_percent + 5) / 10;
@@ -302,7 +302,7 @@ static void check_if_skip(e2fsck_t ctx)
 	printf(_("%s: clean, %u/%u files, %u/%u blocks"), ctx->device_name,
 	       fs->super->s_inodes_count - fs->super->s_free_inodes_count,
 	       fs->super->s_inodes_count,
-	       ext2_blocks_count(fs->super) - fs->super->s_free_blocks_count,
+	       ext2_blocks_count(fs->super) - ext2_free_blocks_count(fs->super),
 	       ext2_blocks_count(fs->super));
 	next_check = 100000;
 	if (fs->super->s_max_mnt_count > 0) {
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 4088f7b..8b0b964 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -46,7 +46,8 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
-	fs->super->s_free_blocks_count -= inuse;
+	ext2_free_blocks_count_set(fs->super,
+			ext2_free_blocks_count(fs->super) - inuse);
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
 }
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 6969745..19fbaa9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -366,11 +366,12 @@ ipg_retry:
 	 * inode table have not been allocated (and in fact won't be
 	 * by this routine), they are accounted for nevertheless.
 	 */
-	super->s_free_blocks_count = 0;
+	ext2_free_blocks_count_set(super, 0ULL);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		numblocks = ext2fs_reserve_super_and_bgd(fs, i, fs->block_map);
 
-		super->s_free_blocks_count += numblocks;
+		ext2_free_blocks_count_set(super,
+				ext2_free_blocks_count(super) + numblocks);
 		fs->group_desc[i].bg_free_blocks_count = numblocks;
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 074c985..a4ee998 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -263,7 +263,8 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
 				fs->group_desc[group].bg_free_blocks_count++;
-				fs->super->s_free_blocks_count++;
+				ext2_free_blocks_count_set(fs->super,
+					ext2_free_blocks_count(fs->super) + 1);
 			}
 		}
 		group_block += fs->super->s_blocks_per_group;
@@ -468,7 +469,8 @@ static void setup_lazy_bg(ext2_filsys fs)
 			if (bg->bg_free_blocks_count == blks) {
 				bg->bg_free_blocks_count = 0;
 				bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-				sb->s_free_blocks_count -= blks;
+				ext2_free_blocks_count_set(sb,
+					ext2_free_blocks_count(sb) - blks);
 			}
 		}
 	}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 2d3e3c0..a65129f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -213,7 +213,8 @@ static int release_blocks_proc(ext2_filsys fs, blk_t *blocknr,
 	ext2fs_unmark_block_bitmap(fs->block_map,block);
 	group = ext2fs_group_of_blk(fs, block);
 	fs->group_desc[group].bg_free_blocks_count++;
-	fs->super->s_free_blocks_count++;
+	ext2_free_blocks_count_set(fs->super,
+			ext2_free_blocks_count(fs->super) + 1);
 	return 0;
 }
 
diff --git a/misc/util.c b/misc/util.c
index 8fe505a..435396b 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -269,7 +269,8 @@ unsigned int figure_journal_size(int size, ext2_filsys fs)
 				j_blocks);
 			exit(1);
 		}
-		if ((unsigned) j_blocks > fs->super->s_free_blocks_count / 2) {
+		if ((unsigned) j_blocks > ext2_free_blocks_count(fs->super) / 2)
+		{
 			fputs(_("\nJournal size too big for filesystem.\n"),
 			      stderr);
 			exit(1);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 6c37f77..ebd66d2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -109,8 +109,8 @@ errcode_t resize_fs(ext2_filsys fs, blk_t *new_size, int flags,
 #ifdef RESIZE2FS_DEBUG
 	if (rfs->flags & RESIZE_DEBUG_BMOVE)
 		printf("Number of free blocks: %u/%u, Needed: %d\n",
-		       rfs->old_fs->super->s_free_blocks_count,
-		       rfs->new_fs->super->s_free_blocks_count,
+		       ext2_free_blocks_count(rfs->old_fs->super),
+		       ext2_free_blocks_count(rfs->new_fs->super),
 		       rfs->needed_blocks);
 #endif
 	
@@ -242,11 +242,13 @@ retry:
 	 */
 	blk = ext2_blocks_count(old_fs->super);
 	if (blk > ext2_blocks_count(fs->super))
-		fs->super->s_free_blocks_count -=
-			(blk - ext2_blocks_count(fs->super));
+		ext2_free_blocks_count_set(fs->super,
+			ext2_free_blocks_count(fs->super) -
+			(blk - ext2_blocks_count(fs->super)));
 	else
-		fs->super->s_free_blocks_count +=
-			(ext2_blocks_count(fs->super) - blk);
+		ext2_free_blocks_count_set(fs->super,
+			ext2_free_blocks_count(fs->super) +
+			(ext2_blocks_count(fs->super) - blk));
 
 	/*
 	 * Adjust the number of reserved blocks
@@ -407,7 +409,8 @@ retry:
 		adjblocks += 2 + fs->inode_blocks_per_group;
 		
 		numblocks -= adjblocks;
-		fs->super->s_free_blocks_count -= adjblocks;
+		ext2_free_blocks_count_set(fs->super,
+				ext2_free_blocks_count(fs->super) - adjblocks);
 		fs->super->s_free_inodes_count +=
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_free_blocks_count = numblocks;
@@ -1580,7 +1583,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			group_free = 0;
 		}
 	}
-	fs->super->s_free_blocks_count = total_free;
+	ext2_free_blocks_count_set(fs->super, total_free);
 	
 	/*
 	 * Next, calculate the inode statistics
