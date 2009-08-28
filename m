From: pravin shelar <Pravin.Shelar@Sun.COM>
Subject: patch[3/3] FEATURE DIRDATA - e2fs package changes for dirdata feature.
Date: Fri, 28 Aug 2009 11:22:06 +0530
Message-ID: <4A977086.1050907@sun.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_HqXn7NAkbD91meA0TCLLpg)"
Cc: Andreas Dilger <adilger@Sun.COM>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sineb-mail-1.sun.com ([192.18.19.6]:63120 "EHLO
	sineb-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZH1GBR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Aug 2009 02:01:17 -0400
Received: from fe-apac-06.sun.com (fe-apac-06.sun.com [192.18.19.177] (may be forged))
	by sineb-mail-1.sun.com (8.13.6+Sun/8.12.9) with ESMTP id n7S5onFL027629
	for <linux-ext4@vger.kernel.org>; Fri, 28 Aug 2009 05:50:49 GMT
Received: from conversion-daemon.mail-apac.sun.com by mail-apac.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KP200A00O7LSO00@mail-apac.sun.com> for linux-ext4@vger.kernel.org; Fri,
 28 Aug 2009 13:50:49 +0800 (SGT)
Received: from [192.168.1.2] ([unknown] [59.95.7.244])
 by mail-apac.sun.com (Sun Java(tm) System Messaging Server 7u2-7.04 64bit
 (built Jul  2 2009)) with ESMTPSA id <0KP200FQLO8O0SD0@mail-apac.sun.com> for
 linux-ext4@vger.kernel.org; Fri, 28 Aug 2009 13:50:49 +0800 (SGT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.

--Boundary_(ID_HqXn7NAkbD91meA0TCLLpg)
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Content-transfer-encoding: 7BIT

changes to e2fs to handle extended dirent data feature.


Thanks,
Pravin.


--Boundary_(ID_HqXn7NAkbD91meA0TCLLpg)
Content-type: text/x-diff; name=e2fsck-fid_in_dirent-f8.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=e2fsck-fid_in_dirent-f8.patch

Index: b/lib/blkid/probe.h
===================================================================
--- a/lib/blkid/probe.h
+++ b/lib/blkid/probe.h
@@ -119,6 +119,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
+#define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
Index: b/lib/e2p/feature.c
===================================================================
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -75,6 +75,8 @@ static struct feature feature_list[] = {
 			"flex_bg"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
 			"mmp" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_DIRDATA,
+			"dirdata" },
 	{	0, 0, 0 },
 };
 
Index: b/lib/ext2fs/ext2_fs.h
===================================================================
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -650,17 +650,30 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
-
+#define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
-#define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
-				       EXT4_FEATURE_INCOMPAT_MMP)
+#define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE| \
+					EXT4_FEATURE_INCOMPAT_MMP| \
+					EXT4_FEATURE_INCOMPAT_DIRDATA)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
+#define EXT2_FT_MASK			0x0f
+
+#define EXT4_DIRENT_LUFID_SIZE		17
+#define EXT4_DIRENT_LUFID		0x10
+#define EXT4_DIR_PAD			4
+#define EXT4_DIR_ROUND			(EXT4_DIR_PAD - 1)
+#define __EXT4_DIR_REC_LEN(len) 	(((len) + 8 + EXT4_DIR_ROUND) & \
+					~EXT4_DIR_ROUND)
+
+#define EXT4_DIR_REC_LEN(de)		(__EXT4_DIR_REC_LEN(de->name_len +\
+					 ext4_get_dirent_size(de)))
+
 /*
  * Default values for user and/or group using reserved blocks
  */
