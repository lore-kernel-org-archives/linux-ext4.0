From: Kalpak Shah <Kalpak.Shah@Sun.COM>
Subject: [PATCH][12/15] e2fsprogs-mmp.patch
Date: Mon, 06 Oct 2008 16:01:28 +0530
Message-ID: <1223289088.4007.93.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_h/kTKViVmC34yRqyPUOvuQ)"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-2.sun.com ([192.18.19.7]:59623 "EHLO
	sineb-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbYJFKdV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2008 06:33:21 -0400
Received: from fe-apac-05.sun.com (fe-apac-05.sun.com [192.18.19.176] (may be forged))
	by sineb-mail-2.sun.com (8.13.6+Sun/8.12.9) with ESMTP id m96AXFAm027352
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2008 10:33:15 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 id <0K8B00701BXCIY00@mail-apac.sun.com>
 (original mail from Kalpak.Shah@Sun.COM) for linux-ext4@vger.kernel.org; Mon,
 06 Oct 2008 18:33:15 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_h/kTKViVmC34yRqyPUOvuQ)
Content-type: text/plain
Content-transfer-encoding: 7BIT

Add multi-mount protection support to libext2fs (INCOMPAT_MMP feature).

This allows mke2fs, e2fsck, and others to detect if the filesystem is
mounted on a remote node (on SAN disks) and avoid corrupting the
filesystem.  For e2fsprogs this only means that it check the MMP block
to see if the filesystem is in use, and mark the filesystem busy while
e2fsck is running on the system.

There is no requirement that e2fsck updates the MMP block in any regular
interval, but e2fsck does this occasionally to provide additional
information to the sysadmin in case of conflict.

Signed-off-by: Kalpak Shah <kalpak.shah@sun.com>
Signed-off-by: Andreas Dilger <adilger@sun.com>


--Boundary_(ID_h/kTKViVmC34yRqyPUOvuQ)
Content-type: text/x-patch; charset=utf-8; name=e2fsprogs-mmp.patch
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-mmp.patch

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

Index: e2fsprogs-1.41.1/lib/e2p/feature.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/e2p/feature.c
+++ e2fsprogs-1.41.1/lib/e2p/feature.c
@@ -72,7 +72,9 @@ static struct feature feature_list[] = {
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
-                        "flex_bg"},
+			"flex_bg"},
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
+			"mmp" },
 	{	0, 0, 0 },
 };
 
