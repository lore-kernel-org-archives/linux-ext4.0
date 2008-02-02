From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH][6/28] e2fsprogs-nlinks.patch
Date: Sat, 02 Feb 2008 01:25:03 -0700
Message-ID: <20080202082503.GF31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58316 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbYBBIZH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:25:07 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128P6LR016506
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:25:06 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00001R3JH300@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:25:06 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Add support for the DIR_NLINK feature.

This patch includes the changes required to e2fsck to understand the 
nlink count changes made in the kernel. In pass2, while counting the 
links for a directory, if the link count exceeds 65000, its permanently 
set to EXT2_LINK_MAX + 10. In pass4, when the counted and actual nlink
counts are compared, e2fsck does not flag an error if counted links =
EXT2_NLINK_MAX + 10 and existing link count is 1. 

It also handles the case when a directory had more than 65000 subdirs 
and they were later deleted. The nlink count of such a directory remains 
1. In pass4 if counted links are 2 and if existing nlink count = 1, 
e2fsck corrects the nlink count without displaying any errors. 

The file hard link count is also increased to 65000, but this cannot be
exceeded.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40.1/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40.1/e2fsck/pass2.c
@@ -717,7 +717,7 @@ static int check_dir_block(ext2_filsys f
 	blk_t			block_nr = db->blk;
 	ext2_ino_t 		ino = db->ino;
 	ext2_ino_t 		subdir_parent;
-	__u16			links;
+	__u32			links;
 	struct check_dir_struct	*cd;
 	char 			*buf;
 	e2fsck_t		ctx;
@@ -1024,9 +1024,11 @@ static int check_dir_block(ext2_filsys f
 			dups_found++;
 		} else
 			dict_alloc_insert(&de_dict, dirent, dirent);
-		
-		ext2fs_icount_increment(ctx->inode_count, dirent->inode,
-					&links);
+
+		ext2fs_icount_inc32(ctx->inode_count, dirent->inode, &links,
+				    ext2fs_test_inode_bitmap(ctx->inode_dir_map,
+							     dirent->inode) ?
+				    EXT2_LINK_MAX : (__u32)~0U);
 		if (links > 1)
 			ctx->fs_links_count++;
 		ctx->fs_total_count++;
Index: e2fsprogs-1.40.1/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.1/e2fsck/pass4.c
@@ -99,7 +99,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 	struct resource_track	rtrack;
 #endif
 	struct problem_context	pctx;
-	__u16	link_count, link_counted;
+	__u16	link_count;
+	__u32	link_counted;
 	char	*buf = 0;
 	int	group, maxgroup;
 	
@@ -145,7 +146,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 		     ext2fs_test_inode_bitmap(ctx->inode_bb_map, i)))
 			continue;
 		ext2fs_icount_fetch(ctx->inode_link_info, i, &link_count);
