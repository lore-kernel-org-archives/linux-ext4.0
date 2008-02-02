From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][20/28] e2fsprogs-mmp.patch
Date: Sat, 02 Feb 2008 01:48:32 -0700
Message-ID: <20080202084832.GU31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58478 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbYBBIsh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:48:37 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128ma5q016672
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:48:36 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00B01S8CF600@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:48:36 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Add multi-mount protection support to libext2fs (INCOMPAT_MMP feature).

This allows mke2fs, e2fsck, and others to detect if the filesystem is
mounted on a remote node (on SAN disks) and avoid corrupting the
filesystem.  For e2fsprogs this only means that it check the MMP block
to see if the filesystem is in use, and mark the filesystem busy while
e2fsck is running on the system.

There is no requirement that e2fsck updates the MMP block in any regular
interval, but e2fsck does this occasionally to provide additional
information to the sysadmin in case of conflict.

Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.5/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/e2p/feature.c
+++ e2fsprogs-1.40.5/lib/e2p/feature.c
@@ -67,6 +67,8 @@ static struct feature feature_list[] = {
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
+			"mmp" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
                         "flex_bg"},
 	{	0, 0, 0 },
Index: e2fsprogs-1.40.5/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40.5/lib/ext2fs/ext2_fs.h
@@ -566,11 +566,11 @@ struct ext2_super_block {
 	__u16	s_min_extra_isize;	/* All inodes have at least # bytes */
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
-	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
-	__u64   s_mmp_block;            /* Block for multi-mount protection */
-	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u16	s_raid_stride;		/* RAID stride */
+	__u16	s_mmp_update_interval;	/* # seconds to wait in MMP checking */
+	__u64	s_mmp_block;		/* Block for multi-mount protection */
+	__u32	s_raid_stripe_width;	/* blocks on all data disks (N*stride)*/
+	__u32	s_reserved[163];	/* Padding to the end of the block */
 };
 
 /*
@@ -637,7 +637,8 @@ struct ext2_super_block {
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
+				       EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -717,26 +718,34 @@ struct ext2_dir_entry_2 {
 /*
  * This structure will be used for multiple mount protection. It will be
  * written into the block number saved in the s_mmp_block field in the
- * superblock.
- */
-#define	EXT2_MMP_MAGIC    0x004D4D50 /* ASCII for MMP */
-#define	EXT2_MMP_CLEAN    0xFF4D4D50 /* Value of mmp_seq for clean unmount */
-#define	EXT2_MMP_FSCK_ON  0xE24D4D50 /* Value of mmp_seq when being fscked */
+ * superblock. Programs that check MMP should assume that if
+ * SEQ_FSCK (or any unknown code above SEQ_MAX) is present then it is NOT safe
+ * to use the filesystem, regardless of how old the timestamp is.
+ */
+#define EXT2_MMP_MAGIC     0x004D4D50U /* ASCII for MMP */
+#define EXT2_MMP_SEQ_CLEAN 0xFF4D4D50U /* mmp_seq value for clean unmount */
+#define EXT2_MMP_SEQ_FSCK  0xE24D4D50U /* mmp_seq value when being fscked */
+#define EXT2_MMP_SEQ_MAX   0xE24D4D4FU /* maximum valid mmp_seq value */
 
 struct mmp_struct {
-	__u32	mmp_magic;
-	__u32	mmp_seq;
-	__u64	mmp_time;
-	char	mmp_nodename[64];
-	char	mmp_bdevname[32];
-	__u16	mmp_interval;
+	__u32	mmp_magic;		/* Magic number for MMP */
+	__u32	mmp_seq;		/* Sequence no. updated periodically */
+	__u64	mmp_time;		/* Time last updated */
+	char	mmp_nodename[64];	/* Node which last updated MMP block */
+	char	mmp_bdevname[32];	/* Bdev which last updated MMP block */
+	__u16	mmp_check_interval;	/* Changed mmp_check_interval */
 	__u16	mmp_pad1;
-	__u32	mmp_pad2;
+	__u32	mmp_pad2[227];
 };
 
 /*
- * Interval in number of seconds to update the MMP sequence number.
+ * Default interval in seconds to update the MMP sequence number.
+ */
+#define EXT2_MMP_UPDATE_INTERVAL	1
+
+/*
+ * Minimum interval for MMP checking in seconds.
  */
-#define EXT2_MMP_DEF_INTERVAL	5
+#define EXT2_MMP_MIN_CHECK_INTERVAL     5
 
 #endif	/* _LINUX_EXT2_FS_H */
Index: e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
@@ -171,6 +171,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_IMAGE_FILE		0x2000
 #define EXT2_FLAG_EXCLUSIVE		0x4000
 #define EXT2_FLAG_SOFTSUPP_FEATURES	0x8000
