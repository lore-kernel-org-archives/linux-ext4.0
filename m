From: Andreas Dilger <adilger@sun.com>
Subject: Re: Respin of the uninit_group patches
Date: Tue, 25 Mar 2008 02:40:39 -0600
Message-ID: <20080325084039.GA10804@webber.adilger.int>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56814 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYCYIlE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 04:41:04 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m2P8f320011159
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 01:41:03 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JYA00B012LXB800@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Mar 2008 01:41:01 -0700 (PDT)
In-reply-to: <1205760527-14858-1-git-send-email-tytso@mit.edu>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 17, 2008  09:28 -0400, Theodore Ts'o wrote:
> I've reworked this patch series to clean them up a bit.  In
> particular, an unused ext2fs_scan_inode flag (EXT2_SF_DO_CSUM) was
> removed, and I made ext2fs_group_desc_csum() static, and added
> ext2fs_group_desc_csum_set().  In addition, ext2fs_group_desc_set()
> and ext2fs_group_desc_verify() take an ext2_filsys argument instead of
> a superblock and a pointer to a group descriptor, in order to simplify
> the calling code.

Sorry for the delayed reply on this.  After discussions with Eric about
the endian fixes missing from e2fsck, I also looked back at the uninit
groups patches and did a line-by-line comparison to see if anything was
missing.  Sure enough, there are a few checks, and all of the regression
tests are missing.

The missing code is attached here as a patch, and I've uploaded the full
set of CFS patches (against 1.40.5, which I wasn't previously able to
host anywhere) to http://downloads.lustre.org/people/adilger/ in case you
are missing any of the test cases:

tests/f_uninit_bad_free_inodes
tests/f_uninit_blk_used_not_set
tests/f_uninit_checksum_bad
tests/f_uninit_disable
tests/f_uninit_enable
tests/f_uninit_inode_past_unused
tests/f_uninit_last_uninit
tests/f_uninit_set_inode_not_set

I verified all of these tests pass with the code currently on the "next"
branch plus this patch.  All of the f_extents_* patches currently fail,
but that is a different story (not sure I'll have time to look at those
before I go on vacation).

========================================================================

Add a check for the UNINIT_BLOCKS flag set in the last group.  The kernel
patch doesn't handle this gracefully, because it assumes there are a full
set of blocks in each group marked UNINIT_BLOCKS.  The kernel should be
fixed up, but in the meantime this avoids hitting the problem, and is
more consistent with lazy_bg not marking the last group UNINIT.

Un-static the ext2fs_group_desc_csum() so that it could be
used in parse_gd_csum().  The other alternative was to hack around and
have ext2fs_group_desc_csum_set() set the calculated checksum value in
the filesystem, extract it back into "val" and then have the caller
save it back into the filesystem...  Yuck.

Add the ability to have debugfs calculate the correct group checksum.
This is used in the last_uninit testcase, and this requires re-adding the
call to ext2fs_group_desc_csum_set() in e2fsck's check_super_block(),
otherwise it doesn't update the checksums after having "fixed" these
errors and restarting e2fsck would cause the same problems to be hit
each time.  It is now conditional upon having fixed some problem instead
of always being done, so this automatically makes it safe for read-only
filesystems, etc.

Split the m_lazy testcase into two tests - one that has resize enabled,
and one that does not.  There were previously problems with lazy+resize
because the resize feature consumed blocks in some of the groups.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>

======================= e2fsprogs-uninit-update.patch ==================
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index a58c94e..cd371db 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -42,6 +42,7 @@
 static struct ext2_super_block set_sb;
 static struct ext2_inode set_inode;
 static struct ext2_group_desc set_gd;
+static dgrp_t set_bg;
 static ext2_ino_t set_ino;
 static int array_idx;
 