@@ -764,4 +777,50 @@ struct mmp_struct {
  */
 #define EXT2_MMP_MIN_CHECK_INTERVAL     5
 
+static inline int ext4_get_dirent_lu_date_size(struct ext2_dir_entry_2 *de)
+{
+	char *len = de->name + de->name_len + 1 /* NUL terminator */;
+	int dlen = 0;
+	__u8 extra_data_flags = (de->file_type & ~EXT2_FT_MASK) >> 4;
+	__u8 lu_data_flag = (de->file_type & EXT4_DIRENT_LUFID) >> 4;
+
+	if (lu_data_flag) {
+		while (extra_data_flags) {
+			if (extra_data_flags & 1) {
+				if (lu_data_flag & 1) {
+					dlen = *len;
+					break;
+				}
+				len += *len;
+			}
+			extra_data_flags >>= 1;
+			lu_data_flag >>=1;
+		}
+	}
+	return dlen;
+}
+
+/*
+ * Compute the total directory entry data length.
+ * This includes the filename and an implicit NUL terminator (always present),
+ * and optional extensions.  Each extension has a bit set in the high 4 bits of
+ * de->file_type, and the extension length is the first byte in each entry.
+ */
+
+static inline int ext4_get_dirent_size(struct ext2_dir_entry_2 *de)
+{
+	char *len = de->name + de->name_len + 1 /* NUL terminator */;
+	int dlen = 0;
+	__u8 extra_data_flags = (de->file_type & ~EXT2_FT_MASK) >> 4;
+
+	while (extra_data_flags) {
+		if (extra_data_flags & 1) {
+			dlen += *len + (dlen == 0);
+			len += *len;
+		}
+		extra_data_flags >>= 1;
+	}
+	return dlen;
+}
+
 #endif	/* _LINUX_EXT2_FS_H */
Index: b/lib/ext2fs/ext2fs.h
===================================================================
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -553,7 +553,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP| \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -561,7 +562,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP| \
+					 EXT4_FEATURE_INCOMPAT_DIRDATA)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -1422,6 +1424,24 @@ _INLINE_ unsigned int ext2fs_div_ceil(un
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+_INLINE_ struct ext2_dx_root_info* get_ext2_dx_root_info(ext2_filsys fs, char *buf)
+{
+        struct ext2_dir_entry_2 * de = (struct ext2_dir_entry_2 *) buf;
+
+        if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA))
+                return (struct ext2_dx_root_info *)(buf +
+			 __EXT4_DIR_REC_LEN(1) +__EXT4_DIR_REC_LEN(2));
+
+        /* get dotdot first */
+        de = (struct ext2_dir_entry_2 *)((char *)de + de->rec_len);
+
+        /* dx root info is after dotdot entry */
+        de = (struct ext2_dir_entry_2 *)((char *)de + EXT4_DIR_REC_LEN(de));
+
+        return (struct ext2_dx_root_info*) de;
+}
+
 #undef _INLINE_
 #endif
 