+#define EXT2_FLAG_SKIP_MMP		0x10000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -185,6 +186,15 @@ typedef struct ext2_file *ext2_file_t;
  */
 #define EXT2_MKJOURNAL_V1_SUPER	0x0000001
 
+/*
+ * The timestamp in the MMP structure will be updated by e2fsck at some
+ * arbitary intervals (start of passes, after every EXT2_MMP_INODE_INTERVAL
+ * inodes in pass1 and pass1b).  There is no guarantee that e2fsck is updating
+ * the MMP block in a timely manner, and the updates it does are purely for
+ * the convenience of the sysadmin and not for automatic validation.
+ */
+#define EXT2_MMP_INODE_INTERVAL 20000
+
 struct struct_ext2_filsys {
 	errcode_t			magic;
 	io_channel			io;
@@ -228,6 +238,15 @@ struct struct_ext2_filsys {
 	 */
 	struct ext2_inode_cache		*icache;
 	io_channel			image_io;
+
+	/*
+	 * Buffer for Multiple mount protection(MMP) block.
+	 */
+	char *mmp_buf;
+	/*
+	 * Time at which e2fsck last updated the MMP block.
+	 */
+	long mmp_last_written;
 };
 
 #if EXT2_FLAT_INCLUDES
@@ -444,14 +463,16 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
  					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
-					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
+					 EXT4_FEATURE_INCOMPAT_MMP)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
@@ -995,6 +1016,12 @@ errcode_t ext2fs_link(ext2_filsys fs, ex
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);
 
+/* mmp.c */
+errcode_t ext2fs_read_mmp(ext2_filsys fs, blk_t mmp_blk, char *buf);
+errcode_t ext2fs_write_mmp(ext2_filsys fs, blk_t mmp_blk, char *buf);
+errcode_t ext2fs_enable_mmp(ext2_filsys fs);
+long int ext2fs_mmp_new_seq();
+
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
@@ -1032,6 +1059,7 @@ extern void ext2fs_swap_inode(ext2_filsy
 extern void ext2fs_swap_extent_header(struct ext3_extent_header *eh);
 extern void ext2fs_swap_extent_index(struct ext3_extent_idx *ix);
 extern void ext2fs_swap_extent(struct ext3_extent *ex);
+extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
Index: e2fsprogs-1.40.5/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.c
+++ e2fsprogs-1.40.5/misc/tune2fs.c
@@ -60,7 +60,7 @@ char * device_name;
 char * new_label, *new_last_mounted, *new_UUID;
 char * io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
-static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag, p_flag;
 static time_t last_check_time;
 static int print_label;
 static int max_mount_count, mount_count, mount_flags;
@@ -69,6 +69,7 @@ static double reserved_ratio;
 static unsigned long resgid, resuid;
 static unsigned short errors;
 static int open_flag;
+static unsigned int mmp_update_interval;
 static char *features_cmd;
 static char *mntopts_cmd;
 static int stride, stripe_width;
@@ -89,7 +90,8 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options]\n"
 		  "\t[-l] [-s sparse_flag] [-m reserved_blocks_percent]\n"
-		  "\t[-o [^]mount_options[,...]] [-r reserved_blocks_count]\n"
+		  "\t[-o [^]mount_options[,...]] [-p mmp_update_interval]"
+		  "[-r reserved_blocks_count]\n"
 		  "\t[-u user] [-C mount_count] [-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
 		  "\t[-E extended-option[,...]] [-T last_check_time] "
