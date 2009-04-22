From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: 32TB ext4 fsck times
Date: Wed, 22 Apr 2009 19:18:16 -0400
Message-ID: <20090422231816.GA7066@shell>
References: <10039.1240286799@gamaville.dokosmarshall.org> <49EE1F06.5040508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZDVXST (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Apr 2009 19:18:19 -0400
Content-Disposition: inline
In-Reply-To: <49EE1F06.5040508@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 21, 2009 at 03:31:18PM -0400, Ric Wheeler wrote:
> Nick Dokos wrote:
> >Now that 64-bit e2fsck can run to completion on a (newly-minted, never
> >mounted) filesystem, here are some numbers. They must be taken with
> >a large grain of salt of course, given the unrealistict situation, but
> >they might be reasonable lower bounds of what one might expect.
> >
> >First, the disks are 300GB SCSI 15K rpm - there are 28 disks per RAID
> >controller and they are striped into 2TiB volumes (that's a limitation
> >of the hardware). 16 of these volumes are striped together using LVM, to
> >make a 32TiB volume.
> >
> >The machine is a four-slot quad core AMD box with 128GB of memory and
> >dual-port FC adapters.
> >  
> Certainly a great configuration for this test....

I've been thinking about resurrecting my parallel e2fsck patches
(below) - but I would much prefer that someone else do so. :)

Back to something useful the short term... Was the file system created
with uninitialized block groups and lazy inode table initialization?

-VAL

The patch is against e2fsprogs 1.40.4.

 e2fsck/Makefile.in                      |    6
 e2fsck/e2fsck.h                         |    5
 e2fsck/pass1.c                          |   36
 e2fsck/pass2.c                          |   12
 e2fsck/unix.c                           |   18
 lib/ext2fs/readahead.c                  | 1607 ++++++++++++++++++++++++++++++++
 lib/ext2fs/Makefile.in                  |    1
 lib/ext2fs/block.c                      |   20
 lib/ext2fs/dosio.c                      |    2
 lib/ext2fs/ext2_io.h                    |   10
 lib/ext2fs/ext2fs.h                     |   42
 lib/ext2fs/inode.c                      |   70 +
 lib/ext2fs/inode_io.c                   |    2
 lib/ext2fs/io_manager.c                 |   12
 lib/ext2fs/nt_io.c                      |    2
 lib/ext2fs/test_io.c                    |    2
 lib/ext2fs/unix_io.c                    |   41
 17 files changed, 1873 insertions(+), 15 deletions(-)

