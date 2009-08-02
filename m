From: Theodore Tso <tytso@mit.edu>
Subject: Re: Fix device too big bug in mainline?
Date: Sat, 1 Aug 2009 22:22:09 -0400
Message-ID: <20090802022209.GC8680@mit.edu>
References: <20090730215302.GA31141@shell> <20090802002833.GB8680@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55472 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZHBCWU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 1 Aug 2009 22:22:20 -0400
Content-Disposition: inline
In-Reply-To: <20090802002833.GB8680@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In case people are wondering why it's taking so long to merge the
64-bit patch series, let me show one patch as exhibit 'A' about how
not to submit patches to me (or Linus, or any other upstream
maintainer):

Note the lack of an adequate patch description.  Also note how this
patch mushes together 2 or 3 semantic changes into a single patch,
making it extremely difficult to audit.  Even worse are the patches
where what should be a single semantic change is spread out across
multiple patches.

This is why I can't just merge the 64-bit patch series blindly; I'd
have no idea whether or not the result would be good or not because
it's near-impossible to audit.

What I have been doing is gradually extracting out bits and pieces,
combining patches where necessary, separate patches where
appropriately, and then gradually merging patches into the mainline.
But it's slow work that requires meticulous checking, both in terms of
checking to make sure the tree builds after each patch and passes
"make check", as well as making sure I don't drop anything.   

In addition, more than once I've found places where not all of the
places that needed converting to some new interfaces, such as
ext2fs_blocks_count() had been done.  Maybe no one had noticed, but
I'd prefer to catch such problems at merge-time, not when a user
complains about their filesystem getting corrupted and files a bug in
Red Hat's or SLES's bugzilla....


I also would greatly prefer it if people who submit patches to me obey
basic patch and code formatting guidelines.  Things like this are
really uncool:

-				fs->group_desc[i].bg_free_blocks_count =
-					free_array[i];
+				ext2fs_bg_free_blocks_count_set(fs, i, free_array[i])
+					;

Please try to keep code lines wrapped at 72-76 characters, and ixnay
on a single semicolon or one or two close parathesis on a line with
nothing else.

Clean patches get merged more quickly; dirty patches that don't get
cleaned up mean that either I have to try to ask the original patch
submitter to clean them up (and I thought I had made it clear to Val
what my expectations were in terms of clean patches), or I have to
find the time to clean them up myself.  In my experience, cleaning
this up *now* will end up costing us less time than trying to find
bugs in the merged code later.

					- Ted

temporary checkin; about to do checksum conversion

