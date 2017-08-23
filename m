From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: add optimization for heavily hard-linked file systems
Date: Wed, 23 Aug 2017 19:23:51 -0400
Message-ID: <20170823232351.643l4wg7pvnnxyts@thunk.org>
References: <20170819011635.1815929-1-dsp@fb.com>
 <20170822022948.nyn6fessudjaj5xh@thunk.org>
 <a4b31ace-3a54-051d-75df-b47452c789cb@uls.co.za>
 <20170822124505.xr7wnxonsbml3mgh@thunk.org>
 <00f408c1-215e-39e2-dec4-8f05eb604f97@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Doug Porter <dsp@fb.com>, linux-ext4@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47518 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdHWXXx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 23 Aug 2017 19:23:53 -0400
Content-Disposition: inline
In-Reply-To: <00f408c1-215e-39e2-dec4-8f05eb604f97@uls.co.za>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jaco,

Here's my revised version of your patch.  The main differences are in
how to enable this optimization, and the fact that this optimizatoin
is disabled by default.  Users will have to either explicitly request
it by using e2fsck -E inode_count_fullmap or via /etc/e2fsck.conf.

Please take a look and let me know what you think.  (And again, if you
could give me permission to add your Signed-off-by, I would appreciate
it.)

Thanks,

					- Ted

commit 75941780c27190c6507aa7ca813caa79638926c8
Author: Jaco Kroon <jaco@uls.co.za>
Date:   Wed Aug 23 14:21:43 2017 -0400

    e2fsck: add optimization for heavily hard-linked file systems
    
    In the case of file system with large number of hard links, e2fsck can
    take a large amount of time in pass 2 due to binary search lookup of
    inode numbers.  This implements a memory trade-off (storing 2 bytes
    in-memory for each inode to store inode counts).
    
    For a 40TB filesystem with 2.8bn inodes this map alone requires 5.7GB
    of RAM.  For this reason, we don't enable this optimization by
    default.  It can be enabled using either an extended option to e2fsck
    or via a seting in e2fsck.conf.
    
    Even when the fullmap optimization is enabled, we don't use this for
    the icount structure in pass 1.  This is because the gain CPU gain is
    nearly nil for that pass and the sacrificed memory does not justify
    the increase in RAM.
    
    (It could be that during pass 1, if more than 17% if possible inodes
    has link_count>1 (466m inodes in the 40TB with 2.8bn possible inodes
    case) then it becomes more memory efficient to use the full map
    implementation in terms of memory.  However, this is extremely
    unlikely given that most file systems are heavily over-provisioned in
    terms of the number of inodes in the system.)
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 786eb15e7..4c29943d3 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -228,7 +228,29 @@ exactly the opposite of discard option. This is set as default.
 .TP
 .BI no_optimize_extents
 Do not offer to optimize the extent tree by eliminating unnecessary
-width or depth.
+width or depth.  This can also be enabled in the options section of
+.BR /etc/e2fsck.conf .
+.TP
+.BI optimize_extents
+Offer to optimize the extent tree by eliminating unnecessary
+width or depth.  This is the default unless otherwise specified in
+.BR /etc/e2fsck.conf .
+.TP
+.BI inode_count_fullmap
+Trade off using memory for speed when checking a file system with a
+large number of hard-linked files.  The amount of memory required is
+proportional to the number of inodes in the file system.  For large file
+systems, this can be gigabytes of memory.  (For example, a 40TB file system
+with 2.8 billion inodes will consume an additional 5.7 GB memory if this
+optimization is enabled.)  This optimization can also be enabled in the
+options section of
+.BR /etc/e2fsck.conf .
+.TP
+.BI no_inode_count_fullmap
+Disable the
+.B inode_count_fullmap
+optimization.  This is the default unless otherwise specified in
+.BR /etc/e2fsck.conf .
 .TP
 .BI readahead_kb
 Use this many KiB of memory to pre-fetch metadata in the hopes of reducing
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index fbde7ef0b..d8205bcf1 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -157,6 +157,15 @@ the average fill ratio of directories can be maintained at a
 higher, more efficient level.  This relation defaults to 20
 percent.
 .TP
+.I inode_count_fullmap
+If this boolean relation is true, trade off using memory for speed when
+checking a file system with a large number of hard-linked files.  The
+amount of memory required is proportional to the number of inodes in the
+file system.  For large file systems, this can be gigabytes of memory.
+(For example a 40TB file system with 2.8 billion inodes will consume an
+additional 5.7 GB memory if this optimization is enabled.)  This setting
+defaults to false.
+.TP
 .I log_dir
 If the
 .I log_filename
@@ -206,8 +215,8 @@ of that type are squelched.  This can be useful if the console is slow
 end up delaying the boot process for a long time (potentially hours).
 .TP
 .I no_optimize_extents
