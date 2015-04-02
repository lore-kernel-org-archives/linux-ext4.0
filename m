From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/35] e2fsck: read-ahead metadata during passes 1, 2, and 4
Date: Wed, 01 Apr 2015 19:34:27 -0700
Message-ID: <20150402023427.25243.66810.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35287 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbDBCeb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:31 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2fsck pass1 is modified to use the block group data prefetch function
to try to fetch the inode tables into the pagecache before it is
needed.  We iterate through the blockgroups until we have enough inode
tables that need reading such that we can issue readahead; then we sit
and wait until the last inode table block read of the last group to
start fetching the next bunch.

pass2 is modified to use the dirblock prefetching function to prefetch
the list of directory blocks that are assembled in pass1.  We use the
"iterate a subset of a dblist" and avoid copying the dblist.  Directory
blocks are fetched incrementally as we walk through the directory
block list.  In previous iterations of this patch we would free the
directory blocks after processing, but the performance hit to e2fsck
itself wasn't worth it.  Furthermore, it is anticipated that most
users will then mount the FS and start using the directories, so they
may as well remain in the page cache.

pass4 is modified to prefetch the block and inode bitmaps in
anticipation of pass 5, because pass4 is entirely CPU bound.

In general, these mechanisms can decrease fsck time by 10-40%, if the
host system has sufficient memory and the storage system can provide a
lot of IOPs.  Pretty much any storage system capable of handling
multiple IOs in-flight at any time will see a fairly large performance
boost.  (Single-issue USB mass storage disks seem to suffer badly.)

By default, the readahead buffer size will be set to the size of a block
group's inode table (which is 2MiB for a regular ext4 FS).  The -E
readahead_kb= option can be given to specify the amount of memory to
use for readahead or zero to disable it entirely; or an option can be
given in e2fsck.conf.

v2: Fix an off-by-one error in the pass1 readahead which made the
readahead trigger one inode too late if the block groups are full.

v3: Use the dblist partial iterator function to read ahead parts
of the directory block list in pass 2, instead of making sublists.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.8.in      |    7 +++++
 e2fsck/e2fsck.conf.5.in |   15 +++++++++++
 e2fsck/e2fsck.h         |    3 ++
 e2fsck/pass1.c          |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 e2fsck/pass2.c          |   38 +++++++++++++++++++++++++++
 e2fsck/pass4.c          |    9 +++++++
 e2fsck/unix.c           |   28 ++++++++++++++++++++
 lib/ext2fs/ext2fs.h     |    1 +
 lib/ext2fs/inode.c      |    3 +-
 9 files changed, 167 insertions(+), 2 deletions(-)


diff --git a/e2fsck/e2fsck.8.in b/e2fsck/e2fsck.8.in
index 3367f4f..270727a 100644
--- a/e2fsck/e2fsck.8.in
+++ b/e2fsck/e2fsck.8.in
@@ -220,6 +220,13 @@ option may prevent you from further manual data recovery.
 .BI nodiscard
 Do not attempt to discard free blocks and unused inode blocks. This option is
 exactly the opposite of discard option. This is set as default.
+.TP
+.BI readahead_kb
+Use this many KiB of memory to pre-fetch metadata in the hopes of reducing
+e2fsck runtime.  By default, this is set to the size of two block groups' inode
+tables (typically 4MiB on a regular ext4 filesystem); if this amount is more
+than 1/50th of total physical memory, readahead is disabled.  Set this to zero
+to disable readahead entirely.
 .RE
 .TP
 .B \-f
diff --git a/e2fsck/e2fsck.conf.5.in b/e2fsck/e2fsck.conf.5.in
index 9ebfbbf..ab83180 100644
--- a/e2fsck/e2fsck.conf.5.in
+++ b/e2fsck/e2fsck.conf.5.in
@@ -205,6 +205,21 @@ of that type are squelched.  This can be useful if the console is slow
 (i.e., connected to a serial port) and so a large amount of output could
 end up delaying the boot process for a long time (potentially hours).
 .TP