@@ -63,6 +64,7 @@ static errcode_t parse_uuid(struct field_set_info *info, char *arg);
 static errcode_t parse_hashalg(struct field_set_info *info, char *arg);
 static errcode_t parse_time(struct field_set_info *info, char *arg);
 static errcode_t parse_bmap(struct field_set_info *info, char *arg);
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg);
 
 static struct field_set_info super_fields[] = {
 	{ "inodes_count", &set_sb.s_inodes_count, 4, parse_uint },
@@ -178,7 +180,7 @@ static struct field_set_info ext2_bg_fields[] = {
 	{ "flags", &set_gd.bg_flags, 2, parse_uint },
 	{ "reserved", &set_gd.bg_reserved, 2, parse_uint, FLAG_ARRAY, 2 },
 	{ "itable_unused", &set_gd.bg_itable_unused, 2, parse_uint },
-	{ "checksum", &set_gd.bg_checksum, 2, parse_uint },
+	{ "checksum", &set_gd.bg_checksum, 2, parse_gd_csum },
 	{ 0, 0, 0, 0 }
 };
 
@@ -402,6 +404,19 @@ static errcode_t parse_bmap(struct field_set_info *info, char *arg)
 	return retval;
 }
 
+static errcode_t parse_gd_csum(struct field_set_info *info, char *arg)
+{
+
+	if (strcmp(arg, "calc") == 0) {
+		__u16 *val = info->ptr;
+
+		*val = ext2fs_group_desc_csum(current_fs, set_bg);
+
+		return 0;
+	}
+
+	return parse_uint(info, arg);
+}
 
 static void print_possible_fields(struct field_set_info *fields)
 {
@@ -521,7 +536,6 @@ void do_set_block_group_descriptor(int argc, char *argv[])
 		"\t\"set_block_group_descriptor -l\" will list the names of "
 		"the fields in a block group descriptor\n\twhich can be set.";
 	struct field_set_info	*ss;
-	dgrp_t			set_bg;
 	char			*end;
 
 	if ((argc == 2) && !strcmp(argv[1], "-l")) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b6a3a81..134e767 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -371,16 +371,21 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@g descriptor %g has invalid unused inodes count %b.  "),
 	     PROMPT_FIX, PR_PREEN_OK },
 