From: Valerie Aurora Henson <vaurora@redhat.com>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 debugfs/debugfs.c         |   38 +++++++++++++++++++-----------------
 e2fsck/journal.c          |    2 +-
 e2fsck/pass5.c            |   12 +++++-----
 e2fsck/super.c            |   47 ++++++++++++++++++++++-----------------------
 lib/ext2fs/alloc_stats.c  |   15 ++++++-------
 lib/ext2fs/alloc_tables.c |    6 ++--
 lib/ext2fs/closefs.c      |   12 ++++++----
 lib/ext2fs/csum.c         |    2 +-
 lib/ext2fs/ext2fs.h       |    2 +-
 lib/ext2fs/initialize.c   |   16 +++++++-------
 lib/ext2fs/openfs.c       |    2 +-
 lib/ext2fs/swapfs.c       |   14 ++++++++++++-
 misc/mke2fs.c             |    2 +-
 misc/tune2fs.c            |   10 ++++----
 resize/resize2fs.c        |   26 ++++++++++++------------
 15 files changed, 110 insertions(+), 96 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 63b9a44..befbb5b 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -307,7 +307,6 @@ void do_show_super_stats(int argc, char *argv[])
 {
 	dgrp_t	i;
 	FILE 	*out;
-	struct ext2_group_desc *gdp;
 	int	c, header_only = 0;
 	int	numdirs = 0, first, gdt_csum;
 
@@ -340,27 +339,30 @@ void do_show_super_stats(int argc, char *argv[])
 
 	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
 					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
-	gdp = &current_fs->group_desc[0];
-	for (i = 0; i < current_fs->group_desc_count; i++, gdp++) {
-		fprintf(out, " Group %2d: block bitmap at %u, "
-		        "inode bitmap at %u, "
-		        "inode table at %u\n"
+	for (i = 0; i < current_fs->group_desc_count; i++) {
+		fprintf(out, " Group %2d: block bitmap at %llu, "
+		        "inode bitmap at %llu, "
+		        "inode table at %llu\n"
 		        "           %d free %s, "
 		        "%d free %s, "
 		        "%d used %s%s",
-		        i, gdp->bg_block_bitmap,
-		        gdp->bg_inode_bitmap, gdp->bg_inode_table,
-		        gdp->bg_free_blocks_count,
-		        gdp->bg_free_blocks_count != 1 ? "blocks" : "block",
-		        gdp->bg_free_inodes_count,
-		        gdp->bg_free_inodes_count != 1 ? "inodes" : "inode",
-		        gdp->bg_used_dirs_count,
-		        gdp->bg_used_dirs_count != 1 ? "directories"
-				: "directory", gdt_csum ? ", " : "\n");
+		        i, ext2fs_block_bitmap_loc(current_fs, i),
+		        ext2fs_inode_bitmap_loc(current_fs, i),
+			ext2fs_inode_table_loc(current_fs, i),
+		        ext2fs_bg_free_blocks_count(current_fs, i),
+		        ext2fs_bg_free_blocks_count(current_fs, i) != 1 ?
+			"blocks" : "block",
+		        ext2fs_bg_free_inodes_count(current_fs, i),
+		        ext2fs_bg_free_inodes_count(current_fs, i) != 1 ?
+			"inodes" : "inode",
+		        ext2fs_bg_used_dirs_count(current_fs, i),
+		        ext2fs_bg_used_dirs_count(current_fs, i) != 1 ? "directories"
+ 				: "directory", gdt_csum ? ", " : "\n");
 		if (gdt_csum)
 			fprintf(out, "%d unused %s\n",
-				gdp->bg_itable_unused,
-				gdp->bg_itable_unused != 1 ? "inodes":"inode");
+				ext2fs_bg_itable_unused(current_fs, i),
+				ext2fs_bg_itable_unused(current_fs, i) != 1 ?
+				"inodes" : "inode");
 		first = 1;
 		print_bg_opts(current_fs, i, EXT2_BG_INODE_UNINIT, "Inode not init",
 			      &first, out);
@@ -368,7 +370,7 @@ void do_show_super_stats(int argc, char *argv[])
 			      &first, out);
 		if (gdt_csum) {
 			fprintf(out, "%sChecksum 0x%04x",
-				first ? "           [":", ", gdp->bg_checksum);
+				first ? "           [":", ", ext2fs_bg_checksum(current_fs, i));
 			first = 0;
 		}
 		if (!first)
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index dd56e7a..f5fdef5 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1011,7 +1011,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 	group = ext2fs_group_of_ino(fs, ino);
 	ext2fs_unmark_inode_bitmap2(fs->inode_map, ino);
 	ext2fs_mark_ib_dirty(fs);
-	fs->group_desc[group].bg_free_inodes_count++;
+	ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group) + 1);
 	ext2fs_group_desc_csum_set(fs, group);
 	fs->super->s_free_inodes_count++;
 	return;
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 6cdbd6b..9ac4324 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -343,8 +343,8 @@ redo_counts:
 
 			if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_free_blocks_count =