+.I readahead_mem_pct
+Use this percentage of memory to try to read in metadata blocks ahead of the
+main e2fsck thread.  This should reduce run times, depending on the speed of
+the underlying storage and the amount of free memory.  There is no default, but
+see
+.B readahead_mem_pct
+for more details.
+.TP
+.I readahead_kb
+Use this amount of memory to read in metadata blocks ahead of the main checking
+thread.  Setting this value to zero disables readahead entirely.  By default,
+this is set the size of two block groups' inode tables (typically 4MiB on a
+regular ext4 filesystem); if this amount is more than 1/50th of total physical
+memory, readahead is disabled.
+.TP
 .I report_features
 If this boolean relation is true, e2fsck will print the file system
 features as part of its verbose reporting (i.e., if the
diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index b8795a8..a0e03e3 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -379,6 +379,9 @@ struct e2fsck_struct {
 	 */
 	void *priv_data;
 	ext2fs_block_bitmap block_metadata_map; /* Metadata blocks */
+
+	/* How much are we allowed to readahead? */
+	unsigned long long readahead_kb;
 };
 
 /* Used by the region allocation code */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index bf95ae1..993aedd 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -898,6 +898,60 @@ out:
 	return 0;
 }
 
+static void pass1_readahead(e2fsck_t ctx, dgrp_t *group, ext2_ino_t *next_ino)
+{
+	ext2_ino_t inodes_in_group = 0, inodes_per_block, inodes_per_buffer;
+	dgrp_t start = *group, grp;
+	blk64_t blocks_to_read = 0;
+	errcode_t err = EXT2_ET_INVALID_ARGUMENT;
+
+	if (ctx->readahead_kb == 0)
+		goto out;
+
+	/* Keep iterating groups until we have enough to readahead */
+	inodes_per_block = EXT2_INODES_PER_BLOCK(ctx->fs->super);
+	for (grp = start; grp < ctx->fs->group_desc_count; grp++) {
+		if (ext2fs_bg_flags_test(ctx->fs, grp, EXT2_BG_INODE_UNINIT))
+			continue;
+		inodes_in_group = ctx->fs->super->s_inodes_per_group -
+					ext2fs_bg_itable_unused(ctx->fs, grp);
+		blocks_to_read += (inodes_in_group + inodes_per_block - 1) /
+					inodes_per_block;
+		if (blocks_to_read * ctx->fs->blocksize >
+		    ctx->readahead_kb * 1024)
+			break;
+	}
+
+	err = e2fsck_readahead(ctx->fs, E2FSCK_READA_ITABLE, start,
+			       grp - start + 1);
+	if (err == EAGAIN) {
+		ctx->readahead_kb /= 2;
+		err = 0;
+	}
+
+out:
+	if (err) {
+		/* Error; disable itable readahead */
+		*group = ctx->fs->group_desc_count;
+		*next_ino = ctx->fs->super->s_inodes_count;
+	} else {
+		/*
+		 * Don't do more readahead until we've reached the first inode
+		 * of the last inode scan buffer block for the last group.
+		 */
+		*group = grp + 1;
+		inodes_per_buffer = (ctx->inode_buffer_blocks ?
+				     ctx->inode_buffer_blocks :
+				     EXT2_INODE_SCAN_DEFAULT_BUFFER_BLOCKS) *
+				    ctx->fs->blocksize /
+				    EXT2_INODE_SIZE(ctx->fs->super);
+		inodes_in_group--;
+		*next_ino = inodes_in_group -
+			    (inodes_in_group % inodes_per_buffer) + 1 +
+			    (grp * ctx->fs->super->s_inodes_per_group);
+	}
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -920,10 +974,19 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		low_dtime_check = 1;
 	int		inode_size;
 	int		failed_csum = 0;
+	ext2_ino_t	ino_threshold = 0;
+	dgrp_t		ra_group = 0;
 
 	init_resource_track(&rtrack, ctx->fs->io);
 	clear_problem_context(&pctx);
 
+	/* If we can do readahead, figure out how many groups to pull in. */
+	if (!e2fsck_can_readahead(ctx->fs))
+		ctx->readahead_kb = 0;
+	else if (ctx->readahead_kb == ~0ULL)
+		ctx->readahead_kb = e2fsck_guess_readahead(ctx->fs);
+	pass1_readahead(ctx, &ra_group, &ino_threshold);
+
 	if (!(ctx->options & E2F_OPT_PREEN))
 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
 
@@ -1103,6 +1166,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
 							  inode, inode_size);