+	/* Last group block bitmap uninitialized. */
+	{ PR_0_BB_UNINIT_LAST,
+	  N_("last @g @b @B uninitialized.  "),
+	     PROMPT_FIX, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
 	{ PR_1_PASS_HEADER,
 	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Root directory is not an inode */
 	{ PR_1_ROOT_NO_DIR, N_("@r is not a @d.  "),
-	  PROMPT_CLEAR, 0 }, 
+	  PROMPT_CLEAR, 0 },
 
 	/* Root directory has dtime set */
 	{ PR_1_ROOT_DTIME,
@@ -1227,23 +1232,23 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_2_HTREE_BAD_DEPTH,
 	  N_("@p @h %d: node (%B) has @n depth\n"),
 	  PROMPT_NONE, 0 },
-	
+
 	/* Duplicate directory entry found */
 	{ PR_2_DUPLICATE_DIRENT,
 	  N_("Duplicate @E found.  "),
 	  PROMPT_CLEAR, 0 },
-	
+
 	/* Non-unique filename found */
 	{ PR_2_NON_UNIQUE_FILE, /* xgettext: no-c-format */
 	  N_("@E has a non-unique filename.\nRename to %s"),
 	  PROMPT_NULL, 0 },
-	
+
 	/* Duplicate directory entry found */
 	{ PR_2_REPORT_DUP_DIRENT,
 	  N_("Duplicate @e '%Dn' found.\n\tMarking %p (%i) to be rebuilt.\n\n"),
 	  PROMPT_NONE, 0 },
-	
-  	/* i_blocks_hi should be zero */
+
+	/* i_blocks_hi should be zero */
 	{ PR_2_BLOCKS_HI_ZERO,
 	  N_("i_blocks_hi @F %N, @s zero.\n"),
 	  PROMPT_CLEAR, 0 },
@@ -1251,7 +1256,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Unexpected HTREE block */
 	{ PR_2_UNEXPECTED_HTREE_BLOCK,
 	  N_("Unexpected @b in @h %d (%q).\n"), PROMPT_CLEAR_HTREE, 0 },
-		  
+
 	/* Inode found in group where _INODE_UNINIT is set */
 	{ PR_2_INOREF_BG_INO_UNINIT,
 	  N_("@i %i found in @g %g where _INODE_UNINIT is set.  "),
@@ -1268,12 +1273,12 @@ static struct e2fsck_problem problem_table[] = {
 	{ PR_3_PASS_HEADER,
 	  N_("Pass 3: Checking @d connectivity\n"),
 	  PROMPT_NONE, 0 },
-		  
+
 	/* Root inode not allocated */
 	{ PR_3_NO_ROOT_INODE,
 	  N_("@r not allocated.  "),
-	  PROMPT_ALLOCATE, 0 },	
-		  
+	  PROMPT_ALLOCATE, 0 },
+
 	/* No room in lost+found */
 	{ PR_3_EXPAND_LF_DIR,
 	  N_("No room in @l @d.  "),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index a2bd2b5..7993203 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -208,6 +208,9 @@ struct problem_context {
 /* Group descriptor N has invalid unused inodes count. */
 #define PR_0_GDT_ITABLE_UNUSED			0x000038
 
+/* Last group block bitmap is uninitialized. */
+#define PR_0_BB_UNINIT_LAST			0x000039
+
 /*
  * Pass 1 errors
  */
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 6753a14..87a0d78 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -631,11 +631,13 @@ void check_super_block(e2fsck_t ctx)
 		    (gd->bg_used_dirs_count > sb->s_inodes_per_group))
 			ext2fs_unmark_valid(fs);
 
+		should_be = 0;
 		if (!ext2fs_group_desc_csum_verify(fs, i)) {
 			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
 				gd->bg_flags &=	~(EXT2_BG_BLOCK_UNINIT |
 				                  EXT2_BG_INODE_UNINIT);
 				gd->bg_itable_unused = 0;
+				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
@@ -647,23 +649,42 @@ void check_super_block(e2fsck_t ctx)
 				gd->bg_flags &= ~(EXT2_BG_BLOCK_UNINIT |
 						  EXT2_BG_INODE_UNINIT);
 				gd->bg_itable_unused = 0;
+				should_be = 1;
 			}
 			ext2fs_unmark_valid(fs);
 		}
+
+		if (i == fs->group_desc_count - 1 &&
+		    gd->bg_flags & EXT2_BG_BLOCK_UNINIT) {
+			if (fix_problem(ctx, PR_0_BB_UNINIT_LAST, &pctx)) {
+				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				should_be = 1;
+			}
+			ext2fs_unmark_valid(fs);
+		}
+
 		if (gd->bg_flags & EXT2_BG_BLOCK_UNINIT &&
 		    !(gd->bg_flags & EXT2_BG_INODE_UNINIT)) {
-			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx))
+			if (fix_problem(ctx, PR_0_BB_UNINIT_IB_INIT, &pctx)) {
 				gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+				should_be = 1;
+			}
 			ext2fs_unmark_valid(fs);
 		}
+
 		if (csum_flag &&
 		    (gd->bg_itable_unused > gd->bg_free_inodes_count ||
 		     gd->bg_itable_unused > sb->s_inodes_per_group)) {
 			pctx.blk = gd->bg_itable_unused;
-			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx))
+			if (fix_problem(ctx, PR_0_GDT_ITABLE_UNUSED, &pctx)) {
 				gd->bg_itable_unused = 0;
+				should_be = 1;
+			}
 			ext2fs_unmark_valid(fs);
 		}
+
+		if (should_be)
+			ext2fs_group_desc_csum_set(fs, i);
 	}
 
 	/*
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index c35d924..6b25d6f 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -18,13 +18,7 @@
 #define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
-#ifdef DEBUG
-#define STATIC
-#else
-#define STATIC static
-#endif
-
-STATIC __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
+__u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 {
 	__u16 crc = 0;
 	struct ext2_group_desc *desc;
@@ -104,6 +98,8 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 
 	for (i = 0; i < fs->group_desc_count; i++, bg++) {
 		int old_csum = bg->bg_checksum;
+		int old_unused = bg->bg_itable_unused;
+		int old_flags = bg->bg_flags;
 
 		/* Even if it wasn't zeroed, by the time this function is
 		 * called by e2fsck we have already scanned and corrected
@@ -112,48 +108,44 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 		 * zeroing of the inode table if mke2fs didn't do it, to help
 		 * out if we need to do a full itable scan sometime later. */
 		if (!(bg->bg_flags & (EXT2_BG_INODE_UNINIT |
-				      EXT2_BG_INODE_ZEROED))) {
+				      EXT2_BG_INODE_ZEROED)))
 			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