-					free_array[i];
+				ext2fs_bg_free_blocks_count_set(fs, i, free_array[i])
+					;
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -573,8 +573,8 @@ do_counts:
 			pctx.ino2 = free_array[i];
 			if (fix_problem(ctx, PR_5_FREE_INODE_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_free_inodes_count =
-					free_array[i];
+				ext2fs_bg_free_inodes_count_set(fs, i, free_array[i])
+					;
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -586,8 +586,8 @@ do_counts:
 
 			if (fix_problem(ctx, PR_5_FREE_DIR_COUNT_GROUP,
 					&pctx)) {
-				fs->group_desc[i].bg_used_dirs_count =
-					dir_array[i];
+				ext2fs_bg_used_dirs_count_set(fs, i, dir_array[i])
+					;
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index c269b0e..a1fb878 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -458,7 +458,6 @@ void check_super_block(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk64_t	first_block, last_block;
 	struct ext2_super_block *sb = fs->super;
-	struct ext2_group_desc *gd;
 	problem_t	problem;
 	blk64_t	blocks_per_group = fs->super->s_blocks_per_group;
 	__u32	bpg_max;
@@ -587,7 +586,7 @@ void check_super_block(e2fsck_t ctx)
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
-	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
+	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
 
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
@@ -627,61 +626,61 @@ void check_super_block(e2fsck_t ctx)
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
-		free_blocks += gd->bg_free_blocks_count;
-		free_inodes += gd->bg_free_inodes_count;
+		free_blocks += ext2fs_bg_free_blocks_count(fs, i);
+		free_inodes += ext2fs_bg_free_inodes_count(fs, i);
 
-		if ((gd->bg_free_blocks_count > sb->s_blocks_per_group) ||
-		    (gd->bg_free_inodes_count > sb->s_inodes_per_group) ||
-		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
+		if ((ext2fs_bg_free_blocks_count(fs, i) > sb->s_blocks_per_group) ||
+		    (ext2fs_bg_free_inodes_count(fs, i) > sb->s_inodes_per_group) ||
+		    (ext2fs_bg_used_dirs_count(fs, i) > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
 		should_be = 0;
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
-				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
-				                  EXT2_BG_INODE_UNINIT);
-				gd->bg_itable_unused = 0;
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
+				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
 
 		if (!csum_flag &&
-		    (gd->bg_flags &(EXT2_BG_BLOCK_UNINIT|EXT2_BG_INODE_UNINIT)||
-		     gd->bg_itable_unused != 0)){
+		    (ext2fs_bg_flag_test(fs, i, EXT2_BG_BLOCK_UNINIT) ||
+		     ext2fs_bg_flag_test(fs, i, EXT2_BG_INODE_UNINIT) ||
+		     ext2fs_bg_itable_unused(fs, i) != 0)){
 			if (fix_problem(ctx, PR_0_GDT_UNINIT, &pctx)) {
-				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
-						  EXT2_BG_INODE_UNINIT);
-				gd->bg_itable_unused = 0;
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
 
 		if (i == fs->group_desc_count - 1 &&
-		    gd->bg_flags & EXT2_BG_BLOCK_UNINIT) {
+		    ext2fs_bg_flag_test(fs, i, EXT2_BG_BLOCK_UNINIT)) {
 			if (fix_problem(ctx, PR_0_BB_UNINIT_LAST, &pctx)) {
-				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
 
-		if (gd->bg_flags & EXT2_BG_BLOCK_UNINIT &&
-		    !(gd->bg_flags & EXT2_BG_INODE_UNINIT)) {
+		if (ext2fs_bg_flag_test(fs, i, EXT2_BG_BLOCK_UNINIT) &&
+		    !ext2fs_bg_flag_test(fs, i, EXT2_BG_INODE_UNINIT)) {
 			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx)) {
-				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
 
 		if (csum_flag &&
-		    (gd->bg_itable_unused > gd->bg_free_inodes_count ||
-		     gd->bg_itable_unused > sb->s_inodes_per_group)) {
-			pctx.blk = gd->bg_itable_unused;
+		    (ext2fs_bg_itable_unused(fs, i) > ext2fs_bg_free_inodes_count(fs, i) ||
+		     ext2fs_bg_itable_unused(fs, i) > sb->s_inodes_per_group)) {
+			pctx.blk = ext2fs_bg_itable_unused(fs, i);
 			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx)) {
-				gd->bg_itable_unused = 0;
+				ext2fs_bg_itable_unused_set(fs, i, 0);
 				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index d254998..5423c30 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -31,13 +31,13 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_mark_inode_bitmap2(fs->inode_map, ino);
 	else
 		ext2fs_unmark_inode_bitmap2(fs->inode_map, ino);
-	fs->group_desc[group].bg_free_inodes_count -= inuse;
+	ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group) - inuse);
 	if (isdir)
-		fs->group_desc[group].bg_used_dirs_count += inuse;
+		ext2fs_bg_used_dirs_count_set(fs, group, ext2fs_bg_used_dirs_count(fs, group) + inuse);
 
 	/* We don't strictly need to be clearing the uninit flag if inuse < 0
 	 * (i.e. freeing inodes) but it also means something is bad. */
-	fs->group_desc[group].bg_flags &= ~EXT2_BG_INODE_UNINIT;
+	ext2fs_bg_flag_clear(fs, group, EXT2_BG_INODE_UNINIT);
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
 		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
@@ -45,9 +45,8 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 			group * fs->super->s_inodes_per_group + 1;
 
 		if (ino >= first_unused_inode)
-			fs->group_desc[group].bg_itable_unused =
-				group * fs->super->s_inodes_per_group +
-				fs->super->s_inodes_per_group - ino;
+			ext2fs_bg_itable_unused_set(fs, group, group * fs->super->s_inodes_per_group + fs->super->s_inodes_per_group - ino)
+				;
 		ext2fs_group_desc_csum_set(fs, group);
 	}
 
@@ -76,8 +75,8 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 		ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	else
 		ext2fs_unmark_block_bitmap2(fs->block_map, blk);
-	fs->group_desc[group].bg_free_blocks_count -= inuse;
-	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+	ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group) - inuse);
+	ext2fs_bg_flag_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_group_desc_csum_set(fs, group);
 
 	ext2fs_free_blocks_count_add(fs->super, -inuse);
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index b218e7f..2f691ac 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -141,7 +141,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		ext2fs_block_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
-			fs->group_desc[gr].bg_free_blocks_count--;
+			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
 			ext2fs_bg_flag_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_group_desc_csum_set(fs, gr);
@@ -169,7 +169,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		ext2fs_inode_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
 			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
-			fs->group_desc[gr].bg_free_blocks_count--;
+			ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 			ext2fs_free_blocks_count_add(fs->super, -1);
 			ext2fs_bg_flag_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_group_desc_csum_set(fs, gr);
@@ -203,7 +203,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			ext2fs_mark_block_bitmap2(bmap, blk);
 			if (flexbg_size) {
 				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
-				fs->group_desc[gr].bg_free_blocks_count--;
+				ext2fs_bg_free_blocks_count_set(fs, gr, ext2fs_bg_free_blocks_count(fs, gr) - 1);
 				ext2fs_free_blocks_count_add(fs->super, -1);
 				ext2fs_bg_flag_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
 				ext2fs_group_desc_csum_set(fs, gr);
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index dd24856..e2523c3 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -270,7 +270,7 @@ errcode_t ext2fs_flush_with_progress(ext2_filsys fs, const char *message)
 	struct ext2_super_block *super_shadow = 0;
 	struct ext2_group_desc *group_shadow = 0;
 #ifdef WORDS_BIGENDIAN
-	struct ext2_group_desc *s, *t;
+	char		*s, *t;
 	dgrp_t		j;
 #endif
 	char	*group_ptr;
@@ -297,10 +297,12 @@ errcode_t ext2fs_flush_with_progress(ext2_filsys fs, const char *message)
 	       fs->desc_blocks);
 
 	/* swap the group descriptors */
-	for (j=0, s=fs->group_desc, t=group_shadow;
-	     j < fs->group_desc_count; j++, t++, s++) {
-		*t = *s;
-		ext2fs_swap_group_desc(t);
+	t = group_shadow;
+	for (j=0; j < fs->group_desc_count; j++) {
+		s = (char *) ext2fs_group_desc(fs, j);
+		memcpy(t, s, fs->group_desc_size);
+		ext2fs_swap_group_desc(fs, t);
+		t += fs->group_desc_size;
 	}
 #else
 	super_shadow = fs->super;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 7c79397..5612de1 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -43,7 +43,7 @@ STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 		struct ext2_group_desc swabdesc = *desc;
 
 		/* Have to swab back to little-endian to do the checksum */
-		ext2fs_swap_group_desc(&swabdesc);
+		ext2fs_swap_group_desc(fs, &swabdesc);
 		desc = &swabdesc;
 
 		group = ext2fs_swab32(group);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7c6a9d9..a4396a4 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1279,7 +1279,7 @@ extern void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
 extern void ext2fs_swap_ext_attr_entry(struct ext2_ext_attr_entry *to_entry,
 				       struct ext2_ext_attr_entry *from_entry);
 extern void ext2fs_swap_super(struct ext2_super_block * super);
-extern void ext2fs_swap_group_desc(struct ext2_group_desc *gdp);
+extern void ext2fs_swap_group_desc(ext2_filsys, struct ext2_group_desc *gdp);
 extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 				   struct ext2_inode_large *f, int hostorder,
 				   int bufsize);
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 35d076a..c1b3ca9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -413,13 +413,13 @@ ipg_retry:
 		 */
 		if (csum_flag) {
 			if (i != fs->group_desc_count - 1)
-				fs->group_desc[i].bg_flags |=
-					EXT2_BG_BLOCK_UNINIT;
-			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_UNINIT;
+				ext2fs_bg_flag_set(fs, i, EXT2_BG_BLOCK_UNINIT)
+					;
+			ext2fs_bg_flag_set(fs, i, EXT2_BG_INODE_UNINIT);
 			numblocks = super->s_inodes_per_group;
 			if (i == 0)
 				numblocks -= super->s_first_ino;
-			fs->group_desc[i].bg_itable_unused = numblocks;
+			ext2fs_bg_itable_unused_set(fs, i, numblocks);
 		}
 		numblocks = ext2fs_reserve_super_and_bgd(fs, i, fs->block_map);
 		if (fs->super->s_log_groups_per_flex)
@@ -428,10 +428,10 @@ ipg_retry:
 		ext2fs_free_blocks_count_set(super,
 					     ext2fs_free_blocks_count(super) +
 					     numblocks);
-		fs->group_desc[i].bg_free_blocks_count = numblocks;
-		fs->group_desc[i].bg_free_inodes_count =
-			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_used_dirs_count = 0;
+		ext2fs_bg_free_blocks_count_set(fs, i, numblocks);
+		ext2fs_bg_free_inodes_count_set(fs, i, fs->super->s_inodes_per_group)
+			;
+		ext2fs_bg_used_dirs_count_set(fs, i, 0);
 		ext2fs_group_desc_csum_set(fs, i);
 	}
 
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 5e49608..ddb3ede 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -334,7 +334,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 #ifdef WORDS_BIGENDIAN
 		gdp = (struct ext2_group_desc *) dest;
 		for (j=0; j < groups_per_block; j++)
-			ext2fs_swap_group_desc(gdp++);
+			ext2fs_swap_group_desc(fs, gdp++);
 #endif
 		dest += fs->blocksize;
 	}
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 42bc01e..25af281 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -78,8 +78,9 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 
 }
 
-void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
+void ext2fs_swap_group_desc(ext2_filsys fs, struct ext2_group_desc *gdp)
 {
+	// Do the 32-bit parts first
 	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
 	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);
 	gdp->bg_inode_table = ext2fs_swab32(gdp->bg_inode_table);
@@ -89,6 +90,17 @@ void ext2fs_swap_group_desc(struct ext2_group_desc *gdp)
 	gdp->bg_flags = ext2fs_swab16(gdp->bg_flags);
 	gdp->bg_itable_unused = ext2fs_swab16(gdp->bg_itable_unused);
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
+	// Now do the 64-bit parts if we need 'em
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp4 = (struct ext4_group_desc *) gdp;
+		gdp4->bg_block_bitmap_hi = ext2fs_swab32(gdp4->bg_block_bitmap_hi);
+		gdp4->bg_inode_bitmap_hi = ext2fs_swab32(gdp4->bg_inode_bitmap_hi);
+		gdp4->bg_inode_table_hi = ext2fs_swab32(gdp4->bg_inode_table_hi);
+		gdp4->bg_free_blocks_count_hi = ext2fs_swab16(gdp4->bg_free_blocks_count_hi);
+		gdp4->bg_free_inodes_count_hi = ext2fs_swab16(gdp4->bg_free_inodes_count_hi);
+		gdp4->bg_used_dirs_count_hi = ext2fs_swab16(gdp4->bg_used_dirs_count_hi);
+		gdp4->bg_itable_unused_hi = ext2fs_swab16(gdp4->bg_itable_unused_hi);
+	}
 }
 
 void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 0cbfef3..9f311bd 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -273,7 +273,7 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
 						group_block);
 				group_bad++;
 				group = ext2fs_group_of_blk(fs, group_block+j);
