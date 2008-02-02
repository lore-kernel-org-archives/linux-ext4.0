From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] [2/28] e2fsprogs-eacheck.patch
Date: Sat, 02 Feb 2008 01:16:32 -0700
Message-ID: <20080202081632.GB31694@webber.adilger.int>
References: <20080202075943.GB23836@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58267 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725AbYBBIQg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Feb 2008 03:16:36 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m128GZZx016422
	for <linux-ext4@vger.kernel.org>; Sat, 2 Feb 2008 00:16:35 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JVL00M01QSZER00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 02 Feb 2008 00:16:35 -0800 (PST)
In-reply-to: <20080202075943.GB23836@webber.adilger.int>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Verify in-inode EA structure.
Allow in-inode EAs to have a checksum.
Connect zero-length inodes that have an EA to lost+found.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: e2fsprogs-1.40.5/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.5/e2fsck/e2fsck.h
@@ -478,6 +478,9 @@ extern void init_resource_track(struct r
 extern int inode_has_valid_blocks(struct ext2_inode *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
 			      struct ext2_inode * inode, const char * proc);
+extern void e2fsck_read_inode_full(e2fsck_t ctx, unsigned long ino,
+				   struct ext2_inode *inode,
+				   const int bufsize, const char *proc);
 extern void e2fsck_write_inode(e2fsck_t ctx, unsigned long ino,
 			       struct ext2_inode * inode, const char * proc);
 extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
Index: e2fsprogs-1.40.5/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.5/e2fsck/pass1.c
@@ -264,6 +264,7 @@ static void check_ea_in_inode(e2fsck_t c
 	remain = storage_size - sizeof(__u32); 
 
 	while (!EXT2_EXT_IS_LAST_ENTRY(entry)) {
+		__u32 hash;
 
 		/* header eats this space */
 		remain -= sizeof(struct ext2_ext_attr_entry);
@@ -291,9 +292,12 @@ static void check_ea_in_inode(e2fsck_t c
 			problem = PR_1_ATTR_VALUE_BLOCK;
 			goto fix;
 		}
-		
-		/* e_hash must be 0 in inode's ea */
-		if (entry->e_hash != 0) {
+
+		hash = ext2fs_ext_attr_hash_entry(entry,
+						  start + entry->e_value_offs);
+
+		/* e_hash may be 0 in older inode's ea */
+		if (entry->e_hash != 0 && entry->e_hash != hash) {
 			pctx->num = entry->e_hash;
 			problem = PR_1_ATTR_HASH;
 			goto fix;
@@ -308,15 +312,12 @@ fix:
 	 * it seems like a corruption. it's very unlikely we could repair
 	 * EA(s) in automatic fashion -bzzz
 	 */
-#if 0
-	problem = PR_1_ATTR_HASH;
-#endif
 	if (problem == 0 || !fix_problem(ctx, problem, pctx))
 		return;
 
-	/* simple remove all possible EA(s) */
+	/* simply remove all remaining EA(s) */
 	*((__u32 *)start) = 0UL;
-	e2fsck_write_inode_full(ctx, pctx->ino, pctx->inode,
+	e2fsck_write_inode_full(ctx, pctx->ino,(struct ext2_inode *)pctx->inode,
 				EXT2_INODE_SIZE(sb), "pass1");
 }
 
@@ -1360,10 +1361,13 @@ static int check_ext_attr(e2fsck_t ctx, 
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
@@ -1371,6 +1375,7 @@ static int check_ext_attr(e2fsck_t ctx, 
 		     entry->e_name_index == 0)) {
 			if (fix_problem(ctx, PR_1_EA_BAD_NAME, pctx))
 				goto clear_extattr;
+			break;
 		}
 		if (entry->e_value_block != 0) {
 			if (fix_problem(ctx, PR_1_EA_BAD_VALUE, pctx))
@@ -1387,6 +1392,17 @@ static int check_ext_attr(e2fsck_t ctx, 
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
@@ -1508,8 +1524,11 @@ static void check_blocks(e2fsck_t ctx, s
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
Index: e2fsprogs-1.40.5/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.5/e2fsck/pass4.c
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
Index: e2fsprogs-1.40.5/e2fsck/problem.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/problem.c
+++ e2fsprogs-1.40.5/e2fsck/problem.c
@@ -776,7 +776,7 @@ static struct e2fsck_problem problem_tab
 
 	/* invalid ea entry->e_hash */	
 	{ PR_1_ATTR_HASH,
-	  N_("@a in @i %i has a hash (%N) which is @n (must be 0)\n"),
+	  N_("@a in @i %i has a hash (%N) which is @n\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
 	/* inode appears to be a directory */
Index: e2fsprogs-1.40.5/e2fsck/util.c
===================================================================
--- e2fsprogs-1.40.5.orig/e2fsck/util.c
+++ e2fsprogs-1.40.5/e2fsck/util.c
@@ -393,6 +393,20 @@ void e2fsck_read_inode(e2fsck_t ctx, uns
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
Index: e2fsprogs-1.40.5/lib/ext2fs/ext2_ext_attr.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext2_ext_attr.h
+++ e2fsprogs-1.40.5/lib/ext2fs/ext2_ext_attr.h
@@ -30,7 +30,7 @@ struct ext2_ext_attr_entry {
 	__u32	e_value_block;	/* disk block attribute is stored on (n/i) */
 	__u32	e_value_size;	/* size of attribute value */
 	__u32	e_hash;		/* hash value of name and value */
-#if 0
+#if 1
 	char	e_name[0];	/* attribute name */
 #endif
 };
Index: e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.5/lib/ext2fs/ext2fs.h
@@ -75,10 +75,12 @@ typedef __u32		ext2_dirhash_t;
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
@@ -711,6 +713,8 @@ extern errcode_t ext2fs_dup_handle(ext2_
 extern errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir);
 
 /* ext_attr.c */
+extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
+					void *data);
 extern errcode_t ext2fs_read_ext_attr(ext2_filsys fs, blk_t block, void *buf);
 extern errcode_t ext2fs_write_ext_attr(ext2_filsys fs, blk_t block,
 				       void *buf);
@@ -961,6 +965,10 @@ extern errcode_t ext2fs_create_resize_in
 /* swapfs.c */
 extern void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, 
 				 int has_header);
+extern void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
+					struct ext2_ext_attr_header *from_hdr);
+extern void ext2fs_swap_ext_attr_entry(struct ext2_ext_attr_entry *to_entry,
+				       struct ext2_ext_attr_entry *from_entry);
 extern void ext2fs_swap_super(struct ext2_super_block * super);
 extern void ext2fs_swap_group_desc(struct ext2_group_desc *gdp);
 extern void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
Index: e2fsprogs-1.40.5/lib/ext2fs/ext_attr.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/ext_attr.c
+++ e2fsprogs-1.40.5/lib/ext2fs/ext_attr.c
@@ -23,6 +23,43 @@
 
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
+	/* The hash needs to be calculated on the data in little-endian. */
+	if (entry->e_value_block == 0 && entry->e_value_size != 0) {
+		__u32 *value = (__u32 *)data;
+		for (n = (entry->e_value_size + EXT2_EXT_ATTR_ROUND) >>
+			 EXT2_EXT_ATTR_PAD_BITS; n; n--) {
+			hash = (hash << VALUE_HASH_SHIFT) ^
+			       (hash >> (8*sizeof(hash) - VALUE_HASH_SHIFT)) ^
+			       ext2fs_le32_to_cpu(*value++);
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
Index: e2fsprogs-1.40.5/lib/ext2fs/swapfs.c
===================================================================
--- e2fsprogs-1.40.5.orig/lib/ext2fs/swapfs.c
+++ e2fsprogs-1.40.5/lib/ext2fs/swapfs.c
@@ -90,6 +90,29 @@ void ext2fs_swap_group_desc(struct ext2_
 	gdp->bg_checksum = ext2fs_swab16(gdp->bg_checksum);
 }
 
+void ext2fs_swap_ext_attr_header(struct ext2_ext_attr_header *to_header,
+				 struct ext2_ext_attr_header *from_header)
+{
+	int n;
+
+	to_header->h_magic    = ext2fs_swab32(from_header->h_magic);
+	to_header->h_blocks   = ext2fs_swab32(from_header->h_blocks);
+	to_header->h_refcount = ext2fs_swab32(from_header->h_refcount);
+	to_header->h_hash     = ext2fs_swab32(from_header->h_hash);
+	for (n = 0; n < 4; n++)
+		to_header->h_reserved[n] =
+			ext2fs_swab32(from_header->h_reserved[n]);
+}
+
+void ext2fs_swap_ext_attr_entry(struct ext2_ext_attr_entry *to_entry,
+				struct ext2_ext_attr_entry *from_entry)
+{
+	to_entry->e_value_offs  = ext2fs_swab16(from_entry->e_value_offs);
+	to_entry->e_value_block = ext2fs_swab32(from_entry->e_value_block);
+	to_entry->e_value_size  = ext2fs_swab32(from_entry->e_value_size);
+	to_entry->e_hash	= ext2fs_swab32(from_entry->e_hash);
+}
+
 void ext2fs_swap_ext_attr(char *to, char *from, int bufsize, int has_header)
 {
 	struct ext2_ext_attr_header *from_header =
@@ -98,32 +121,22 @@ void ext2fs_swap_ext_attr(char *to, char
 		(struct ext2_ext_attr_header *)to;
 	struct ext2_ext_attr_entry *from_entry, *to_entry;
 	char *from_end = (char *)from_header + bufsize;
-	int n;
 
 	if (to_header != from_header)
 		memcpy(to_header, from_header, bufsize);
 
-	from_entry = (struct ext2_ext_attr_entry *)from_header;
-	to_entry   = (struct ext2_ext_attr_entry *)to_header;
-
 	if (has_header) {
-		to_header->h_magic    = ext2fs_swab32(from_header->h_magic);
-		to_header->h_blocks   = ext2fs_swab32(from_header->h_blocks);
-		to_header->h_refcount = ext2fs_swab32(from_header->h_refcount);
-		for (n=0; n<4; n++)
-			to_header->h_reserved[n] =
-				ext2fs_swab32(from_header->h_reserved[n]);
+		ext2fs_swap_ext_attr_header(to_header, from_header);
+
 		from_entry = (struct ext2_ext_attr_entry *)(from_header+1);
 		to_entry   = (struct ext2_ext_attr_entry *)(to_header+1);
+	} else {
+		from_entry = (struct ext2_ext_attr_entry *)from_header;
+		to_entry   = (struct ext2_ext_attr_entry *)to_header;
 	}
 
 	while ((char *)from_entry < from_end && *(__u32 *)from_entry) {
-		to_entry->e_value_offs  =	
-			ext2fs_swab16(from_entry->e_value_offs);
-		to_entry->e_value_block =	
-			ext2fs_swab32(from_entry->e_value_block);
-		to_entry->e_value_size  =	
-			ext2fs_swab32(from_entry->e_value_size);
+		ext2fs_swap_ext_attr_entry(to_entry, from_entry);
 		from_entry = EXT2_EXT_ATTR_NEXT(from_entry);
 		to_entry   = EXT2_EXT_ATTR_NEXT(to_entry);
 	}

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