-			dirty = 1;
-		}
 
 		if (bg->bg_free_inodes_count == sb->s_inodes_per_group &&
 		    i > 0 && (i < fs->group_desc_count - 1 || csum_flag)) {
-			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT)) {
+			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT))
 				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-				dirty = 1;
-			}
-			if (csum_flag) {
-				int old_unused = bg->bg_itable_unused;
+
+			if (csum_flag)
 				bg->bg_itable_unused = sb->s_inodes_per_group;
-				if (old_unused != bg->bg_itable_unused)
-					dirty = 1;
-			}
 		} else if (csum_flag) {
-			int old_unused = bg->bg_itable_unused;
-			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
-			bg->bg_itable_unused = sb->s_inodes_per_group -
-				find_last_inode_ingrp(fs->inode_map,
+			if (fs->inode_map)
+				bg->bg_itable_unused = sb->s_inodes_per_group -
+					find_last_inode_ingrp(fs->inode_map,
 						      sb->s_inodes_per_group,i);
-			if (old_unused != bg->bg_itable_unused)
-				dirty = 1;
+			else if (bg->bg_flags & EXT2_BG_INODE_UNINIT)
+				bg->bg_itable_unused = 0;
+
+			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
 		}
 
 		/* skip first and last groups, or groups with GDT backups
 		 * because the resize inode has blocks allocated in them. */
-		if (i == 0 || (i == fs->group_desc_count - 1 && !csum_flag) ||
+		if (i == 0 || i == fs->group_desc_count - 1 ||
 		    (ext2fs_bg_has_super(fs, i) && sb->s_reserved_gdt_blocks))
 			goto checksum;
 
 		blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
 		if (bg->bg_free_blocks_count == blks &&
 		    bg->bg_flags & EXT2_BG_INODE_UNINIT &&
-		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT)) {
+		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT))
 			bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-			dirty = 1;
-		}
 checksum:
 		ext2fs_group_desc_csum_set(fs, i);
+		if (old_flags != bg->bg_flags)
+			dirty = 1;
+		if (old_unused != bg->bg_itable_unused)
+			dirty = 1;
 		if (old_csum != bg->bg_checksum)
 			dirty = 1;
 	}
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index b4a445d..bd568b3 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -239,9 +239,8 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 		scan->inodes_left -=
 			fs->group_desc[scan->current_group].bg_itable_unused;
 		scan->blocks_left =
-			(EXT2_INODES_PER_GROUP(fs->super) -
-			 fs->group_desc[scan->current_group].bg_itable_unused +
-			 fs->blocksize / scan->inode_size - 1) *
+			(scan->inodes_left +
+			 (fs->blocksize / scan->inode_size - 1)) *
 			scan->inode_size / fs->blocksize;
 	}
 
diff --git a/lib/ext2fs/tst_csum.c b/lib/ext2fs/tst_csum.c
index e3fa9be..efeeb0a 100644
--- a/lib/ext2fs/tst_csum.c
+++ b/lib/ext2fs/tst_csum.c
@@ -4,8 +4,8 @@
  * Copyright (C) 2006, 2007 by Andreas Dilger <adilger@clusterfs.com>
  *
  * %Begin-Header%
- * This file may be redistributed under the terms of the GNU Public
- * License.
+ * This file may be redistributed under the terms of the GNU General Public
+ * License, Version 2.  See the file COPYING for more details.
  * %End-Header%
  */
 
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index a32c34a..79929b4 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -227,7 +227,7 @@ for the filesystem.  (For administrators who are creating
 filesystems on RAID arrays, it is preferable to use the
 .I stride
 RAID parameter as part of the
-.B \-R
+.B \-E
 option rather than manipulating the number of blocks per group.)  
 This option is generally used by developers who
 are developing test cases.  