-		ext2fs_icount_fetch(ctx->inode_count, i, &link_counted);
+		ext2fs_icount_fetch32(ctx->inode_count, i, &link_counted);
 		if (link_counted == 0) {
 			if (!buf)
 				buf = e2fsck_allocate_memory(ctx,
@@ -156,10 +157,12 @@ void e2fsck_pass4(e2fsck_t ctx)
 				continue;
 			ext2fs_icount_fetch(ctx->inode_link_info, i,
 					    &link_count);
-			ext2fs_icount_fetch(ctx->inode_count, i,
-					    &link_counted);
+			ext2fs_icount_fetch32(ctx->inode_count, i,
+					      &link_counted);
 		}
-		if (link_counted != link_count) {
+		if (link_counted != link_count &&
+		    !(ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
+		      link_count == 1 && link_counted > EXT2_LINK_MAX)) {
 			e2fsck_read_inode(ctx, i, inode, "pass4");
 			pctx.ino = i;
 			pctx.inode = inode;
@@ -169,7 +172,12 @@ void e2fsck_pass4(e2fsck_t ctx)
 					    PR_4_INCONSISTENT_COUNT, &pctx);
 			}
 			pctx.num = link_counted;
-			if (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
+			/* i_link_count was previously exceeded, but no longer
+			 * is, fix this but don't consider it an error */
+			if ((LINUX_S_ISDIR(inode->i_mode) && link_counted > 1 &&
+			     (inode->i_flags & EXT2_INDEX_FL) &&
+			     link_count == 1 && !(ctx->options & E2F_OPT_NO)) ||
+			     (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx))) {
 				inode->i_links_count = link_counted;
 				e2fsck_write_inode(ctx, i, inode, "pass4");
 			}
Index: e2fsprogs-1.40.1/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/ext2_fs.h
+++ e2fsprogs-1.40.1/lib/ext2fs/ext2_fs.h
@@ -646,6 +646,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
Index: e2fsprogs-1.40.1/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.1/lib/ext2fs/ext2fs.h
@@ -462,7 +462,8 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT3_FEATURE_INCOMPAT_RECOVER)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
@@ -471,7 +472,6 @@ typedef struct ext2_icount *ext2_icount_
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT3_FEATURE_INCOMPAT_EXTENTS)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
 
 /*
@@ -795,12 +795,20 @@ extern errcode_t ext2fs_create_icount2(e
 extern errcode_t ext2fs_create_icount(ext2_filsys fs, int flags, 
 				      unsigned int size,
 				      ext2_icount_t *ret);
+extern errcode_t ext2fs_icount_fetch32(ext2_icount_t icount, ext2_ino_t ino,
+				       __u32 *ret);
 extern errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino,
 				     __u16 *ret);
+extern errcode_t ext2fs_icount_inc32(ext2_icount_t icount, ext2_ino_t ino,
+				     __u32 *ret, __u32 overflow);
 extern errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 					 __u16 *ret);
+extern errcode_t ext2fs_icount_dec32(ext2_icount_t icount, ext2_ino_t ino,
+				     __u32 *ret);
 extern errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 					 __u16 *ret);
+extern errcode_t ext2fs_icount_store32(ext2_icount_t icount, ext2_ino_t ino,
+				       __u32 count);
 extern errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 				     __u16 count);
 extern ext2_ino_t ext2fs_get_icount_size(ext2_icount_t icount);
Index: e2fsprogs-1.40.1/lib/ext2fs/icount.c
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/icount.c
+++ e2fsprogs-1.40.1/lib/ext2fs/icount.c
@@ -43,7 +43,7 @@
 
 struct ext2_icount_el {
 	ext2_ino_t	ino;
-	__u16	count;
+	__u32	count;
 };
 
 struct ext2_icount {
@@ -397,16 +397,16 @@ static struct ext2_icount_el *get_icount
 }
 
 static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
-				 __u16 count)
+				 __u32 count)
 {
-	struct ext2_icount_el 	*el;
+	struct ext2_icount_el	*el;
 	TDB_DATA key, data;
 
 	if (icount->tdb) {
 		key.dptr = (unsigned char *) &ino;
 		key.dsize = sizeof(ext2_ino_t);
 		data.dptr = (unsigned char *) &count;
-		data.dsize = sizeof(__u16);
+		data.dsize = sizeof(__u32);
 		if (count) {
 			if (tdb_store(icount->tdb, key, data, TDB_REPLACE))
 				return tdb_error(icount->tdb) +
@@ -428,9 +428,9 @@ static errcode_t set_inode_count(ext2_ic
 }
 
 static errcode_t get_inode_count(ext2_icount_t icount, ext2_ino_t ino,
-				 __u16 *count)
+				 __u32 *count)
 {
-	struct ext2_icount_el 	*el;
+	struct ext2_icount_el	*el;
 	TDB_DATA key, data;
 
 	if (icount->tdb) {
@@ -443,7 +443,7 @@ static errcode_t get_inode_count(ext2_ic
 			return tdb_error(icount->tdb) + EXT2_ET_TDB_SUCCESS;
 		}
 
-		*count = *((__u16 *) data.dptr);
+		*count = *((__u32 *) data.dptr);
 		free(data.dptr);
 		return 0;
 	}
@@ -480,7 +480,7 @@ errcode_t ext2fs_icount_validate(ext2_ic
 	return ret;
 }
 
-errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
+errcode_t ext2fs_icount_fetch32(ext2_icount_t icount, ext2_ino_t ino, __u32 *ret)
 {
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
@@ -500,10 +500,21 @@ errcode_t ext2fs_icount_fetch(ext2_icoun
 	return 0;
 }
 
-errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
-				  __u16 *ret)
+errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 {
-	__u16			curr_value;
+	__u32 ret32 = ret ? *ret : 0;
+	errcode_t err;
+
+	err = ext2fs_icount_fetch32(icount, ino, &ret32);
+	*ret = (__u16)ret32;
+
+	return err;
+}
+
+errcode_t ext2fs_icount_inc32(ext2_icount_t icount, ext2_ino_t ino,
+			      __u32 *ret, __u32 overflow)
+{
+	__u32			curr_value;
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
@@ -528,6 +539,8 @@ errcode_t ext2fs_icount_increment(ext2_i
 		if (ext2fs_test_inode_bitmap(icount->multiple, ino)) {
 			get_inode_count(icount, ino, &curr_value);
 			curr_value++;
+			if (curr_value >= overflow)
+				curr_value = overflow + 10;
 			if (set_inode_count(icount, ino, curr_value))
 				return EXT2_ET_NO_MEMORY;
 		} else {
@@ -547,6 +560,8 @@ errcode_t ext2fs_icount_increment(ext2_i
 		 */
 		get_inode_count(icount, ino, &curr_value);
 		curr_value++;