@@ -101,7 +103,8 @@ static __u32 ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER |	/* R/O compat */
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
@@ -290,6 +293,7 @@ static void update_feature_set(ext2_fils
 {
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir, uninit, old_uninit;
+	int mmp, old_mmp;
 	int flex_bg, old_flex_bg;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
@@ -293,6 +296,7 @@ static void update_feature_set(ext2_fils
 	int flex_bg, old_flex_bg;
 	struct ext2_super_block *sb= fs->super;
 	__u32	old_compat, old_incompat, old_ro_compat;
+	int error;
 
 	old_compat = sb->s_feature_compat;
 	old_ro_compat = sb->s_feature_ro_compat;
@@ -310,6 +315,8 @@ static void update_feature_set(ext2_fils
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
 	old_uninit = sb->s_feature_ro_compat &
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+	old_mmp = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_MMP;
 	if (e2p_edit_feature(features, &sb->s_feature_compat,
 			     ok_features)) {
 		fprintf(stderr, _("Invalid filesystem option set: %s\n"),
@@ -328,6 +335,8 @@ static void update_feature_set(ext2_fils
 		EXT2_FEATURE_COMPAT_DIR_INDEX;
 	uninit = sb->s_feature_ro_compat &
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+	mmp = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_MMP;
 	if (old_journal && !journal) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&
 		    !(mount_flags & EXT2_MF_READONLY)) {
@@ -376,6 +385,75 @@ static void update_feature_set(ext2_fils
 			exit(1);
 		}
 	}
+	if (!old_mmp && mmp) {
+		if ((mount_flags & EXT2_MF_MOUNTED) ||
+		    (mount_flags & EXT2_MF_READONLY)) {
+			fputs(_("The multiple mount protection feature can't \n"
+				"be set if the filesystem is mounted or \n"
+				"read-only.\n"), stderr);
+			exit(1);
+		}
+
+		error = ext2fs_enable_mmp(fs);
+		if (error) {
+			fputs(_("\nError while enabling multiple mount "
+				"protection feature."), stderr);
+			exit(1);
+		}
+
+		printf(_("Multiple mount protection has been enabled. The MMP "
+			 "update interval has been set to %d seconds.\n"),
+		       sb->s_mmp_update_interval);
+	}
+
+	if (old_mmp && !mmp) {
+		blk_t mmp_block;
+		struct mmp_struct *mmp_s;
+		char *buf;
+
+		if (mount_flags & EXT2_MF_READONLY) {
+			fputs(_("The multiple mount protection feature cannot\n"
+				"be disabled if the filesystem is readonly.\n"),
+				stderr);
+			exit(1);
+		}
+
+		error = ext2fs_read_bitmaps(fs);
+		if (error) {
+			fputs(_("Error while reading bitmaps\n"), stderr);
+			exit(1);
+		}
+
+		mmp_block = sb->s_mmp_block;
+
+		error = ext2fs_get_mem(fs->blocksize, &buf);
+		if (error) {
+			fputs(_("Error allocating memory.\n"), stderr);
+			exit(1);
+		}
+
+		mmp_s = (struct mmp_struct *) buf;
+		error = ext2fs_read_mmp(fs, mmp_block, buf);
+		if (error) {
+			if (error == EXT2_ET_MMP_MAGIC_INVALID)
+				printf(_("Magic number in MMP block does not "
+					 "match. expected: %x, actual: %x\n"),
+					 EXT2_MMP_MAGIC, mmp_s->mmp_magic);
+			else
+				com_err (program_name, error,
+	 				 _("while reading MMP block."));
+			goto mmp_error;
+		}
+
+		ext2fs_unmark_block_bitmap(fs->block_map, mmp_block);
+		ext2fs_mark_bb_dirty(fs);
+
+mmp_error:
+		sb->s_mmp_block = 0;
+		sb->s_mmp_update_interval = 0;
+		if (buf)
+			ext2fs_free_mem(&buf);
+	}
 
 	if (sb->s_rev_level == EXT2_GOOD_OLD_REV &&
 	    (sb->s_feature_compat || sb->s_feature_ro_compat ||
@@ -530,7 +608,7 @@ static void parse_tune2fs_options(int ar
 	struct passwd * pw;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:p:r:s:u:C:E:J:L:M:O:T:U:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -685,6 +763,26 @@ static void parse_tune2fs_options(int ar
 				features_cmd = optarg;
 				open_flag = EXT2_FLAG_RW;
 				break;
+			case 'p':
+				mmp_update_interval = strtol (optarg, &tmp, 0);
+				if (*tmp && mmp_update_interval < 0) {
+					com_err (program_name, 0, _("invalid "
+						 "mmp update interval"));
+					usage();
+				}
+				if (mmp_update_interval == 0)
+					mmp_update_interval = EXT2_MMP_UPDATE_INTERVAL;
+				if (mmp_update_interval > EXT2_MMP_UPDATE_INTERVAL) {
+					com_err (program_name, 0,
+						 _("MMP update interval of %s "
+						   "seconds may be dangerous "
+						   "under high load. Consider "
+						   "decreasing it."),
+						 optarg);
+				}
+				p_flag = 1;
+				open_flag = EXT2_FLAG_RW;
+				break;
 			case 'r':
 				reserved_blocks = strtoul (optarg, &tmp, 0);
 				if (*tmp) {
@@ -883,6 +981,9 @@ int main (int argc, char ** argv)
 #else
 	io_ptr = unix_io_manager;
 #endif
+	if (open_flag == EXT2_FLAG_RW && f_flag)
+		open_flag |= EXT2_FLAG_SKIP_MMP;
+
 	retval = ext2fs_open2(device_name, io_options, open_flag, 
 			      0, 0, io_ptr, &fs);
         if (retval) {
@@ -944,6 +1045,12 @@ int main (int argc, char ** argv)
 		printf (_("Setting reserved blocks percentage to %g%% (%u blocks)\n"),
 			reserved_ratio, sb->s_r_blocks_count);
 	}
+	if (p_flag) {
+		sb->s_mmp_update_interval = mmp_update_interval;
+		ext2fs_mark_super_dirty(fs);
+		printf (_("Setting multiple mount protection update interval to "
+			  "%lu seconds\n"), mmp_update_interval);
+	}
 	if (r_flag) {
 		if (reserved_blocks >= sb->s_blocks_count/2) {
 			com_err (program_name, 0,
Index: e2fsprogs-1.40.5/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.5/e2fsck/pass1.c
@@ -795,7 +795,20 @@ void e2fsck_pass1(e2fsck_t ctx)
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    !(fs->super->s_mmp_block < fs->super->s_first_data_block ||
+	      fs->super->s_mmp_block >= fs->super->s_blocks_count))
+		ext2fs_mark_block_bitmap(ctx->block_found_map,
+					 fs->super->s_mmp_block);
+
 	while (1) {
+		if (ino % EXT2_MMP_INODE_INTERVAL == 0) {
+			errcode_t error;
+
+			error = e2fsck_mmp_update(fs);
+			if (error)
+				fatal_error(ctx, 0);
+		}
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino, 
 							  inode, inode_size);
Index: e2fsprogs-1.40.5/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.5/e2fsck/unix.c
@@ -1076,6 +1076,23 @@ restart:
 			       "to do a read-only\n"
 			       "check of the device.\n"));
 #endif
+		else if (retval == EXT2_ET_MMP_BAD_BLOCK) {
+			if (fix_problem(ctx, PR_0_MMP_INVALID_BLK, &pctx)) {
+				fs->super->s_mmp_block = 0;
+				ext2fs_mark_super_dirty(fs);
+			}
+		}
+		else if (retval == EXT2_ET_MMP_FAILED) {
+			dump_mmp_msg((struct mmp_struct *)fs->mmp_buf,
+				     _("Device is already active on another node."));
+		}
+		else if (retval == EXT2_ET_MMP_FSCK_ON) {
+			dump_mmp_msg((struct mmp_struct *)fs->mmp_buf,
+				     _("It seems as if e2fsck is running on the "
+				     "filesystem.\nIf you are sure that e2fsck is "
+				     "not running then use \"tune2fs -O ^mmp {device}\" "
+				     "followed by \"tune2fs -O mmp {device}\""));
+		}
 		else
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
 		fatal_error(ctx, 0);
Index: e2fsprogs-1.40.5/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.5/e2fsck/problem.c
@@ -389,6 +389,11 @@ static struct e2fsck_problem problem_tab
 	  PROMPT_NONE, 0 },
 
 
+	/* Superblock has invalid MMP block. */
+	{ PR_0_MMP_INVALID_BLK,
+	  N_("@S has invalid MMP block.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
Index: e2fsprogs-1.40.5/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/problem.h
+++ e2fsprogs-1.40.5/e2fsck/problem.h
@@ -222,6 +222,9 @@ struct problem_context {
 #define PR_0_CLEAR_EXTRA_ISIZE			0x00003C
 
 
+/* Superblock has invalid MMP block. */
+#define PR_0_MMP_INVALID_BLK			0x00003A
+
 /*
  * Pass 1 errors
  */
Index: e2fsprogs-1.40.5/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40.5/lib/ext2fs/swapfs.c
@@ -70,6 +70,8 @@ void ext2fs_swap_super(struct ext2_super
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_mmp_update_interval = ext2fs_swab16(sb->s_mmp_update_interval);
+	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
 	for (i=0; i < 17; i++)
@@ -310,4 +312,12 @@ void ext2fs_swap_inode(ext2_filsys fs, s
 				sizeof(struct ext2_inode));
 }
 
+void ext2fs_swap_mmp(struct mmp_struct *mmp)
+{
+	mmp->mmp_magic = ext2fs_swab32(mmp->mmp_magic);
+	mmp->mmp_seq = ext2fs_swab32(mmp->mmp_seq);
+	mmp->mmp_time = ext2fs_swab64(mmp->mmp_time);
+	mmp->mmp_check_interval = ext2fs_swab16(mmp->mmp_check_interval);
+}
+
 #endif
Index: e2fsprogs-1.40.5/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/openfs.c
+++ e2fsprogs-1.40.5/lib/ext2fs/openfs.c
@@ -22,6 +22,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
 
 #include "ext2_fs.h"
 
@@ -67,6 +70,97 @@ errcode_t ext2fs_open(const char *name, 
 }
 
 /*
+ * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
+ */
+int ext2fs_multiple_mount_protect(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	char *buf;
+	struct mmp_struct *mmp_s;
+	unsigned seq;
+	unsigned int mmp_check_interval;
+	errcode_t retval = 0;
+
+	retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+	buf = fs->mmp_buf;
+
+	retval = ext2fs_read_mmp(fs, mmp_blk, buf);
+	if (retval)
+		goto mmp_error;
+
+	mmp_s = (struct mmp_struct *) buf;
+
+	mmp_check_interval = fs->super->s_mmp_update_interval;
+	if (mmp_check_interval < EXT2_MMP_MIN_CHECK_INTERVAL)
+		mmp_check_interval = EXT2_MMP_MIN_CHECK_INTERVAL;
+
+	/*
+	 * If check_interval in MMP block is larger, use that instead of
+	 * check_interval from the superblock.
+	 */
+	if (mmp_s->mmp_check_interval > mmp_check_interval)
+		mmp_check_interval = mmp_s->mmp_check_interval;
+
+
+	seq = mmp_s->mmp_seq;
+	if (seq == EXT2_MMP_SEQ_CLEAN)
+		goto clean_seq;
+	if (seq == EXT2_MMP_SEQ_FSCK) {
+		retval = EXT2_ET_MMP_FSCK_ON;
+		goto mmp_error;
+	}
+
+	if (seq > EXT2_MMP_SEQ_FSCK) {
+		retval = EXT2_ET_MMP_UNKNOWN_SEQ;
+		goto mmp_error;
+	}
+
+	sleep(2 * mmp_check_interval + 1);
+
+	retval = ext2fs_read_mmp(fs, mmp_blk, buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+clean_seq:
+	mmp_s->mmp_seq = seq = ext2fs_mmp_new_seq();
+
+	retval = ext2fs_write_mmp(fs, mmp_blk, buf);
+	if (retval)
+		goto mmp_error;
+
+	sleep(2 * mmp_check_interval + 1);
+
+	retval = ext2fs_read_mmp(fs, mmp_blk, buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+	mmp_s->mmp_seq = EXT2_MMP_SEQ_FSCK;
+	retval = ext2fs_write_mmp(fs, mmp_blk, buf);
+	if (retval)
+		goto mmp_error;
+
+	return 0;
+
+mmp_error:
+	if (buf)
+		ext2fs_free_mem(&buf);
+
+	return retval;
+}
+
+/*
  *  Note: if superblock is non-zero, block-size must also be non-zero.
  * 	Superblock and block_size can be zero to use the default size.
  *
@@ -76,6 +170,7 @@ errcode_t ext2fs_open(const char *name, 
  * 	EXT2_FLAG_FORCE - Open the filesystem even if some of the
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
+ *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
@@ -320,6 +415,15 @@ errcode_t ext2fs_open2(const char *name,
 	}
 
 	*ret_fs = fs;
+
+	fs->mmp_buf = NULL;
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (flags & EXT2_FLAG_RW) && !(flags & EXT2_FLAG_SKIP_MMP)) {
+		retval = ext2fs_multiple_mount_protect(fs);
+		if (retval)
+			goto cleanup;
+	}
+
 	return 0;
 cleanup:
 	ext2fs_free(fs);
Index: e2fsprogs-1.40.5/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext2_err.et.in
+++ e2fsprogs-1.40.5/lib/ext2fs/ext2_err.et.in
@@ -362,5 +362,25 @@ ec	EXT2_ET_EA_NAME_NOT_FOUND,
 ec	EXT2_ET_EA_NAME_EXISTS,
 	"Extended attribute name already exists"
 
+ec	EXT2_ET_MMP_MAGIC_INVALID,
+	"MMP: Invalid magic number in MMP block"
+
+ec	EXT2_ET_MMP_FAILED,
+	"MMP: Device already active on another node"
+
+ec	EXT2_ET_MMP_FSCK_ON,
+	"MMP: Seems as if fsck is already being run on the filesystem."
+
+ec	EXT2_ET_MMP_BAD_BLOCK,
+	"MMP: MMP block number beyond filesystem range."
+
+ec	EXT2_ET_MMP_UNKNOWN_SEQ,
+	"MMP: MMP sequence is beyond EXT2_MMP_SEQ_MAX. This filesystem "
+	"seems to be undergoing an unknown operation."
+
+ec	EXT2_ET_MMP_FSCK_ABORT,
+	"MMP: Expected sequence not found. Filesystem may be mounted while "
+	"fsck was running"
+
 	end
 
Index: e2fsprogs-1.40.5/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/closefs.c
+++ e2fsprogs-1.40.5/lib/ext2fs/closefs.c
@@ -351,12 +351,63 @@ errout:
 	return retval;
 }
 
+errcode_t write_mmp_clean(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	char *buf = fs->mmp_buf, *buf_cmp;
+	struct mmp_struct *mmp, *mmp_cmp;
+	errcode_t retval;
+
+	retval = ext2fs_get_mem(fs->blocksize, &buf_cmp);
+	if (retval)
+		goto mmp_error;
+
+	retval = ext2fs_read_mmp(fs, mmp_blk, buf_cmp);
+	if (retval)
+		goto mmp_error;
+	mmp_cmp = (struct mmp_struct *) buf_cmp;
+
+	/*
+	 * This is important since we may come here just after when MMP feature
+	 * is set and fs->mmp_buf is NULL
+	 */
+	if (!buf)
+		goto check_skipped;
+
+	/*
+	 * Make sure that the MMP block is not changed.
+	 */
+	mmp = (struct mmp_struct *) buf;
+	if (memcmp(mmp, mmp_cmp, sizeof(struct mmp_struct)))
+		return EXT2_ET_MMP_FSCK_ABORT;
+
+check_skipped:
+	mmp_cmp->mmp_seq = EXT2_MMP_SEQ_CLEAN;
+	retval = ext2fs_write_mmp(fs, mmp_blk, buf_cmp);
+
+mmp_error:
+	if (buf)
+		ext2fs_free_mem(&buf);
+	if (buf_cmp)
+		ext2fs_free_mem(&buf_cmp);
+
+	return retval;
+}
+
+
 errcode_t ext2fs_close(ext2_filsys fs)
 {
 	errcode_t	retval;
 	
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (fs->flags & EXT2_FLAG_RW) && !(fs->flags & EXT2_FLAG_SKIP_MMP)) {
+		retval = write_mmp_clean(fs);
+		if (retval)
+			return retval;
+	}
+
 	if (fs->flags & EXT2_FLAG_DIRTY) {
 		retval = ext2fs_flush(fs);
 		if (retval)
Index: e2fsprogs-1.40.5/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.40.5/e2fsck/e2fsck.c
@@ -186,6 +186,7 @@ int e2fsck_run(e2fsck_t ctx)
 {
 	int	i;
 	pass_t	e2fsck_pass;
+	int error;
 
 #ifdef HAVE_SETJMP_H
 	if (setjmp(ctx->abort_loc)) {
@@ -198,6 +199,9 @@ int e2fsck_run(e2fsck_t ctx)
 	for (i=0; (e2fsck_pass = e2fsck_passes[i]); i++) {
 		if (ctx->flags & E2F_FLAG_RUN_RETURN)
 			break;
+		error = e2fsck_mmp_update(ctx->fs);
+		if (error)
+		      	fatal_error(ctx, 0);
 		e2fsck_pass(ctx);
 		if (ctx->progress)
 			(void) (ctx->progress)(ctx, 0, 0, 0);
Index: e2fsprogs-1.40.5/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.5/e2fsck/e2fsck.h
@@ -535,6 +535,8 @@ extern void mtrace_print(char *mesg);
 extern blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
+errcode_t e2fsck_mmp_update(ext2_filsys fs);
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
 
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
Index: e2fsprogs-1.40.5/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-1.40.5/lib/ext2fs/Makefile.in
@@ -55,6 +55,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
+	mmp.o \
 	native.o \
 	newdir.o \
 	openfs.o \
@@ -116,6 +117,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/lookup.c \
 	$(srcdir)/mkdir.c \
 	$(srcdir)/mkjournal.c \
+	$(srcdir)/mmp.c	\
 	$(srcdir)/namei.c \
 	$(srcdir)/native.c \
 	$(srcdir)/newdir.c \
@@ -502,6 +504,7 @@ mkdir.o: $(srcdir)/mkdir.c $(srcdir)/ext
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
  $(srcdir)/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/bitops.h
+mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h
 mkjournal.o: $(srcdir)/mkjournal.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(top_srcdir)/lib/e2p/e2p.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h $(srcdir)/ext3_extents.h \
Index: e2fsprogs-1.40.5/lib/ext2fs/mmp.c
===================================================================
--- /dev/null
+++ e2fsprogs-1.40.5/lib/ext2fs/mmp.c
@@ -0,0 +1,139 @@
+/*
+ * Helper functions for multiple mount protection(MMP).
+ *
+ * Copyright (C) 2006, 2007 by Kalpak Shah <kalpak@clusterfs.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <sys/time.h>
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+errcode_t ext2fs_read_mmp(ext2_filsys fs, blk_t mmp_blk, char *buf)
+{
+	struct mmp_struct *mmp_s;
+	errcode_t retval;
+
+	if ((mmp_blk < fs->super->s_first_data_block) ||
+	    (mmp_blk >= fs->super->s_blocks_count))
+		return EXT2_ET_MMP_BAD_BLOCK;
+
+	/*
+	 * Make sure that we read direct from disk by reading only
+	 * sizeof(stuct mmp_struct) bytes.
+	 */
+	retval = io_channel_read_blk(fs->io, mmp_blk,
+				     -(int)sizeof(struct mmp_struct), buf);
+	if (retval)
+		return retval;
+
+	mmp_s = (struct mmp_struct *) buf;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	if (mmp_s->mmp_magic != EXT2_MMP_MAGIC)
+		return EXT2_ET_MMP_MAGIC_INVALID;
+
+	return 0;
+}
+
+errcode_t ext2fs_write_mmp(ext2_filsys fs, blk_t mmp_blk, char *buf)
+{
+	struct mmp_struct *mmp_s = (struct mmp_struct *) buf;
+	struct timeval tv;
+	int retval;
+
+	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
+	gettimeofday(&tv, 0);
+	mmp_s->mmp_time = tv.tv_sec;
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	retval = io_channel_write_blk(fs->io, mmp_blk,
+				      -(int)sizeof(struct mmp_struct), buf);
+
+#ifdef EXT2FS_ENABLE_SWAPFS
+	if (fs->super->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+		ext2fs_swap_mmp(mmp_s);
+#endif
+
+	/*
+	 * Make sure the block gets to disk quickly.
+	 */
+	io_channel_flush(fs->io);
+	return retval;
+}
+
+long int ext2fs_mmp_new_seq()
+{
+	long int new_seq;
+
+	do {
+		new_seq = random();
+	} while (new_seq > EXT2_MMP_SEQ_MAX);
+
+	return new_seq;
+}
+
+errcode_t ext2fs_enable_mmp(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	struct mmp_struct *mmp_s = NULL;
+	blk_t mmp_block;
+	char *buf;
+	int error;
+
+	error = ext2fs_read_bitmaps(fs);
+	if (error)
+		goto out;
+
+	error = ext2fs_new_block(fs, 0, 0, &mmp_block);
+	if (error)
+		goto out;
+
+	ext2fs_block_alloc_stats(fs, mmp_block, +1);
+	sb->s_mmp_block = mmp_block;
+
+	error = ext2fs_get_mem(fs->blocksize, &buf);
+	if (error)
+		goto out;
+
+	mmp_s = (struct mmp_struct *) buf;
+	memset(mmp_s, 0, sizeof(struct mmp_struct));
+
+	mmp_s->mmp_magic = EXT2_MMP_MAGIC;
+	mmp_s->mmp_seq = EXT2_MMP_SEQ_CLEAN;
+	mmp_s->mmp_time = 0;
+	mmp_s->mmp_nodename[0] = '\0';
+	mmp_s->mmp_bdevname[0] = '\0';
+	mmp_s->mmp_check_interval = EXT2_MMP_MIN_CHECK_INTERVAL;
+
+	error = ext2fs_write_mmp(fs, mmp_block, buf);
+	if (error) {
+		if (buf)
+			ext2fs_free_mem(&buf);
+		goto out;
+	}
+
+	if (buf)
+		ext2fs_free_mem(&buf);
+
+	sb->s_mmp_update_interval = EXT2_MMP_UPDATE_INTERVAL;
+
+out:
+	return error;
+}
Index: e2fsprogs-1.40.5/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/pass1b.c
+++ e2fsprogs-1.40.5/e2fsck/pass1b.c
@@ -272,6 +272,13 @@ static void pass1b(e2fsck_t ctx, char *b
 	pb.pctx = &pctx;
 	pctx.str = "pass1b";
 	while (1) {
+		if (ino % EXT2_MMP_INODE_INTERVAL == 0) {
+			errcode_t error;
+
+			error = e2fsck_mmp_update(fs);
+			if (error)
+				fatal_error(ctx, 0);
+		}
 		pctx.errcode = ext2fs_get_next_inode(scan, &ino, &inode);
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
Index: e2fsprogs-1.40.5/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.40.5.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.40.5/misc/tune2fs.8.in
@@ -438,6 +438,11 @@ Setting the filesystem feature is equiva
 .B \-j
 option.
 .TP
+.B mmp
+Enable or disable multiple mount protection(MMP) feature. MMP helps to protect
+the filesystem from being multiply mounted and is useful in shared storage
+environment.
+.TP
 .B sparse_super
 Limit the number of backup superblocks to save space on large filesystems.
 .TP
@@ -474,6 +479,9 @@ being mounted by kernels which do not su
 .B uninit_groups
 feature is not yet supported by any officially released kernel.
 .TP
+.BI \-p " mmp_check_interval"
+Set the desired MMP check interval in seconds. It is 5 seconds by default.
+.TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
 .TP
Index: e2fsprogs-1.40.5/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.40.5.orig/misc/mke2fs.c
+++ e2fsprogs-1.40.5/misc/mke2fs.c
@@ -922,7 +922,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_MMP,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|	/* R/O compat */
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
@@ -1803,8 +1804,21 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
-	if (!super_only)
+	if (!super_only) {
 		ext2fs_set_gdt_csum(fs);
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+			retval = ext2fs_enable_mmp(fs);
+			if (retval) {
+				fprintf(stderr, _("\nError while enabling "
+					"multiple mount protection feature."));
+				exit(1);
+			}
+			printf(_("Multiple mount protection has been enabled. "
+				 "The MMP update interval has been set to "
+				 "%d seconds.\n"),
+				 fs->super->s_mmp_update_interval);
+		}
+	}
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
Index: e2fsprogs-1.40.5/e2fsck/util.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/util.c
+++ e2fsprogs-1.40.5/e2fsck/util.c
@@ -607,3 +607,61 @@ errcode_t e2fsck_zero_blocks(ext2_filsys
 	}
 	return 0;
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+	printf("MMP check failed: %s\n", msg);
+	printf("MMP failure info: last update time: %llu, "
+	       "last update node: %s, last update device: %s\n",
+	       (long long)mmp->mmp_time, mmp->mmp_nodename, mmp->mmp_bdevname);
+}
+
+#define EXT2_MIN_MMP_UPDATE_INTERVAL 60
+
+errcode_t e2fsck_mmp_update(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	char *buf = fs->mmp_buf, *buf_cmp;
+	struct mmp_struct *mmp, *mmp_cmp;
+	struct timeval tv;
+	errcode_t retval;
+
+	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
+		return 0;
+
+	gettimeofday(&tv, 0);
+	if (tv.tv_sec - fs->mmp_last_written < EXT2_MIN_MMP_UPDATE_INTERVAL)
+		return 0;
+
+	retval = ext2fs_get_mem(fs->blocksize, &buf_cmp);
+	if (retval)
+		goto mmp_error;
+
+	retval = ext2fs_read_mmp(fs, mmp_blk, buf_cmp);
+	if (retval)
+		goto mmp_error;
+
+	mmp = (struct mmp_struct *) buf;
+	mmp_cmp = (struct mmp_struct *) buf_cmp;
+
+	if (memcmp(mmp, mmp_cmp, sizeof(struct mmp_struct))) {
+		dump_mmp_msg(mmp_cmp, _("\n UNEXPECTED INCONSISTENCY: "
+			     "Unexpected MMP structure read from disk.\n"
+			     "It seems the filesystem is being modified while "
+			     "fsck is running.\n"));
+		retval = EXT2_ET_MMP_FSCK_ABORT;
+		goto mmp_error;
+	}
+
+	mmp->mmp_time = tv.tv_sec;
+	fs->mmp_last_written = tv.tv_sec;
+	mmp->mmp_seq = EXT2_MMP_SEQ_FSCK;
+	retval = ext2fs_write_mmp(fs, mmp_blk, buf);
+
+mmp_error:
+	if (buf_cmp)
+		ext2fs_free_mem(&buf_cmp);
+
+	return retval;
+}
Index: e2fsprogs-1.40.5/lib/ext2fs/bitops.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/bitops.h
+++ e2fsprogs-1.40.5/lib/ext2fs/bitops.h
@@ -329,6 +329,12 @@ _INLINE_ __u32 ext2fs_swab32(__u32 val)
 		((val<<8)&0xFF0000) | (val<<24));
 }
 
+_INLINE_ __u64 ext2fs_swab64(__u64 val)
+{
+	return (ext2fs_swab32(val >> 32) |
+		(((__u64)ext2fs_swab32(val & 0xFFFFFFFFUL)) << 32));
+}
+
 #endif /* !_EXT2_HAVE_ASM_SWAB */
 
 #if !defined(_EXT2_HAVE_ASM_FINDBIT_)
Index: e2fsprogs-1.40.5/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.40.5.orig/debugfs/set_fields.c
+++ e2fsprogs-1.40.5/debugfs/set_fields.c
@@ -129,7 +129,7 @@ static struct field_set_info super_field
 	{ "flags", &set_sb.s_flags, 4, parse_uint },
 	{ "raid_stride", &set_sb.s_raid_stride, 2, parse_uint },
 	{ "min_extra_isize", &set_sb.s_min_extra_isize, 4, parse_uint },
-	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
+	{ "mmp_update_interval", &set_sb.s_mmp_update_interval, 2, parse_uint },
 	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
 	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
 	{ 0, 0, 0, 0 }

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
