From: "Theodore Ts'o" <tytso@mit.edu>
Subject: The e2fsprogs nlinks-dir patch
Date: Thu, 13 Mar 2008 13:20:39 -0400
Message-ID: <E1JZr6d-0004yL-1m@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:54018 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbYCMRUw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Mar 2008 13:20:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


I was just auditing the e2fsprogs nlinks-dir patch, and I think there
are some problems with it.   First of all, it creates a whole new set of
icount abstractions so it can count using a 32-bit count.  That's
strictly not necessary, since all e2fsck cares about is whether the
count is bigger than EXT2_LINK_MAX, or 65,000.   

The bigger problem is that it fetches the actual number of
subdirectories (which could be some very large number, like 65538, or
some number much larger than 2**16):

		ext2fs_icount_fetch32(ctx->inode_count, i, &link_counted);

It then tests to see if the on-disk count is OK, which it does this way:

		if (link_counted != link_count &&
		    !(ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
		      link_count == 1 && link_counted > EXT2_LINK_MAX)) {

So if it is the actual and on-disk count is different, but the inode in
question is an inode and the on-disk count is 1, but the actual count is
greater than EXT2_LINK_MAX, it's OK.  Otherwise, we need to Take Action.

OK, but what if the on-disk count is some number less than EXT2_LINK_MAX
--- say, 64,999?  And what if the actual number of subdiretories is
somewhat larger and greater than EXT2_LINK_MAX, say, like 65538?   Well,
then the code blindly assignens the 32-bit link_counted to the 16-bit
on-disk i_links_count field, and writes it to disk:

				inode->i_links_count = link_counted;
				e2fsck_write_inode(ctx, i, inode, "pass4");

The number 65538 will get masked down to 2.  Hilarity then ensues.

I've verified this problem exists in the
e2fsprogs-1.40.2.cfs1-0redhat.src.rpm version of e2fsprogs.  

Since I wasn't very satisfied with the patch.  I proceeded to rewrite
it.  This is what I've come up with (although I will probably split the
icount changes to a separate commit).   It's quite a bit shorter than
the current cfs nlinks patch, as well.   Please comment.

						- Ted

From: "Theodore Ts'o" <tytso@mit.edu>
Date: Sat, 2 Feb 2008 01:25:03 -0700
Subject: [PATCH] Add support for the DIR_NLINK feature.

This patch includes the changes required to e2fsck to understand the
nlink count changes made in the kernel.

In e2fsck pass 4, when we fetch the actual link count, if it is
exceeds 65,000 we set the link count to 1.  We silently fix the
situation where the nlink count of the directory is 1, and there are
fewer than 65,000 subdirectories, since since that can happen
naturally.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass4.c       |   10 +++++++++-
 lib/ext2fs/ext2_fs.h |    1 +
 lib/ext2fs/ext2fs.h  |    4 ++--
 lib/ext2fs/icount.c  |   31 +++++++++++++++++++++----------
 4 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index e6fe604..ebc19a8 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -155,6 +155,9 @@ void e2fsck_pass4(e2fsck_t ctx)
 			ext2fs_icount_fetch(ctx->inode_count, i,
 					    &link_counted);
 		}
+		if (ext2fs_test_inode_bitmap(ctx->inode_dir_map, i) &&
+		    (link_counted > EXT2_LINK_MAX))
+			link_counted = 1;
 		if (link_counted != link_count) {
 			e2fsck_read_inode(ctx, i, inode, "pass4");
 			pctx.ino = i;
@@ -165,7 +168,12 @@ void e2fsck_pass4(e2fsck_t ctx)
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
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 896c590..f13c02f 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -632,6 +632,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
 
 /*
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 15f4352..d52fa34 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -516,7 +516,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
@@ -525,7 +526,6 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT3_FEATURE_INCOMPAT_EXTENTS)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM|\
-					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK|\
 					 EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)
 
 /*
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 2905676..bec0f5f 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -43,7 +43,7 @@
 
 struct ext2_icount_el {
 	ext2_ino_t	ino;
-	__u16	count;
+	__u32		count;
 };
 
 struct ext2_icount {
@@ -60,6 +60,15 @@ struct ext2_icount {
 	TDB_CONTEXT		*tdb;
 };
 
+/*
+ * We now use a 32-bit counter field because it doesn't cost us
+ * anything extra for the in-memory data structure, due to alignment
+ * padding.  But there's no point changing the interface if most of
+ * the time we only care if the number is bigger than 65,000 or not.
+ * So use the following translation function to return a 16-bit count.
+ */
+#define icount_16_xlate(x) (((x) > 65500) ? 65500 : (x))
+
 void ext2fs_free_icount(ext2_icount_t icount)
 {
 	if (!icount)
@@ -398,7 +407,7 @@ static struct ext2_icount_el *get_icount_el(ext2_icount_t icount,
 }
 
 static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
-				 __u16 count)
+				 __u32 count)
 {
 	struct ext2_icount_el 	*el;
 	TDB_DATA key, data;
@@ -407,7 +416,7 @@ static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 		key.dptr = (unsigned char *) &ino;
 		key.dsize = sizeof(ext2_ino_t);
 		data.dptr = (unsigned char *) &count;
-		data.dsize = sizeof(__u16);
+		data.dsize = sizeof(__u32);
 		if (count) {
 			if (tdb_store(icount->tdb, key, data, TDB_REPLACE))
 				return tdb_error(icount->tdb) +
@@ -429,7 +438,7 @@ static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 }
 
 static errcode_t get_inode_count(ext2_icount_t icount, ext2_ino_t ino,
-				 __u16 *count)
+				 __u32 *count)
 {
 	struct ext2_icount_el 	*el;
 	TDB_DATA key, data;
@@ -444,7 +453,7 @@ static errcode_t get_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 			return tdb_error(icount->tdb) + EXT2_ET_TDB_SUCCESS;
 		}
 
-		*count = *((__u16 *) data.dptr);
+		*count = *((__u32 *) data.dptr);
 		free(data.dptr);
 		return 0;
 	}
@@ -483,6 +492,7 @@ errcode_t ext2fs_icount_validate(ext2_icount_t icount, FILE *out)
 
 errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 {
+	__u32	val;
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
 	if (!ino || (ino > icount->num_inodes))
@@ -497,14 +507,15 @@ errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 		*ret = 0;
 		return 0;
 	}
-	get_inode_count(icount, ino, ret);
+	get_inode_count(icount, ino, &val);
+	*ret = icount_16_xlate(val);
 	return 0;
 }
 
 errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 				  __u16 *ret)
 {
-	__u16			curr_value;
+	__u32			curr_value;
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
@@ -554,14 +565,14 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 	if (icount->multiple)
 		ext2fs_mark_inode_bitmap(icount->multiple, ino);
 	if (ret)
-		*ret = curr_value;
+		*ret = icount_16_xlate(curr_value);
 	return 0;
 }
 
 errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 				  __u16 *ret)
 {
-	__u16			curr_value;
+	__u32			curr_value;
 
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
@@ -597,7 +608,7 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 		ext2fs_unmark_inode_bitmap(icount->multiple, ino);
 
 	if (ret)
-		*ret = curr_value;
+		*ret = icount_16_xlate(curr_value);
 	return 0;
 }
 
-- 
1.5.4.1.144.gdfee-dirty