+		if (ino > ino_threshold)
+			pass1_readahead(ctx, &ra_group, &ino_threshold);
 		ehandler_operation(old_op);
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			return;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 94665c6..120f611 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -61,6 +61,9 @@
  * Keeps track of how many times an inode is referenced.
  */
 static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf);
+static int check_dir_block2(ext2_filsys fs,
+			   struct ext2_db_entry2 *dir_blocks_info,
+			   void *priv_data);
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *dir_blocks_info,
 			   void *priv_data);
@@ -77,6 +80,9 @@ struct check_dir_struct {
 	struct problem_context	pctx;
 	int	count, max;
 	e2fsck_t ctx;
+	unsigned long long list_offset;
+	unsigned long long ra_entries;
+	unsigned long long next_ra_off;
 };
 
 void e2fsck_pass2(e2fsck_t ctx)
@@ -96,6 +102,9 @@ void e2fsck_pass2(e2fsck_t ctx)
 	int			i, depth;
 	problem_t		code;
 	int			bad_dir;
+	int (*check_dir_func)(ext2_filsys fs,
+			      struct ext2_db_entry2 *dir_blocks_info,
+			      void *priv_data);
 
 	init_resource_track(&rtrack, ctx->fs->io);
 	clear_problem_context(&cd.pctx);
@@ -139,6 +148,9 @@ void e2fsck_pass2(e2fsck_t ctx)
 	cd.ctx = ctx;
 	cd.count = 1;
 	cd.max = ext2fs_dblist_count2(fs->dblist);
+	cd.list_offset = 0;
+	cd.ra_entries = ctx->readahead_kb * 1024 / ctx->fs->blocksize;
+	cd.next_ra_off = 0;
 
 	if (ctx->progress)
 		(void) (ctx->progress)(ctx, 2, 0, cd.max);
@@ -146,7 +158,8 @@ void e2fsck_pass2(e2fsck_t ctx)
 	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
 		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
 
-	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_block,
+	check_dir_func = cd.ra_entries ? check_dir_block2 : check_dir_block;
+	cd.pctx.errcode = ext2fs_dblist_iterate2(fs->dblist, check_dir_func,
 						 &cd);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK || ctx->flags & E2F_FLAG_RESTART)
 		return;
@@ -868,6 +881,29 @@ int get_filename_hash(ext2_filsys fs, int encrypted, int version,
 			      ret_hash, ret_minor_hash);
 }
 
+static int check_dir_block2(ext2_filsys fs,
+			   struct ext2_db_entry2 *db,
+			   void *priv_data)
+{
+	int err;
+	struct check_dir_struct *cd = priv_data;
+
+	if (cd->ra_entries && cd->list_offset >= cd->next_ra_off) {
+		err = e2fsck_readahead_dblist(fs,
+					E2FSCK_RA_DBLIST_IGNORE_BLOCKCNT,
+					fs->dblist,
+					cd->list_offset + cd->ra_entries / 8,
+					cd->ra_entries);
+		if (err)
+			cd->ra_entries = 0;
+		cd->next_ra_off = cd->list_offset + (cd->ra_entries * 7 / 8);
+	}
+
+	err = check_dir_block(fs, db, priv_data);
+	cd->list_offset++;
+	return err;
+}
+
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
 			   void *priv_data)
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 21d93f0..bc9a2c4 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -106,6 +106,15 @@ void e2fsck_pass4(e2fsck_t ctx)
 #ifdef MTRACE
 	mtrace_print("Pass 4");
 #endif