--- e2fsprogs-1.40.4.orig/lib/ext2fs/ext2_io.h
+++ e2fsprogs-1.40.4/lib/ext2fs/ext2_io.h
@@ -63,6 +63,10 @@ struct struct_io_manager {
 	errcode_t (*set_blksize)(io_channel channel, int blksize);
 	errcode_t (*read_blk)(io_channel channel, unsigned long block,
 			      int count, void *data);
+	errcode_t (*readahead)(io_channel channel, unsigned long block,
+			       int count);
+	errcode_t (*cache_release)(io_channel channel, unsigned long block,
+				   int count);
 	errcode_t (*write_blk)(io_channel channel, unsigned long block,
 			       int count, const void *data);
 	errcode_t (*flush)(io_channel channel);
@@ -82,6 +86,8 @@ struct struct_io_manager {
 #define io_channel_close(c) 		((c)->manager->close((c)))
 #define io_channel_set_blksize(c,s)	((c)->manager->set_blksize((c),s))
 #define io_channel_read_blk(c,b,n,d)	((c)->manager->read_blk((c),b,n,d))
+#define io_channel_readahead(c,b,n)	((c)->manager->readahead((c),b,n))
+#define io_channel_cache_release(c,b,n)	((c)->manager->cache_release((c),b,n))
 #define io_channel_write_blk(c,b,n,d)	((c)->manager->write_blk((c),b,n,d))
 #define io_channel_flush(c) 		((c)->manager->flush((c)))
 #define io_channel_bumpcount(c)		((c)->refcount++)
@@ -92,6 +98,10 @@ extern errcode_t io_channel_set_options(
 extern errcode_t io_channel_write_byte(io_channel channel,
 				       unsigned long offset,
 				       int count, const void *data);
+extern errcode_t readahead_noop(io_channel channel, unsigned long block,
+				int count);
+extern errcode_t cache_release_noop(io_channel channel, unsigned long block,
+				    int count);

 /* unix_io.c */
 extern io_manager unix_io_manager;
--- e2fsprogs-1.40.4.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs-1.40.4/lib/ext2fs/unix_io.c
@@ -17,6 +17,10 @@

 #define _LARGEFILE_SOURCE
 #define _LARGEFILE64_SOURCE
+/* Below needed for fadvise */
+#define _XOPEN_SOURCE 600
+/* Without this, fadvise goes 32 bit? */
+#define _FILE_OFFSET_BITS 64

 #include <stdio.h>
 #include <string.h>
@@ -77,6 +81,10 @@ static errcode_t unix_close(io_channel c
 static errcode_t unix_set_blksize(io_channel channel, int blksize);
 static errcode_t unix_read_blk(io_channel channel, unsigned long block,
 			       int count, void *data);
+static errcode_t unix_readahead(io_channel channel, unsigned long block,
+				int count);
+static errcode_t unix_cache_release(io_channel channel, unsigned long block,
+				    int count);
 static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 				int count, const void *data);
 static errcode_t unix_flush(io_channel channel);
@@ -103,6 +111,8 @@ static struct struct_io_manager struct_u
 	unix_close,
 	unix_set_blksize,
 	unix_read_blk,
+	unix_readahead,
+	unix_cache_release,
 	unix_write_blk,
 	unix_flush,
 #ifdef NEED_BOUNCE_BUFFER
@@ -587,6 +597,37 @@ static errcode_t unix_read_blk(io_channe
 #endif /* NO_IO_CACHE */
 }

+static errcode_t unix_readahead(io_channel channel, unsigned long block,
+				int count)
+{
+	struct unix_private_data *data;
+
+	data = (struct unix_private_data *)channel->private_data;
+#if DEBUG
+	printf(" RA: %s: readahead %lu, %d blocks\n", __FUNCTION__,
+	       block, count);
+#endif
+	posix_fadvise(data->dev, (ext2_loff_t)block * channel->block_size,
+		      (ext2_loff_t)count * channel->block_size,
+		      POSIX_FADV_WILLNEED);
+	return 0;
+}
+
+static errcode_t unix_cache_release(io_channel channel, unsigned long block,
+				    int count)
+{
+	struct unix_private_data *data;
+
+	data = (struct unix_private_data *)channel->private_data;
+#if DEBUG
+	printf("MT: %s: release %lu, %d blocks\n", __FUNCTION__, block, count);
+#endif
+	posix_fadvise(data->dev, (ext2_loff_t)block * channel->block_size,
+		      (ext2_loff_t)count * channel->block_size,
+		      POSIX_FADV_DONTNEED);
+	return 0;
+}
+
 static errcode_t unix_write_blk(io_channel channel, unsigned long block,
 				int count, const void *buf)
 {
--- e2fsprogs-1.40.4.orig/lib/ext2fs/inode_io.c
+++ e2fsprogs-1.40.4/lib/ext2fs/inode_io.c
@@ -64,6 +64,8 @@ static struct struct_io_manager struct_i
 	inode_close,
 	inode_set_blksize,
 	inode_read_blk,
+	readahead_noop,
+	cache_release_noop,
 	inode_write_blk,
 	inode_flush,
 	inode_write_byte
--- e2fsprogs-1.40.4.orig/lib/ext2fs/dosio.c
+++ e2fsprogs-1.40.4/lib/ext2fs/dosio.c
@@ -64,6 +64,8 @@ static struct struct_io_manager struct_d
         dos_close,
         dos_set_blksize,
         dos_read_blk,
+        readahead_noop,
+        cache_release_noop,
         dos_write_blk,
         dos_flush
 };
--- e2fsprogs-1.40.4.orig/lib/ext2fs/nt_io.c
+++ e2fsprogs-1.40.4/lib/ext2fs/nt_io.c
@@ -236,6 +236,8 @@ static struct struct_io_manager struct_n
 	nt_close,
 	nt_set_blksize,
 	nt_read_blk,
+	readahead_noop,
+	cache_release_noop,
 	nt_write_blk,
 	nt_flush
 };
--- e2fsprogs-1.40.4.orig/lib/ext2fs/test_io.c
+++ e2fsprogs-1.40.4/lib/ext2fs/test_io.c
@@ -74,6 +74,8 @@ static struct struct_io_manager struct_t
 	test_close,
 	test_set_blksize,
 	test_read_blk,
+	readahead_noop,
+	cache_release_noop,
 	test_write_blk,
 	test_flush,
 	test_write_byte,
--- e2fsprogs-1.40.4.orig/lib/ext2fs/io_manager.c
+++ e2fsprogs-1.40.4/lib/ext2fs/io_manager.c
@@ -67,3 +67,15 @@ errcode_t io_channel_write_byte(io_chann

 	return EXT2_ET_UNIMPLEMENTED;
 }
+
+errcode_t readahead_noop(io_channel channel, unsigned long block,
+			 int count)
+{
+	return 0;
+}
+
+errcode_t cache_release_noop(io_channel channel, unsigned long block,
+			 int count)
+{
+	return 0;
+}
--- e2fsprogs-1.40.4.orig/e2fsck/Makefile.in
+++ e2fsprogs-1.40.4/e2fsck/Makefile.in
@@ -119,16 +119,16 @@ e2fsck: e2fsck.@E2FSCK_TYPE@
 e2fsck.static: $(OBJS)  $(STATIC_DEPLIBS)
 	@echo "	LD $@"
 	@$(LD) $(ALL_LDFLAGS) $(LDFLAG_STATIC) -o e2fsck.static $(OBJS) \
-		$(STATIC_LIBS)
+		$(STATIC_LIBS) -lpthread

 e2fsck.shared: $(OBJS)  $(DEPLIBS)
 	@echo "	LD $@"
-	@$(LD) $(ALL_LDFLAGS) -o e2fsck.shared $(OBJS) $(LIBS)
+	@$(LD) $(ALL_LDFLAGS) -o e2fsck.shared $(OBJS) $(LIBS)  -lpthread

 e2fsck.profiled: $(PROFILED_OBJS)  $(PROFILED_DEPLIBS)
 	@echo "	LD $@"
 	@$(LD) $(ALL_LDFLAGS) -g -pg -o e2fsck.profiled $(PROFILED_OBJS) \
-		$(PROFILED_LIBS)
+		$(PROFILED_LIBS)  -lpthread

 tst_refcount: ea_refcount.c
 	@echo "	LD $@"
--- e2fsprogs-1.40.4.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.4/e2fsck/e2fsck.h
@@ -334,6 +334,11 @@ struct e2fsck_struct {
 	profile_t	profile;
 	int blocks_per_page;

+ 	/*
+ 	 * Readahead state
+ 	 */
+ 	struct readahead_state *ra;
+
 	/*
 	 * For the use of callers of the e2fsck functions; not used by
 	 * e2fsck functions themselves.
--- e2fsprogs-1.40.4.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.4/e2fsck/pass1.c
@@ -463,6 +463,25 @@ extern void e2fsck_setup_tdb_icount(e2fs
 		*ret = 0;
 }

+/*
+ * Should we submit this inode for readahead?
+ */
+
+static int readahead_this_inode(struct ext2_inode *inode)
+{
+	/* Does this inode have valid blocks (i.e., not a fast symlink)? */
+	if (ext2fs_inode_has_valid_blocks(inode) &&
+	    /* Is it a directory or regular file? */
+	    (LINUX_S_ISDIR(inode->i_mode) ||
+	     LINUX_S_ISREG(inode->i_mode)) &&
+	    /* And does it have indirect blocks? */
+	    (inode->i_block[EXT2_IND_BLOCK] ||
+	     inode->i_block[EXT2_DIND_BLOCK] ||
+	     inode->i_block[EXT2_TIND_BLOCK]))
+		return 1;
+	return 0;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -483,7 +502,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		imagic_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
-	
+
 #ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack);
 #endif
@@ -498,6 +517,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->dirs_to_hash = 0;
 	}

+	ext2fs_readahead_inode_init(ctx->ra, readahead_this_inode);
+
 #ifdef MTRACE
 	mtrace_print("Pass 1");
 #endif
@@ -619,6 +640,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;

+	ext2fs_readahead_inode_start(ctx->ra);
+
 	while (1) {
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
@@ -687,6 +710,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 			ext2fs_mark_inode_bitmap(ctx->inode_used_map, ino);
 			clear_problem_context(&pctx);
+			/* Inodes are normally released in check_blocks except for this one */
+			ext2fs_readahead_inode_release(ctx->ra, fs, ino, block_buf);
 			continue;
 		} else if (ino == EXT2_ROOT_INO) {
 			/*
@@ -935,6 +960,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	}
 	process_inodes(ctx, block_buf);
 	ext2fs_close_inode_scan(scan);
+	ext2fs_readahead_inode_exit(ctx->ra);

 	/*
 	 * If any extended attribute blocks' reference counts need to
@@ -1032,6 +1058,8 @@ static errcode_t scan_callback(ext2_fils
 	scan_struct = (struct scan_callback_struct *) priv_data;
 	ctx = scan_struct->ctx;
 	
+	ext2fs_readahead_inode_table_release(ctx->ra, fs, group);
+
 	process_inodes((e2fsck_t) fs->priv_data, scan_struct->block_buf);

 	if (ctx->progress)
@@ -1515,10 +1543,14 @@ static void check_blocks(e2fsck_t ctx, s
 	if (inode->i_file_acl && check_ext_attr(ctx, pctx, block_buf))
 		pb.num_blocks++;

-	if (ext2fs_inode_has_valid_blocks(inode))
+	if (ext2fs_inode_has_valid_blocks(inode)) {
 		pctx->errcode = ext2fs_block_iterate2(fs, ino,
 				       pb.is_dir ? BLOCK_FLAG_HOLE : 0,
 				       block_buf, process_block, &pb);
+		/* Release it if we read it in the first place */
+		if (readahead_this_inode(inode))
+			ext2fs_readahead_inode_release(ctx->ra, fs, ino, block_buf);
+	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
 	end_problem_latch(ctx, PR_LATCH_TOOBIG);
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
--- e2fsprogs-1.40.4.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.4/e2fsck/unix.c
@@ -57,6 +57,8 @@ static int normalize_swapfs;
 static int cflag;		/* check disk */
 static int show_version_only;
 static int verbose;
+static unsigned int max_ios;
+static unsigned int cache_max;

 static int replace_bad_blocks;
 static int keep_bad_blocks;
@@ -74,6 +76,7 @@ static void usage(e2fsck_t ctx)
 		_("Usage: %s [-panyrcdfvstDFSV] [-b superblock] [-B blocksize]\n"
 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
+		"\t\t[-A maximum_concurrent_ios] [-m maximum_memory]\n"
 		"\t\t[-E extended-options] device\n"),
 		ctx->program_name);

@@ -619,8 +622,11 @@ static errcode_t PRS(int argc, char *arg
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
-	while ((c = getopt (argc, argv,
"panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+	while ((c = getopt (argc, argv,
"paA:nyrcC:B:dE:fvtFVm:M:b:I:j:P:l:L:N:SsDk")) != EOF)
 		switch (c) {
+		case 'A':
+			max_ios = atoi(optarg);
+			break;
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
 			res = sscanf(optarg, "%d", &ctx->progress_fd);
@@ -727,6 +733,10 @@ static errcode_t PRS(int argc, char *arg
 		case 'V':
 			show_version_only = 1;
 			break;
+		case 'm':
+			/* XXX should handle 3M and 54kb type stuff */
+			cache_max = atoi(optarg);
+			break;
 #ifdef MTRACE
 		case 'M':
 			mallwatch = (void *) strtol(optarg, NULL, 0);
@@ -1244,7 +1254,13 @@ restart:
 	else
 		journal_size = -1;

+	if (ext2fs_readahead_init(ctx->fs, max_ios, cache_max, &ctx->ra))
+		printf(_("Readahead failed to start, disabled.\n"));
+
 	run_result = e2fsck_run(ctx);
+
+	ext2fs_readahead_exit(&ctx->ra);
+
 	e2fsck_clear_progbar(ctx);

 	if (ctx->flags & E2F_FLAG_JOURNAL_INODE) {
--- e2fsprogs-1.40.4.orig/lib/ext2fs/Makefile.in
+++ e2fsprogs-1.40.4/lib/ext2fs/Makefile.in
@@ -59,6 +59,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_O
 	openfs.o \
 	read_bb.o \
 	read_bb_file.o \
+	readahead.o \
 	res_gdt.o \
 	rw_bitmaps.o \
 	swapfs.o \
--- e2fsprogs-1.40.4.orig/lib/ext2fs/block.c
+++ e2fsprogs-1.40.4/lib/ext2fs/block.c
@@ -59,6 +59,9 @@ static int block_iterate_ind(blk_t *ind_
 		ret |= BLOCK_ERROR;
 		return ret;
 	}
+	if (ctx->flags & BLOCK_FLAG_IND_ONLY)
+		return ret;
+
 	ctx->errcode = ext2fs_read_ind_block(ctx->fs, *ind_block,
 					     ctx->ind_buf);
 	if (ctx->errcode) {
@@ -259,7 +262,6 @@ static int block_iterate_tind(blk_t *tin
 		ret |= (*ctx->func)(ctx->fs, tind_block,
 				    BLOCK_COUNT_TIND, ref_block,
 				    ref_offset, ctx->priv_data);
-	
 	return ret;
 }
 	
@@ -342,14 +344,17 @@ errcode_t ext2fs_block_iterate2(ext2_fil
 	/*
 	 * Iterate over normal data blocks
 	 */
-	for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
-		if (blocks[i] || (flags & BLOCK_FLAG_APPEND)) {
-			ret |= (*ctx.func)(fs, &blocks[i],
-					    ctx.bcount, 0, i, priv_data);
-			if (ret & BLOCK_ABORT)
-				goto abort_exit;
+	if (!(flags & BLOCK_FLAG_IND_ONLY)) {
+		for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
+			if (blocks[i] || (flags & BLOCK_FLAG_APPEND)) {
+				ret |= (*ctx.func)(fs, &blocks[i],
+						   ctx.bcount, 0, i, priv_data);
+				if (ret & BLOCK_ABORT)
+					goto abort_exit;
+			}
 		}
 	}
+
 	if (*(blocks + EXT2_IND_BLOCK) || (flags & BLOCK_FLAG_APPEND)) {
 		ret |= block_iterate_ind(blocks + EXT2_IND_BLOCK,
 					 0, EXT2_IND_BLOCK, &ctx);
@@ -434,4 +439,3 @@ errcode_t ext2fs_block_iterate(ext2_fils
 	return ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_NO_LARGE | flags,
 				     block_buf, xlate_func, &xl);
 }
-
--- e2fsprogs-1.40.4.orig/lib/ext2fs/ext2fs.h
+++ e2fsprogs-1.40.4/lib/ext2fs/ext2fs.h
@@ -278,6 +278,9 @@ struct struct_ext2_filsys {
  * BLOCK_FLAG_DATA_ONLY indicates that the iterator function should be
  * called for data blocks only.
  *
+ * BLOCK_FLAG_IND_ONLY is the opposite of BLOCK_FLAG_DATA_ONLY - only
+ * call the iterate function for indirect blocks.
+ *
  * BLOCK_FLAG_NO_LARGE is for internal use only.  It informs
  * ext2fs_block_iterate2 that large files won't be accepted.
  */
@@ -285,6 +288,7 @@ struct struct_ext2_filsys {
 #define BLOCK_FLAG_HOLE		1
 #define BLOCK_FLAG_DEPTH_TRAVERSE	2
 #define BLOCK_FLAG_DATA_ONLY	4
+#define BLOCK_FLAG_IND_ONLY	8

 #define BLOCK_FLAG_NO_LARGE	0x1000

@@ -808,6 +812,8 @@ extern errcode_t ext2fs_get_next_inode_f
 					    ext2_ino_t *ino,
 					    struct ext2_inode *inode,
 					    int bufsize);
+errcode_t ext2fs_get_next_inode_ptr(ext2_inode_scan scan, ext2_ino_t *ino,
+				    struct ext2_inode **inode);
 extern errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 				  ext2_inode_scan *ret_scan);
 extern void ext2fs_close_inode_scan(ext2_inode_scan scan);
@@ -907,6 +913,42 @@ errcode_t ext2fs_link(ext2_filsys fs, ex
 errcode_t ext2fs_unlink(ext2_filsys fs, ext2_ino_t dir, const char *name,
 			ext2_ino_t ino, int flags);

+/* readahead.c */
+
+struct readahead_state;
+
+/* Generic readahead start/stop functions */
+
+errcode_t ext2fs_readahead_init(ext2_filsys fs, unsigned int max_ios,
+				unsigned int max_mem,
+				struct readahead_state **ret_ra);
+void ext2fs_readahead_exit(struct readahead_state **ret_ra);
+void ext2fs_readahead_kill(struct readahead_state *ra);
+
+/* Inode readahead (pass 1) */
+
+void ext2fs_readahead_inode_init(struct readahead_state *ra,
+				 int (*should_read_inode)(struct ext2_inode *));
+void ext2fs_readahead_inode_start(struct readahead_state *ra);
+void ext2fs_readahead_inode_exit(struct readahead_state *ra);
+void ext2fs_readahead_inode_release(struct readahead_state *ra, ext2_filsys fs,
+				    ext2_ino_t ino, char *block_buf);
+void ext2fs_readahead_inode_table_release(struct readahead_state *ra,
+					  ext2_filsys fs, dgrp_t group);
+/* Directory block readahead (pass 2) */
+
+void ext2fs_readahead_dblist_init(struct readahead_state *ra,
+				  ext2_dblist dblist);
+void ext2fs_readahead_dblist_start(struct readahead_state *ra);
+void ext2fs_readahead_dblist_exit(struct readahead_state *ra);
+void ext2fs_readahead_dblist_release(struct readahead_state *ra,
+				     ext2_filsys fs, blk_t blk);
+
+/* Private to readahead implementation */
+
+void * readahead_inode_loop(void *arg);
+void * readahead_dblist(void *arg);
+
 /* read_bb.c */
 extern errcode_t ext2fs_read_bb_inode(ext2_filsys fs,
 				      ext2_badblocks_list *bb_list);
--- /dev/null
+++ e2fsprogs-1.40.4/lib/ext2fs/readahead.c
@@ -0,0 +1,1607 @@
+/*
+ * readahead.c --- Fast, parallel readahead of file system structures
+ *
+ * Copyright (C) 2007-2008 Valerie Henson <val@nmt.edu>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ *
+ * Generic readahead functions for users of ext2 lib.
+ *
+ * The general theory of readahead is that the main thread (fsck in
+ * most cases) spawns a second thread, the readahead thread, to go
+ * preread the file system structures.  The readahead thread relies on
+ * the buffer cache to store the blocks it has pre-read - it's sort of
+ * managing the buffer cache blindfolded.  Similarly, the readahead
+ * thread also keeps track of how many ios it has submittted to the
+ * device which have not yet completed, so it can avoid overflowing
+ * the device io queue.  This is also done without any real
+ * communication with the actual device queue; we're just guessing for
+ * the most part.
+ *
+ * This file is divided into calls made by the readahead thread and
+ * calls made by the main thread.
+ *
+ * Readahead is turned off by default, as it gives minimal or zero
+ * performance improvement on single disk systems, which make up the
+ * majority of file systems in Linux.
+ *
+ * Cache management:
+ *
+ * The total amount of cache to use is set by a command-line option.
+ * This should be a little bit smaller than the maximum memory
+ * available for buffer cache - i.e., not all of free memory, since
+ * buffer cache is usually limited to some fraction of all memory.
+ * Setting the maximum cache to greater than the buffer cache will
+ * approximately double elapsed time, since all of the file system
+ * data will be read from disk twice - once by readahead, and after it
+ * has been evicted by other pre-read blocks, a second time by the
+ * main thread.  This is bad.  Currently, I figure out what the buffer
+ * cache maximum is by running vmstat and reading the "buff" field.
+ *
+ * The *_readahead functions are called by the readahead thread and
+ * queue up ios to be pre-read.  When the io is actually issued and
+ * completed, the readahead thread increases the number of blocks
+ * available in cache.  The main thread (the client) calls the
+ * ext2fs_readahead_*_release functions (in readahead_client.c),
+ * reducing the number of blocks marked as in the cache and marking
+ * them as WONTNEED using fadvise (probably unnecessary and a no-op,
+ * as normal block aging should evict them from cache as new blocks
+ * are read).
+ *
+ * The threads sleep and wake according to the size of the cache, with
+ * the readahead thread as the producer and the main thread as the
+ * consumer.  The readahead thread wakes the main thread whenever a
+ * significant amount of cache is available, and wakes and waits on
+ * the main thread if the cache is full.  The main thread wakes the
+ * readahead thread whenever a significant amount of cache becomes
+ * free, and wakes and waits on the readahead thread whenever the
+ * cache becomes empty.  The threads only signal each other when a
+ * significant amount of cache becomes free or available because
+ * otherwise the threads can get locked in a tight wake/sleep cycle in
+ * which the readahead thread never has the opportunity to issue
+ * multiple ios in parallel.  Another small modification is that the
+ * readahead thread records how much cache it needs to complete the
+ * next io before it goes to sleep, so the main thread won't wake it
+ * unless there is enough cache to satisfy the next io.
+ *
+ * One major pitfall of this approach is that it requires very careful
+ * accounting of blocks read.  The main thread must call the release
+ * function for every block that the readahead thread adds to the
+ * cache.  In particular, the main thread must release the indirect
+ * blocks for every inode that the readahead thread walks.  The main
+ * thread may not want to readahead every inode in the file system, so
+ * the interface allows the client to pass a function used to decide
+ * which inodes to readahead.
+ *
+ * Note that the main thread is allowed to pull slightly ahead of the
+ * readahead thread (and allow the cache used accounting to go
+ * negative) because it's hard to predict how many blocks the main
+ * thread will read when it's checking an inode.  Checking before
+ * every block read would be a lot of overhead, so checking and
+ * blocking if necessary is done when the main thread is entirely done
+ * with an inode.
+ *
+ * We try to keep the granularity of adding or releasing things to the
+ * cache large, so that we don't grab locks and send signals and
+ * switch threads for every block that enters or leaves the cache.
+ *
+ * Asynchronous IO implementation:
+ *
+ * Asynchronous, parallel IO is implemented using primitives that are
+ * available, well-tested, and actually do something in most deployed
+ * Linux systems:
+ *
+ * Start io: posix_fadvise (WILLNEED)
+ * Complete io: read() into scratch buffer
+ *
+ * Amazingly, this works - and it goes fast.  At this point in time,
+ * the only other serious alternative is to spawn multiple threads and
+ * do synchronous ios from the thread.  No other forms of aio for
+ * Linux satisfy the above three criteria; in particular, POSIX aio is
+ * implemented as synchronous IO on most systems.
+ *
+ * Device queue management:
+ *
+ * As with the cache, we assume we have pretty much exclusive use of
+ * the device containing the file system, and try to manage the queue
+ * blind.  The io queue size is currently passed in from the user, but
+ * could be found programmatically with some effort.  Ios are
+ * considered outstanding after we start readahead until we read the
+ * actual data requested.  We try to collect at least max_ios before
+ * sorting and issuing them, to get optimal parallelization and head
+ * movement.
+ *
+ * This code replicates some portion of the in-kernel device queue
+ * management - queue plugging, merging, sorting, etc.  Why not just
+ * let the kernel handle it?  The answer is that we can predict what
+ * blocks will be needed, and we know about block dependencies.  The
+ * block layer has to guess what will happen next, but we have more
+ * information than we can pass down through the system call
+ * interface.  That said, it's certainly possible that the performance
+ * difference will be negligible on some systems.
+ *
+ * Thread management:
+ *
+ * Each pass of readahead (inode, direct block, etc.) creates and
+ * destroys its own thread.  The thread isn't created and doesn't
+ * start until the *_start() function is called, so the main thread
+ * controls when readahead starts working.  Some generic helper
+ * functions are provided; the per-pass initialization only has to
+ * initialize its own private variables.
+ *
+ * TODO:
+ *
+ * - acls and xattrs are ignored, but should also be read.
+ * - The user interface is less than stellar, esp. for maximum cache memory
+ * - autoconf the thread stuff and all of readahead
+ * - Implement main thread timeout for safety
+ * - Replace dummy block hack to keep main thread from hanging
+ * - Use pthread_cleanup handlers when holding locks to prevent
+ *   deadlock in the case of the thread dying while holding a lock
+ * - mincore() instead of read()?
+ * - parallelize inode table readahead
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#if HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#include <pthread.h>
+#include <error.h>
+#include <errno.h>
+
+#include "ext2_fs.h"
+#include "ext2fs.h"
+#include "ext2fsP.h"
+
+/* XXX should use ext2 debug routines? */
+
+/* #define EXT2FS_READAHEAD_DEBUG */
+
+#ifdef EXT2FS_READAHEAD_DEBUG
+#define dprintf			printf
+#else
+#define dprintf(args...)	do { } while (0)
+#endif
+
+struct io_desc {
+	blk_t	blk;
+	unsigned int count;
+};
+
+struct readahead_state {
+	ext2_filsys	fs;
+	int		enabled;
+
+	/*
+	 * Pass-independent IO and cache management.
+	 */
+
+	/* Maximum number of simultaneous ios disk can handle */
+	unsigned int	max_ios;
+	/* Maximum io size - to prevent deadlocks waiting for cache */
+	unsigned int	max_io_size;
+	/* Kick off outstanding ios after this many msecs idle */
+	unsigned int	timeout;
+	/* Should be at least max_ios in size */
+	unsigned int	io_queue_size;
+	/* Blocks to read queue */
+	struct io_desc	*io_queue;
+	/* Ios in the queue */
+	unsigned int	ios_queued;
+	/* Blocks in the queue (but not issued) */
+	unsigned int	blocks_queued;
+	/* All cache size variables are in units of file system blocks */
+	/* Maximum buffer cache to use */
+	int		cache_max;
+	/* Buffer cache used by pre-read blocks */
+	int		cache_used;
+	/* Cache reserved for in-progress readaheads */
+	int		cache_pending;
+	/* Cache blocks needed for waiting readahead thread to progress */
+	int		cache_needed;
+	/* Wake readahead when cache used gets this low */
+	unsigned int	cache_restart_ra;
+	/* Wake main thread ahead when cache used gets this high */
+	unsigned int	cache_restart_main;
+	/* Protects shared cache variables */
+	pthread_mutex_t	cache_mutex;
+	/* Condition variable for thread wake/sleep */
+	pthread_cond_t	cache_wake;
+	/* Is readahead done? Then don't wait on zero cache */
+	int		cache_readahead_done;
+	/*
+	 * Scratch buffer for reading a single throwaway block.  Never
+	 * ever read the contents.
+	 */
+	char		*scratch_buf;
+	/* Readahead thread struct; only need one of them */
+	pthread_t		thread;
+	/* Pass-specific exit handler */
+	void		(*thread_exit)(struct readahead_state *);
+	/* Should we exit now? Check frequently */
+	int		should_exit;
+
+	/*
+	 * Inode readahead related state
+	 */
+
+	/*
+	 * Indirect blocks are traversed recursively and need one
+	 * block buffer for double and triple blocks (singles use the
+	 * scratch_buf).
+	 */
+	char		*double_buf;
+	char		*triple_buf;
+	/* We do our own internal inode scan */
+	ext2_inode_scan scan;
+	/* Caller provided function to decide which inodes to read ahead */
+	int		(*should_read_inode)(struct ext2_inode *);
+
+	/*
+	 * Directory block readahead related state
+	 */
+
+	/* List of directory blocks */
+	ext2_dblist dblist;
+};
+
+static void readahead_test_exit(struct readahead_state *ra);
+static void readhead_thread_exit_now(struct readahead_state *ra);
+
+/*
+ * Cache management routines.
+ */
+
+/*
+ * Sanity check cache variables and kill readahead if things look
+ * wonky.  Caller must not hold the cache mutex.
+ */
+
+static void check_cache(struct readahead_state *ra)
+{
+	if (ra->cache_used + ra->cache_pending > ra->cache_max) {
+		fprintf(stderr, "Bug! cache_used (%d) + cache_pending (%d) is "
+			"greater than cache_max (%d)\n",
+			ra->cache_used, ra->cache_pending, ra->cache_max);
+#ifdef EXT2FS_READAHEAD_DEBUG
+		abort();
+#endif
+		readhead_thread_exit_now(ra);
+	}
+}
+
+/*
+ * Do we have room in the cache for this io?
+ */
+
+static int cache_full(struct readahead_state *ra, unsigned int blks)
+{
+	/* No lock needed - main thread can only decrease cache_used */
+	if (ra->cache_used + ra->cache_pending + blks > ra->cache_max) {
+		dprintf(" RA: %s: cache_used %d cache_pending %d blks %u\n",
+			__FUNCTION__, ra->cache_used, ra->cache_pending, blks);
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * Wait until cache becomes available.
+ */
+
+static void wait_for_cache(struct readahead_state *ra, unsigned int blks)
+{
+	check_cache(ra);
+	pthread_mutex_lock(&ra->cache_mutex);
+	/*
+	 * The main thread could have freed up cache since the call to
+	 * cache_full(), check to see if we already have space
+	 * available.
+	 */
+	if (ra->cache_used + ra->cache_pending + blks <= ra->cache_max) {
+		pthread_mutex_unlock(&ra->cache_mutex);
+		return;
+	}
+	/* Guess not.  Wait for it. */
+	ra->cache_needed = blks;
+	dprintf(" RA: %s: Need cache, waking main thread, used %d needed %d\n",
+		__FUNCTION__, ra->cache_used, ra->cache_needed);
+	pthread_cond_signal(&ra->cache_wake);
+	dprintf(" RA: %s: Waiting for main thread to free cache...\n",
+		__FUNCTION__);
+	pthread_cond_wait(&ra->cache_wake, &ra->cache_mutex);
+	/* cache_needed is reset by the main thread */
+	pthread_mutex_unlock(&ra->cache_mutex);
+	/* See if we were actually woken by request to exit */
+	readahead_test_exit(ra);
+}
+
+/*
+ * Track blocks read into buffer cache and ready for the main thread
+ * to use.
+ */
+
+static void blocks_ready(struct readahead_state *ra, unsigned int count)
+{
+	check_cache(ra);
+	pthread_mutex_lock(&ra->cache_mutex);
+	dprintf(" RA: %s: cache_pending %d cache_used %d count %u\n",
+		__FUNCTION__, ra->cache_pending, ra->cache_used, count);
+	ra->cache_pending -= count;
+	ra->cache_used += count;
+	/* Wake main thread if we crossed the boundary */
+	if ((ra->cache_used - count < ra->cache_restart_main) &&
+	    (ra->cache_used >= ra->cache_restart_main)) {
+		dprintf(" RA: %s: Cache filling up, waking main thread "
+			"(used %d)\n", __FUNCTION__, ra->cache_used);
+		pthread_cond_signal(&ra->cache_wake);
+	}
+	pthread_mutex_unlock(&ra->cache_mutex);
+}
+
+/*
+ * IO queue management routines.
+ */
+
+#ifdef EXT2FS_READAHEAD_DEBUG
+
+/*
+ * Sanity check the io queue.
+ */
+
+static void check_queue(struct readahead_state *ra)
+{
+	struct io_desc *io;
+	int i;
+
+	if (ra->ios_queued > ra->io_queue_size) {
+		fprintf(stderr, "Bug!  IOs queued %u > IO queue size %u\n",
+			ra->ios_queued, ra->io_queue_size);
+		goto out;
+	}
+
+	for (i = 0; i < ra->io_queue_size; i++) {
+		io = &ra->io_queue[i];
+		/* Only print non-zero ios for brevity */
+		if (io->blk)
+			dprintf("  io[%d] blk %u count %u\n", i, io->blk,
+			       io->count);
+		if ((io->blk || io->count) &&
+		    (i >= ra->ios_queued)) {
+			fprintf(stderr, "Bug!  io[%d] lost! "
+				"(blk %u count %u)\n", i, io->blk, io->count);
+			goto out;
+		}
+	}
+
+	return;
+
+ out:
+#ifdef EXT2FS_READAHEAD_DEBUG
+	abort();
+#endif
+	readhead_thread_exit_now(ra);
+}
+#else
+#define check_queue(x) do { } while(0);
+#endif
+
+/*
+ * Compare function for sorting the io queue.  We sort unused (zero)
+ * ios created by merge_ios() to the end.
+ */
+
+static EXT2_QSORT_TYPE io_compare(const void *a, const void *b)
+{
+	struct io_desc *io_a = (struct io_desc *) a;
+	struct io_desc *io_b = (struct io_desc *) b;
+
+	if ((io_a->blk == 0) &&
+	    (io_b->blk == 0))
+		/* Don't care */
+		return 0;
+	/*
+	 * Make zeroes bigger than everything else so they move to the
+	 * end of the queue.
+	 */
+	if (io_a->blk == 0)
+		return 1;
+
+	if (io_b->blk == 0)
+		return -1;
+
+	return io_a->blk - io_b->blk;
+}
+
+/*
+ * Merge ios if they are contiguous while respecting maximum IO size.
+ */
+
+static void merge_ios(struct readahead_state *ra)
+{
+	/* merge_ios not to be called with less than one io */
+	unsigned int new_ios = 1;
+	struct io_desc *last_io;
+	struct io_desc *new_io;
+	blk_t last_blk;
+	blk_t new_last_blk;
+	int i;
+
+	qsort(ra->io_queue, ra->ios_queued, sizeof(ra->io_queue[0]),
+	      io_compare);
+
+	/* Set last_io to the first io... */
+	last_io = &ra->io_queue[0];
+	new_ios = 1;
+	/* Then start merging at second io */
+	for (i = 1; i < ra->ios_queued; i++) {
+		dprintf(" RA: %s: io[%d]\n", __FUNCTION__, i);
+		new_io = &ra->io_queue[i];
+		last_blk = last_io->blk + last_io->count;
+		/*
+		 * Merge ios if both (1) the start of the new io is <=
+		 * to the end of the last io, and (2) the new io would
+		 * not be bigger than the maximum allowed io.
+		 */
+		if ((new_io->blk <= last_blk) &&
+		    ((new_io->count + last_io->count) <= ra->max_io_size)) {
+			dprintf(" RA: %s: io merged! [%u,%u] + [%u,%u] = ",
+				__FUNCTION__, last_io->blk, last_io->count,
+				new_io->blk, new_io->count);
+			new_last_blk = new_io->blk + new_io->count;
+			/*
+			 * Be careful.  The end of this io could be
+			 * less than the end of last io.
+			 */
+			if (new_last_blk > last_blk)
+				last_io->count = new_last_blk - last_io->blk;
+			/* Clear the merged io */
+			new_io->blk = 0;
+			new_io->count = 0;
+			dprintf("[%u,%u]\n", last_io->blk, last_io->count);
+		} else {
+			dprintf(" RA: Not merged: [%u,%u] and [%u,%u]\n",
+				last_io->blk, last_io->count,
+				new_io->blk, new_io->count);
+			/* This is our new last io */
+			last_io = new_io;
+			new_ios++;
+		}
+	}
+
+	/* Resort to move zeroes to the end */
+	qsort(ra->io_queue, ra->ios_queued, sizeof(ra->io_queue[0]),
+	      io_compare);
+
+	check_queue(ra);
+
+	ra->ios_queued = new_ios;
+}
+
+/*
+ * Ios can be bad for at least two reasons:
+ *
+ * - corrupted on-disk block pointer (can't prevent this)
+ * - programming error (a.k.a. "bug")
+ *
+ * Check for and reject obviously bad ios before they are issued or
+ * cache is reserved for them.
+ */
+
+static int reject_io(struct readahead_state *ra, blk_t blk, unsigned int count)
+{
+	blk_t max_blk = ra->fs->super->s_blocks_count - 1;
+
+	/* Is the blk number within the bounds of the file system? */
+	if ((blk == 0) || (blk + count > max_blk)) {
+		fprintf(stderr, "Bad io: blk %u count %u\n", blk, count);
+#ifdef EXT2FS_READAHEAD_DEBUG
+		abort();
+#endif
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * Complete issued ios to get them out of the device's io queue.
+ */
+
+static void reap_ios(struct readahead_state *ra, unsigned int start,
+		     unsigned int count)
+{
+	unsigned int blocks_reaped = 0;
+	struct io_desc *io;
+	int i;
+
+	dprintf(" RA: %s: start %u count %u\n", __FUNCTION__, start, count);
+	for (i = start; i < start + count; i++) {
+		io = &ra->io_queue[i];
+		if (reject_io(ra, io->blk, io->count))
+			continue;
+		/*
+		 * Read blocks into the scratch buffer one io at a
+		 * time and throw them away (scratch buffer is big
+		 * enough for the maximum possible io).  Wastes memory
+		 * bandwidth, but I sure hope that's not our
+		 * bottleneck.  Also, passing the memory back to the
+		 * main thread is painful, and keeping the blocks in
+		 * memory would result in double-buffering for
+		 * everything in the cache anyway.
+		 */
+		io_channel_read_blk(ra->fs->io, io->blk, io->count,
+				    ra->scratch_buf);
+		blocks_reaped += io->count;
+		/*
+		 * Only release blocks to the cache when we have a lot
+		 * of them to avoid excessive lock and signal
+		 * overhead.
+		 */
+		/* XXX should be based on high/low watermarks */
+		if (blocks_reaped > (ra->cache_max / 10)) {
+			blocks_ready(ra, blocks_reaped);
+			blocks_reaped = 0;
+		}
+		/* Clear the io descriptor for debugging */
+		io->blk = 0;
+		io->count = 0;
+		/*
+		 * Frequent checking for an exit request is especially
+		 * important when doing IO.
+		 */
+		readahead_test_exit(ra);
+	}
+	blocks_ready(ra, blocks_reaped);
+	blocks_reaped = 0;
+}
+
+/*
+ * Given an array of ios, sort, issue, and wait for them.
+ *
+ * Device queue management is important.  We want to avoid overflowing
+ * the device queue and getting our readahead requests thrown away, so
+ * we need to know whether the previous readahead ios have completed.
+ * At the same time, we want to issue max_ios number of sorted IOs in
+ * parallel.  So we collect ios at user level and wait until (1) the
+ * queue is full, (2) we need a synchronous read (as for double/triple
+ * indirect blocks or inode tables), or (3) we timeout.  Then we issue
+ * the readahead requests, up to max_ios at a time.  We then do a
+ * synchronous read of all the outstanding ios to make sure they have
+ * completed before issuing the next set of ios.  Poor man's aio.
+ */
+
+static void issue_ios(struct readahead_state *ra)
+{
+	unsigned int ios_in_flight = 0;
+	struct io_desc *io;
+	int ios_finished = 0;
+	int i;
+
+	merge_ios(ra);
+
+	dprintf(" RA: %s: ios_queued %u blocks_queued %u after merge\n",
+		__FUNCTION__, ra->ios_queued, ra->blocks_queued);
+	/*
+	 * Issue up to max ios at a time.  If necessary, wake the main
+	 * thread and wait for cache to become available.
+	 */
+	for (i = 0; i < ra->ios_queued; i++) {
+		io = &ra->io_queue[i];
+		/* Check io and cache limits */
+		if ((ios_in_flight == ra->max_ios) ||
+		    cache_full(ra, io->count)) {
+			/* Cache won't overflow if we issue current ios */
+			reap_ios(ra, ios_finished, ios_in_flight);
+			ios_in_flight = 0;
+			ios_finished = i;
+		}
+		/* Check that we have enough cache */
+		wait_for_cache(ra, io->count);
+		/* Now we have enough cache and a free io slot */
+		dprintf(" RA: %s: issuing io %d blk %u count %d\n",
+			__FUNCTION__, i, io->blk, io->count);
+		io_channel_readahead(ra->fs->io, io->blk, io->count);
+		/* Reserve cache for this io */
+		ra->cache_pending += io->count;
+		ios_in_flight++;
+		readahead_test_exit(ra);
+	}
+	/* Finish off the last of the ios */
+	if (ios_in_flight)
+		reap_ios(ra, ios_finished, ios_in_flight);
+	ra->ios_queued = 0;
+	ra->blocks_queued = 0;
+}
+
+/*
+ * Issue any outstanding ios and wake main thread one more time.
+ * Called before thread exits.
+ */
+
+static void finish_ios(struct readahead_state *ra)
+{
+	/* Kick off any left-over ios */
+	if (ra->ios_queued)
+		issue_ios(ra);
+
+	/* Wake main thread one more time in case it's waiting on us */
+	pthread_mutex_lock(&ra->cache_mutex);
+	/*
+	 * XXX HACK: Prevent main thread hanging on zero cache by
+	 * adding a dummy block to the cache.  Will deadlock if we
+	 * have a cache accounting bug that makes cache_used go
+	 * negative.
+	 */
+	ra->cache_used += 1;
+	dprintf(" RA: %s: Readahead finished, waking main thread "
+		"cache_used %d\n", __FUNCTION__, ra->cache_used);
+	pthread_cond_signal(&ra->cache_wake);
+	pthread_mutex_unlock(&ra->cache_mutex);
+}
+
+/*
+ * Check if the io queue is full.  If it is, try to squish the ios
+ * together to free up io slots.
+ */
+
+static int queue_full(struct readahead_state *ra)
+{
+	if (ra->ios_queued == ra->io_queue_size)
+		merge_ios(ra);
+	if (ra->ios_queued == ra->io_queue_size)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Add an io to the readahead queue, issuing ios if necessary to make
+ * space in the queue.
+ */
+
+static void queue_blks(struct readahead_state *ra, blk_t blk,
+		       unsigned int count)
+{
+	unsigned int blks_to_queue;
+	struct io_desc *io;
+
+	dprintf(" RA: %s: queue %u, blk %u, count %d\n", __FUNCTION__,
+		ra->ios_queued, blk, count);
+
+	if (reject_io(ra, blk, count))
+		return;
+
+	/* Break down large requests into max_io_size chunks */
+	while (count) {
+		if (queue_full(ra))
+			issue_ios(ra);
+		io = &ra->io_queue[ra->ios_queued];
+		blks_to_queue = count > ra->max_io_size ?
+			ra->max_io_size : count;
+		io->blk = blk;
+		io->count = blks_to_queue;
+		/* printf("%s: queued blk %u count %u\n", __FUNCTION__, io->blk,
+		   io->count); */
+		ra->blocks_queued += count;
+		ra->ios_queued++;
+		count -= blks_to_queue;
+		blk += blks_to_queue;
+	}
+}
+
+/*
+ * Read requested blocks, issuing any other waiting ios while we're at
+ * it.
+ */
+
+static void read_blks(struct readahead_state *ra, blk_t blk,
+		      unsigned int count, char *buf)
+{
+	dprintf(" RA: %s: blk %u count %u\n", __FUNCTION__, blk, count);
+
+	if (reject_io(ra, blk, count))
+		return;
+
+	/* Add to readahead queue */
+	queue_blks(ra, blk, count);
+	/*
+	 * Since we have to go to disk anyway, kick off and complete
+	 * all outstanding ios.
+	 */
+	issue_ios(ra);
+	/*
+	 * Retrieve specific data requested.  The cache used by this
+	 * block is already accounted for.
+	 */
+	io_channel_read_blk(ra->fs->io, blk, count, buf);
+}
+
+/*
+ * Inode table and indirect block readahead routines.
+ */
+
+/*
+ * Given a triple, double, or single indirect block, recursively
+ * traverse the indirect block tree.  Read triples and doubles
+ * immediately, but just add singles to the main block queue and read
+ * them at our convenience.
+ */
+
+static void readahead_ind_blk(struct readahead_state *ra, blk_t blk,
+			      int level, int print_header)
+{
+	unsigned int limit = ra->fs->blocksize >> 2;
+	blk_t *blk_ptr;
+	char *buf;
+	int i;
+
+	if (print_header)
+		dprintf(" RA: %*s%s: blk %u level %d\n", level * 4, "",
+			__FUNCTION__, blk, level);
+	else if (level != 0)
+		/* Start a new line */
+		dprintf("\n");
+
+	if (reject_io(ra, blk, 1))
+		return;
+
+	/* Single indirect block?  Just queue it up and return. */
+	if (level == 0) {
+		queue_blks(ra, blk, 1);
+		return;
+	}
+
+	/* Read double/triple immediately */
+	if (level == 1)
+		buf = ra->double_buf;
+	else
+		buf = ra->triple_buf;
+
+	read_blks(ra, blk, 1, buf);
+
+	/* Iterate through the block pointers */
+	blk_ptr = (blk_t *) buf;
+	dprintf(" RA: %*s%s(%d): read block %u into buf %p\n",
+		level * 4, "", __FUNCTION__, level, blk, buf);
+
+	for (i = 0; i < limit; i++) {
+		if (blk_ptr[i] != 0)
+			readahead_ind_blk(ra, blk_ptr[i], level - 1, 0);
+	}
+}
+
+/*
+ * Perform breadth-first traversal on the indirect blocks of the inode.
+ */
+
+static void readahead_inode(struct readahead_state *ra,
+			    struct ext2_inode *inode,
+			    ext2_ino_t ino)
+{
+	dprintf("%s: %d\n", __FUNCTION__, ino);
+
+	/* XXX Read acls and xattrs too */
+
+	if (inode->i_block[EXT2_IND_BLOCK])
+		readahead_ind_blk(ra, inode->i_block[EXT2_IND_BLOCK], 0, 1);
+	if (inode->i_block[EXT2_DIND_BLOCK])
+		readahead_ind_blk(ra, inode->i_block[EXT2_DIND_BLOCK], 1, 1);
+	if (inode->i_block[EXT2_TIND_BLOCK])
+		readahead_ind_blk(ra, inode->i_block[EXT2_TIND_BLOCK], 2, 1);
+}
+
+/*
+ * Start readahead for a set of inode tables.
+ *
+ * XXX Inode table readahead really, really ought to be parallelized,
+ * but the cache and io slot management is pretty hairy.  Why?
+ *
+ * - You can't just add the blocks to the cache for more than one
+ * inode table at once because the main thread will think the indirect
+ * blocks for the current inode table are ready and go read them -
+ * which will kill performance because reading indirect blocks out of
+ * order is pretty fatally slow.
+ *
+ * - You have to reserve some cache for indirect block reads for the
+ * current block group to complete or else readahead won't be able to
+ * progress, since all the cache will be locked up as pending and it
+ * will never make any of it available to the main thread.  To merely
+ * prevent deadlocks, you must reserve at least enough blocks for the
+ * maximum io size.  To make it perform well, you have to reserve more
+ * than that.  How much is enough?  Don't know.
+ *
+ * - To make sure you can read inode tables in parallel, you want to
+ * make sure you have enough io slots free.  Again, how many?  Should
+ * they be always reserved or can indirect block reads be able to use
+ * them?  Should you just issue all outstanding ios when you start
+ * reading a block group?  But then you have to change issue_ios so it
+ * doesn't mark the blocks as available in cache.
+ *
+ * Possible solutions:
+ *
+ * - Track inode table blocks and indirect blocks separately.  Messes
+ * up nice clean generic cache interface.
+ *
+ * - Track current inode number and don't let main thread process
+ * beyond that.  Have to worry about cache/inode progress deadlocks.
+ *
+ * - Reserve cache/io for inode table readaheads.  Danger of deadlocks
+ * waiting for cache waiting for io waiting for cache, etc..  How much
+ * to reserve not clear.
+ */
+
+static void readahead_inode_tables(struct readahead_state *ra, dgrp_t group,
+				  int count)
+{
+	int i;
+
+	dprintf(" RA: %s: Starting groups %u-%u cache_used %u\n",
+		__FUNCTION__, group, group + count - 1, ra->cache_used);
+
+	for (i = 0; i < count; i++)
+		queue_blks(ra, ra->fs->group_desc[group + i].bg_inode_table,
+			   ra->fs->inode_blocks_per_group);
+	/*
+	 * Kick off the io immediately since we'll need the blocks
+	 * right away.
+	 */
+	issue_ios(ra);
+}
+
+/*
+ * At the end of each block group, issue readahead for the next block
+ * group(s).
+ */
+
+static errcode_t readahead_scan_callback(ext2_filsys fs,
+			       ext2_inode_scan scan EXT2FS_ATTR((unused)),
+			       dgrp_t group, void * priv_data)
+{
+	struct readahead_state *ra = (struct readahead_state *) priv_data;
+	dgrp_t next_group = group + 1;
+
+	dprintf(" RA: %s: Finished group %u cache_used %d\n", __FUNCTION__,
+		group, ra->cache_used);
+
+	/* Any more blockgroups? */
+	if (next_group == fs->group_desc_count)
+		return 0;
+
+	/* Start readahead for next inode table(s) */
+	/* XXX count is always 1 for now - see comment */
+	readahead_inode_tables(ra, next_group, 1);
+	return 0;
+}
+
+/*
+ * Theory of readahead thread exit/kill:
+ *
+ * The readahead thread will end for one of two reasons: (1) This
+ * particular pass is successfully completed, (2) The main thread
+ * wants to kill readahead entirely because some pass was aborted.
+ * When either of these things happens, we need to exit the readahead
+ * thread safely and then run the exit function for this pass in the
+ * main thread's context.  The nasty bit is doing this while making
+ * sure we don't leave the cache mutex locked.  We really have to
+ * avoid the main thread blocking in any situation so that readahead
+ * doesn't make fsck *less* stable.  Pthreads doesn't offer any
+ * reasonable facilities for doing this, though.
+ *
+ * The solution is exactly the same one as the main fsck thread: Block
+ * cancellation and occasionally check at predetermined safe places if
+ * we should exit now.
+ *
+ * So the interface for cleaning up properly after passes goes like
+ * this:
+ *
+ * In the pass-specific init routine, set the thread_exit pointer to
+ * your exit function - after completing all setup that will be torn
+ * down on exit.
+ *
+ * Call readahead_thread_setup at start of the pass-specific main
+ * routine to disable cancellation.
+ *
+ * When the pass completes normally, it should call
+ * readahead_thread_exit().  This will exit the thread.  Pass-specific
+ * clean up will not happen until the main thread calls the pass exit
+ * function (clean up should be done in the same context as
+ * initialization).
+ *
+ * If something goes drastically wrong, the pass has to be restarted,
+ * or readahead needs to be disabled immediately for any reason, call
+ * ext2fs_readahead_kill().  This will set the "exit and cleanup"
+ * variable.  The readahead thread will eventually check it and
+ * correctly clean up and kill the current readahead thread.  From
+ * this point on, readahead is disabled and no future readahead
+ * requests will actually start.  If you want readahead to start
+ * again, start over again with ext2fs_readahead_init().
+ *
+ * Throughout the pass-specific readahead, use readahead_test_exit()
+ * to frequenttly check for the exit condition (e.g., don't do too
+ * much IO without checking for exit).
+ */
+
+/*
+ * Generic post-thread create setup.  Run it first thing as soon as
+ * the thread is created (in the new thread's context).
+ */
+
+static void readahead_thread_setup(struct readahead_state *ra)
+{
+	/*
+	 * Disable cancellation so that we can exit only at safe
+	 * points.
+	 */
+	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
+}
+
+/*
+ * Normal pass completion exit handler.
+ */
+
+static void readahead_thread_exit(struct readahead_state *ra)
+{
+	finish_ios(ra);
+}
+
+/*
+ * Check if readahead should exit entirely.  Currently it's just a
+ * check and an exit, but if anything is added, note that we do not
+ * want to do anything fancy because we're trying to kill all
+ * readahead activity as soon as possible without doing anything
+ * dangerous.  All pass-specific cleanup is done in the context of the
+ * caller.
+ *
+ * This function may not be called with the cache mutex held.
+ */
+
+static void readahead_test_exit(struct readahead_state *ra)
+{
+	if (!ra->should_exit)
+		return;
+
+	fprintf(stderr, "Readahead thread dying an untimely death.\n");
+
+	ra->enabled = 0;
+	pthread_exit(NULL);
+}
+
+/*
+ * Exit now.  Initiated from the readahead thread, rather than the
+ * main thread as in ext2fs_readahead_kill().
+ *
+ * This function may not be called with the cache mutex held.
+ */
+
+static void readhead_thread_exit_now(struct readahead_state *ra)
+{
+	ra->should_exit = 1;
+	readahead_test_exit(ra);
+}
+
+/*
+ * The inode readahead main function iterates over all the inodes in
+ * the file system, reading the indirect blocks if necessary, to get
+ * data in cache as efficiently as possible.  The main thread issues
+ * IOs synchronously and as-needed; we can do better.
+ */
+
+void * readahead_inode_loop(void *arg)
+{
+	struct readahead_state *ra = (struct readahead_state *) arg;
+	struct ext2_inode *inode;
+	ext2_ino_t ino = 0;
+
+	readahead_thread_setup(ra);
+
+	dprintf(" RA: %s\n", __FUNCTION__);
+
+	ext2fs_set_inode_callback(ra->scan, readahead_scan_callback, ra);
+
+	/* Start first bg readahead, rest are triggered by callback */
+	readahead_inode_tables(ra, 0, 1);
+
+	do {
+		ext2fs_get_next_inode_ptr(ra->scan, &ino, &inode);
+		/* Is it interesting? Readahead its indirect blocks */
+		if (!ra->should_read_inode || ra->should_read_inode(inode))
+			readahead_inode(ra, inode, ino);
+		/*
+		 * Check after every inode for exit request; we can
+		 * process a lot of inodes before hitting any other
+		 * exit points.
+		 */
+		readahead_test_exit(ra);
+	} while (ino);
+
+	readahead_thread_exit(ra);
+	/* Return value ignored */
+	return NULL;
+}
+
+/*
+ * Helper function for ext2fs_dblist_iterate.
+ */
+
+static int iter_dblist(ext2_filsys fs, struct ext2_db_entry *db,
+		       void *priv_data)
+{
+	struct readahead_state *ra = (struct readahead_state *) priv_data;
+
+	queue_blks(ra, db->blk, 1);
+
+	return 0;
+}
+
+/*
+ * Do the directory block readahead.
+ */
+
+void * readahead_dblist(void *arg)
+{
+	struct readahead_state *ra = (struct readahead_state *) arg;
+	errcode_t err;
+
+	readahead_thread_setup(ra);
+
+	err = ext2fs_dblist_iterate(ra->dblist, iter_dblist, ra);
+
+	if (err)
+		fprintf(stderr, "Error traversing directory blocks\n");
+
+	readahead_thread_exit(ra);
+
+	/* Return value ignored */
+	return NULL;
+}
+
+/*
+ * The client routines for readahead are called only by the main
+ * thread.  The rest of the readahead functions are called only by the
+ * readahead thread.  The client initializes, starts, and stops the
+ * readahead thread.  It informs the readahead thread when it has
+ * finished reading blocks from the cache.
+ *
+ * The distinction between the two threads is especially important
+ * when it comes to lseek()/read()/write() on the device file
+ * descriptor.  The two threads must never share an fd or the lseek()s
+ * will race with each other.  The readahead thread's fd is in the
+ * readahead struct; the main thread's fd is in the context struct
+ * (both are inside the ext2_filsys sturcture).  The main symptom of
+ * this bug is getting back data which is from somewhere on disk, just
+ * not the somewhere you wanted.
+ *
+ */
+
+static int readahead_disabled(struct readahead_state *ra)
+{
+	if ((ra == NULL) || !ra->enabled)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Put the cache and associated locks into the right state to start a
+ * readahead thread.
+ */
+
+static void readahead_cache_init(struct readahead_state *ra)
+{
+	pthread_mutex_init(&ra->cache_mutex, NULL);
+	pthread_cond_init(&ra->cache_wake, NULL);
+
+	ra->cache_used = 0;
+	ra->cache_needed = 0;
+	ra->cache_readahead_done = 0;
+}
+
+errcode_t ext2fs_readahead_init(ext2_filsys fs, unsigned int max_ios,
+				unsigned int cache_max,
+				struct readahead_state **ret_ra)
+{
+	struct readahead_state *ra;
+	int retval;
+
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	*ret_ra = NULL;
+
+	/*
+	 * Don't initialize readahead unless explicitly enabled by the
+	 * user passing the max ios argument.
+	 */
+
+	if (max_ios == 0)
+		return 0;
+
+	retval = ext2fs_get_mem(sizeof(*ra), &ra);
+	if (retval)
+		return retval;
+
+	/* Reopen the device so we don't share the file pointer */
+	retval = ext2fs_open2(fs->device_name, NULL,
+			      /* Don't ask for exclusive open because
+			       * we definitely won't get it. */
+			      (fs->flags && ~IO_FLAG_EXCLUSIVE), 0, 0,
+			      fs->io->manager, &ra->fs);
+	if (retval)
+		goto out;
+
+	/* Thread exit/kill management */
+	ra->should_exit = 0;
+	ra->thread_exit = NULL;
+
+	/* IO queue set up */
+	ra->max_ios = max_ios;
+	dprintf("MT: %s: Maximum ios %u\n", __FUNCTION__, ra->max_ios);
+	ra->timeout = 100; /* milliseconds, currently not used */
+	/* Not sure how big to make this, but must be at least max_ios */
+	ra->io_queue_size = ra->max_ios * 10;
+	dprintf("MT: %s: IO queue size %u\n", __FUNCTION__, ra->io_queue_size);
+	ra->ios_queued = 0;
+	retval = ext2fs_get_mem(sizeof(ra->io_queue[0]) * ra->io_queue_size,
+				&ra->io_queue);
+	if (retval)
+		goto out_close;
+	/* Clear the queue for debugging purposes */
+	memset(ra->io_queue, 0, sizeof(ra->io_queue[0]) * ra->io_queue_size);
+
+	/* Cache set up */
+
+	/*
+	 * Max memory must be at least as big as an inode table.  Make
+	 * the minimum four times that so we can get more than one
+	 * block group ahead and read some indirect blocks too.
+	 */
+	ra->cache_max = cache_max;
+	/* XXX currently measuring cache_max in file system blocks, yuck */
+	if (ra->cache_max < ra->fs->inode_blocks_per_group) {
+		ra->cache_max = 4 * ra->fs->inode_blocks_per_group;
+		if (cache_max != 0)
+			/* XXX use ext2 printing routines */
+			fprintf(stderr, "Maximum cache %u blocks too small; "
+				"raised to %u blocks", cache_max,
+				ra->cache_max);
+	}
+	dprintf("MT: %s: Maximum cache %u\n", __FUNCTION__, ra->cache_max);
+
+	readahead_cache_init(ra);
+	/*
+	 * When the cache gets full, the readahead thread sleeps.
+	 * When the cache gets empty, the main thread sleeps.  If we
+	 * wake the threads at empty/full, then we end up with an
+	 * inefficient ping-pong effect where the readahead thread
+	 * only issues one io before going back to sleep.  The ideal
+	 * pattern is where the readahead thread caches a bunch of
+	 * blocks, then goes back to sleep until a lot of the cache is
+	 * free again, so it issue lots of ios in parallel.  When the
+	 * main thread wakes/sleeps is less important, other than
+	 * avoiding a lot of signal/wake traffic if it's near the
+	 * readahead thread wake point or near the cache boundaries.
+	 * Wait to wake it up until the cache is close to full.
+	 *
+	 * XXX Should wake main thread sooner?
+	 */
+
+	/* Restart readahead when the cache gets this low */
+	ra->cache_restart_ra = ra->cache_max / 3;
+	dprintf("MT: %s: Readahead restarts at %u\n", __FUNCTION__,
+	       ra->cache_restart_ra);
+	ra->cache_restart_main = (ra->cache_max * 2) / 3;
+	dprintf("MT: %s: Main thread restarts at %u\n", __FUNCTION__,
+	       ra->cache_restart_main);
+
+	/* Maxium io size (in blocks) should be less than the cache size */
+	/* XXX should be command line option */
+	ra->max_io_size = (256 * 1024) / ra->fs->blocksize;
+	if (ra->max_io_size > ra->cache_max) {
+		dprintf("MT: %s: Maximum io size %u larger than cache %u\n",
+			__FUNCTION__, ra->max_io_size, ra->cache_max);
+		ra->max_io_size = ra->cache_max / 4;
+	}
+	dprintf("MT: %s: Maximum io size %u\n", __FUNCTION__, ra->max_io_size);
+
+	/* Make scratch buffer big enough for largest ios */
+	retval = ext2fs_get_mem(ra->max_io_size * ra->fs->blocksize,
+				&ra->scratch_buf);
+	if (retval)
+		goto out_free_queue;
+
+	ra->enabled = 1;
+	*ret_ra = ra;
+	return 0;
+
+ out_free_queue:
+	ext2fs_free_mem(&ra->io_queue);
+ out_close:
+	ext2fs_close(ra->fs);
+ out:
+	ext2fs_free_mem(&ra);
+	fprintf(stderr, "Readahead failed to initialize.\n");
+	return retval;
+}
+
+void ext2fs_readahead_exit(struct readahead_state **ret_ra)
+{
+	struct readahead_state *ra = *ret_ra;
+
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (!ra)
+		return;
+
+	pthread_mutex_destroy(&ra->cache_mutex);
+	pthread_cond_destroy(&ra->cache_wake);
+	ext2fs_free_mem(&ra->scratch_buf);
+	ext2fs_free_mem(&ra->io_queue);
+	ext2fs_close(ra->fs);
+	ext2fs_free_mem(&ra);
+	*ret_ra = NULL;
+}
+
+/*
+ * Release blocks that have already been read.  Primitive for the
+ * various release runctions.
+ */
+
+static void blocks_release(struct readahead_state *ra, ext2_filsys fs,
+			   blk_t blk, int count)
+{
+	dprintf("MT: %s: cache_used %d releasing %d\n", __FUNCTION__,
+		ra->cache_used, count);
+	pthread_mutex_lock(&ra->cache_mutex);
+	ra->cache_used -= count;
+	/*
+	 * Did we get ahead of readahead?
+	 *
+	 * XXX Main thread hangs on cache_used == 0; current
+	 * workaround is to add a bogus block to the cache on exit.
+	 */
+	if (ra->cache_used <= 0) {
+		dprintf("MT: %s: Cache empty, waking readahead thread\n",
+			__FUNCTION__);
+		pthread_cond_signal(&ra->cache_wake);
+		dprintf("MT: %s: Waiting for readahead to populate cache...\n",
+			__FUNCTION__);
+		/* XXX use timeout to avoid deadlock on fatal bugs */
+		pthread_cond_wait(&ra->cache_wake, &ra->cache_mutex);
+		dprintf("MT: %s: Continuing, cache_used %d\n", __FUNCTION__,
+			ra->cache_used);
+	}
+	/*
+	 * Wake readahead thread if we have enough free cache to issue
+	 * io efficiently.
+	 */
+	if ((ra->cache_used + count) > ra->cache_restart_ra &&
+	    (ra->cache_used <= ra->cache_restart_ra)) {
+		/* Do we have enough cache to satisfy any specific need? */
+		if ((ra->cache_used + ra->cache_needed <= ra->cache_max)) {
+			dprintf("MT: %s: Cache available, waking readahead "
+				"(needed %u used %d)\n", __FUNCTION__,
+				ra->cache_needed, ra->cache_used);
+			pthread_cond_signal(&ra->cache_wake);
+			/* Don't keep waking it over and over... */
+			ra->cache_needed = 0;
+		}
+	}
+	pthread_mutex_unlock(&ra->cache_mutex);
+	/* Optional but nice: Let vm know we don't need these any more */
+	io_channel_cache_release(fs->io, blk, count);
+}
+
+/*
+ * ext2fs_block_iterate2 helper function for releasing indirect
+ * blocks.
+ */
+
+static int ind_block_release(ext2_filsys fs, blk_t *block_nr,
+		  e2_blkcnt_t blockcnt,
+		  blk_t ref_block EXT2FS_ATTR((unused)),
+		  int ref_offset EXT2FS_ATTR((unused)),
+		  void *priv_data)
+{
+	struct readahead_state *ra = (struct readahead_state *) priv_data;
+
+	/*
+	 * The blockcnt arg is the total number of data blocks (?)
+	 * traversed so far for this inode, not the number of blocks
+	 * to release.
+	 */
+	blocks_release(ra, fs, *block_nr, 1);
+
+	return 0;
+}
+
+/*
+ * Mark all cached blocks from this inode as released.
+ */
+
+void ext2fs_readahead_inode_release(struct readahead_state *ra,
+				    ext2_filsys fs, ext2_ino_t ino, char *block_buf)
+{
+	errcode_t err;
+
+	dprintf("MT: %s: %u\n", __FUNCTION__, ino);
+
+	if (readahead_disabled(ra))
+		return;
+
+	/*
+	 * Don't use ra->fs - that contains the readahead thread's fd
+	 * - using the same fd results in exciting lseek()/read()
+	 * races.
+	 */
+	err = ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_IND_ONLY,
+				    block_buf, ind_block_release, ra);
+
+	/* Can't return this error, but can notify user */
+	if (err)
+		fprintf(stderr, "%s: Error %d traversing indirect blocks "
+			"for ino %u\n",  __FUNCTION__, (int) err, ino);
+}
+
+/*
+ * Mark all cached blocks from this inode table as used.
+ */
+
+void ext2fs_readahead_inode_table_release(struct readahead_state *ra,
+					  ext2_filsys fs, dgrp_t group)
+{
+	if (readahead_disabled(ra))
+		return;
+
+	dprintf("MT: %s: Finished group %u cache_used %u\n",
+		__FUNCTION__, group, ra->cache_used);
+
+	blocks_release(ra, fs, ra->fs->group_desc[group].bg_inode_table,
+		       ra->fs->inode_blocks_per_group);
+}
+
+/*
+ * Generic thread start.  Pass it the function for starting this pass
+ * of readahead.
+ */
+
+static void readahead_thread_start(struct readahead_state *ra,
+				   void * (*thread_start)(void *))
+{
+	if (pthread_create(&ra->thread, NULL, thread_start, ra)) {
+		fprintf(stderr, "Thread failed to start.\n");
+		ra->enabled = 0;
+		return;
+	}
+
+	/*
+	 * Wait for readahead to put something in the cache.  The
+	 * readahead thread might have already read something into the
+	 * cache and signaled us to wake, so only wait if nothing is
+	 * in the cache already.
+	 */
+	pthread_mutex_lock(&ra->cache_mutex);
+	if (ra->cache_used == 0)
+		pthread_cond_wait(&ra->cache_wake, &ra->cache_mutex);
+	pthread_mutex_unlock(&ra->cache_mutex);
+}
+
+/*
+ * Signal the current readahead thread to stop.  Call it before
+ * freeing any resources that the readahead thread might access.
+ *
+ * This function must complete in the case of the thread exiting
+ * before or during this function.
+ */
+
+static void readahead_thread_stop(struct readahead_state *ra)
+{
+	ra->should_exit = 1;
+	/*
+	 * Wake readahead thread in case it's waiting on cache.  The
+	 * readahead thread must test for exit after every
+	 * pthread_cond_wait().
+	 */
+	pthread_mutex_lock(&ra->cache_mutex);
+	pthread_cond_signal(&ra->cache_wake);
+	pthread_mutex_unlock(&ra->cache_mutex);
+	/*
+	 * At this point, the readahead thread has either (a) already
+	 * exited, or (b) is running but will call
+	 * readahead_test_exit() shortly and exit then.
+	 */
+	pthread_join(ra->thread, NULL);
+	/* Now the readahead thread is dead for sure */
+
+	/* Run the pass-specific clean up */
+	if (ra->thread_exit)
+		ra->thread_exit(ra);
+	ra->thread_exit = NULL;
+
+	readahead_cache_init(ra);
+	ra->should_exit = 0;
+
+	/*
+	 * Check to see if the readahead thread encountered some
+	 * problem and disabled readahead.  In that case, close down
+	 * readahead entirely.  To restart, call
+	 * ext2fs_readahead_init().
+	 */
+	if (readahead_disabled(ra))
+		ext2fs_readahead_exit(&ra);
+}
+
+/*
+ * Use this to kill readahead entirely and turn it off until
+ * ext2fs_readahead_init() is called again.  It is safe to call any
+ * ext2fs_readahead_* function after this since readahead will be
+ * disabled.
+ */
+
+void ext2fs_readahead_kill(struct readahead_state *ra)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (!ra)
+		return;
+
+	readahead_thread_stop(ra);
+
+	ra->enabled = 0;
+}
+
+/*
+ * Clean up after inode readahead.
+ */
+
+static void readahead_inode_exit(struct readahead_state *ra)
+{
+	ext2fs_close_inode_scan(ra->scan);
+	ext2fs_free_mem(&ra->triple_buf);
+	ext2fs_free_mem(&ra->double_buf);
+	ra->should_read_inode = NULL;
+}
+
+/*
+ * Initialize inode readahead state.
+ */
+
+void ext2fs_readahead_inode_init(struct readahead_state *ra,
+				 int (*should_read_inode)(struct ext2_inode *))
+{
+	if (readahead_disabled(ra))
+		return;
+
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	/*
+	 * Allocate buffers for saving triple and double indirect
+	 * blocks while recursively queueing and issuing ios for the
+	 * block pointers they contain.  Don't need any for single
+	 * indirect blocks because we don't have to read the data
+	 * blocks they point to.
+	 */
+
+	if (ext2fs_get_mem(ra->fs->blocksize, &ra->double_buf))
+		goto out;
+
+	if (ext2fs_get_mem(ra->fs->blocksize, &ra->triple_buf))
+		goto out_free_double;
+
+	if (ext2fs_open_inode_scan(ra->fs, 8, &ra->scan)) {
+		fprintf(stderr, "Open inode scan failed, disabling "
+			"readahead\n");
+		goto out_free_double;
+	}
+
+	ra->should_read_inode = should_read_inode;
+	ra->thread_exit = readahead_inode_exit;
+
+	return;
+
+ out_free_double:
+	ext2fs_free_mem(&ra->double_buf);
+ out:
+	fprintf(stderr, "Inode readahead failed to initialize.\n");
+	ra->enabled = 0;
+}
+
+/*
+ * Kick off inode readahead.
+ */
+
+void ext2fs_readahead_inode_start(struct readahead_state *ra)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (readahead_disabled(ra))
+		return;
+
+	readahead_thread_start(ra, readahead_inode_loop);
+}
+
+/*
+ * Stop the inode readahead thread.  readahead_thread_stop() does all
+ * the actual work, including running the thread_exit function.
+ */
+
+void ext2fs_readahead_inode_exit(struct readahead_state *ra)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (readahead_disabled(ra))
+		return;
+
+	readahead_thread_stop(ra);
+}
+
+/*
+ * Release a block from the directory block list.
+ */
+
+void ext2fs_readahead_dblist_release(struct readahead_state *ra,
+				     ext2_filsys fs, blk_t blk)
+{
+	if (readahead_disabled(ra))
+		return;
+
+	blocks_release(ra, fs, blk, 1);
+}
+
+/*
+ * Clean up after directory block readahead.
+ */
+
+static void readahead_dblist_exit(struct readahead_state *ra)
+{
+	ra->dblist = NULL;
+}
+
+/*
+ * Set up the directory block readahead thread.
+ */
+
+void ext2fs_readahead_dblist_init(struct readahead_state *ra,
ext2_dblist dblist)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (readahead_disabled(ra))
+		return;
+
+	ra->dblist = dblist;
+	ra->thread_exit = readahead_dblist_exit;
+}
+
+/*
+ * Start the directory block readahead thread.
+ *
+ * Don't alter the dblist (i.e., sort it) after starting the dblist
+ * readahead, or you'll have some fabulous race conditions.  Note that
+ * ext2_dblist_iterate will sort the dblist if it's not already
+ * sorted.  Sort the dblist BEFORE you call this function.
+ */
+
+void ext2fs_readahead_dblist_start(struct readahead_state *ra)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (readahead_disabled(ra))
+		return;
+
+	readahead_thread_start(ra, readahead_dblist);
+}
+
+void ext2fs_readahead_dblist_exit(struct readahead_state *ra)
+{
+	dprintf("MT: %s\n", __FUNCTION__);
+
+	if (readahead_disabled(ra))
+		return;
+
+	readahead_thread_stop(ra);
+}
--- e2fsprogs-1.40.4.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40.4/e2fsck/pass2.c
@@ -148,9 +148,17 @@ void e2fsck_pass2(e2fsck_t ctx)

 	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
 		ext2fs_dblist_sort(fs->dblist, special_dir_block_cmp);
-	
+	else
+		ext2fs_dblist_sort(fs->dblist, 0);
+
+	/* Start readahead after the dblist has been sorted */
+	ext2fs_readahead_dblist_init(ctx->ra, fs->dblist);
+	ext2fs_readahead_dblist_start(ctx->ra);
+
 	cd.pctx.errcode = ext2fs_dblist_iterate(fs->dblist, check_dir_block,
 						&cd);
+	ext2fs_readahead_dblist_exit(ctx->ra);
+
 	if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 		return;
 	if (cd.pctx.errcode) {
@@ -778,6 +786,8 @@ static int check_dir_block(ext2_filsys f
 	
 	old_op = ehandler_operation(_("reading directory block"));
 	cd->pctx.errcode = ext2fs_read_dir_block(fs, block_nr, buf);
+	/* Release the block now - it is already in our memory */
+	ext2fs_readahead_dblist_release(ctx->ra, fs, block_nr);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
--- e2fsprogs-1.40.4.orig/lib/ext2fs/inode.c
+++ e2fsprogs-1.40.4/lib/ext2fs/inode.c
@@ -491,6 +491,76 @@ errcode_t ext2fs_get_next_inode_full(ext
 	return retval;
 }

+errcode_t ext2fs_get_next_inode_ptr(ext2_inode_scan scan, ext2_ino_t *ino,
+				    struct ext2_inode **inode)
+{
+	errcode_t	retval;
+	int		extra_bytes = 0;
+
+	EXT2_CHECK_MAGIC(scan, EXT2_ET_MAGIC_INODE_SCAN);
+
+	/*
+	 * Do we need to start reading a new block group?
+	 */
+	if (scan->inodes_left <= 0) {
+	force_new_group:
+		if (scan->done_group) {
+			retval = (scan->done_group)
+				(scan->fs, scan, scan->current_group,
+				 scan->done_group_data);
+			if (retval)
+				return retval;
+		}
+		if (scan->groups_left <= 0) {
+			*ino = 0;
+			return 0;
+		}
+		retval = get_next_blockgroup(scan);
+		if (retval)
+			return retval;
+	}
+	/*
+	 * These checks are done outside the above if statement so
+	 * they can be done for block group #0.
+	 */
+	if ((scan->scan_flags & EXT2_SF_DO_LAZY) &&
+	    (scan->fs->group_desc[scan->current_group].bg_flags &
+	     EXT2_BG_INODE_UNINIT))
+		goto force_new_group;
+	if (scan->current_block == 0) {
+		if (scan->scan_flags & EXT2_SF_SKIP_MISSING_ITABLE) {
+			goto force_new_group;
+		} else
+			return EXT2_ET_MISSING_INODE_TABLE;
+	}
+
+	/*
+	 * Have we run out of space in the inode buffer?  If so, we
+	 * need to read in more blocks.
+	 */
+	if (scan->bytes_left < scan->inode_size) {
+		memcpy(scan->temp_buffer, scan->ptr, scan->bytes_left);
+		extra_bytes = scan->bytes_left;
+
+		retval = get_next_blocks(scan);
+		if (retval)
+			return retval;
+	}
+
+	/* XXX ignoring extra_bytes logic */
+	/* Return a pointer directly to the inode buffer... Don't write it. */
+	*inode = (struct ext2_inode *) scan->ptr;
+	scan->ptr += scan->inode_size;
+	scan->bytes_left -= scan->inode_size;
+	if (scan->scan_flags & EXT2_SF_BAD_INODE_BLK)
+		retval = EXT2_ET_BAD_BLOCK_IN_INODE_TABLE;
+
+	scan->inodes_left--;
+	scan->current_inode++;
+	*ino = scan->current_inode;
+	return retval;
+}
+
 errcode_t ext2fs_get_next_inode(ext2_inode_scan scan, ext2_ino_t *ino,
 				struct ext2_inode *inode)
 {
