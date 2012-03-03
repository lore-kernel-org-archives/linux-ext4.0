From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [RFC v2] e2fsprogs: Rework metadata_csum/gdt_csum flag handling
Date: Fri, 2 Mar 2012 19:50:48 -0800
Message-ID: <20120303035048.GF15164@tux1.beaverton.ibm.com>
References: <20120107082751.21970.84856.stgit@elm3c44.beaverton.ibm.com> <20120107082919.21970.99182.stgit@elm3c44.beaverton.ibm.com> <8ED6E1F9-DB56-4D31-BCA8-2A3A8D514BD5@dilger.ca> <20120213222828.GF21641@thunk.org> <20120229012738.GD15164@tux1.beaverton.ibm.com> <8C789086-51FD-4091-905B-4D227842BB06@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8C789086-51FD-4091-905B-4D227842BB06@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Feb 28, 2012 at 10:40:59PM -0700, Andreas Dilger wrote:
> On 2012-02-28, at 6:27 PM, Darrick J. Wong wrote:
> > Ok, I've reworked the block group descriptor checksum handling code per this
> > email thread.  INCOMPAT_BG_USE_META_CSUM is gone.  METADATA_CSUM implies (and
> > in fact overrides) GDT_CSUM.  When both are set, the group descriptor checksum
> > uses the same function as all other metadata blocks' checksums (by default
> > crc32c).  I created a helper function to determine if group descriptor
> > checksums are enabled, and the actual gdt checksum verify/set functions are
> > smart enough to use the correct function.
> > 
> > Below are the changes that I intend to make to e2fsprogs.  I'll integrate these
> > changes into the (huge) e2fsprogs patchset, but wanted to aggregate the changes
> > here first to avoid overwhelming reviewers.  I'll send a kernel patch shortly.
> > 
> > Question: What will happen to old kernels when METADATA_CSUM and GDT_CSUM are
> > set?
> 
> This should never be allowed by the tools, and should be treated by e2fsck as
> an error, that is fixed by clearing GDT_CSUM and leaving METADATA_CSUM set.
> 
> > Should tune2fs/e2fsck change METADATA_CSUM|GDT_CSUM to only METADATA_CSUM
> > if they encounter it?
> 
> Yes.
> 
> > I'm a little concerned that a pre-METADATA_CSUM kernel will see the GDT_CSUM
> > flag and assume it's ok to proceed in ro mode and get confused.
> 
> Right, so if tune2fs/mke2fs set METADATA_CSUM and always disable GDT_CSUM at
> the same time there will be no problem.  e2fsck will correct this in case it
> is seen in the wild.  This should be rare, since it means the other feature
> flags are also corrupted, and that will probably force the use of a backup
> superblock, or make mincemeat of the filesystem for other reasons (bad
> checksums cannot themselves corrupt the filesystem).
> 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> 
> Looks like a net win all around.  One comment inline, but you can add my
> 
> Acked-by: Andreas Dilger <adilger@dilger.ca>

I fixed the comment, and modified the tools so that metadata_csum and uninit_bg
can't both be set at the same time.  This made tune2fs handling a bit trickier,
because now I had to deal with transitioning the filesystem between
metadata_csum, uninit_bg, and neither flag being set.  I think I covered all
possible transitions of those flags in my testing matrix. :)

Question: What do we do when clearing metadata_csum?  Right now the code can
handle transitions either to ^metadata_csum,uninit_bg (mostly a matter of
rewriting the gdt checksums and bitwise operations) and
^metadata_csum,^uninit_bg.  If, however, the user doesn't explicitly specify an
uninit_bg setting, what do we default to?  Defaulting to metadata_csum ->
^uninit_bg is least surprising (command line args work as expected) but then
all the group descriptors have to be rewritten, and uninit bitmaps have to be
initialized.  On the other hand, metadata_csum -> uninit_bg causes fewer
changes to the fs.

Also it turns out that the old code to turn off uninit_bg is broken -- in the
case of a group with uninit bitmaps, it will zero out the group flags (clearing
the uninit bitmap status) but does not zero out the bitmap.  This causes the
next fs driver to see garbage in the bitmaps.

I also fixed a e2fsck problem code that I hadn't specified in problem.c.