@@ -433,7 +433,7 @@ Create a filesystem without initializing all of the groups.  This speeds
 up filesystem creation time noticably, and can also reduce
 .BR e2fsck time
 dramatically.  This feature causes the filesystem to be read-only in
-older kernels is not supported in most Linux kernels, use with caution.
+older kernels, and is not supported in most Linux kernels.  Use with caution.
 .B \-j
 option).
 @JDEV@.TP
diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index b5af4d0..c6f1ca7 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -444,7 +444,9 @@ only supports clearing this filesystem feature.
 Allow the kernel to initialize bitmaps and inode tables and keep a high
 watermark for the unused inodes in a filesystem, to reduce
 .BR e2fsck (8)
-time.
+time.  This first e2fsck run after enabling this feature will take the
+full time, but subsequent e2fsck runs will take only a fraction of the
+original time, depending on how full the file system is.
 .RE
 .IP
 After setting or clearing 
@@ -464,6 +466,12 @@ if necessary.  After setting the
 feature, 
 .B e2fsck -D
 can be run to convert existing directories to the hashed B-tree format.
+Enabling certain filesystem features may prevent the filesystem from being
+mounted by kernels which do not support those features.  In particular the
+.BR uninit_groups
+and
+.BR flex_bg
+features are only supported by the ext4 filesystem.
 .TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
diff --git a/tests/f_uninit_last_uninit/expect.1 b/tests/f_uninit_last_uninit/expect.1
new file mode 100644
index 0000000..dae50e4
--- /dev/null
+++ b/tests/f_uninit_last_uninit/expect.1
@@ -0,0 +1,9 @@
+last group block bitmap uninitialized.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
diff --git a/tests/f_uninit_last_uninit/expect.2 b/tests/f_uninit_last_uninit/expect.2
new file mode 100644
index 0000000..435a8a7
--- /dev/null
+++ b/tests/f_uninit_last_uninit/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32 files (9.1% non-contiguous), 105/10000 blocks
+Exit status is 0
diff --git a/tests/f_uninit_last_uninit/name b/tests/f_uninit_last_uninit/name
new file mode 100644
index 0000000..4f93e23
--- /dev/null
+++ b/tests/f_uninit_last_uninit/name
@@ -0,0 +1,2 @@
+last group has BLOCK_UNINIT set
+
diff --git a/tests/f_uninit_last_uninit/script b/tests/f_uninit_last_uninit/script
new file mode 100644
index 0000000..477357a
--- /dev/null
+++ b/tests/f_uninit_last_uninit/script
@@ -0,0 +1,20 @@
+SKIP_GUNZIP="true"
+
+touch $TMPFILE
+$MKE2FS -N 32 -F -o Linux -O uninit_groups -b 1024 $TMPFILE 10000 > /dev/null 2>&1 
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+set_current_time 200704102100
+set_super_value lastcheck 0
+set_super_value hash_seed null
+set_super_value mkfs_time 0
+set_bg 1 flags 0x7
+set_bg 1 checksum calc
+q
+EOF
+
+E2FSCK_TIME=200704102100
+export E2FSCK_TIME
+
+. $cmd_dir/run_e2fsck
+
+unset E2FSCK_TIME
diff --git a/tests/m_lazy/expect.1 b/tests/m_lazy/expect.1
index e0e459c..901133b 100644
--- a/tests/m_lazy/expect.1
+++ b/tests/m_lazy/expect.1
@@ -5,7 +5,6 @@ Fragment size=1024 (log=0)
 32768 inodes, 131072 blocks
 6553 blocks (5.00%) reserved for the super user
 First data block=1
-Maximum filesystem blocks=67371008
 16 block groups
 8192 blocks per group, 8192 fragments per group
 2048 inodes per group
@@ -15,21 +14,21 @@ Superblock backups stored on blocks:
 Writing inode tables: done                            
 Writing superblocks and filesystem accounting information: done
 