-Do not offer to optimize the extent tree by eliminating unnecessary
-width or depth.
+If this boolean relation is true, do not offer to optimize the extent
+tree by reducing the tree's width or depth.  This setting defaults to false.
 .TP
 .I readahead_mem_pct
 Use this percentage of memory to try to read in metadata blocks ahead of the
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 81c09d7eb..12855453d 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -170,6 +170,7 @@ struct resource_track {
 #define E2F_OPT_CONVERT_BMAP	0x4000 /* convert blockmap to extent */
 #define E2F_OPT_FIXES_ONLY	0x8000 /* skip all optimizations */
 #define E2F_OPT_NOOPT_EXTENTS	0x10000 /* don't optimize extents */
+#define E2F_OPT_ICOUNT_FULLMAP	0x20000 /* don't optimize extents */
 
 /*
  * E2fsck flags
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index bc26beb99..6442c9449 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -711,6 +711,7 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
 	errcode_t		retval;
 	char			*tdb_dir;
 	int			enable;
+	int			full_map;
 
 	*ret = 0;
 
@@ -734,6 +735,8 @@ extern errcode_t e2fsck_setup_icount(e2fsck_t ctx, const char *icount_name,
 	}
 	e2fsck_set_bitmap_type(ctx->fs, EXT2FS_BMAP64_RBTREE, icount_name,
 			       &save_type);
+	if (ctx->options & E2F_OPT_ICOUNT_FULLMAP)
+		flags |= EXT2_ICOUNT_OPT_FULLMAP;
 	retval = ext2fs_create_icount2(ctx->fs, flags, 0, hint, ret);
 	ctx->fs->default_bitmap_type = save_type;
 	return retval;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index ff961483b..939862f1a 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -709,9 +709,18 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		} else if (strcmp(token, "nodiscard") == 0) {
 			ctx->options &= ~E2F_OPT_DISCARD;
 			continue;
+		} else if (strcmp(token, "optimize_extents") == 0) {
+			ctx->options &= ~E2F_OPT_NOOPT_EXTENTS;
+			continue;
 		} else if (strcmp(token, "no_optimize_extents") == 0) {
 			ctx->options |= E2F_OPT_NOOPT_EXTENTS;
 			continue;
+		} else if (strcmp(token, "inode_count_fullmap") == 0) {
+			ctx->options |= E2F_OPT_ICOUNT_FULLMAP;
+			continue;
+		} else if (strcmp(token, "no_inode_count_fullmap") == 0) {
+			ctx->options &= ~E2F_OPT_ICOUNT_FULLMAP;
+			continue;
 		} else if (strcmp(token, "log_filename") == 0) {
 			if (!arg)
 				extended_usage++;
@@ -733,17 +742,21 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 	free(buf);
 
 	if (extended_usage) {
-		fputs(("\nExtended options are separated by commas, "
+		fputs(_("\nExtended options are separated by commas, "
 		       "and may take an argument which\n"
 		       "is set off by an equals ('=') sign.  "
-		       "Valid extended options are:\n"), stderr);
-		fputs(("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
-		fputs(("\tfragcheck\n"), stderr);
-		fputs(("\tjournal_only\n"), stderr);
-		fputs(("\tdiscard\n"), stderr);
-		fputs(("\tnodiscard\n"), stderr);
-		fputs(("\treadahead_kb=<buffer size>\n"), stderr);
-		fputs(("\tbmap2extent\n"), stderr);
+		       "Valid extended options are:\n\n"), stderr);
+		fputs(_("\tea_ver=<ea_version (1 or 2)>\n"), stderr);
+		fputs("\tfragcheck\n", stderr);
+		fputs("\tjournal_only\n", stderr);
+		fputs("\tdiscard\n", stderr);
+		fputs("\tnodiscard\n", stderr);
+		fputs("\toptimize_extents\n", stderr);
+		fputs("\tno_optimize_extents\n", stderr);
+		fputs("\tinode_count_fullmap\n", stderr);
+		fputs("\tno_inode_count_fullmap\n", stderr);
+		fputs(_("\treadahead_kb=<buffer size>\n"), stderr);
+		fputs("\tbmap2extent\n", stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -1015,6 +1028,11 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if (c)
 		ctx->options |= E2F_OPT_NOOPT_EXTENTS;
 
+	profile_get_boolean(ctx->profile, "options", "inode_count_fullmap",
+			    0, 0, &c);
+	if (c)
+		ctx->options |= E2F_OPT_ICOUNT_FULLMAP;
+
 	if (ctx->readahead_kb == ~0ULL) {
 		profile_get_integer(ctx->profile, "options",
 				    "readahead_mem_pct", 0, -1, &c);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8ff49ca66..68d0e2a57 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -532,6 +532,7 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
  * ext2_icount_t abstraction
  */
 #define EXT2_ICOUNT_OPT_INCREMENT	0x01
+#define EXT2_ICOUNT_OPT_FULLMAP		0x02
 
 typedef struct ext2_icount *ext2_icount_t;
 
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index 594b1cc2b..65420e9f3 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -61,6 +61,7 @@ struct ext2_icount {
 	char			*tdb_fn;
 	TDB_CONTEXT		*tdb;
 #endif
+	__u16			*fullmap;
 };
 
 /*
@@ -93,6 +94,9 @@ void ext2fs_free_icount(ext2_icount_t icount)
 	}
 #endif
 
+	if (icount->fullmap)
+		ext2fs_free_mem(&icount->fullmap);
+
 	ext2fs_free_mem(&icount);
 }
 
@@ -108,10 +112,24 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 		return retval;
 	memset(icount, 0, sizeof(struct ext2_icount));
 
+	if ((flags & EXT2_ICOUNT_OPT_FULLMAP) &&
+	    (flags & EXT2_ICOUNT_OPT_INCREMENT)) {
+		retval = ext2fs_get_mem((sizeof(__u32) *
+					 fs->super->s_inodes_count),
+					&icount->fullmap);
+		/* If we can't allocate, fall back */
+		if (!retval) {
+			memset(icount->fullmap, 0,
+			       sizeof(__u32) * fs->super->s_inodes_count);
+			goto successout;
+		}
+	}
+
 	retval = ext2fs_allocate_inode_bitmap(fs, "icount", &icount->single);
 	if (retval)
 		goto errout;
 