Index: b/misc/mke2fs.c
===================================================================
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -842,7 +842,8 @@ static __u32 ok_features[3] = {
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
 		EXT4_FEATURE_INCOMPAT_FLEX_BG|
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP|
+		EXT4_FEATURE_INCOMPAT_DIRDATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
Index: b/misc/tune2fs.c
===================================================================
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -125,7 +125,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP|
+		EXT4_FEATURE_INCOMPAT_DIRDATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -143,7 +144,8 @@ static __u32 clear_ok_features[3] = {
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP|
+		EXT4_FEATURE_INCOMPAT_DIRDATA,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
Index: b/e2fsck/pass1.c
===================================================================
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1845,7 +1845,7 @@ static int handle_htree(e2fsck_t ctx, st
 	}
 
 	/* XXX should check that beginning matches a directory */
-	root = (struct ext2_dx_root_info *) (block_buf + 24);
+	root = get_ext2_dx_root_info(fs, block_buf);
 
 	if ((root->reserved_zero || root->info_length < 8) &&
 	    fix_problem(ctx, PR_1_HTREE_BADROOT, pctx))
Index: b/e2fsck/pass2.c
===================================================================
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -336,13 +336,49 @@ static EXT2_QSORT_TYPE special_dir_block
 	return (int) (db_a->blockcnt - db_b->blockcnt);
 }
 
-
+/*
+ * check for dirent data in ext3 dirent.
+ * return 0 if dirent data is ok.
+ * return 1 if dirent data does not exist.
+ * return 2 if dirent was modified due to error.
+ */
+int e2fsck_check_dirent_data(e2fsck_t ctx, struct ext2_dir_entry_2 *de,
+			     unsigned int offset, struct problem_context *pctx)
+{
+	if (!(ctx->fs->super->s_feature_incompat &
+			EXT4_FEATURE_INCOMPAT_DIRDATA)) {
+		if (de->file_type & ~EXT2_FT_MASK) {
+			/* clear dirent extra data flags. */
+			if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+				de->file_type &= EXT2_FT_MASK;
+				return 2;
+			}
+		}
+		return 1;
+	}
+	if (de->file_type & ~EXT2_FT_MASK) {
+		if (de->rec_len == EXT4_DIR_REC_LEN(de) ||
+		   (de->rec_len + offset == EXT2_BLOCK_SIZE(ctx->fs->super))) {
+			if (ext4_get_dirent_lu_date_size(de) ==
+			    EXT4_DIRENT_LUFID_SIZE)
+				return 0;
+		}
+		/* just clear dirent data flags for now, we should fix FID data
+		 * in lustre specific pass.
+		 */
+		if (fix_problem(ctx, PR_2_CLEAR_DIRDATA, pctx)) {
+			de->file_type &= EXT2_FT_MASK;
+			return 2;
+		}
+	}
+	return 1;
+}
 /*
  * Make sure the first entry in the directory is '.', and that the
  * directory entry is sane.
  */
 static int check_dot(e2fsck_t ctx,
-		     struct ext2_dir_entry *dirent,
+		     struct ext2_dir_entry *dirent, unsigned int offset,
 		     ext2_ino_t ino, struct problem_context *pctx)
 {
 	struct ext2_dir_entry *nextdir;
@@ -350,6 +386,7 @@ static int check_dot(e2fsck_t ctx,
 	int	created = 0;
 	int	rec_len, new_len;
 	int	problem = 0;
+	int     dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
@@ -359,11 +396,15 @@ static int check_dot(e2fsck_t ctx,
 	else if (dirent->name[1] != '\0')
 		problem = PR_2_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx,
+				(struct ext2_dir_entry_2 *)dirent,
+				offset, pctx);
+
 	rec_len = (dirent->rec_len || ctx->fs->blocksize < 65536) ?
 		dirent->rec_len : 65536;
 	if (problem) {
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (rec_len < 12 && dir_data_error)
 				rec_len = dirent->rec_len = 12;
 			dirent->inode = ino;
 			dirent->name_len = 1;
@@ -379,7 +420,7 @@ static int check_dot(e2fsck_t ctx,
 			status = 1;
 		}
 	}
-	if (rec_len > 12) {
+	if (rec_len > 12 && dir_data_error) {
 		new_len = rec_len - 12;
 		if (new_len > 12) {
 			if (created ||
@@ -403,10 +444,11 @@ static int check_dot(e2fsck_t ctx,
  * here; this gets done in pass 3.
  */
 static int check_dotdot(e2fsck_t ctx,
-			struct ext2_dir_entry *dirent,
+			struct ext2_dir_entry *dirent, unsigned int offset,
 			ext2_ino_t ino, struct problem_context *pctx)
 {
 	int	rec_len, problem = 0;
+	int     dir_data_error;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT_DOT;
@@ -417,11 +459,14 @@ static int check_dotdot(e2fsck_t ctx,
 	else if (dirent->name[2] != '\0')
 		problem = PR_2_DOT_DOT_NULL_TERM;
 
+	dir_data_error = e2fsck_check_dirent_data(ctx,
+				 (struct ext2_dir_entry_2 *)dirent,
+				 offset, pctx);
 	rec_len = (dirent->rec_len || ctx->fs->blocksize < 65536) ?
 		dirent->rec_len : 65536;
 	if (problem) {
 		if (fix_problem(ctx, problem, pctx)) {
-			if (rec_len < 12)
+			if (dir_data_error && rec_len < 12)
 				dirent->rec_len = 12;
 			/*
 			 * Note: we don't have the parent inode just
@@ -483,6 +528,12 @@ static _INLINE_ int check_filetype(e2fsc
 	int	should_be = EXT2_FT_UNKNOWN;
 	__u16	result;
 	struct ext2_inode	inode;
+	__u8    dirdata = 0;
+
+	if (ctx->fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA) {
+		dirdata = filetype & ~EXT2_FT_MASK;
+		filetype = filetype & EXT2_FT_MASK;
+	}
 
 	if (!(ctx->fs->super->s_feature_incompat &
 	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
@@ -517,7 +568,7 @@ static _INLINE_ int check_filetype(e2fsc
 			pctx) == 0)
 		return 0;
 
-	dirent->name_len = (dirent->name_len & 0xFF) | should_be << 8;
+	dirent->name_len = ((dirent->name_len & 0xFF) | (dirdata | should_be) << 8);
 	return 1;
 }
 
@@ -539,7 +590,7 @@ static void parse_int_node(ext2_filsys f
 	ext2_dirhash_t	hash = 0, prev_hash;
 
 	if (db->blockcnt == 0) {
-		root = (struct ext2_dx_root_info *) (block_buf + 24);
+		root = get_ext2_dx_root_info(fs, block_buf);
 
 #ifdef DX_DEBUG
 		printf("Root node dump:\n");
@@ -550,7 +601,7 @@ static void parse_int_node(ext2_filsys f
 		printf("\t Flags: %d\n", root->unused_flags);
 #endif
 
-		ent = (struct ext2_dx_entry *) (block_buf + 24 + root->info_length);
+		ent = (struct ext2_dx_entry *) ((char *) root + root->info_length);
 	} else {
 		ent = (struct ext2_dx_entry *) (block_buf+8);
 	}
@@ -809,7 +860,7 @@ static int check_dir_block(ext2_filsys f
 			dirent->rec_len : 65536;
 		limit = (struct ext2_dx_countlimit *) (buf+8);
 		if (db->blockcnt == 0) {
-			root = (struct ext2_dx_root_info *) (buf + 24);
+			root = get_ext2_dx_root_info(fs, buf);
 			dx_db->type = DX_DIRBLOCK_ROOT;
 			dx_db->flags |= DX_FLAG_FIRST | DX_FLAG_LAST;
 			if ((root->reserved_zero ||
@@ -867,10 +918,10 @@ out_htree:
 		}
 
 		if (dot_state == 0) {
-			if (check_dot(ctx, dirent, ino, &cd->pctx))
+			if (check_dot(ctx, dirent, offset, ino, &cd->pctx))
 				dir_modified++;
 		} else if (dot_state == 1) {
-			ret = check_dotdot(ctx, dirent, ino, &cd->pctx);
+			ret = check_dotdot(ctx, dirent, offset, ino, &cd->pctx);
 			if (ret < 0)
 				goto abort_free_dict;
 			if (ret)
@@ -886,6 +937,11 @@ out_htree:
 		if (!dirent->inode)
 			goto next;
 
+		ret = e2fsck_check_dirent_data(ctx, (struct ext2_dir_entry_2 *)dirent,
+					 offset, &cd->pctx);
+		if (ret == 2)
+			dir_modified++;
+
 		/*
 		 * Make sure the inode listed is a legal one.
 		 */
Index: b/e2fsck/pass3.c
===================================================================
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -606,6 +606,7 @@ static int fix_dotdot_proc(struct ext2_d
 	struct fix_dotdot_struct *fp = (struct fix_dotdot_struct *) priv_data;
 	errcode_t	retval;
 	struct problem_context pctx;
+	__u16 dirdata = 0;
 
 	if ((dirent->name_len & 0xFF) != 2)
 		return 0;
@@ -625,6 +626,9 @@ static int fix_dotdot_proc(struct ext2_d
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
+
+	dirdata  = dirent->name_len & (~EXT2_FT_MASK << 8);
+
 	if (fp->ctx->fs->super->s_feature_incompat &
 	    EXT2_FEATURE_INCOMPAT_FILETYPE)
 		dirent->name_len = (dirent->name_len & 0xFF) |
@@ -632,6 +636,9 @@ static int fix_dotdot_proc(struct ext2_d
 	else
 		dirent->name_len = dirent->name_len & 0xFF;
 
+	if (fp->ctx->fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_DIRDATA)
+		dirent->name_len |= dirdata;
+
 	fp->done++;
 	return DIRENT_ABORT | DIRENT_CHANGED;
 }
Index: b/e2fsck/problem.c
===================================================================
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1374,6 +1374,11 @@ static struct e2fsck_problem problem_tab
 	  N_("@i %i is badly corrupt (badness value = %N).  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
+        /* Directory dirdata flag set */
+        { PR_2_CLEAR_DIRDATA,
+          N_("@E dirdata length set incorrectly.\n"),
+          PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 3 errors */
 
 	/* Pass 3: Checking directory connectivity */
Index: b/e2fsck/problem.h
===================================================================
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -825,6 +825,9 @@ struct problem_context {
 /* Inode completely corrupt */
 #define PR_2_INODE_TOOBAD		0x020049
 
+/* Directory dirdata flag set */
+#define PR_2_CLEAR_DIRDATA		0x02f000
+
 /*
  * Pass 3 errors
  */
Index: b/tests/f_dirdata/expect.1
===================================================================
--- /dev/null
+++ b/tests/f_dirdata/expect.1
@@ -0,0 +1,15 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Entry 'foobar2' in /ROOT/dir1 (439) dirdata length set incorrectly.
+Clear? yes
+
+Entry 'foobar1' in /ROOT/dir1 (439) dirdata length set incorrectly.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 543/5000 files (0.9% non-contiguous), 1731/5000 blocks
+Exit status is 1
Index: b/tests/f_dirdata/expect.2
===================================================================
--- /dev/null
+++ b/tests/f_dirdata/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 543/5000 files (0.9% non-contiguous), 1731/5000 blocks
+Exit status is 0
Index: b/tests/f_dirdata/name
===================================================================
--- /dev/null
+++ b/tests/f_dirdata/name
@@ -0,0 +1 @@
+corrupted dirdata length.

--Boundary_(ID_HqXn7NAkbD91meA0TCLLpg)--