+	/*
+	 * Since pass4 is mostly CPU bound, start readahead of bitmaps
+	 * ahead of pass 5 if we haven't already loaded them.
+	 */
+	if (ctx->readahead_kb &&
+	    (fs->block_map == NULL || fs->inode_map == NULL))
+		e2fsck_readahead(fs, E2FSCK_READA_BBITMAP |
+				     E2FSCK_READA_IBITMAP,
+				 0, fs->group_desc_count);
 
 	clear_problem_context(&pctx);
 
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index e629136..f45a903 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -650,6 +650,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 	char	*buf, *token, *next, *p, *arg;
 	int	ea_ver;
 	int	extended_usage = 0;
+	unsigned long long reada_kb;
 
 	buf = string_copy(ctx, opts, 0);
 	for (token = buf; token && *token; token = next) {
@@ -678,6 +679,15 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 				continue;
 			}
 			ctx->ext_attr_ver = ea_ver;
+		} else if (strcmp(token, "readahead_kb") == 0) {
+			reada_kb = strtoull(arg, &p, 0);
+			if (*p) {
+				fprintf(stderr, "%s",
+					_("Invalid readahead buffer size.\n"));
+				extended_usage++;
+				continue;
+			}
+			ctx->readahead_kb = reada_kb;
 		} else if (strcmp(token, "fragcheck") == 0) {
 			ctx->options |= E2F_OPT_FRAGCHECK;
 			continue;
@@ -717,6 +727,7 @@ static void parse_extended_opts(e2fsck_t ctx, const char *opts)
 		fputs(("\tjournal_only\n"), stderr);
 		fputs(("\tdiscard\n"), stderr);
 		fputs(("\tnodiscard\n"), stderr);
+		fputs(("\treadahead_kb=<buffer size>\n"), stderr);
 		fputc('\n', stderr);
 		exit(1);
 	}
@@ -750,6 +761,7 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 #ifdef CONFIG_JBD_DEBUG
 	char 		*jbd_debug;
 #endif
+	unsigned long long phys_mem_kb;
 
 	retval = e2fsck_allocate_context(&ctx);
 	if (retval)
@@ -777,6 +789,8 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	else
 		ctx->program_name = "e2fsck";
 
+	phys_mem_kb = get_memory_size() / 1024;
+	ctx->readahead_kb = ~0ULL;
 	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
 		case 'C':
@@ -961,6 +975,20 @@ static errcode_t PRS(int argc, char *argv[], e2fsck_t *ret_ctx)
 	if (c)
 		verbose = 1;
 
+	if (ctx->readahead_kb == ~0ULL) {
+		profile_get_integer(ctx->profile, "options",
+				    "readahead_mem_pct", 0, -1, &c);
+		if (c >= 0 && c <= 100)
+			ctx->readahead_kb = phys_mem_kb * c / 100;
+		profile_get_integer(ctx->profile, "options",
+				    "readahead_kb", 0, -1, &c);
+		if (c >= 0)
+			ctx->readahead_kb = c;
+		if (ctx->readahead_kb != ~0ULL &&
+		    ctx->readahead_kb > phys_mem_kb)
+			ctx->readahead_kb = phys_mem_kb;
+	}
+
 	/* Turn off discard in read-only mode */
 	if ((ctx->options & E2F_OPT_NO) &&
 	    (ctx->options & E2F_OPT_DISCARD))
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 5084d88..d4f6c8e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1424,6 +1424,7 @@ extern errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan,
 					    ext2_ino_t *ino,
 					    struct ext2_inode *inode,
 					    int bufsize);
+#define EXT2_INODE_SCAN_DEFAULT_BUFFER_BLOCKS	8
 extern errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 				  ext2_inode_scan *ret_scan);
 extern void ext2fs_close_inode_scan(ext2_inode_scan scan);
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 8cc0eb8..58389a8 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -175,7 +175,8 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	scan->bytes_left = 0;
 	scan->current_group = 0;
 	scan->groups_left = fs->group_desc_count - 1;
-	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks : 8;
+	scan->inode_buffer_blocks = buffer_blocks ? buffer_blocks :
+				    EXT2_INODE_SCAN_DEFAULT_BUFFER_BLOCKS;
 	scan->current_block = ext2fs_inode_table_loc(scan->fs,
 						     scan->current_group);
 	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);