So, here's v2 (which I will integrate into the main patch series when the dust
settles).

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 debugfs/debugfs.c        |    3 -
 e2fsck/pass5.c           |   18 ++----
 e2fsck/problem.c         |   20 ++++++
 e2fsck/problem.h         |    5 ++
 e2fsck/super.c           |   16 +++++
 e2fsck/unix.c            |    2 -
 lib/e2p/feature.c        |    2 -
 lib/ext2fs/alloc.c       |    6 +-
 lib/ext2fs/alloc_stats.c |    3 -
 lib/ext2fs/csum.c        |   13 +---
 lib/ext2fs/ext2_fs.h     |    6 ++
 lib/ext2fs/ext2fs.h      |   12 +++-
 lib/ext2fs/initialize.c  |    3 -
 lib/ext2fs/inode.c       |    9 +--
 lib/ext2fs/openfs.c      |    3 -
 lib/ext2fs/rw_bitmaps.c  |   12 +---
 misc/dumpe2fs.c          |    4 +
 misc/mke2fs.c            |   29 ++++-----
 misc/tune2fs.c           |  142 ++++++++++++++++++++++++++--------------------
 resize/resize2fs.c       |   12 +---
 20 files changed, 170 insertions(+), 150 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index c1cbf06..9c8e48e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -357,8 +357,7 @@ void do_show_super_stats(int argc, char *argv[])
 		return;
 	}
 