+		if (curr_value >= overflow)
+			curr_value = overflow + 10;
 		if (set_inode_count(icount, ino, curr_value))
 			return EXT2_ET_NO_MEMORY;
 	}
@@ -557,10 +572,23 @@ errcode_t ext2fs_icount_increment(ext2_i
 	return 0;
 }
 
-errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
+errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 				  __u16 *ret)
 {
-	__u16			curr_value;
+	__u32 ret32 = ret ? *ret : 0;
+	errcode_t err;
+
+	err = ext2fs_icount_inc32(icount, ino, &ret32, (__u16)~0U);
+	if (ret)
+		*ret = ret32;
+
+	return err;
+}
+
+errcode_t ext2fs_icount_dec32(ext2_icount_t icount, ext2_ino_t ino,
+			      __u32 *ret)
+{
+	__u32			curr_value;
 
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
@@ -600,8 +628,21 @@ errcode_t ext2fs_icount_decrement(ext2_i
 	return 0;
 }
 
-errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
-			      __u16 count)
+errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
+				  __u16 *ret)
+{
+	__u32 ret32 = ret ? *ret : 0;
+	errcode_t err;
+
+	err = ext2fs_icount_dec32(icount, ino, &ret32);
+	if (ret)
+		*ret = ret32;
+
+	return err;
+}
+
+errcode_t ext2fs_icount_store32(ext2_icount_t icount, ext2_ino_t ino,
+				__u32 count)
 {
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
@@ -635,6 +676,12 @@ errcode_t ext2fs_icount_store(ext2_icoun
 	return 0;
 }
 
+errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
+			      __u16 count)
+{
+	return ext2fs_icount_store32(icount, ino, count);
+}
+
 ext2_ino_t ext2fs_get_icount_size(ext2_icount_t icount)
 {
 	if (!icount || icount->magic != EXT2_ET_MAGIC_ICOUNT)
Index: e2fsprogs-1.40.1/e2fsck/pass3.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass3.c
+++ e2fsprogs-1.40.1/e2fsck/pass3.c
@@ -581,19 +581,22 @@ errcode_t e2fsck_adjust_inode_count(e2fs
 #endif
 
 	if (adj == 1) {
-		ext2fs_icount_increment(ctx->inode_count, ino, 0);
+		ext2fs_icount_inc32(ctx->inode_count, ino, 0,
+				    ext2fs_test_inode_bitmap(ctx->inode_dir_map,
+							     ino) ?
+				    EXT2_LINK_MAX : ~0U);
 		if (inode.i_links_count == (__u16) ~0)
 			return 0;
 		ext2fs_icount_increment(ctx->inode_link_info, ino, 0);
 		inode.i_links_count++;
 	} else if (adj == -1) {
-		ext2fs_icount_decrement(ctx->inode_count, ino, 0);
+		ext2fs_icount_dec32(ctx->inode_count, ino, 0);
 		if (inode.i_links_count == 0)
 			return 0;
 		ext2fs_icount_decrement(ctx->inode_link_info, ino, 0);
 		inode.i_links_count--;
 	}
-	
+
 	retval = ext2fs_write_inode(fs, ino, &inode);
 	if (retval)
 		return retval;

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
