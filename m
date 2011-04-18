From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/2] E2fsprogs: use the generic inode flags
Date: Mon, 18 Apr 2011 15:37:26 +0800
Message-ID: <4DABEA36.5060007@cn.fujitsu.com>
References: <4DA2A0CC.9000301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, tytso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52857 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRHfn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Apr 2011 03:35:43 -0400
In-Reply-To: <4DA2A0CC.9000301@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 debugfs/htree.c        |    2 +-
 e2fsck/pass1.c         |   22 +++++++++++-----------
 e2fsck/pass2.c         |    2 +-
 e2fsck/pass4.c         |    2 +-
 e2fsck/rehash.c        |    4 ++--
 ext2ed/inode_com.c     |   14 +++++++-------
 lib/e2p/fgetflags.c    |    6 +++---
 lib/e2p/fsetflags.c    |    6 +++---
 lib/e2p/getflags.c     |    6 +++---
 lib/e2p/pf.c           |   34 +++++++++++++++++-----------------
 lib/e2p/setflags.c     |    6 +++---
 lib/ext2fs/ext2_fs.h   |   44 ++++++++++++++++++++++----------------------
 lib/ext2fs/link.c      |    4 ++--
 lib/ext2fs/mkjournal.c |    2 +-
 misc/chattr.c          |   26 +++++++++++++-------------
 misc/tune2fs.c         |    2 +-
 16 files changed, 91 insertions(+), 91 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 08f9749..cc9f0fb 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -243,7 +243,7 @@ void do_htree_dump(int argc, char *argv[])
 		goto errout;
 	}
 