+
 	if (flags & EXT2_ICOUNT_OPT_INCREMENT) {
 		retval = ext2fs_allocate_inode_bitmap(fs, "icount_inc",
 						      &icount->multiple);
@@ -120,6 +138,7 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 	} else
 		icount->multiple = 0;
 
+successout:
 	icount->magic = EXT2_ET_MAGIC_ICOUNT;
 	icount->num_inodes = fs->super->s_inodes_count;
 
@@ -256,6 +275,9 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, unsigned int size,
 	if (retval)
 		return retval;
 
+	if (icount->fullmap)
+		goto successout;
+
 	if (size) {
 		icount->size = size;
 	} else {
@@ -295,6 +317,7 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, unsigned int size,
 		icount->count = hint->count;
 	}
 
+successout:
 	*ret = icount;
 	return 0;
 
@@ -433,6 +456,11 @@ static errcode_t set_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 		return 0;
 	}
 #endif
+	if (icount->fullmap) {
+		icount->fullmap[ino] = icount_16_xlate(count);
+		return 0;
+	}
+
 	el = get_icount_el(icount, ino, 1);
 	if (!el)
 		return EXT2_ET_NO_MEMORY;
@@ -463,6 +491,11 @@ static errcode_t get_inode_count(ext2_icount_t icount, ext2_ino_t ino,
 		return 0;
 	}
 #endif
+	if (icount->fullmap) {
+		*count = icount->fullmap[ino];
+		return 0;
+	}
+
 	el = get_icount_el(icount, ino, 0);
 	if (!el) {
 		*count = 0;
@@ -504,14 +537,16 @@ errcode_t ext2fs_icount_fetch(ext2_icount_t icount, ext2_ino_t ino, __u16 *ret)
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
-		*ret = 1;
-		return 0;
-	}
-	if (icount->multiple &&
-	    !ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
-		*ret = 0;
-		return 0;
+	if (!icount->fullmap) {
+		if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
+			*ret = 1;
+			return 0;
+		}
+		if (icount->multiple &&
+			!ext2fs_test_inode_bitmap2(icount->multiple, ino)) {
+			*ret = 0;
+			return 0;
+		}
 	}
 	get_inode_count(icount, ino, &val);
 	*ret = icount_16_xlate(val);
@@ -528,7 +563,10 @@ errcode_t ext2fs_icount_increment(ext2_icount_t icount, ext2_ino_t ino,
 	if (!ino || (ino > icount->num_inodes))
 		return EXT2_ET_INVALID_ARGUMENT;
 
-	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
+	if (icount->fullmap) {
+		curr_value = icount_16_xlate(icount->fullmap[ino] + 1);
+		icount->fullmap[ino] = curr_value;
+	} else if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		/*
 		 * If the existing count is 1, then we know there is
 		 * no entry in the list.
@@ -585,6 +623,16 @@ errcode_t ext2fs_icount_decrement(ext2_icount_t icount, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
+	if (icount->fullmap) {
+		if (!icount->fullmap[ino])
+			return EXT2_ET_INVALID_ARGUMENT;
+
+		curr_value = --icount->fullmap[ino];
+		if (ret)
+			*ret = icount_16_xlate(curr_value);
+		return 0;
+	}
+
 	if (ext2fs_test_inode_bitmap2(icount->single, ino)) {
 		ext2fs_unmark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
@@ -626,6 +674,9 @@ errcode_t ext2fs_icount_store(ext2_icount_t icount, ext2_ino_t ino,
 
 	EXT2_CHECK_MAGIC(icount, EXT2_ET_MAGIC_ICOUNT);
 
+	if (icount->fullmap)
+		return set_inode_count(icount, ino, count);
+
 	if (count == 1) {
 		ext2fs_mark_inode_bitmap2(icount->single, ino);
 		if (icount->multiple)