-	gdt_csum = EXT2_HAS_RO_COMPAT_FEATURE(current_fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	gdt_csum = ext2fs_has_group_desc_csum(current_fs);
 	for (i = 0; i < current_fs->group_desc_count; i++) {
 		fprintf(out, " Group %2d: block bitmap at %llu, "
 		        "inode bitmap at %llu, "
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index f1ce6d7..c5dba0b 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -88,7 +88,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	ext2_ino_t	ino_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_ib_dirty(ctx->fs))
@@ -103,9 +103,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -149,7 +147,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 	int		nbytes;
 	blk64_t		blk_itr;
 	errcode_t	retval;
-	int		csum_flag = 0;
+	int		csum_flag;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
 	if (ext2fs_test_bb_dirty(ctx->fs))
@@ -164,9 +162,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 		fatal_error(ctx, 0);
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(ctx->fs);
 
 	clear_problem_context(&pctx);
 	for (i = 0; i < ctx->fs->group_desc_count; i++) {
@@ -322,8 +318,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
@@ -599,8 +594,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 redo_counts:
 	had_problem = 0;
 	save_problem = 0;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index d3d0ee5..d7be5aa 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -428,6 +428,15 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@S MMP block checksum does not match MMP block.  "),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
 
+	/*
+	 * metadata_csum implies uninit_bg; both feature bits cannot
+	 * be set simultaneously.
+	 */
+	{ PR_0_META_AND_GDT_CSUM_SET,
+	  N_("@S metadata_csum supersedes uninit_bg; both feature "
+	     "bits cannot be set simultaneously."),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK},
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
@@ -1423,10 +1432,15 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@d @i %i, %B, offset %N: @d has no checksum\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
-	/* leaf node passes checks, but fails checksum */
+	/* leaf node fails checksum */
 	{ PR_2_LEAF_NODE_CSUM_INVALID,
-	  N_("@d @i %i, %B, offset %N: @d passes checks, but fails checksum\n"),
-	  PROMPT_FIX, 0 },
+	  N_("@d @i %i, %B, offset %N: @d fails checksum\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
+	/* leaf node passes checks but fails checksum */
+	{ PR_2_LEAF_NODE_ONLY_CSUM_INVALID,
+	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum\n"),
+	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Pass 3 errors */
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 01d8377..5126c57 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -245,6 +245,11 @@ struct problem_context {
 /* Superblock has invalid MMP checksum. */
 #define PR_0_MMP_CSUM_INVALID			0x000044
 
+/*
+ * metadata_csum supersedes uninit_bg; both feature bits cannot be set
+ * simultaneously.
+ */
+#define PR_0_META_AND_GDT_CSUM_SET		0x000045
 
 /*
  * Pass 1 errors
diff --git a/e2fsck/super.c b/e2fsck/super.c
index dbd337c..d70947b 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -577,14 +577,26 @@ void check_super_block(e2fsck_t ctx)
 		}
 	}
 
+	/* Are meta_csum and gdt_csum both set? */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	    fix_problem(ctx, PR_0_META_AND_GDT_CSUM_SET, &pctx)) {
+		fs->super->s_feature_ro_compat &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		ext2fs_mark_super_dirty(fs);
+		for (i = 0; i < fs->group_desc_count; i++)
+			ext2fs_group_desc_csum_set(fs, i);
+	}
+
 	/*
 	 * Verify the group descriptors....
 	 */
 	first_block = sb->s_first_data_block;
 	last_block = ext2fs_blocks_count(sb)-1;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9319e40..d3fb8f8 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1658,7 +1658,7 @@ no_journal:
 	}
 
 	if ((run_result & E2F_FLAG_CANCEL) == 0 &&
-	    sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM &&
+	    ext2fs_has_group_desc_csum(ctx->fs) &&
 	    !(ctx->options & E2F_OPT_READONLY)) {
 		retval = ext2fs_set_gdt_csum(ctx->fs);
 		if (retval) {
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 9f9c6dd..486f846 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -87,8 +87,6 @@ static struct feature feature_list[] = {
 			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
 			"flex_bg"},
-	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
-			"bg_use_meta_csum"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 948a0ec..e62ed68 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -36,8 +36,7 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 	blk64_t		blk, super_blk, old_desc_blk, new_desc_blk;
 	int		old_desc_blocks;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
+	if (!ext2fs_has_group_desc_csum(fs) ||
 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT)))
 		return;
 
@@ -83,8 +82,7 @@ static void check_inode_uninit(ext2_filsys fs, ext2fs_inode_bitmap map,
 {
 	ext2_ino_t	i, ino;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) ||
+	if (!ext2fs_has_group_desc_csum(fs) ||
 	    !(ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT)))
 		return;
 
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index adec363..4229084 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -38,8 +38,7 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 	/* We don't strictly need to be clearing the uninit flag if inuse < 0
 	 * (i.e. freeing inodes) but it also means something is bad. */
 	ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
 			ext2fs_bg_itable_unused(fs, group) +
 			group * fs->super->s_inodes_per_group + 1;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 99ca652..425f736 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -743,9 +743,7 @@ STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 #endif
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		/* new metadata csum code */
 		__u16 old_crc;
 		__u32 crc32;
@@ -781,8 +779,7 @@ out:
 
 int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group)
 {
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	if (ext2fs_has_group_desc_csum(fs) &&
 	    (ext2fs_bg_checksum(fs, group) !=
 	     ext2fs_group_desc_csum(fs, group)))
 		return 0;
@@ -792,8 +789,7 @@ int ext2fs_group_desc_csum_verify(ext2_filsys fs, dgrp_t group)
 
 void ext2fs_group_desc_csum_set(ext2_filsys fs, dgrp_t group)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return;
 
 	/* ext2fs_bg_checksum_set() sets the actual checksum field but
@@ -827,8 +823,7 @@ errcode_t ext2fs_set_gdt_csum(ext2_filsys fs)
 	if (!fs->inode_map)
 		return EXT2_ET_NO_INODE_BITMAP;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return 0;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index c2e7fbe..89df977 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -729,6 +729,11 @@ struct ext2_super_block {
 #define EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT	0x0080
 #define EXT4_FEATURE_RO_COMPAT_QUOTA		0x0100
 #define EXT4_FEATURE_RO_COMPAT_BIGALLOC		0x0200
+/*
+ * METADATA_CSUM implies GDT_CSUM.  When METADATA_CSUM is set, group
+ * descriptor checksums use the same algorithm as all other data
+ * structures' checksums.
+ */
 #define EXT4_FEATURE_RO_COMPAT_METADATA_CSUM	0x0400
 #define EXT4_FEATURE_RO_COMPAT_REPLICA		0x0800
 
@@ -743,7 +748,6 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
-#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x8000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index ff2799a..28cb626 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -579,8 +579,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT|\
-					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -589,8 +588,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_MMP|\
-					 EXT4_FEATURE_INCOMPAT_64BIT|\
-					 EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)
+					 EXT4_FEATURE_INCOMPAT_64BIT)
 #endif
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
@@ -646,6 +644,12 @@ typedef struct stat ext2fs_struct_stat;
 /*
  * function prototypes
  */
+static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
+{
+	return EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+}
 
 /* alloc.c */
 extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index a63ea18..a22cab4 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -435,8 +435,7 @@ ipg_retry:
 	 * bitmaps will be accounted for when allocated).
 	 */
 	free_blocks = 0;
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		/*
 		 * Don't set the BLOCK_UNINIT group for the last group
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 74703c5..3e6d853 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -157,8 +157,7 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 						     scan->current_group);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
 	scan->blocks_left = scan->fs->inode_blocks_per_group;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		scan->inodes_left -=
 			ext2fs_bg_itable_unused(fs, scan->current_group);
 		scan->blocks_left =
@@ -183,8 +182,7 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	}
 	if (scan->fs->badblocks && scan->fs->badblocks->num)
 		scan->scan_flags |= EXT2_SF_CHK_BADBLOCKS;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+	if (ext2fs_has_group_desc_csum(fs))
 		scan->scan_flags |= EXT2_SF_DO_LAZY;
 	*ret_scan = scan;
 	return 0;
@@ -250,8 +248,7 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 	scan->bytes_left = 0;
 	scan->inodes_left = EXT2_INODES_PER_GROUP(fs->super);
 	scan->blocks_left = fs->inode_blocks_per_group;
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (ext2fs_has_group_desc_csum(fs)) {
 		scan->inodes_left -=
 			ext2fs_bg_itable_unused(fs, scan->current_group);
 		scan->blocks_left =
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index d2b64f4..2dc9b94 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -382,8 +382,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	 * If recovery is from backup superblock, Clear _UNININT flags &
 	 * reset bg_itable_unused to zero
 	 */
-	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
 		dgrp_t group;
 
 		for (group = 0; group < fs->group_desc_count; group++) {
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index a5097c1..18e18aa 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -36,7 +36,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	unsigned int	nbits;
 	errcode_t	retval;
 	char		*block_buf = NULL, *inode_buf = NULL;
-	int		csum_flag = 0;
+	int		csum_flag;
 	blk64_t		blk;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	ext2_ino_t	ino_itr = 1;
@@ -46,9 +46,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 
 	inode_nbytes = block_nbytes = 0;
 	if (do_block) {
@@ -168,7 +166,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	errcode_t retval;
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
 	int inode_nbytes = EXT2_INODES_PER_GROUP(fs->super) / 8;
-	int csum_flag = 0;
+	int csum_flag;
 	int do_image = fs->flags & EXT2_FLAG_IMAGE_FILE;
 	unsigned int	cnt;
 	blk64_t	blk;
@@ -181,9 +179,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-		csum_flag = 1;
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 
 	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
 	if (retval)
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index b8f386e..3ceb0f8 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -114,7 +114,7 @@ static void print_bg_opts(ext2_filsys fs, dgrp_t i)
 {
 	int first = 1, bg_flags = 0;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+	if (ext2fs_has_group_desc_csum(fs))
 		bg_flags = ext2fs_bg_flags(fs, i);
 
 	print_bg_opt(bg_flags, EXT2_BG_INODE_UNINIT, "INODE_UNINIT",
@@ -190,7 +190,7 @@ static void list_desc (ext2_filsys fs)
 		print_range(first_block, last_block);
 		fputs(")", stdout);
 		print_bg_opts(fs, i);
-		if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
+		if (ext2fs_has_group_desc_csum(fs))
 			printf(_("  Checksum 0x%04x, unused inodes %u\n"),
 			       ext2fs_bg_checksum(fs, i),
 			       ext2fs_bg_itable_unused(fs, i));
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 8852735..3d3b1d3 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -885,8 +885,7 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
 		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_64BIT |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_64BIT,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -1937,6 +1936,12 @@ profile_error:
 	if (extended_opts)
 		parse_extended_opts(&fs_param, extended_opts);
 
+	/* Don't allow user to set both metadata_csum and uninit_bg bits. */
+	if ((fs_param.s_feature_ro_compat &
+	     EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (fs_param.s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		fs_param.s_feature_ro_compat &= ~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+
 	/* Since sparse_super is the default, we would only have a problem
 	 * here if it was explicitly disabled.
 	 */
@@ -2049,7 +2054,8 @@ static int should_do_undo(const char *name)
 	int csum_flag, force_undo;
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(&fs_param,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 	force_undo = get_int_from_profile(fs_types, "force_undo", 0);
 	if (!force_undo && (!csum_flag || !lazy_itable_init))
 		return 0;
@@ -2306,19 +2312,6 @@ int main (int argc, char *argv[])
 	if (!quiet &&
 	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
-		if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
-			printf(_("Group descriptor checksums "
-				 "are not enabled.  This reduces the "
-				 "coverage of metadata checksumming.  "
-				 "Pass -O uninit_bg to rectify.\n"));
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
-		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM))
-			printf(_("Group descriptor checksums will not use "
-				 "the faster metadata_checksum algorithm.  "
-				 "Pass -O bg_use_meta_csum to rectify.\n"));
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				EXT3_FEATURE_INCOMPAT_EXTENTS))
 			printf(_("Extents are not enabled.  The file extent "
@@ -2358,6 +2351,7 @@ int main (int argc, char *argv[])
 	    (fs_param.s_feature_ro_compat &
 	     (EXT4_FEATURE_RO_COMPAT_HUGE_FILE|EXT4_FEATURE_RO_COMPAT_GDT_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_DIR_NLINK|
+	      EXT4_FEATURE_RO_COMPAT_METADATA_CSUM|
 	      EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)))
 		fs->super->s_kbytes_written = 1;
 
@@ -2505,8 +2499,7 @@ int main (int argc, char *argv[])
 		 * inodes as unused; we want e2fsck to consider all
 		 * inodes as potentially containing recoverable data.
 		 */
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			for (i = 1; i < fs->group_desc_count; i++)
 				ext2fs_bg_itable_unused_set(fs, i, 0);
 		}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index cba4d4c..241694f 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -92,7 +92,6 @@ static unsigned long new_inode_size;
 static char *ext_mount_opts;
 static int usrquota, grpquota;
 static int rewrite_checksums;
-static int rewrite_bgs_for_checksum;
 
 int journal_size, journal_flags;
 char *journal_device;
@@ -138,8 +137,7 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -159,8 +157,7 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP |
-		EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM,
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -717,27 +714,47 @@ static void rewrite_metadata_checksums(ext2_filsys fs)
 	ext2fs_mark_super_dirty(fs);
 }
 
-/*
- * Rewrite just the block group checksums.  Only call this function if
- * you're _not_ calling rewrite_metadata_checksums; this function exists
- * to handle the case that you're changing bg_use_meta_csum and NOT changing
- * either gdt_csum or metadata_csum.
- */
-static void rewrite_bg_checksums(ext2_filsys fs)
+static void enable_uninit_bg(ext2_filsys fs)
 {
+	struct ext2_group_desc *gd;
 	int i;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
-		return;
+	for (i = 0; i < fs->group_desc_count; i++) {
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
+		gd->bg_itable_unused = 0;
+		gd->bg_flags = EXT2_BG_INODE_ZEROED;
+		ext2fs_group_desc_csum_set(fs, i);
+	}
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+}
 
-	ext2fs_init_csum_seed(fs);
-	for (i = 0; i < fs->group_desc_count; i++)
+static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
+{
+	struct ext2_group_desc *gd;
+	int i;
+
+	/* Load bitmaps to ensure that the uninit ones get written out */
+	fs->super->s_feature_ro_compat |= csum_feature_flag;
+	ext2fs_read_bitmaps(fs);
+	ext2fs_mark_ib_dirty(fs);
+	ext2fs_mark_bb_dirty(fs);
+	fs->super->s_feature_ro_compat &= ~csum_feature_flag;
+
+	for (i = 0; i < fs->group_desc_count; i++) {
+		gd = ext2fs_group_desc(fs, fs->group_desc, i);
+		if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
+			/* 
+			 * XXX what we really should do is zap
+			 * uninitialized inode tables instead.
+			 */
+			request_fsck_afterwards(fs);
+			break;
+		}
+		gd->bg_itable_unused = 0;
+		gd->bg_flags = 0;
 		ext2fs_group_desc_csum_set(fs, i);
+	}
 	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	ext2fs_mark_super_dirty(fs);
 }
 
 /*
@@ -912,25 +929,26 @@ mmp_error:
 		}
 	}
 
-	if (FEATURE_ON(E2P_FEATURE_INCOMPAT,
-		       EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
-		if (check_fsck_needed(fs))
-			exit(1);
-		rewrite_bgs_for_checksum = 1;
-	}
-
-	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT,
-			EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM)) {
-		if (check_fsck_needed(fs))
-			exit(1);
-		rewrite_bgs_for_checksum = 1;
-	}
-
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (check_fsck_needed(fs))
 			exit(1);
 		rewrite_checksums = 1;
+		/* metadata_csum supersedes uninit_bg */
+		fs->super->s_feature_ro_compat &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+
+		/* if uninit_bg was previously off, rewrite group desc */
+		if (!(old_features[E2P_FEATURE_RO_INCOMPAT] &
+		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			enable_uninit_bg(fs);
+
+		/*
+		 * Since metadata_csum supersedes uninit_bg, pretend like
+		 * uninit_bg has been off all along.
+		 */
+		old_features[E2P_FEATURE_RO_INCOMPAT] &=
+			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
@@ -938,37 +956,40 @@ mmp_error:
 		if (check_fsck_needed(fs))
 			exit(1);
 		rewrite_checksums = 1;
+		/*
+		 * If we're turning off metadata_csum and not turning on
+		 * uninit_bg, rewrite group desc.
+		 */
+		if (!(fs->super->s_feature_ro_compat &
+		      EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+			disable_uninit_bg(fs,
+				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+		else
+			/*
+			 * metadata_csum previously provided uninit_bg, so if
+			 * we're also setting the uninit_bg feature bit,
+			 * pretend like it was previously enabled.  Checksums
+			 * will be rewritten with crc16 later.
+			 */
+			old_features[E2P_FEATURE_RO_INCOMPAT] |=
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 		       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		for (i = 0; i < fs->group_desc_count; i++) {
-			gd = ext2fs_group_desc(fs, fs->group_desc, i);
-			gd->bg_itable_unused = 0;
-			gd->bg_flags = EXT2_BG_INODE_ZEROED;
-			ext2fs_group_desc_csum_set(fs, i);
-		}
-		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
+		/* Do not enable uninit_bg when metadata_csum enabled */
+		if (fs->super->s_feature_ro_compat &
+		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+			fs->super->s_feature_ro_compat &=
+				~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		else
+			enable_uninit_bg(fs);
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
-			EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
-		for (i = 0; i < fs->group_desc_count; i++) {
-			gd = ext2fs_group_desc(fs, fs->group_desc, i);
-			if ((gd->bg_flags & EXT2_BG_INODE_ZEROED) == 0) {
-				/* 
-				 * XXX what we really should do is zap
-				 * uninitialized inode tables instead.
-				 */
-				request_fsck_afterwards(fs);
-				break;
-			}
-			gd->bg_itable_unused = 0;
-			gd->bg_flags = 0;
-			gd->bg_checksum = 0;
-		}
-		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
-	}
+			EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		disable_uninit_bg(fs,
+				EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 
 	if (FEATURE_ON(E2P_FEATURE_RO_INCOMPAT,
 				EXT4_FEATURE_RO_COMPAT_QUOTA)) {
@@ -2550,8 +2571,7 @@ retry_open:
 				exit(1);
 		}
 
-		if (sb->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		if (ext2fs_has_group_desc_csum(fs)) {
 			/*
 			 * Determine if the block group checksums are
 			 * correct so we know whether or not to set
@@ -2588,8 +2608,6 @@ retry_open:
 	}
 	if (rewrite_checksums)
 		rewrite_metadata_checksums(fs);
-	else if (rewrite_bgs_for_checksum)
-		rewrite_bg_checksums(fs);
 	if (I_flag) {
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index dc2805d..8a02ff4 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -191,8 +191,7 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
 	int		old_desc_blocks;
 	dgrp_t		g;
 
-	if (!(EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)))
+	if (!ext2fs_has_group_desc_csum(fs))
 		return;
 
 	for (g=0; g < fs->group_desc_count; g++) {
@@ -482,8 +481,7 @@ retry:
 	group_block = fs->super->s_first_data_block +
 		old_fs->group_desc_count * fs->super->s_blocks_per_group;
 
-	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	csum_flag = ext2fs_has_group_desc_csum(fs);
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
@@ -743,8 +741,7 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 	} else if (IS_INODE_TB(fs, group, blk)) {
 		ext2fs_inode_table_loc_set(fs, group, 0);
 		rfs->needed_blocks++;
-	} else if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					      EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	} else if (ext2fs_has_group_desc_csum(fs) &&
 		   (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT))) {
 		/*
 		 * If the block bitmap is uninitialized, which means
@@ -804,8 +801,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	for (blk = ext2fs_blocks_count(fs->super);
 	     blk < ext2fs_blocks_count(old_fs->super); blk++) {
 		g = ext2fs_group_of_blk2(fs, blk);
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+		if (ext2fs_has_group_desc_csum(fs) &&
 		    ext2fs_bg_flags_test(old_fs, g, EXT2_BG_BLOCK_UNINIT)) {
 			/*
 			 * The block bitmap is uninitialized, so skip