-	if ((inode.i_flags & EXT2_BTREE_FL) == 0) {
+	if ((inode.i_flags & FS_BTREE_FL) == 0) {
 		com_err(argv[0], 0, "Not a hash-indexed directory");
 		goto errout;
 	}
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 67dd986..5ba93ca 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -138,7 +138,7 @@ int e2fsck_pass1_check_device_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
 	 * If the index flag is set, then this is a bogus
 	 * device/fifo/socket
 	 */
-	if (inode->i_flags & EXT2_INDEX_FL)
+	if (inode->i_flags & FS_INDEX_FL)
 		return 0;
 
 	/*
@@ -152,7 +152,7 @@ int e2fsck_pass1_check_device_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
 	 * you can't set or clear immutable flags for devices.)  Once
 	 * the kernel has been fixed we can change this...
 	 */
-	if (inode->i_flags & (EXT2_IMMUTABLE_FL | EXT2_APPEND_FL)) {
+	if (inode->i_flags & (FS_IMMUTABLE_FL | FS_APPEND_FL)) {
 		for (i=4; i < EXT2_N_BLOCKS; i++)
 			if (inode->i_block[i])
 				return 0;
@@ -175,7 +175,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2fs_extent	extent;
 
 	if ((inode->i_size_high || inode->i_size == 0) ||
-	    (inode->i_flags & EXT2_INDEX_FL))
+	    (inode->i_flags & FS_INDEX_FL))
 		return 0;
 
 	if (inode->i_flags & EXT4_EXTENTS_FL) {
@@ -235,7 +235,7 @@ int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
  * If the immutable (or append-only) flag is set on the inode, offer
  * to clear it.
  */
-#define BAD_SPECIAL_FLAGS (EXT2_IMMUTABLE_FL | EXT2_APPEND_FL)
+#define BAD_SPECIAL_FLAGS (FS_IMMUTABLE_FL | FS_APPEND_FL)
 static void check_immutable(e2fsck_t ctx, struct problem_context *pctx)
 {
 	if (!(pctx->inode->i_flags & BAD_SPECIAL_FLAGS))
@@ -989,7 +989,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
 		    (inode->osd2.linux2.l_i_blocks_hi != 0))
 			mark_inode_bad(ctx, ino);
-		if (inode->i_flags & EXT2_IMAGIC_FL) {
+		if (inode->i_flags & FS_IMAGIC_FL) {
 			if (imagic_fs) {
 				if (!ctx->inode_imagic_map)
 					alloc_imagic_map(ctx);
@@ -997,7 +997,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							 ino);
 			} else {
 				if (fix_problem(ctx, PR_1_SET_IMAGIC, &pctx)) {
-					inode->i_flags &= ~EXT2_IMAGIC_FL;
+					inode->i_flags &= ~FS_IMAGIC_FL;
 					e2fsck_write_inode(ctx, ino,
 							   inode, "pass1");
 				}
@@ -1893,13 +1893,13 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	extent_fs = (ctx->fs->super->s_feature_incompat &
                      EXT3_FEATURE_INCOMPAT_EXTENTS);
 
-	if (inode->i_flags & EXT2_COMPRBLK_FL) {
+	if (inode->i_flags & FS_COMPRBLK_FL) {
 		if (fs->super->s_feature_incompat &
 		    EXT2_FEATURE_INCOMPAT_COMPRESSION)
 			pb.compressed = 1;
 		else {
 			if (fix_problem(ctx, PR_1_COMPR_SET, pctx)) {
-				inode->i_flags &= ~EXT2_COMPRBLK_FL;
+				inode->i_flags &= ~FS_COMPRBLK_FL;
 				dirty_inode++;
 			}
 		}
@@ -1940,9 +1940,9 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		return;
 	}
 
-	if (inode->i_flags & EXT2_INDEX_FL) {
+	if (inode->i_flags & FS_INDEX_FL) {
 		if (handle_htree(ctx, pctx, ino, inode, block_buf)) {
-			inode->i_flags &= ~EXT2_INDEX_FL;
+			inode->i_flags &= ~FS_INDEX_FL;
 			dirty_inode++;
 		} else {
 #ifdef ENABLE_HTREE
@@ -2043,7 +2043,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	}
 
 	if (ctx->dirs_to_hash && pb.is_dir &&
-	    !(inode->i_flags & EXT2_INDEX_FL) &&
+	    !(inode->i_flags & FS_INDEX_FL) &&
 	    ((inode->i_size / fs->blocksize) >= 3))
 		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 8d1cbc6..946674b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1240,7 +1240,7 @@ static void clear_htree(e2fsck_t ctx, ext2_ino_t ino)
 	struct ext2_inode	inode;
 
 	e2fsck_read_inode(ctx, ino, &inode, "clear_htree");
-	inode.i_flags = inode.i_flags & ~EXT2_INDEX_FL;
+	inode.i_flags = inode.i_flags & ~FS_INDEX_FL;
 	e2fsck_write_inode(ctx, ino, &inode, "clear_htree");
 	if (ctx->dirs_to_hash)
 		ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 695612b..83f1816 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -171,7 +171,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 			/* i_link_count was previously exceeded, but no longer
 			 * is, fix this but don't consider it an error */
 			if ((isdir && link_counted > 1 &&
-			     (inode->i_flags & EXT2_INDEX_FL) &&
+			     (inode->i_flags & FS_INDEX_FL) &&
 			     link_count == 1 && !(ctx->options & E2F_OPT_NO)) ||
 			    fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
 				inode->i_links_count = link_counted;
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 5543134..e351678 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -689,9 +689,9 @@ static errcode_t write_directory(e2fsck_t ctx, ext2_filsys fs,
 
 	e2fsck_read_inode(ctx, ino, &inode, "rehash_dir");
 	if (compress)
-		inode.i_flags &= ~EXT2_INDEX_FL;
+		inode.i_flags &= ~FS_INDEX_FL;
 	else
-		inode.i_flags |= EXT2_INDEX_FL;
+		inode.i_flags |= FS_INDEX_FL;
 	inode.i_size = outdir->num * fs->blocksize;
 	ext2fs_iblk_sub_blocks(fs, &inode, wd.cleared);
 	e2fsck_write_inode(ctx, ino, &inode, "rehash_dir");
diff --git a/ext2ed/inode_com.c b/ext2ed/inode_com.c
index 8d4b9f3..a7ffd35 100644
--- a/ext2ed/inode_com.c
+++ b/ext2ed/inode_com.c
@@ -169,38 +169,38 @@ void type_ext2_inode___show (char *command_line)
 	wmove (show_pad,10,40);
 	temp=inode_ptr->i_flags;
 
-	if (temp & EXT2_SECRM_FL)
+	if (temp & FS_SECRM_FL)
 		wprintw (show_pad,"s");
 	else
 		wprintw (show_pad,"-");
 
 
-	if (temp & EXT2_UNRM_FL)
+	if (temp & FS_UNRM_FL)
 		wprintw (show_pad,"u");
 	else
 		wprintw (show_pad,"-");
 
-	if (temp & EXT2_COMPR_FL)
+	if (temp & FS_COMPR_FL)
 		wprintw (show_pad,"c");
 	else
 		wprintw (show_pad,"-");
 
-	if (temp & EXT2_SYNC_FL)
+	if (temp & FS_SYNC_FL)
 		wprintw (show_pad,"S");
 	else
 		wprintw (show_pad,"-");
 
-	if (temp & EXT2_IMMUTABLE_FL)
+	if (temp & FS_IMMUTABLE_FL)
 		wprintw (show_pad,"i");
 	else
 		wprintw (show_pad,"-");
 
-	if (temp & EXT2_APPEND_FL)
+	if (temp & FS_APPEND_FL)
 		wprintw (show_pad,"a");
 	else
 		wprintw (show_pad,"-");
 
-	if (temp & EXT2_NODUMP_FL)
+	if (temp & FS_NODUMP_FL)
 		wprintw (show_pad,"d");
 	else
 		wprintw (show_pad,"-");
diff --git a/lib/e2p/fgetflags.c b/lib/e2p/fgetflags.c
index d66f8e1..3d13ba0 100644
--- a/lib/e2p/fgetflags.c
+++ b/lib/e2p/fgetflags.c
@@ -51,15 +51,15 @@ int fgetflags (const char * name, unsigned long * flags)
 	*flags = 0;
 #ifdef UF_IMMUTABLE
 	if (buf.st_flags & UF_IMMUTABLE)
-		*flags |= EXT2_IMMUTABLE_FL;
+		*flags |= FS_IMMUTABLE_FL;
 #endif
 #ifdef UF_APPEND
 	if (buf.st_flags & UF_APPEND)
-		*flags |= EXT2_APPEND_FL;
+		*flags |= FS_APPEND_FL;
 #endif
 #ifdef UF_NODUMP
 	if (buf.st_flags & UF_NODUMP)
-		*flags |= EXT2_NODUMP_FL;
+		*flags |= FS_NODUMP_FL;
 #endif
 
 	return 0;
diff --git a/lib/e2p/fsetflags.c b/lib/e2p/fsetflags.c
index 30437a2..5bd7e0c 100644
--- a/lib/e2p/fsetflags.c
+++ b/lib/e2p/fsetflags.c
@@ -56,15 +56,15 @@ int fsetflags (const char * name, unsigned long flags)
 	unsigned long bsd_flags = 0;
 
 #ifdef UF_IMMUTABLE
-	if (flags & EXT2_IMMUTABLE_FL)
+	if (flags & FS_IMMUTABLE_FL)
 		bsd_flags |= UF_IMMUTABLE;
 #endif
 #ifdef UF_APPEND
-	if (flags & EXT2_APPEND_FL)
+	if (flags & FS_APPEND_FL)
 		bsd_flags |= UF_APPEND;
 #endif
 #ifdef UF_NODUMP
-	if (flags & EXT2_NODUMP_FL)
+	if (flags & FS_NODUMP_FL)
 		bsd_flags |= UF_NODUMP;
 #endif
 
diff --git a/lib/e2p/getflags.c b/lib/e2p/getflags.c
index a738fed..438bcdb 100644
--- a/lib/e2p/getflags.c
+++ b/lib/e2p/getflags.c
@@ -38,15 +38,15 @@ int getflags (int fd, unsigned long * flags)
 	*flags = 0;
 #ifdef UF_IMMUTABLE
 	if (buf.st_flags & UF_IMMUTABLE)
-		*flags |= EXT2_IMMUTABLE_FL;
+		*flags |= FS_IMMUTABLE_FL;
 #endif
 #ifdef UF_APPEND
 	if (buf.st_flags & UF_APPEND)
-		*flags |= EXT2_APPEND_FL;
+		*flags |= FS_APPEND_FL;
 #endif
 #ifdef UF_NODUMP
 	if (buf.st_flags & UF_NODUMP)
-		*flags |= EXT2_NODUMP_FL;
+		*flags |= FS_NODUMP_FL;
 #endif
 
 	return 0;
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index f34a5cc..cc50896 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -27,25 +27,25 @@ struct flags_name {
 };
 
 static struct flags_name flags_array[] = {
-	{ EXT2_SECRM_FL, "s", "Secure_Deletion" },
-	{ EXT2_UNRM_FL, "u" , "Undelete" },
-	{ EXT2_SYNC_FL, "S", "Synchronous_Updates" },
-	{ EXT2_DIRSYNC_FL, "D", "Synchronous_Directory_Updates" },
-	{ EXT2_IMMUTABLE_FL, "i", "Immutable" },
-	{ EXT2_APPEND_FL, "a", "Append_Only" },
-	{ EXT2_NODUMP_FL, "d", "No_Dump" },
-	{ EXT2_NOATIME_FL, "A", "No_Atime" },
-	{ EXT2_COMPR_FL, "c", "Compression_Requested" },
+	{ FS_SECRM_FL, "s", "Secure_Deletion" },
+	{ FS_UNRM_FL, "u" , "Undelete" },
+	{ FS_SYNC_FL, "S", "Synchronous_Updates" },
+	{ FS_DIRSYNC_FL, "D", "Synchronous_Directory_Updates" },
+	{ FS_IMMUTABLE_FL, "i", "Immutable" },
+	{ FS_APPEND_FL, "a", "Append_Only" },
+	{ FS_NODUMP_FL, "d", "No_Dump" },
+	{ FS_NOATIME_FL, "A", "No_Atime" },
+	{ FS_COMPR_FL, "c", "Compression_Requested" },
 #ifdef ENABLE_COMPRESSION
-	{ EXT2_COMPRBLK_FL, "B", "Compressed_File" },
-	{ EXT2_DIRTY_FL, "Z", "Compressed_Dirty_File" },
-	{ EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
-	{ EXT2_ECOMPR_FL, "E", "Compression_Error" },
+	{ FS_COMPRBLK_FL, "B", "Compressed_File" },
+	{ FS_DIRTY_FL, "Z", "Compressed_Dirty_File" },
+	{ FS_NOCOMPR_FL, "X", "Compression_Raw_Access" },
+	{ FS_ECOMPR_FL, "E", "Compression_Error" },
 #endif
-	{ EXT3_JOURNAL_DATA_FL, "j", "Journaled_Data" },
-	{ EXT2_INDEX_FL, "I", "Indexed_directory" },
-	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
-	{ EXT2_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
+	{ FS_JOURNAL_DATA_FL, "j", "Journaled_Data" },
+	{ FS_INDEX_FL, "I", "Indexed_directory" },
+	{ FS_NOTAIL_FL, "t", "No_Tailmerging" },
+	{ FS_TOPDIR_FL, "T", "Top_of_Directory_Hierarchies" },
 	{ EXT4_EXTENTS_FL, "e", "Extents" },
 	{ EXT4_HUGE_FILE_FL, "h", "Huge_file" },
 	{ 0, NULL, NULL }
diff --git a/lib/e2p/setflags.c b/lib/e2p/setflags.c
index cc00b20..347648c 100644
--- a/lib/e2p/setflags.c
+++ b/lib/e2p/setflags.c
@@ -43,15 +43,15 @@ int setflags (int fd, unsigned long flags)
 	unsigned long bsd_flags = 0;
 
 #ifdef UF_IMMUTABLE
-	if (flags & EXT2_IMMUTABLE_FL)
+	if (flags & FS_IMMUTABLE_FL)
 		bsd_flags |= UF_IMMUTABLE;
 #endif
 #ifdef UF_APPEND
-	if (flags & EXT2_APPEND_FL)
+	if (flags & FS_APPEND_FL)
 		bsd_flags |= UF_APPEND;
 #endif
 #ifdef UF_NODUMP
-	if (flags & EXT2_NODUMP_FL)
+	if (flags & FS_NODUMP_FL)
 		bsd_flags |= UF_NODUMP;
 #endif
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a89e33b..858c103 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -251,27 +251,27 @@ struct ext2_dx_countlimit {
 /*
  * Inode flags
  */
-#define EXT2_SECRM_FL			0x00000001 /* Secure deletion */
-#define EXT2_UNRM_FL			0x00000002 /* Undelete */
-#define EXT2_COMPR_FL			0x00000004 /* Compress file */
-#define EXT2_SYNC_FL			0x00000008 /* Synchronous updates */
-#define EXT2_IMMUTABLE_FL		0x00000010 /* Immutable file */
-#define EXT2_APPEND_FL			0x00000020 /* writes to file may only append */
-#define EXT2_NODUMP_FL			0x00000040 /* do not dump file */
-#define EXT2_NOATIME_FL			0x00000080 /* do not update atime */
+#define FS_SECRM_FL			0x00000001 /* Secure deletion */
+#define FS_UNRM_FL			0x00000002 /* Undelete */
+#define FS_COMPR_FL			0x00000004 /* Compress file */
+#define FS_SYNC_FL			0x00000008 /* Synchronous updates */
+#define FS_IMMUTABLE_FL			0x00000010 /* Immutable file */
+#define FS_APPEND_FL			0x00000020 /* writes to file may only append */
+#define FS_NODUMP_FL			0x00000040 /* do not dump file */
+#define FS_NOATIME_FL			0x00000080 /* do not update atime */
 /* Reserved for compression usage... */
-#define EXT2_DIRTY_FL			0x00000100
-#define EXT2_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
-#define EXT2_NOCOMPR_FL			0x00000400 /* Access raw compressed data */
-#define EXT2_ECOMPR_FL			0x00000800 /* Compression error */
+#define FS_DIRTY_FL			0x00000100
+#define FS_COMPRBLK_FL			0x00000200 /* One or more compressed clusters */
+#define FS_NOCOMPR_FL			0x00000400 /* Access raw compressed data */
+#define FS_ECOMPR_FL			0x00000800 /* Compression error */
 /* End compression flags --- maybe not all used */
-#define EXT2_BTREE_FL			0x00001000 /* btree format dir */
-#define EXT2_INDEX_FL			0x00001000 /* hash-indexed directory */
-#define EXT2_IMAGIC_FL			0x00002000
-#define EXT3_JOURNAL_DATA_FL		0x00004000 /* file data should be journaled */
-#define EXT2_NOTAIL_FL			0x00008000 /* file tail should not be merged */
-#define EXT2_DIRSYNC_FL 		0x00010000 /* Synchronous directory modifications */
-#define EXT2_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
+#define FS_BTREE_FL			0x00001000 /* btree format dir */
+#define FS_INDEX_FL			0x00001000 /* hash-indexed directory */
+#define FS_IMAGIC_FL			0x00002000
+#define FS_JOURNAL_DATA_FL		0x00004000 /* file data should be journaled */
+#define FS_NOTAIL_FL			0x00008000 /* file tail should not be merged */
+#define FS_DIRSYNC_FL	 		0x00010000 /* Synchronous directory modifications */
+#define FS_TOPDIR_FL			0x00020000 /* Top of directory hierarchies*/
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
@@ -279,10 +279,10 @@ struct ext2_dx_countlimit {
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
-#define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
+#define FS_RESERVED_FL			0x80000000 /* reserved for ext2 lib */
 
-#define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-#define EXT2_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
+#define FS_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
+#define FS_FL_USER_MODIFIABLE		0x004B80FF /* User modifiable flags */
 
 /*
  * ioctl commands
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 4cc8426..053ccc9 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -143,8 +143,8 @@ errcode_t ext2fs_link(ext2_filsys fs, ext2_ino_t dir, const char *name,
 	if ((retval = ext2fs_read_inode(fs, dir, &inode)) != 0)
 		return retval;
 
-	if (inode.i_flags & EXT2_INDEX_FL) {
-		inode.i_flags &= ~EXT2_INDEX_FL;
+	if (inode.i_flags & FS_INDEX_FL) {
+		inode.i_flags &= ~FS_INDEX_FL;
 		if ((retval = ext2fs_write_inode(fs, dir, &inode)) != 0)
 			return retval;
 	}
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 242c537..8dccf66 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -521,7 +521,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 			retval = errno;
 			goto errout;
 		}
-		f |= EXT2_NODUMP_FL | EXT2_IMMUTABLE_FL;
+		f |= FS_NODUMP_FL | FS_IMMUTABLE_FL;
 		retval = ioctl(fd, EXT2_IOC_SETFLAGS, &f);
 #endif
 #endif
diff --git a/misc/chattr.c b/misc/chattr.c
index de33b08..78e3736 100644
--- a/misc/chattr.c
+++ b/misc/chattr.c
@@ -93,19 +93,19 @@ struct flags_char {
 };
 
 static const struct flags_char flags_array[] = {
-	{ EXT2_NOATIME_FL, 'A' },
-	{ EXT2_SYNC_FL, 'S' },
-	{ EXT2_DIRSYNC_FL, 'D' },
-	{ EXT2_APPEND_FL, 'a' },
-	{ EXT2_COMPR_FL, 'c' },
-	{ EXT2_NODUMP_FL, 'd' },
+	{ FS_NOATIME_FL, 'A' },
+	{ FS_SYNC_FL, 'S' },
+	{ FS_DIRSYNC_FL, 'D' },
+	{ FS_APPEND_FL, 'a' },
+	{ FS_COMPR_FL, 'c' },
+	{ FS_NODUMP_FL, 'd' },
 	{ EXT4_EXTENTS_FL, 'e'},
-	{ EXT2_IMMUTABLE_FL, 'i' },
-	{ EXT3_JOURNAL_DATA_FL, 'j' },
-	{ EXT2_SECRM_FL, 's' },
-	{ EXT2_UNRM_FL, 'u' },
-	{ EXT2_NOTAIL_FL, 't' },
-	{ EXT2_TOPDIR_FL, 'T' },
+	{ FS_IMMUTABLE_FL, 'i' },
+	{ FS_JOURNAL_DATA_FL, 'j' },
+	{ FS_SECRM_FL, 's' },
+	{ FS_UNRM_FL, 'u' },
+	{ FS_NOTAIL_FL, 't' },
+	{ FS_TOPDIR_FL, 'T' },
 	{ 0, 0 }
 };
 
@@ -242,7 +242,7 @@ static int change_attributes(const char * name)
 			printf("\n");
 		}
 		if (!S_ISDIR(st.st_mode))
-			flags &= ~EXT2_DIRSYNC_FL;
+			flags &= ~FS_DIRSYNC_FL;
 		if (fsetflags(name, flags) == -1) {
 			if (!silent) {
 				com_err(program_name, errno,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index bcada11..5bf0bfb 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -303,7 +303,7 @@ static void remove_journal_inode(ext2_filsys fs)
 		ext2fs_mark_bb_dirty(fs);
 		fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	} else
-		inode.i_flags &= ~EXT2_IMMUTABLE_FL;
+		inode.i_flags &= ~FS_IMMUTABLE_FL;
 	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval) {
 		com_err(program_name, retval,
-- 
1.6.5.2