-Filesystem features: ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Filesystem features: ext_attr dir_index lazy_bg filetype sparse_super
  
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 28683/32768 files (0.0% non-contiguous), 77097/131072 blocks
+test_filesys: 28683/32768 files (0.0% non-contiguous), 115220/131072 blocks
 Exit status is 0
 
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Filesystem features:      ext_attr dir_index lazy_bg filetype sparse_super
 Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
@@ -37,12 +36,11 @@ Filesystem OS type:       Linux
 Inode count:              32768
 Block count:              131072
 Reserved block count:     6553
-Free blocks:              53975
+Free blocks:              15852
 Free inodes:              4085
 First block:              1
 Block size:               1024
 Fragment size:            1024
-Reserved GDT blocks:      256
 Blocks per group:         8192
 Fragments per group:      8192
 Inodes per group:         2048
@@ -58,19 +56,17 @@ Default directory hash:   tea
 
 Group 0: (Blocks 1-8192)
   Primary superblock at 1, Group descriptors at 2-2
-  Reserved GDT blocks at 3-258
-  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
-  Inode table at 261-516 (+260)
-  7662 free blocks, 2037 free inodes, 2 directories
-  Free blocks: 531-8192
+  Block bitmap at 3 (+2), Inode bitmap at 4 (+3)
+  Inode table at 5-260 (+4)
+  7919 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 274-8192
   Free inodes: 12-2048
-Group 1: (Blocks 8193-16384) [Inode not init]
+Group 1: (Blocks 8193-16384) [Inode not init, Block not init]
   Backup superblock at 8193, Group descriptors at 8194-8194
-  Reserved GDT blocks at 8195-8450
-  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
-  Inode table at 8453-8708 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 8709-16384
+  Block bitmap at 8195 (+2), Inode bitmap at 8196 (+3)
+  Inode table at 8197-8452 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
   Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
@@ -78,13 +74,12 @@ Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 3: (Blocks 24577-32768) [Inode not init]
+Group 3: (Blocks 24577-32768) [Inode not init, Block not init]
   Backup superblock at 24577, Group descriptors at 24578-24578
-  Reserved GDT blocks at 24579-24834
-  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
-  Inode table at 24837-25092 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 25093-32768
+  Block bitmap at 24579 (+2), Inode bitmap at 24580 (+3)
+  Inode table at 24581-24836 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
   Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
@@ -92,13 +87,12 @@ Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 5: (Blocks 40961-49152) [Inode not init]
+Group 5: (Blocks 40961-49152) [Inode not init, Block not init]
   Backup superblock at 40961, Group descriptors at 40962-40962
-  Reserved GDT blocks at 40963-41218
-  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
-  Inode table at 41221-41476 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 41477-49152
+  Block bitmap at 40963 (+2), Inode bitmap at 40964 (+3)
+  Inode table at 40965-41220 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
   Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
@@ -106,13 +100,12 @@ Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 7: (Blocks 57345-65536) [Inode not init]
+Group 7: (Blocks 57345-65536) [Inode not init, Block not init]
   Backup superblock at 57345, Group descriptors at 57346-57346
-  Reserved GDT blocks at 57347-57602
-  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
-  Inode table at 57605-57860 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 57861-65536
+  Block bitmap at 57347 (+2), Inode bitmap at 57348 (+3)
+  Inode table at 57349-57604 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
   Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
@@ -120,13 +113,12 @@ Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
   0 free blocks, 0 free inodes, 0 directories
   Free blocks: 
   Free inodes: 
-Group 9: (Blocks 73729-81920) [Inode not init]
+Group 9: (Blocks 73729-81920) [Inode not init, Block not init]
   Backup superblock at 73729, Group descriptors at 73730-73730
-  Reserved GDT blocks at 73731-73986
-  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
-  Inode table at 73989-74244 (+260)
-  7676 free blocks, 0 free inodes, 0 directories
-  Free blocks: 74245-81920
+  Block bitmap at 73731 (+2), Inode bitmap at 73732 (+3)
+  Inode table at 73733-73988 (+4)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
   Free inodes: 
 Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
   Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
