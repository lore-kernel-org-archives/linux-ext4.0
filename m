From: Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH] e2fsprogs: Additions in EA checking
Date: Wed, 02 May 2007 14:46:22 +0530
Message-ID: <1178097382.4529.28.camel@garfield>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: TheodoreTso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:42804 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbXEBJN0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 May 2007 05:13:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

This patch makes the following changes to EA checking:

1) Allow in-inode EAs to have a hash.
2) Connect zero-length inodes that have an EA to lost+found.
3) Addition of hash function for EAs

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>

Index: e2fsprogs-1.40/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40/e2fsck/e2fsck.h
@@ -475,6 +475,9 @@ extern void init_resource_track(struct r
 extern int inode_has_valid_blocks(struct ext2_inode *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
 			      struct ext2_inode * inode, const char * proc);
+extern void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
+				   struct ext2_inode *inode,
+				   const int bufsize, const char *proc);
 extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
 			       struct ext2_inode * inode, const char * proc);
 extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
Index: e2fsprogs-1.40/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40/e2fsck/pass1.c
@@ -250,8 +250,8 @@ static void check_ea_in_inode(e2fsck_t c
 	int problem = 0;
 
 	inode = (struct ext2_inode_large *) pctx->inode;
-	storage_size = EXT2_INODE_SIZE(ctx->fs->super) - EXT2_GOOD_OLD_INODE_SIZE -
-		inode->i_extra_isize;
+	storage_size = EXT2_INODE_SIZE(ctx->fs->super) -
+		EXT2_GOOD_OLD_INODE_SIZE - inode->i_extra_isize;
 	start = ((char *) inode) + EXT2_GOOD_OLD_INODE_SIZE +
 		inode->i_extra_isize + sizeof(__u32);
 	end = (char *) inode + EXT2_INODE_SIZE(ctx->fs->super);
@@ -263,6 +263,7 @@ static void check_ea_in_inode(e2fsck_t c
 	remain = storage_size - sizeof(__u32); 
 
 	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		__u32 hash;
 
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
@@ -291,8 +292,11 @@ static void check_ea_in_inode(e2fsck_t c
 			goto fix;
 		}
 		
-		/* e_hash must be 0 in inode's ea */
-		if (entry->e_hash != 0) {
+		hash = ext2fs_ext_attr_hash_entry(entry,
+						  start + entry->e_value_offs);
+
+		/* e_hash may be 0 in older inode's ea */
+		if (entry->e_hash != 0 && entry->e_hash != hash) {
 			pctx->num = entry->e_hash;
 			problem = PR_1_ATTR_HASH;
 			goto fix;
@@ -307,9 +311,6 @@ fix:
 	 * it seems like a corruption. it's very unlikely we could repair
 	 * EA(s) in automatic fashion -bzzz
 	 */
-#if 0
-	problem = PR_1_ATTR_HASH;
-#endif
 	if (problem == 0 || !fix_problem(ctx, problem, pctx))
 		return;
 
@@ -1357,10 +1358,13 @@ static int check_ext_attr(e2fsck_t ctx, 
 	entry = (struct ext2_ext_attr_entry *)(header+1);
 	end = block_buf + fs->blocksize;
 	while ((char *)entry < end && *(__u32 *)entry) {
+		__u32 hash;
+
 		if (region_allocate(region, (char *)entry - (char *)header,
 			           EXT2_EXT_ATTR_LEN(entry->e_name_len))) {
 			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
 				goto clear_extattr;
+			break;
 		}
 		if ((ctx->ext_attr_ver == 1 &&
 		     (entry->e_name_len == 0 || entry->e_name_index != 0)) ||
@@ -1368,6 +1372,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 		     entry->e_name_index == 0)) {
 			if (fix_problem(ctx, PR_1_EA_BAD_NAME, pctx))
 				goto clear_extattr;
+			break;
 		}
 		if (entry->e_value_block != 0) {
 			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
@@ -1379,6 +1384,17 @@ static int check_ext_attr(e2fsck_t ctx, 
 			if (fix_problem(ctx, PR_1_EA_ALLOC_COLLISION, pctx))
 				goto clear_extattr;
 		}
+
+		hash = ext2fs_ext_attr_hash_entry(entry, block_buf +
+							 entry->e_value_offs);
+
+		if (entry->e_hash != hash) {
+			pctx->num = entry->e_hash;
+			if (fix_problem(ctx, PR_1_ATTR_HASH, pctx))
+				goto clear_extattr;
+			entry->e_hash = hash;
+		}
+
 		entry = EXT2_EXT_ATTR_NEXT(entry);
 	}
 	if (region_allocate(region, (char *)entry - (char *)header, 4)) {
@@ -1500,8 +1516,11 @@ static void check_blocks(e2fsck_t ctx, s
 		}
 	}
 
-	if (inode->i_file_acl && check_ext_attr(ctx, pctx, block_buf))
+	if (inode->i_file_acl && check_ext_attr(ctx, pctx, block_buf)) {
+		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
+			goto out;
 		pb.num_blocks++;
+	}
 
 	if (ext2fs_inode_has_valid_blocks(inode))
 		pctx->errcode = ext2fs_block_iterate2(fs, ino,
Index: e2fsprogs-1.40/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40/e2fsck/pass4.c
@@ -15,6 +15,7 @@
 
 #include "e2fsck.h"
 #include "problem.h"
+#include <ext2fs/ext2_ext_attr.h>
 
 /*
  * This routine is called when an inode is not connected to the
@@ -23,31 +24,41 @@
  * This subroutine returns 1 then the caller shouldn't bother with the
  * rest of the pass 4 tests.
  */
-static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i)
+static int disconnect_inode(e2fsck_t ctx, ext2_ino_t i,
+			    struct ext2_inode *inode)
 {
 	ext2_filsys fs = ctx->fs;
-	struct ext2_inode	inode;
 	struct problem_context	pctx;
+	__u32 eamagic = 0;
+	int extra_size = 0;
 
-	e2fsck_read_inode(ctx, i, &inode, "pass4: disconnect_inode");
+	if (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE) {
+		e2fsck_read_inode_full(ctx, i, inode,EXT2_INODE_SIZE(fs->super),
+				       "pass4: disconnect_inode");
+		extra_size = ((struct ext2_inode_large *)inode)->i_extra_isize;
+	} else {
+		e2fsck_read_inode(ctx, i, inode, "pass4: disconnect_inode");
+	}
 	clear_problem_context(&pctx);
 	pctx.ino = i;
-	pctx.inode = &inode;
+	pctx.inode = inode;
 	
+	if (EXT2_INODE_SIZE(fs->super) -EXT2_GOOD_OLD_INODE_SIZE -extra_size >0)
+		eamagic = *(__u32 *)(((char *)inode) +EXT2_GOOD_OLD_INODE_SIZE +
+				     extra_size);
 	/*
 	 * Offer to delete any zero-length files that does not have
 	 * blocks.  If there is an EA block, it might have useful
 	 * information, so we won't prompt to delete it, but let it be
 	 * reconnected to lost+found.
 	 */
-	if (!inode.i_blocks && (LINUX_S_ISREG(inode.i_mode) ||
-				LINUX_S_ISDIR(inode.i_mode))) {
+	if (!inode->i_blocks && eamagic != EXT2_EXT_ATTR_MAGIC &&
+	    (LINUX_S_ISREG(inode->i_mode) || LINUX_S_ISDIR(inode->i_mode))) {
 		if (fix_problem(ctx, PR_4_ZERO_LEN_INODE, &pctx)) {
 			ext2fs_icount_store(ctx->inode_link_info, i, 0);
-			inode.i_links_count = 0;
-			inode.i_dtime = ctx->now;
-			e2fsck_write_inode(ctx, i, &inode,
-					   "disconnect_inode");
+			inode->i_links_count = 0;
+			inode->i_dtime = ctx->now;
+			e2fsck_write_inode(ctx, i, inode, "disconnect_inode");
 			/*
 			 * Fix up the bitmaps...
 			 */
@@ -55,7 +66,7 @@ static int disconnect_inode(e2fsck_t ctx
 			ext2fs_unmark_inode_bitmap(ctx->inode_used_map, i);
 			ext2fs_unmark_inode_bitmap(ctx->inode_dir_map, i);
 			ext2fs_inode_alloc_stats2(fs, i, -1,
-						  LINUX_S_ISDIR(inode.i_mode));
+						  LINUX_S_ISDIR(inode->i_mode));
 			return 0;
 		}
 	}
@@ -83,7 +94,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t	i;
-	struct ext2_inode	inode;
+	struct ext2_inode	*inode;
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 #endif
@@ -111,6 +122,9 @@ void e2fsck_pass4(e2fsck_t ctx)
 		if ((ctx->progress)(ctx, 4, 0, maxgroup))
 			return;
 
+	inode = e2fsck_allocate_memory(ctx, EXT2_INODE_SIZE(fs->super),
+				       "scratch inode");
+
 	/* Protect loop from wrap-around if s_inodes_count maxed */
 	for (i=1; i <= fs->super->s_inodes_count && i > 0; i++) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -138,7 +152,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 				     fs->blocksize, "bad_inode buffer");
 			if (e2fsck_process_bad_inode(ctx, 0, i, buf))
 				continue;
-			if (disconnect_inode(ctx, i))
+			if (disconnect_inode(ctx, i, inode))
 				continue;
 			ext2fs_icount_fetch(ctx->inode_link_info, i,
 					    &link_count);
@@ -146,18 +160,18 @@ void e2fsck_pass4(e2fsck_t ctx)
 					    &link_counted);
 		}
 		if (link_counted != link_count) {
-			e2fsck_read_inode(ctx, i, &inode, "pass4");
+			e2fsck_read_inode(ctx, i, inode, "pass4");
 			pctx.ino = i;
-			pctx.inode = &inode;
-			if (link_count != inode.i_links_count) {
+			pctx.inode = inode;
+			if (link_count != inode->i_links_count) {
 				pctx.num = link_count;
 				fix_problem(ctx,
 					    PR_4_INCONSISTENT_COUNT, &pctx);
 			}
 			pctx.num = link_counted;
 			if (fix_problem(ctx, PR_4_BAD_REF_COUNT, &pctx)) {
-				inode.i_links_count = link_counted;
-				e2fsck_write_inode(ctx, i, &inode, "pass4");
+				inode->i_links_count = link_counted;
+				e2fsck_write_inode(ctx, i, inode, "pass4");
 			}
 		}
 	}
@@ -170,6 +184,8 @@ void e2fsck_pass4(e2fsck_t ctx)
 errout:
 	if (buf)
 		ext2fs_free_mem(&buf);
+
+	ext2fs_free_mem(&inode);
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
Index: e2fsprogs-1.40/e2fsck/util.c
===================================================================
--- e2fsprogs-1.40.orig/e2fsck/util.c
+++ e2fsprogs-1.40/e2fsck/util.c
@@ -361,6 +361,20 @@ void e2fsck_read_inode(e2fsck_t ctx, uns
 	}
 }
 
+void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
+			    struct ext2_inode *inode, int bufsize,
+			    const char *proc)
+{
+	int retval;
+
+	retval = ext2fs_read_inode_full(ctx->fs, ino, inode, bufsize);
+	if (retval) {
+		com_err("ext2fs_read_inode_full", retval,
+			_("while reading inode %ld in %s"), ino, proc);
+		fatal_error(ctx, 0);
+	}
+}
+
 extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 			       struct ext2_inode * inode, int bufsize,
 			       const char *proc)
Index: e2fsprogs-1.40/lib/ext2fs/ext2_ext_attr.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2_ext_attr.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2_ext_attr.h
@@ -30,7 +30,7 @@ struct ext2_ext_attr_entry {
 	__u32	e_value_block;	/* disk block attribute is stored on (n/i) */
 	__u32	e_value_size;	/* size of attribute value */
 	__u32	e_hash;		/* hash value of name and value */
-#if 0
+#if 1
 	char	e_name[0];	/* attribute name */
 #endif
 };
Index: e2fsprogs-1.40/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40/lib/ext2fs/ext2fs.h
@@ -83,10 +83,12 @@ typedef __u32		ext2_dirhash_t;
 #include "com_err.h"
 #include "ext2_io.h"
 #include "ext2_err.h"
+#include "ext2_ext_attr.h"
 #else
 #include <et/com_err.h>
 #include <ext2fs/ext2_io.h>
 #include <ext2fs/ext2_err.h>
+#include <ext2fs/ext2_ext_attr.h>
 #endif
 
 /*
@@ -714,6 +716,8 @@ extern errcode_t ext2fs_dup_handle(ext2_
 extern errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir);
 
 /* ext_attr.c */
+extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
+					void *data);
 extern errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf);
 extern errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block,
 				       void *buf);