Index: e2fsprogs-1.41.1/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.41.1/lib/ext2fs/ext2_fs.h
@@ -579,7 +579,7 @@ struct ext2_super_block {
 	__u16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__u32	s_flags;		/* Miscellaneous flags */
 	__u16   s_raid_stride;		/* RAID stride */
-	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
+	__u16   s_mmp_update_interval;  /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
@@ -652,7 +652,8 @@ struct ext2_super_block {
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
+#define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
+				       EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
@@ -732,26 +733,34 @@ struct ext2_dir_entry_2 {
 /*
  * This structure will be used for multiple mount protection. It will be
  * written into the block number saved in the s_mmp_block field in the
- * superblock.
- */
-#define	EXT2_MMP_MAGIC    0x004D4D50 /* ASCII for MMP */
-#define	EXT2_MMP_CLEAN    0xFF4D4D50 /* Value of mmp_seq for clean unmount */
-#define	EXT2_MMP_FSCK_ON  0xE24D4D50 /* Value of mmp_seq when being fscked */
+ * superblock. Programs that check MMP should assume that if SEQ_FSCK
+ * (or any unknown code above SEQ_MAX) is present then it is NOT safe
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
Index: e2fsprogs-1.41.1/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.41.1/lib/ext2fs/ext2fs.h
@@ -172,6 +172,8 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_EXCLUSIVE		0x4000
 #define EXT2_FLAG_SOFTSUPP_FEATURES	0x8000
 #define EXT2_FLAG_NOFREE_ON_ERROR	0x10000
+#define EXT2_FLAG_SKIP_MMP		0x20000
+
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -186,6 +188,15 @@ typedef struct ext2_file *ext2_file_t;
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
@@ -231,6 +242,16 @@ struct struct_ext2_filsys {
 	io_channel			image_io;
 
 	/*
+	 * Buffers for Multiple mount protection(MMP) block.
+	 */
+	char *mmp_buf;
+	char *mmp_cmp;
+	/*
+	 * Time at which e2fsck last updated the MMP block.
+	 */
+	long mmp_last_written;
+
+	/*
 	 * More callback functions
 	 */
 	errcode_t (*get_alloc_block)(ext2_filsys fs, blk64_t goal,
@@ -528,14 +549,16 @@ typedef struct ext2_icount *ext2_icount_
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
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -1100,6 +1123,15 @@ errcode_t ext2fs_link(ext2_filsys fs, ex
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);
 
+/* mmp.c */
+errcode_t ext2fs_mmp_read(ext2_filsys fs, blk_t mmp_blk, char *buf);
+errcode_t ext2fs_mmp_write(ext2_filsys fs, blk_t mmp_blk, char *buf);
+errcode_t ext2fs_mmp_init(ext2_filsys fs);
+errcode_t ext2fs_mmp_start(ext2_filsys fs);
+errcode_t ext2fs_mmp_update(ext2_filsys fs);
+errcode_t ext2fs_mmp_stop(ext2_filsys fs);
+long int ext2fs_mmp_new_seq();
+
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
@@ -1134,6 +1166,7 @@ extern void ext2fs_swap_inode_full(ext2_
 				   int bufsize);
 extern void ext2fs_swap_inode(ext2_filsys fs,struct ext2_inode *t,
 			      struct ext2_inode *f, int hostorder);
+extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
Index: e2fsprogs-1.41.1/misc/tune2fs.c
===================================================================
--- e2fsprogs-1.41.1.orig/misc/tune2fs.c
+++ e2fsprogs-1.41.1/misc/tune2fs.c
@@ -64,7 +64,7 @@ char * device_name;
 char * new_label, *new_last_mounted, *new_UUID;
 char * io_options;
 static int c_flag, C_flag, e_flag, f_flag, g_flag, i_flag, l_flag, L_flag;
-static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag;
+static int m_flag, M_flag, r_flag, s_flag = -1, u_flag, U_flag, T_flag, p_flag;
 static int I_flag;
 static time_t last_check_time;
 static int print_label;
@@ -74,6 +74,7 @@ static double reserved_ratio;
 static unsigned long resgid, resuid;
 static unsigned short errors;
 static int open_flag;
+static unsigned int mmp_update_interval;
 static char *features_cmd;
 static char *mntopts_cmd;
 static int stride, stripe_width;
@@ -104,7 +105,7 @@ static void usage(void)
 		  "[-g group]\n"
 		  "\t[-i interval[d|m|w]] [-j] [-J journal_options] [-l]\n"
 		  "\t[-m reserved_blocks_percent] "
-		  "[-o [^]mount_options[,...]] \n"
+		  "[-o [^]mount_options[,...]] [-p mmp_update_interval]\n"
 		  "\t[-r reserved_blocks_count] [-u user] [-C mount_count] "
 		  "[-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
@@ -120,7 +121,8 @@ static __u32 ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -137,7 +139,8 @@ static __u32 clear_ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG |
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -149,7 +152,7 @@ static __u32 clear_ok_features[3] = {
 /*
  * Remove an external journal from the filesystem
  */
-static void remove_journal_device(ext2_filsys fs)
+static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
@@ -238,13 +241,15 @@ static void remove_journal_device(ext2_f
 no_valid_journal:
 	if (commit_remove_journal == 0) {
 		fputs(_("Journal NOT removed\n"), stderr);
-		exit(1);
+		return 1;
 	}
 	fs->super->s_journal_dev = 0;
 	uuid_clear(fs->super->s_journal_uuid);
 	ext2fs_mark_super_dirty(fs);
 	fputs(_("Journal removed\n"), stdout);
 	free(journal_path);
+
+	return 0;
 }
 
 /* Helper function for remove_journal_inode */
@@ -267,7 +272,7 @@ static int release_blocks_proc(ext2_fils
 /*
  * Remove the journal inode from the filesystem
  */
-static void remove_journal_inode(ext2_filsys fs)
+static errcode_t remove_journal_inode(ext2_filsys fs)
 {
 	struct ext2_inode	inode;
 	errcode_t		retval;
@@ -277,14 +282,14 @@ static void remove_journal_inode(ext2_fi
 	if (retval) {
 		com_err(program_name, retval,
 			_("while reading journal inode"));
-		exit(1);
+		return retval;
 	}
 	if (ino == EXT2_JOURNAL_INO) {
 		retval = ext2fs_read_bitmaps(fs);
 		if (retval) {
 			com_err(program_name, retval,
 				_("while reading bitmaps"));
-			exit(1);
+			return retval;
 		}
 		retval = ext2fs_block_iterate(fs, ino,
 					      BLOCK_FLAG_READ_ONLY, NULL,
@@ -292,7 +297,7 @@ static void remove_journal_inode(ext2_fi
 		if (retval) {
 			com_err(program_name, retval,
 				_("while clearing journal inode"));
-			exit(1);
+			return retval;
 		}
 		memset(&inode, 0, sizeof(inode));
 		ext2fs_mark_bb_dirty(fs);
@@ -303,31 +308,35 @@ static void remove_journal_inode(ext2_fi
 	if (retval) {
 		com_err(program_name, retval,
 			_("while writing journal inode"));
-		exit(1);
+		return retval;
 	}
 	fs->super->s_journal_inum = 0;
 	ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
  * Update the default mount options
  */
-static void update_mntopts(ext2_filsys fs, char *mntopts)
+static int update_mntopts(ext2_filsys fs, char *mntopts)
 {
 	struct ext2_super_block *sb= fs->super;
 
 	if (e2p_edit_mntopts(mntopts, &sb->s_default_mount_opts, ~0)) {
 		fprintf(stderr, _("Invalid mount option set: %s\n"),
 			mntopts);
-		exit(1);
+		return 1;
 	}
 	ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
  * Update the feature set as provided by the user.
  */
-static void update_feature_set(ext2_filsys fs, char *features)
+static int update_feature_set(ext2_filsys fs, char *features)
 {
 	struct ext2_super_block *sb= fs->super;
 	__u32		old_features[3];
@@ -362,7 +371,7 @@ static void update_feature_set(ext2_fils
 			fprintf(stderr, _("Setting filesystem feature '%s' "
 					  "not supported.\n"),
 				e2p_feature2string(type_err, mask_err));
-		exit(1);
+		return 1;
 	}
 
 	if (FEATURE_OFF(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
@@ -372,21 +381,95 @@ static void update_feature_set(ext2_fils
 				"cleared when the filesystem is\n"
 				"unmounted or mounted "
 				"read-only.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 		if (sb->s_feature_incompat &
 		    EXT3_FEATURE_INCOMPAT_RECOVER) {
 			fputs(_("The needs_recovery flag is set.  "
 				"Please run e2fsck before clearing\n"
 				"the has_journal flag.\n"), stderr);
-			exit(1);
+			return 1;
 		}
 		if (sb->s_journal_inum) {
-			remove_journal_inode(fs);
+			if (remove_journal_inode(fs))
+				return 1;
 		}
 		if (sb->s_journal_dev) {
-			remove_journal_device(fs);
+			if (remove_journal_device(fs))
+				return 1;
+		}
+	}
+	if (FEATURE_ON(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
+		int error;
+
+		if ((mount_flags & EXT2_MF_MOUNTED) ||
+		    (mount_flags & EXT2_MF_READONLY)) {
+			fputs(_("The multiple mount protection feature can't \n"
+				"be set if the filesystem is mounted or \n"
+				"read-only.\n"), stderr);
+			return 1;
+		}
+
+		error = ext2fs_mmp_init(fs);
+		if (error) {
+			fputs(_("\nError while enabling multiple mount "
+				"protection feature."), stderr);
+			return 1;
+		}
+
+		printf(_("Multiple mount protection has been enabled "
+			 "with update interval %ds.\n"),
+		       sb->s_mmp_update_interval);
+	}
+
+	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP)) {
+		blk_t mmp_block;
+		struct mmp_struct *mmp_s;
+		char *buf;
+		int error;
+
+		if (mount_flags & EXT2_MF_READONLY) {
+			fputs(_("The multiple mount protection feature cannot\n"
+				"be disabled if the filesystem is readonly.\n"),
+				stderr);
+			return 1;
+		}
+
+		error = ext2fs_read_bitmaps(fs);
+		if (error) {
+			fputs(_("Error while reading bitmaps\n"), stderr);
+			return 1;
+		}
+
+		mmp_block = sb->s_mmp_block;
+
+		error = ext2fs_get_mem(fs->blocksize, &buf);
+		if (error) {
+			fputs(_("Error allocating memory.\n"), stderr);
+			return 1;
+		}
+
+		mmp_s = (struct mmp_struct *) buf;
+		error = ext2fs_mmp_read(fs, mmp_block, buf);
+		if (error) {
+			if (error == EXT2_ET_MMP_MAGIC_INVALID)
+				printf(_("Magic number in MMP block does not "
+					 "match. expected: %x, actual: %x\n"),
+					 EXT2_MMP_MAGIC, mmp_s->mmp_magic);
+			else
+				com_err (program_name, error,
+					 _("while reading MMP block."));
+			goto mmp_error;
 		}
+
+		ext2fs_unmark_block_bitmap(fs->block_map, mmp_block);
+		ext2fs_mark_bb_dirty(fs);
+
+mmp_error:
+		sb->s_mmp_block = 0;
+		sb->s_mmp_update_interval = 0;
+		if (buf)
+			ext2fs_free_mem(&buf);
 	}
 
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
@@ -455,12 +538,14 @@ static void update_feature_set(ext2_fils
 	    (old_features[E2P_FEATURE_INCOMPAT] != sb->s_feature_incompat) ||
 	    (old_features[E2P_FEATURE_RO_INCOMPAT] != sb->s_feature_ro_compat))
 		ext2fs_mark_super_dirty(fs);
+
+	return 0;
 }
 
 /*
  * Add a journal to the filesystem.
  */
-static void add_journal(ext2_filsys fs)
+static int add_journal(ext2_filsys fs)
 {
 	unsigned long journal_blocks;
 	errcode_t	retval;
@@ -515,7 +600,7 @@ static void add_journal(ext2_filsys fs)
 			fprintf(stderr, "\n");
 			com_err(program_name, retval,
 				_("\n\twhile trying to create journal file"));
-			exit(1);
+			return retval;
 		} else
 			fputs(_("done\n"), stdout);
 		/*
@@ -526,12 +611,12 @@ static void add_journal(ext2_filsys fs)
 			fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	}
 	print_check_message(fs);
-	return;
+	return 0;
 
 err:
 	if (journal_device)
 		free(journal_device);
-	exit(1);
+	return 1;
 }
 
 
@@ -599,7 +684,7 @@ static void parse_tune2fs_options(int ar
 	open_flag = 0;
 
 	printf("tune2fs %s (%s)\n", E2FSPROGS_VERSION, E2FSPROGS_DATE);
-	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:r:s:u:C:E:I:J:L:M:O:T:U:")) != EOF)
+	while ((c = getopt(argc, argv, "c:e:fg:i:jlm:o:p:r:s:u:C:E:I:J:L:M:O:T:U:")) != EOF)
 		switch (c)
 		{
 			case 'c':
@@ -754,6 +839,26 @@ static void parse_tune2fs_options(int ar
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
@@ -856,7 +961,7 @@ void do_findfs(int argc, char **argv)
 	exit(0);
 }
 
-static void parse_extended_opts(ext2_filsys fs, const char *opts)
+static int parse_extended_opts(ext2_filsys fs, const char *opts)
 {
 	char	*buf, *token, *next, *p, *arg;
 	int	len, hash_alg;
@@ -867,7 +972,7 @@ static void parse_extended_opts(ext2_fil
 	if (!buf) {
 		fprintf(stderr,
 			_("Couldn't allocate memory to parse options!\n"));
-		exit(1);
+		return 1;
 	}
 	strcpy(buf, opts);
 	for (token = buf; token && *token; token = next) {
@@ -953,9 +1058,11 @@ static void parse_extended_opts(ext2_fil
 			"\ttest_fs\n"
 			"\t^test_fs\n"));
 		free(buf);
-		exit(1);
+		return 1;
 	}
 	free(buf);
+
+	return 0;
 }
 
 static int get_move_bitmap(ext2_filsys fs, int new_ino_blks_per_grp,
@@ -1421,6 +1528,8 @@ int main (int argc, char ** argv)
 	ext2_filsys fs;
 	struct ext2_super_block *sb;
 	io_manager io_ptr, io_ptr_orig = NULL;
+	int rc = 0;
+	int rc2;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -1448,6 +1557,9 @@ int main (int argc, char ** argv)
 		io_ptr = unix_io_manager;
 
 retry_open:
+	if ((open_flag & EXT2_FLAG_RW) == 0 || f_flag)
+		 open_flag |= EXT2_FLAG_SKIP_MMP;
+
 	retval = ext2fs_open2(device_name, io_options, open_flag,
 			      0, 0, io_ptr, &fs);
         if (retval) {
@@ -1455,7 +1567,8 @@ retry_open:
 			 device_name);
 		fprintf(stderr,
 			_("Couldn't find valid filesystem superblock.\n"));
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 
 	if (I_flag && !io_ptr_orig) {
@@ -1467,12 +1580,14 @@ retry_open:
 		if (new_inode_size == EXT2_INODE_SIZE(fs->super)) {
 			fprintf(stderr, _("The inode size is already %d\n"),
 				new_inode_size);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		if (new_inode_size < EXT2_INODE_SIZE(fs->super)) {
 			fprintf(stderr, _("Shrinking the inode size is "
 					  "not supported\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 
 		/*
@@ -1481,8 +1596,10 @@ retry_open:
 		 */
 		io_ptr_orig = io_ptr;
 		retval = tune2fs_setup_tdb(device_name, &io_ptr);
-		if (retval)
-			exit(1);
+		if (retval) {
+			rc = 1;
+			goto closefs;
+		}
 		if (io_ptr != io_ptr_orig) {
 			ext2fs_close(fs);
 			goto retry_open;
@@ -1497,7 +1614,7 @@ retry_open:
 		printf("%.*s\n", (int) sizeof(sb->s_volume_name),
 		       sb->s_volume_name);
 		remove_error_table(&et_ext2_error_table);
-		exit(0);
+		goto closefs;
 	}
 
 	retval = ext2fs_check_if_mounted(device_name, &mount_flags);
@@ -1505,7 +1622,8 @@ retry_open:
 		com_err("ext2fs_check_if_mount", retval,
 			_("while determining whether %s is mounted."),
 			device_name);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	/* Normally we only need to write out the superblock */
 	fs->flags |= EXT2_FLAG_SUPER_ONLY;
@@ -1543,12 +1661,19 @@ retry_open:
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
 				 _("reserved blocks count is too big (%lu)"),
 				 reserved_blocks);
-			exit (1);
+			rc = 1;
+			goto closefs;
 		}
 		sb->s_r_blocks_count = reserved_blocks;
 		ext2fs_mark_super_dirty(fs);
@@ -1572,7 +1697,8 @@ retry_open:
 	if (s_flag == 0) {
 		fputs(_("\nClearing the sparse superflag not supported.\n"),
 		      stderr);
-		exit(1);
+		rc = 1;
+		goto closefs;
 	}
 	if (T_flag) {
 		sb->s_lastcheck = last_check_time;
@@ -1600,14 +1726,26 @@ retry_open:
 			sizeof(sb->s_last_mounted));
 		ext2fs_mark_super_dirty(fs);
 	}
-	if (mntopts_cmd)
-		update_mntopts(fs, mntopts_cmd);
-	if (features_cmd)
-		update_feature_set(fs, features_cmd);
-	if (extended_cmd)
-		parse_extended_opts(fs, extended_cmd);
-	if (journal_size || journal_device)
-		add_journal(fs);
+	if (mntopts_cmd) {
+		rc = update_mntopts(fs, mntopts_cmd);
+		if (rc)
+			goto closefs;
+	}
+	if (features_cmd) {
+		rc = update_feature_set(fs, features_cmd);
+		if (rc)
+			goto closefs;
+	}
+	if (extended_cmd) {
+		rc = parse_extended_opts(fs, extended_cmd);
+		if (rc)
+			goto closefs;
+	}
+	if (journal_size || journal_device) {
+		rc = add_journal(fs);
+		if (rc);
+			goto closefs;
+	}
 
 	if (U_flag) {
 		if ((strcasecmp(new_UUID, "null") == 0) ||
@@ -1619,7 +1757,8 @@ retry_open:
 			uuid_generate(sb->s_uuid);
 		} else if (uuid_parse(new_UUID, sb->s_uuid)) {
 			com_err(program_name, 0, _("Invalid UUID format\n"));
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		ext2fs_mark_super_dirty(fs);
 	}
@@ -1628,7 +1767,8 @@ retry_open:
 			fputs(_("The inode size may only be "
 				"changed when the filesystem is "
 				"unmounted.\n"), stderr);
-			exit(1);
+			rc = 1;
+			goto closefs;
 		}
 		/*
 		 * We want to update group descriptor also
@@ -1658,5 +1798,11 @@ retry_open:
 		printf(_("Setting stripe width to %d\n"), stripe_width);
 	}
 	remove_error_table(&et_ext2_error_table);
+closefs:
+	if (rc) {
+		ext2fs_mmp_stop(fs);
+		exit(1);
+	}
+
 	return (ext2fs_close (fs) ? 1 : 0);
 }
Index: e2fsprogs-1.41.1/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass1.c
+++ e2fsprogs-1.41.1/e2fsck/pass1.c
@@ -814,7 +814,20 @@ void e2fsck_pass1(e2fsck_t ctx)
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
Index: e2fsprogs-1.41.1/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/unix.c
+++ e2fsprogs-1.41.1/e2fsck/unix.c
@@ -1124,6 +1124,24 @@ restart:
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
+				     _("Device active on another node"));
+		}
+		else if (retval == EXT2_ET_MMP_FSCK_ON) {
+			dump_mmp_msg((struct mmp_struct *)fs->mmp_buf,
+				     _("It seems that e2fsck is running on the "
+				     "filesystem.\nIf you are sure that e2fsck "
+				     "is not running then use "
+				     "'tune2fs -O ^mmp {device}'\n"
+				     "followed by 'tune2fs -O mmp {device}'"));
+		}
 		else
 			fix_problem(ctx, PR_0_SB_CORRUPT, &pctx);
 		fatal_error(ctx, 0);
Index: e2fsprogs-1.41.1/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.c
+++ e2fsprogs-1.41.1/e2fsck/problem.c
@@ -394,6 +394,11 @@ static struct e2fsck_problem problem_tab
 	  PROMPT_NONE, 0 },
 
 
+	/* Superblock has invalid MMP block. */
+	{ PR_0_MMP_INVALID_BLK,
+	  N_("@S has invalid MMP block.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1 errors */
 
 	/* Pass 1: Checking inodes, blocks, and sizes */
Index: e2fsprogs-1.41.1/e2fsck/problem.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/problem.h
+++ e2fsprogs-1.41.1/e2fsck/problem.h
@@ -225,6 +225,9 @@ struct problem_context {
 #define PR_0_CLEAR_EXTRA_ISIZE			0x00003C
 
 
+/* Superblock has invalid MMP block. */
+#define PR_0_MMP_INVALID_BLK			0x00003A
+
 /*
  * Pass 1 errors
  */
Index: e2fsprogs-1.41.1/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.41.1/lib/ext2fs/swapfs.c
@@ -70,6 +70,8 @@ void ext2fs_swap_super(struct ext2_super
 	sb->s_min_extra_isize = ext2fs_swab16(sb->s_min_extra_isize);
 	sb->s_want_extra_isize = ext2fs_swab16(sb->s_want_extra_isize);
 	sb->s_flags = ext2fs_swab32(sb->s_flags);
+	sb->s_mmp_update_interval = ext2fs_swab16(sb->s_mmp_update_interval);
+	sb->s_mmp_block = ext2fs_swab64(sb->s_mmp_block);
 	for (i=0; i < 4; i++)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
 	for (i=0; i < 17; i++)
@@ -271,4 +273,12 @@ void ext2fs_swap_inode(ext2_filsys fs, s
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
Index: e2fsprogs-1.41.1/lib/ext2fs/openfs.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/openfs.c
+++ e2fsprogs-1.41.1/lib/ext2fs/openfs.c
@@ -22,6 +22,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_ERRNO_H
+#include <errno.h>
+#endif
 
 #include "ext2_fs.h"
 
@@ -76,6 +79,7 @@ errcode_t ext2fs_open(const char *name, 
  * 	EXT2_FLAG_FORCE - Open the filesystem even if some of the
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
+ *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
@@ -325,6 +329,14 @@ errcode_t ext2fs_open2(const char *name,
 
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
+
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (flags & EXT2_FLAG_RW) && !(flags & EXT2_FLAG_SKIP_MMP)) {
+		retval = ext2fs_mmp_start(fs);
+		if (retval)
+			goto cleanup;
+	}
+
 	return 0;
 cleanup:
 	if (flags & EXT2_FLAG_NOFREE_ON_ERROR)
Index: e2fsprogs-1.41.1/lib/ext2fs/ext2_err.et.in
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/ext2_err.et.in
+++ e2fsprogs-1.41.1/lib/ext2fs/ext2_err.et.in
@@ -440,4 +440,22 @@ ec	EXT2_ET_EA_NAME_NOT_FOUND,
 ec	EXT2_ET_EA_NAME_EXISTS,
 	"Extended attribute name already exists"
 
+ec	EXT2_ET_MMP_MAGIC_INVALID,
+	"MMP: invalid magic number in header"
+
+ec	EXT2_ET_MMP_FAILED,
+	"MMP: device already active on another node"
+
+ec	EXT2_ET_MMP_FSCK_ON,
+	"MMP: appears fsck currently being run on the filesystem"
+
+ec	EXT2_ET_MMP_BAD_BLOCK,
+	"MMP: block number beyond filesystem range"
+
+ec	EXT2_ET_MMP_UNKNOWN_SEQ,
+	"MMP: seems to be undergoing an unknown operation"
+
+ec	EXT2_ET_MMP_CHANGE_ABORT,
+	"MMP: sequence changed - filesystem may be in use elsewhere"
+
 	end
Index: e2fsprogs-1.41.1/lib/ext2fs/closefs.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/closefs.c
+++ e2fsprogs-1.41.1/lib/ext2fs/closefs.c
@@ -458,11 +458,20 @@ errcode_t ext2fs_close(ext2_filsys fs)
 		if (retval)
 			return retval;
 	}
+
 	if (fs->write_bitmaps) {
 		retval = fs->write_bitmaps(fs);
 		if (retval)
 			return retval;
 	}
+
+	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	    (fs->flags & EXT2_FLAG_RW) && !(fs->flags & EXT2_FLAG_SKIP_MMP)) {
+		retval = ext2fs_mmp_stop(fs);
+		if (retval)
+			return retval;
+	}
+
 	ext2fs_free(fs);
 	return 0;
 }
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.c
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.c
@@ -201,6 +201,7 @@ int e2fsck_run(e2fsck_t ctx)
 {
 	int	i;
 	pass_t	e2fsck_pass;
+	int error;
 
 #ifdef HAVE_SETJMP_H
 	if (setjmp(ctx->abort_loc)) {
@@ -213,6 +214,9 @@ int e2fsck_run(e2fsck_t ctx)
 	for (i=0; (e2fsck_pass = e2fsck_passes[i]); i++) {
 		if (ctx->flags & E2F_FLAG_RUN_RETURN)
 			break;
+		error = e2fsck_mmp_update(ctx->fs);
+		if (error)
+			fatal_error(ctx, 0);
 		e2fsck_pass(ctx);
 		if (ctx->progress)
 			(void) (ctx->progress)(ctx, 0, 0, 0);
Index: e2fsprogs-1.41.1/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.41.1/e2fsck/e2fsck.h
@@ -528,6 +528,8 @@ extern void mtrace_print(char *mesg);
 extern blk_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
 			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
+errcode_t e2fsck_mmp_update(ext2_filsys fs);
 
 /* unix.c */
 extern void e2fsck_clear_progbar(e2fsck_t ctx);
Index: e2fsprogs-1.41.1/lib/ext2fs/Makefile.in
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-1.41.1/lib/ext2fs/Makefile.in
@@ -61,6 +61,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	lookup.o \
 	mkdir.o \
 	mkjournal.o \
+	mmp.o \
 	native.o \
 	newdir.o \
 	openfs.o \
@@ -124,6 +125,7 @@ SRCS= ext2_err.c \
 	$(srcdir)/lookup.c \
 	$(srcdir)/mkdir.c \
 	$(srcdir)/mkjournal.c \
+	$(srcdir)/mmp.c	\
 	$(srcdir)/namei.c \
 	$(srcdir)/native.c \
 	$(srcdir)/newdir.c \
@@ -622,6 +624,8 @@ mkjournal.o: $(srcdir)/mkjournal.c $(src
  $(top_builddir)/lib/ext2fs/ext2_err.h $(srcdir)/ext2_ext_attr.h \
  $(srcdir)/bitops.h $(srcdir)/jfs_user.h $(srcdir)/kernel-jbd.h \
  $(srcdir)/jfs_compat.h $(srcdir)/kernel-list.h
+mmp.o: $(srcdir)/ext2_fs.h $(srcdir)/ext2fs.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h
 namei.o: $(srcdir)/namei.c $(srcdir)/ext2_fs.h \
  $(top_builddir)/lib/ext2fs/ext2_types.h $(srcdir)/ext2fs.h \
  $(srcdir)/ext2_fs.h $(srcdir)/ext3_extents.h $(top_srcdir)/lib/et/com_err.h \
Index: e2fsprogs-1.41.1/lib/ext2fs/mmp.c
===================================================================
--- /dev/null
+++ e2fsprogs-1.41.1/lib/ext2fs/mmp.c
@@ -0,0 +1,335 @@
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
+errcode_t ext2fs_mmp_read(ext2_filsys fs, blk_t mmp_blk, char *buf)
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
+errcode_t ext2fs_mmp_write(ext2_filsys fs, blk_t mmp_blk, char *buf)
+{
+	struct mmp_struct *mmp_s = (struct mmp_struct *) buf;
+	struct timeval tv;
+	int retval;
+
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
+errcode_t ext2fs_mmp_init(ext2_filsys fs)
+{
+	struct ext2_super_block *sb = fs->super;
+	struct mmp_struct *mmp_s = NULL;
+	blk_t mmp_block;
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
+	if (fs->mmp_buf == NULL) {
+		error = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (error)
+			goto out;
+	}
+
+	mmp_s = (struct mmp_struct *)fs->mmp_buf;
+	memset(mmp_s, 0, sizeof(struct mmp_struct));
+
+	mmp_s->mmp_magic = EXT2_MMP_MAGIC;
+	mmp_s->mmp_seq = EXT2_MMP_SEQ_CLEAN;
+	mmp_s->mmp_time = 0;
+#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
+#else
+	mmp_s->mmp_nodename[0] = '\0';
+#endif
+	strncpy(mmp_s->mmp_bdevname, fs->device_name,
+		sizeof(mmp_s->mmp_bdevname));
+
+	mmp_s->mmp_check_interval = EXT2_MMP_MIN_CHECK_INTERVAL;
+
+	error = ext2fs_mmp_write(fs, mmp_block, fs->mmp_buf);
+	if (error) {
+		ext2fs_free_mem(&fs->mmp_buf);
+		fs->mmp_buf = NULL;
+		goto out;
+	}
+
+	sb->s_mmp_update_interval = EXT2_MMP_UPDATE_INTERVAL;
+
+out:
+	return error;
+}
+
+/*
+ * Make sure that the fs is not mounted or being fsck'ed while opening the fs.
+ */
+errcode_t ext2fs_mmp_start(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	struct mmp_struct *mmp_s;
+	unsigned seq;
+	unsigned int mmp_check_interval;
+	errcode_t retval = 0;
+
+	if (fs->mmp_buf == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto mmp_error;
+	}
+
+	retval = ext2fs_mmp_read(fs, mmp_blk, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	mmp_s = (struct mmp_struct *)fs->mmp_buf;
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
+	retval = ext2fs_mmp_read(fs, mmp_blk, fs->mmp_buf);
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
+#if _BSD_SOURCE || _XOPEN_SOURCE >= 500
+	gethostname(mmp_s->mmp_nodename, sizeof(mmp_s->mmp_nodename));
+#else
+	strcpy(mmp_s->mmp_nodename, "unknown host");
+#endif
+	strncpy(mmp_s->mmp_bdevname, fs->device_name,
+		sizeof(mmp_s->mmp_bdevname));
+
+	retval = ext2fs_mmp_write(fs, mmp_blk, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	sleep(2 * mmp_check_interval + 1);
+
+	retval = ext2fs_mmp_read(fs, mmp_blk, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	if (seq != mmp_s->mmp_seq) {
+		retval = EXT2_ET_MMP_FAILED;
+		goto mmp_error;
+	}
+
+	mmp_s->mmp_seq = EXT2_MMP_SEQ_FSCK;
+	retval = ext2fs_mmp_write(fs, mmp_blk, fs->mmp_buf);
+	if (retval)
+		goto mmp_error;
+
+	return 0;
+
+mmp_error:
+	return retval;
+}
+
+/*
+ * Clear the MMP usage in the filesystem.  If this function returns an
+ * error EXT2_ET_MMP_CHANGE_ABORT it means the filesystem was modified
+ * by some other process while in use, and changes should be dropped, or
+ * risk filesystem corruption.
+ */
+errcode_t ext2fs_mmp_stop(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
+	struct mmp_struct *mmp, *mmp_cmp;
+	errcode_t retval;
+
+	if (fs->mmp_cmp == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_cmp);
+		if (retval)
+			goto mmp_error;
+	}
+
+	retval = ext2fs_mmp_read(fs, mmp_blk, fs->mmp_cmp);
+	if (retval)
+		goto mmp_error;
+
+	/*
+	 * This is important since we may come here just after when MMP feature
+	 * is set and fs->mmp_buf is NULL
+	 */
+	if (fs->mmp_buf == NULL)
+		goto check_skipped;
+
+	/*
+	 * Make sure that the MMP block is not changed.
+	 */
+	mmp = (struct mmp_struct *)fs->mmp_buf;
+	mmp_cmp = (struct mmp_struct *)fs->mmp_cmp;
+	if (memcmp(mmp, mmp_cmp, sizeof(struct mmp_struct)))
+		return EXT2_ET_MMP_CHANGE_ABORT;
+
+check_skipped:
+	mmp_cmp->mmp_seq = EXT2_MMP_SEQ_CLEAN;
+	retval = ext2fs_mmp_write(fs, mmp_blk, fs->mmp_cmp);
+
+mmp_error:
+	if (fs->mmp_buf) {
+		ext2fs_free_mem(&fs->mmp_buf);
+		fs->mmp_buf = NULL;
+	}
+	if (fs->mmp_cmp) {
+		ext2fs_free_mem(&fs->mmp_cmp);
+		fs->mmp_cmp = NULL;
+	}
+
+	return retval;
+}
+
+#define EXT2_MIN_MMP_UPDATE_INTERVAL 60
+
+/*
+ * Update the on-disk mmp buffer, after checking that it hasn't been changed.
+ */
+errcode_t ext2fs_mmp_update(ext2_filsys fs)
+{
+	blk_t mmp_blk = fs->super->s_mmp_block;
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
+	if (fs->mmp_cmp == NULL) {
+		retval = ext2fs_get_mem(fs->blocksize, &fs->mmp_cmp);
+		if (retval)
+			goto mmp_error;
+	}
+
+	retval = ext2fs_mmp_read(fs, mmp_blk, fs->mmp_cmp);
+	if (retval)
+		goto mmp_error;
+
+	mmp = (struct mmp_struct *)fs->mmp_buf;
+	mmp_cmp = (struct mmp_struct *)fs->mmp_cmp;
+
+	if (memcmp(mmp, mmp_cmp, sizeof(struct mmp_struct)))
+		return EXT2_ET_MMP_CHANGE_ABORT;
+
+	mmp->mmp_time = tv.tv_sec;
+	fs->mmp_last_written = tv.tv_sec;
+	mmp->mmp_seq = EXT2_MMP_SEQ_FSCK;
+	retval = ext2fs_mmp_write(fs, mmp_blk, fs->mmp_buf);
+
+mmp_error:
+	return retval;
+}
Index: e2fsprogs-1.41.1/e2fsck/pass1b.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/pass1b.c
+++ e2fsprogs-1.41.1/e2fsck/pass1b.c
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
Index: e2fsprogs-1.41.1/misc/tune2fs.8.in
===================================================================
--- e2fsprogs-1.41.1.orig/misc/tune2fs.8.in
+++ e2fsprogs-1.41.1/misc/tune2fs.8.in
@@ -439,6 +439,11 @@ Setting the filesystem feature is equiva
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
@@ -481,6 +486,9 @@ and
 .BR flex_bg
 features are only supported by the ext4 filesystem.
 .TP
+.BI \-p " mmp_check_interval"
+Set the desired MMP check interval in seconds. It is 5 seconds by default.
+.TP
 .BI \-r " reserved-blocks-count"
 Set the number of reserved filesystem blocks.
 .TP
Index: e2fsprogs-1.41.1/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.41.1.orig/misc/mke2fs.c
+++ e2fsprogs-1.41.1/misc/mke2fs.c
@@ -840,7 +840,8 @@ static __u32 ok_features[3] = {
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT4_FEATURE_INCOMPAT_FLEX_BG|
+		EXT4_FEATURE_INCOMPAT_MMP,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2068,8 +2069,20 @@ int main (int argc, char *argv[])
 	}
 no_journal:
 
-	if (!super_only)
+	if (!super_only) {
 		ext2fs_set_gdt_csum(fs);
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+			retval = ext2fs_mmp_init(fs);
+			if (retval) {
+				fprintf(stderr, _("\nError while enabling "
+					"multiple mount protection feature."));
+				exit(1);
+			}
+			printf(_("Multiple mount protection has been enabled "
+				 "with update interval %d seconds.\n"),
+				 fs->super->s_mmp_update_interval);
+		}
+	}
 	if (!quiet)
 		printf(_("Writing superblocks and "
 		       "filesystem accounting information: "));
Index: e2fsprogs-1.41.1/e2fsck/util.c
===================================================================
--- e2fsprogs-1.41.1.orig/e2fsck/util.c
+++ e2fsprogs-1.41.1/e2fsck/util.c
@@ -593,3 +593,25 @@ errcode_t e2fsck_zero_blocks(ext2_filsys
 	}
 	return 0;
 }
+
+void dump_mmp_msg(struct mmp_struct *mmp, const char *msg)
+{
+	printf("MMP check failed: %s\n", msg);
+	printf("MMP failure info: last update time: %llu node: %s device: %s\n",
+	       (long long)mmp->mmp_time, mmp->mmp_nodename, mmp->mmp_bdevname);
+}
+
+errcode_t e2fsck_mmp_update(ext2_filsys fs)
+{
+	errcode_t retval;
+
+	retval = ext2fs_mmp_update(fs);
+	if (retval == EXT2_ET_MMP_CHANGE_ABORT)
+		dump_mmp_msg((struct mmp_struct *)fs->mmp_cmp,
+			     _("\n UNEXPECTED INCONSISTENCY: "
+			     "Unexpected MMP structure read from disk.\n"
+			     "It seems the filesystem is being modified while "
+			     "fsck is running.\n"));
+
+	return retval;
+}
Index: e2fsprogs-1.41.1/lib/ext2fs/bitops.h
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/bitops.h
+++ e2fsprogs-1.41.1/lib/ext2fs/bitops.h
@@ -357,6 +357,12 @@ _INLINE_ __u32 ext2fs_swab32(__u32 val)
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
Index: e2fsprogs-1.41.1/debugfs/set_fields.c
===================================================================
--- e2fsprogs-1.41.1.orig/debugfs/set_fields.c
+++ e2fsprogs-1.41.1/debugfs/set_fields.c
@@ -129,7 +129,7 @@ static struct field_set_info super_field
 	{ "flags", &set_sb.s_flags, 4, parse_uint },
 	{ "raid_stride", &set_sb.s_raid_stride, 2, parse_uint },
 	{ "min_extra_isize", &set_sb.s_min_extra_isize, 4, parse_uint },
-	{ "mmp_interval", &set_sb.s_mmp_interval, 2, parse_uint },
+	{ "mmp_update_interval", &set_sb.s_mmp_update_interval, 2, parse_uint },
 	{ "mmp_block", &set_sb.s_mmp_block, 8, parse_uint },
 	{ "raid_stripe_width", &set_sb.s_raid_stripe_width, 4, parse_uint },
 	{ "log_groups_per_flex", &set_sb.s_log_groups_per_flex, 1, parse_uint },
Index: e2fsprogs-1.41.1/lib/e2p/ls.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/e2p/ls.c
+++ e2fsprogs-1.41.1/lib/e2p/ls.c
@@ -310,6 +310,12 @@ void list_super2(struct ext2_super_block
 			fprintf(f, "type %u\n", sb->s_jnl_backup_type);
 		}
 	}
+	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+		fprintf(f, "MMP block number:         %llu\n",
+			(long long)sb->s_mmp_block);
+		fprintf(f, "MMP update interval:      %u\n",
+			sb->s_mmp_update_interval);
+	}
 }
 
 void list_super (struct ext2_super_block * s)
Index: e2fsprogs-1.41.1/lib/ext2fs/freefs.c
===================================================================
--- e2fsprogs-1.41.1.orig/lib/ext2fs/freefs.c
+++ e2fsprogs-1.41.1/lib/ext2fs/freefs.c
@@ -53,6 +53,11 @@ void ext2fs_free(ext2_filsys fs)
 	if (fs->icache)
 		ext2fs_free_inode_cache(fs->icache);
 
+	if (fs->mmp_buf)
+		ext2fs_free_mem(&fs->mmp_buf);
+	if (fs->mmp_cmp)
+		ext2fs_free_mem(&fs->mmp_cmp);
+
 	fs->magic = 0;
 
 	ext2fs_free_mem(&fs);

--Boundary_(ID_h/kTKViVmC34yRqyPUOvuQ)--