diff --git a/tests/m_lazy/script b/tests/m_lazy/script
index 35be0c8..aaac8f0 100644
--- a/tests/m_lazy/script
+++ b/tests/m_lazy/script
@@ -1,4 +1,4 @@
 DESCRIPTION="lazy group feature"
 FS_SIZE=131072
-MKE2FS_OPTS="-O lazy_bg"
+MKE2FS_OPTS="-O ^resize_inode,lazy_bg"
 . $cmd_dir/run_mke2fs
diff --git a/tests/m_lazy_resize/expect.1 b/tests/m_lazy_resize/expect.1
new file mode 100644
index 0000000..e0e459c
--- /dev/null
+++ b/tests/m_lazy_resize/expect.1
@@ -0,0 +1,166 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+Maximum filesystem blocks=67371008
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Writing inode tables: done                            
+Writing superblocks and filesystem accounting information: done
+
+Filesystem features: ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 28683/32768 files (0.0% non-contiguous), 77097/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index lazy_bg filetype sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              53975
+Free inodes:              4085
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:		  128
+Default directory hash:   tea
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7662 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 531-8192
+  Free inodes: 12-2048
+Group 1: (Blocks 8193-16384) [Inode not init]
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8450
+  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
+  Inode table at 8453-8708 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 8709-16384
+  Free inodes: 
+Group 2: (Blocks 16385-24576) [Inode not init, Block not init]
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 3: (Blocks 24577-32768) [Inode not init]
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24834
+  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
+  Inode table at 24837-25092 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 25093-32768
+  Free inodes: 
+Group 4: (Blocks 32769-40960) [Inode not init, Block not init]
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 5: (Blocks 40961-49152) [Inode not init]
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Reserved GDT blocks at 40963-41218
+  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
+  Inode table at 41221-41476 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 41477-49152
+  Free inodes: 
+Group 6: (Blocks 49153-57344) [Inode not init, Block not init]
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 7: (Blocks 57345-65536) [Inode not init]
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Reserved GDT blocks at 57347-57602
+  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
+  Inode table at 57605-57860 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 57861-65536
+  Free inodes: 
+Group 8: (Blocks 65537-73728) [Inode not init, Block not init]
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 9: (Blocks 73729-81920) [Inode not init]
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Reserved GDT blocks at 73731-73986
+  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
+  Inode table at 73989-74244 (+260)
+  7676 free blocks, 0 free inodes, 0 directories
+  Free blocks: 74245-81920
+  Free inodes: 
+Group 10: (Blocks 81921-90112) [Inode not init, Block not init]
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 11: (Blocks 90113-98304) [Inode not init, Block not init]
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 12: (Blocks 98305-106496) [Inode not init, Block not init]
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 13: (Blocks 106497-114688) [Inode not init, Block not init]
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  0 free blocks, 0 free inodes, 0 directories
+  Free blocks: 
+  Free inodes: 
+Group 15: (Blocks 122881-131071)
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 123139-131071
+  Free inodes: 30721-32768
diff --git a/tests/m_lazy_resize/script b/tests/m_lazy_resize/script
new file mode 100644
index 0000000..2ba081f
--- /dev/null
+++ b/tests/m_lazy_resize/script
@@ -0,0 +1,4 @@
+DESCRIPTION="lazy group feature with resize_inode"
+FS_SIZE=131072
+MKE2FS_OPTS="-O resize_inode,lazy_bg"
+. $cmd_dir/run_mke2fs
diff --git a/tests/m_uninit/expect.1 b/tests/m_uninit/expect.1
index c6c32b9..8d19a40 100644
--- a/tests/m_uninit/expect.1
+++ b/tests/m_uninit/expect.1
@@ -158,9 +158,9 @@ Group 14: (Blocks 114689-122880) [Inode not init, Block not init]
   7934 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
   Free blocks: 
   Free inodes: 
-Group 15: (Blocks 122881-131071) [Inode not init, Block not init]
+Group 15: (Blocks 122881-131071) [Inode not init]
   Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
   Inode table at 122883-123138 (+2)
   7933 free blocks, 2048 free inodes, 0 directories, 2048 unused inodes
-  Free blocks: 
+  Free blocks: 123139-131071
   Free inodes: 
Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