Index: e2fsprogs-1.40/lib/ext2fs/ext_attr.c
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/ext_attr.c
+++ e2fsprogs-1.40/lib/ext2fs/ext_attr.c
@@ -23,6 +23,42 @@
 
 #include "ext2fs.h"
 
+#define NAME_HASH_SHIFT 5
+#define VALUE_HASH_SHIFT 16
+
+/*
+ * ext2_xattr_hash_entry()
+ *
+ * Compute the hash of an extended attribute.
+ */
+__u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry, void *data)
+{
+	__u32 hash = 0;
+	char *name = entry->e_name;
+	int n;
+
+	for (n = 0; n < entry->e_name_len; n++) {
+		hash = (hash << NAME_HASH_SHIFT) ^
+		       (hash >> (8*sizeof(hash) - NAME_HASH_SHIFT)) ^
+		       *name++;
+	}
+
+	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+		__u32 *value = (__u32 *)data;
+		for (n = (entry->e_value_size + EXT2_EXT_ATTR_ROUND) >>
+			 EXT2_EXT_ATTR_PAD_BITS; n; n--) {
+			hash = (hash << VALUE_HASH_SHIFT) ^
+			       (hash >> (8*sizeof(hash) - VALUE_HASH_SHIFT)) ^
+			       *value++;
+		}
+	}
+
+	return hash;
+}
+
+#undef NAME_HASH_SHIFT
+#undef VALUE_HASH_SHIFT
+
 errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf)
 {
 	errcode_t	retval;
Index: e2fsprogs-1.40/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40/lib/ext2fs/swapfs.c
@@ -110,6 +110,7 @@ void ext2fs_swap_ext_attr(char *to, char
 		to_header->h_magic    = ext2fs_swab32(from_header->h_magic);
 		to_header->h_blocks   = ext2fs_swab32(from_header->h_blocks);
 		to_header->h_refcount = ext2fs_swab32(from_header->h_refcount);
+		to_header->h_hash     = ext2fs_swab32(from_header->h_hash);
 		for (n=0; n<4; n++)
 			to_header->h_reserved[n] =
 				ext2fs_swab32(from_header->h_reserved[n]);
@@ -124,6 +125,7 @@ void ext2fs_swap_ext_attr(char *to, char
 			ext2fs_swab32(from_entry->e_value_block);
 		to_entry->e_value_size  =	
 			ext2fs_swab32(from_entry->e_value_size);
+		to_entry->e_hash = ext2fs_swab32(from_entry->e_hash);
 		from_entry = EXT2_EXT_ATTR_NEXT(from_entry);
 		to_entry   = EXT2_EXT_ATTR_NEXT(to_entry);
 	}

Thanks,
Kalpak.