-				fs->group_desc[group].bg_free_blocks_count++;
+				ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group) + 1);
 				ext2fs_group_desc_csum_set(fs, group);
 				ext2fs_free_blocks_count_add(fs->super, 1);
 			}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 24d03d9..de1b2fd 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -261,7 +261,7 @@ static int release_blocks_proc(ext2_filsys fs, blk_t *blocknr,
 	block = *blocknr;
 	ext2fs_unmark_block_bitmap(fs->block_map, block);
 	group = ext2fs_group_of_blk(fs, block);
-	fs->group_desc[group].bg_free_blocks_count++;
+	ext2fs_bg_free_blocks_count_set(fs, group, ext2fs_bg_free_blocks_count(fs, group) + 1);
 	ext2fs_group_desc_csum_set(fs, group);
 	ext2fs_free_blocks_count_add(fs->super, 1);
 	return 0;
@@ -1311,8 +1311,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == ext2fs_blocks_count(fs->super)-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
-				group_free;
+			ext2fs_bg_free_blocks_count_set(fs, group++, group_free)
+				;
 			count = 0;
 			group_free = 0;
 		}
@@ -1336,8 +1336,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
-				group_free;
+			ext2fs_bg_free_inodes_count_set(fs, group++, group_free)
+				;
 			count = 0;
 			group_free = 0;
 		}
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3e2712a..1e84a62 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -465,7 +465,7 @@ retry:
 	} else
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
-	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
+	ext2fs_bg_free_blocks_count_set(fs, i, ext2fs_bg_free_blocks_count(fs, i) + (numblocks - old_numblocks));
 	ext2fs_group_desc_csum_set(fs, i);
 
 	/*
@@ -549,10 +549,10 @@ retry:
 			     ext2fs_free_blocks_count(fs->super) - adjblocks);
 		fs->super->s_free_inodes_count +=
 			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_free_blocks_count = numblocks;
-		fs->group_desc[i].bg_free_inodes_count =
-			fs->super->s_inodes_per_group;
-		fs->group_desc[i].bg_used_dirs_count = 0;
+		ext2fs_bg_free_blocks_count_set(fs, i, numblocks);
+		ext2fs_bg_free_inodes_count_set(fs, i, fs->super->s_inodes_per_group)
+			;
+		ext2fs_bg_used_dirs_count_set(fs, i, 0);
 		ext2fs_group_desc_csum_set(fs, i);
 
 		retval = ext2fs_allocate_group_table(fs, i, 0);
@@ -1828,14 +1828,14 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == ext2fs_blocks_count(fs->super)-1)) {
-			fs->group_desc[group].bg_free_blocks_count =
-				group_free;
+			ext2fs_bg_free_blocks_count_set(fs, group, group_free)
+				;
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
 			count = 0;
 			group_free = 0;
-			uninit = (fs->group_desc[group].bg_flags &
-				  EXT2_BG_BLOCK_UNINIT);
+			uninit = (ext2fs_bg_flag_test(fs, group, EXT2_BG_BLOCK_UNINIT)
+				  );
 			ext2fs_super_and_bgd_loc(fs, group, &super_blk,
 						 &old_desc_blk,
 						 &new_desc_blk, 0);
@@ -1868,14 +1868,14 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group].bg_free_inodes_count =
-				group_free;
+			ext2fs_bg_free_inodes_count_set(fs, group, group_free)
+				;
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
 			count = 0;
 			group_free = 0;
-			uninit = (fs->group_desc[group].bg_flags &
-				  EXT2_BG_INODE_UNINIT);
+			uninit = (ext2fs_bg_flag_test(fs, group, EXT2_BG_INODE_UNINIT)
+				  );
 		}
 	}
 	fs->super->s_free_inodes_count = total_free;
