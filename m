From: Valerie Henson <val@nmt.edu>
Subject: [PATCH] Threaded e2fsck proof of concept
Date: Wed, 26 Sep 2007 12:25:44 -0600
Message-ID: <20070926182543.GA18651@rainbow>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhost.NMT.EDU ([129.138.4.52]:48387 "EHLO mailhost.nmt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761097AbXIZSZx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2007 14:25:53 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The below patch is a proof of concept that e2fsck can get a
performance improvement on file systems with more than one disk
underneath.  On my test case, a 500GB file system with 150GB in use
and 10+1 RAID underneath, elapsed time is reduced by 40-50%.  I see no
performance improvement in the single disk case.  Only the reading of
inode tables and indirect blocks in pass 1 is multi-threaded; most
likely multithreading passes 2 and 5 will help too.  The actual data
processing is still all single-threaded, which is convenient.

Designing multithreaded readahead for the long term is another
question.  The Lustre folks are working on a sys_readahead() based
patch.  True aio() is the obvious solution, but won't work for older
kernels.  Pthreads works for all kernels but is clumsy.  Coming up
with a design for readahead that allows these different
implementations is probably a good idea.

Finally, if you are planning on testing these patches:

* Use -n!  You are crazy to let this write to your file system.
* Use about 2 * number_disks threads. (Doesn't work without -t <n> of
  some sort.)
* The striping logic is probably bogus.  Try something like -A 100000.

Thanks to EMC for making this patch possible.  Share and enjoy!

-VAL

--- e2fsprogs-1.40.2.orig/e2fsck/Makefile.in
+++ e2fsprogs-1.40.2/e2fsck/Makefile.in
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
--- e2fsprogs-1.40.2.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.2/e2fsck/e2fsck.h
@@ -25,6 +25,7 @@
 #ifdef HAVE_SETJMP_H
 #include <setjmp.h>
 #endif
+#include <pthread.h>
 
 #if EXT2_FLAT_INCLUDES
 #include "ext2_fs.h"
@@ -334,6 +335,17 @@ struct e2fsck_struct {
 	profile_t	profile;
 
 	/*
+	 * Multithreaded readahead variables
+	 */
+	unsigned int read_threads;
+	unsigned int stripe_size;
+	struct readahead_state *readahead;
+	/* Used to signal the main thread when a bg is ready */
+	pthread_mutex_t mutex_ready;
+	pthread_cond_t buffer_ready;
+	/* Have to count groups left at the ctx level, not scan level */
+	dgrp_t groups_left;
+	/*
 	 * For the use of callers of the e2fsck functions; not used by
 	 * e2fsck functions themselves.
 	 */
--- e2fsprogs-1.40.2.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.2/e2fsck/pass1.c
@@ -96,9 +96,64 @@ struct process_inode_block {
 	struct ext2_inode inode;
 };
 
-struct scan_callback_struct {
+/*
+ * XXX Complete and total interface violation
+ *
+ * We need to skip around between block groups based on when they're
+ * done with readahead, rather than processing them sequentially.
+ * Probably just using the fs->get_blocks hook or something similar
+ * will work and will cut a few hundred lines of code.  For now, mess
+ * around with libext2fs's private structures.
+ *
+ */
+
+struct ext2_struct_inode_scan {
+	errcode_t		magic;
+	ext2_filsys		fs;
+	ext2_ino_t		current_inode;
+	blk_t			current_block;
+	dgrp_t			current_group;
+	ext2_ino_t		inodes_left;
+	blk_t			blocks_left;
+	dgrp_t			groups_left;
+	blk_t			inode_buffer_blocks;
+	char *			inode_buffer;
+	int			inode_size;
+	char *			ptr;
+	int			bytes_left;
+	char			*temp_buffer;
+	errcode_t		(*done_group)(ext2_filsys fs,
+					      ext2_inode_scan scan,
+					      dgrp_t group,
+					      void * priv_data);
+	void *			done_group_data;
+	int			bad_block_ptr;
+	int			scan_flags;
+	int			reserved[6];
+};
+
+/*
+ * Per thread readahead state.
+ */
+
+struct readahead_state {
+	ext2_filsys	fs;
+	ext2_inode_scan	scan;
 	e2fsck_t	ctx;
-	char		*block_buf;
+	pthread_t	pthread;
+	unsigned int	thread;
+	int		bg_readahead_done;
+	pthread_mutex_t	mutex;
+	pthread_cond_t	pause;
+	blk_t		*ind_blks_queue;
+	unsigned int	ind_blks_count;
+	char		*ind_blks_bufs[3];
+};
+
+struct scan_callback_struct {
+	e2fsck_t		ctx;
+	char			*block_buf;
+	struct readahead_state	*readahead;
 };
 
 /*
@@ -107,6 +162,373 @@ struct scan_callback_struct {
 static struct process_inode_block *inodes_to_process;
 static int process_inode_count;
 
+/*
+ * For the indirect block readahead queue.
+ */
+
+static unsigned int ind_blks_queue_size = 1024; /* Should be an option */
+static unsigned int bad_ind_blk_count;
+
+/*
+ * Minimal sanity check on indirect block addresses during readahead.
+ */
+
+static int
+check_sanity(struct readahead_state *readahead, blk_t blk)
+{
+	e2fsck_t ctx = readahead->ctx;
+	if (blk >= ctx->fs->super->s_blocks_count ||
+	    blk < ctx->fs->super->s_first_data_block) {
+		bad_ind_blk_count++;
+#if 0
+		return 1;
+#else
+		/* Crash for debugging purposes */
+		* (char *) 0 = 0;
+#endif
+	}
+	return 0;
+}
+
+static void
+ind_block_readahead(struct readahead_state *readahead, blk_t blk, char *buf)
+{
+	if (check_sanity(readahead, blk))
+		return;
+#if 0
+	printf("Pre read of ind blk %u\n", blk);
+#endif
+	/* Read the block and hope it sticks in buffer cache */
+	io_channel_read_blk(readahead->fs->io, blk, 1, buf);
+}
+
+static EXT2_QSORT_TYPE process_ind_blks_cmp(const void *a, const void *b)
+{
+	const blk_t *blk_a = (const blk_t *) a;
+	const blk_t *blk_b = (const blk_t *) b;
+
+	return *blk_a - *blk_b;
+}
+
+static void
+process_ind_blks(struct readahead_state *readahead)
+{
+	blk_t *queue = readahead->ind_blks_queue;
+	unsigned int count = readahead->ind_blks_count;
+	char *buf = readahead->ind_blks_bufs[0];
+	int i;
+
+	if (count == 0)
+		return;
+	qsort(queue, count, sizeof (queue[0]), process_ind_blks_cmp);
+	for (i = 0; i < count; i++)
+		ind_block_readahead(readahead, queue[i], buf);
+	readahead->ind_blks_count = 0;
+}
+
+/*
+ * Add indirect blocks to the queue of to-be-read blocks.
+ *
+ * The queue is the obvious performance optimization - sort the blocks
+ * to be read by address.  The double/triples are read immediately and
+ * the singles put in the queue.  I wrote a version where the
+ * doubles/triples had their own queues and were sorted and read
+ * independently, but that went slower.
+ *
+ * This effectively does the exact same optimization as the inode
+ * sorting, just simplified since we're not doing the inode checks at
+ * the same time.
+ */
+
+static void
+add_to_queue(struct readahead_state *readahead, blk_t blk, int level)
+{
+	blk_t *queue = readahead->ind_blks_queue;
+	unsigned int count = readahead->ind_blks_count;
+	char *buf = readahead->ind_blks_bufs[level];
+	e2fsck_t ctx = readahead->ctx;
+	int limit = ctx->fs->blocksize >> 2;
+	blk_t *blk_ptrs;
+	int i;
+
+	if (blk == 0)
+		return;
+	if (check_sanity(readahead, blk))
+		return;
+
+	if (level == 0) {
+		/* Single indirect block */
+		if (count == ind_blks_queue_size)
+			process_ind_blks(readahead);
+		queue[count] = blk;
+		readahead->ind_blks_count++;
+	} else {
+		/* Double or triple - read it and rerun */
+		ind_block_readahead(readahead, blk, buf);
+		blk_ptrs = (blk_t *) buf;
+		for (i = 0; i < limit; i++)
+			add_to_queue(readahead, blk_ptrs[i], level - 1);
+	}
+}
+
+/*
+ * Do readahead on inodes in a block group.
+ */
+
+static void
+readahead_ind_blocks(struct readahead_state *readahead)
+{
+	ext2_inode_scan scan = readahead->scan;
+	struct ext2_inode *inode_array = (struct ext2_inode *) scan->inode_buffer;
+	struct ext2_inode *inode;
+	int num_inodes = scan->inodes_left;
+	int i;
+
+	for (i = 0; i < num_inodes; i++) {
+		inode = &inode_array[i];
+		if (ext2fs_inode_has_valid_blocks(inode)) {
+			/* add_to_queue deals with zero pointers, etc. */
+			add_to_queue(readahead, inode->i_block[EXT2_IND_BLOCK], 0);
+			add_to_queue(readahead, inode->i_block[EXT2_DIND_BLOCK], 1);
+			add_to_queue(readahead, inode->i_block[EXT2_TIND_BLOCK], 2);
+		}
+	}
+	/* Finish off the queue */
+	process_ind_blks(readahead);
+}
+
+/*
+ * Find the next block group number in our stripe.
+ *
+ * Currently readahead is done on block group boundaries.  It may make
+ * more sense to ignore block group boundaries, since block groups can
+ * straddle stripes.  This should probably interact with the stripe
+ * size setting used when creating the file system.
+ */
+
+static dgrp_t
+next_bg_in_stripe(struct readahead_state *readahead)
+{
+	ext2_inode_scan scan = readahead->scan;
+	dgrp_t new_grp = scan->current_group + 1;
+	unsigned long long new_block;
+	unsigned long long new_byte;
+	unsigned long long stripe;
+	unsigned int thread;
+
+	for (new_grp = scan->current_group + 1;
+	     new_grp < readahead->ctx->fs->group_desc_count;
+	     new_grp++) {
+		/* Get the block offset of the inode table */
+		new_block = scan->fs->
+			group_desc[new_grp].bg_inode_table;
+		/* Convert to bytes - stripe size is in bytes */
+		new_byte = new_block * scan->fs->blocksize;
+		/* Divide bytes by stripe size to get a stripe number */
+		stripe = new_byte / readahead->ctx->stripe_size;
+		/* Modulo number of threads to get thread number */
+		thread = stripe % readahead->ctx->read_threads;
+#if 0
+		printf("block %llu byte %llu stripe %llu thread %u read_threads %u\n",
+		       new_block, new_byte, stripe, thread, readahead->ctx->read_threads);
+#endif
+		if (thread == readahead->thread)
+			break;
+	}
+	printf("Thread %u chooses bg %d\n", readahead->thread, new_grp);
+	return new_grp;
+}
+
+/*
+ * Stolen from inode.c and modified for multi-threaded I/O.
+ *
+ * This function is called by ext2fs_get_next_inode when it needs to
+ * read in more blocks from the current blockgroup's inode table.
+ *
+ * This is, of course, a gross violation of the inteface and has to be
+ * fixed.
+ */
+
+static int get_next_blocks_threaded(struct readahead_state *readahead)
+{
+	ext2_inode_scan scan = readahead->scan;
+	blk_t		num_blocks;
+
+	scan->current_group = next_bg_in_stripe(readahead);
+	if (scan->current_group >= scan->fs->group_desc_count)
+		return 0;
+
+	scan->current_block = scan->fs->
+		group_desc[scan->current_group].bg_inode_table;
+
+	scan->current_inode = scan->current_group *
+		EXT2_INODES_PER_GROUP(scan->fs->super);
+
+	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
+	scan->blocks_left = scan->fs->inode_blocks_per_group;
+	/*
+	 * We read an entire block group at once, and we aren't called
+	 * unless there is a block group to read.
+	 */
+	num_blocks = scan->inode_buffer_blocks;
+
+	/* Ignore bad blocks for now. */
+	io_channel_read_blk(readahead->fs->io,
+			    scan->current_block,
+			    (int) num_blocks,
+			    scan->inode_buffer);
+	scan->ptr = scan->inode_buffer;
+	scan->bytes_left = num_blocks * scan->fs->blocksize;
+	/*
+	 * The end result is that blocks_left is 0.  This is because
+	 * it is used to decided how many more blocks in this block
+	 * group are left to read in.
+	 */
+	scan->blocks_left -= num_blocks;
+	if (scan->current_block)
+		scan->current_block += num_blocks;
+	return 1;
+}
+
+/*
+ * Read block groups in our stripe until there are no more.
+ */
+
+static void *
+readahead_bg_loop(void *arg)
+{
+	struct readahead_state *readahead = arg;
+	printf("Thread %u starting\n", readahead->thread);
+	/* Read in the block group */
+	while (get_next_blocks_threaded(readahead) != 0) {
+		/* Read in the indirect blocks */
+		readahead_ind_blocks(readahead);
+		/*
+		 * All done!  Once we set the readahead_done flag, the
+		 * main thread could come in, eat our buffer, and send
+		 * us the wake up signal at any point.  Hold the lock
+		 * across all this so we don't miss the signal.
+		 */
+		pthread_mutex_lock(&readahead->mutex);
+		readahead->bg_readahead_done = 1;
+		/* Signal main thread that we are done with the bg*/
+		pthread_mutex_lock(&readahead->ctx->mutex_ready);
+		pthread_cond_signal(&readahead->ctx->buffer_ready);
+		pthread_mutex_unlock(&readahead->ctx->mutex_ready);
+		/* Sleep until main thread has used our buffer */
+		printf("Thread %d sleeping\n", readahead->thread);
+		pthread_cond_wait(&readahead->pause, &readahead->mutex);
+		pthread_mutex_unlock(&readahead->mutex);
+	}
+	printf("Thread %u exiting\n", readahead->thread);
+	pthread_exit(0);
+}
+
+static void
+readahead_start_thread(struct readahead_state *readahead, unsigned int thread)
+{
+	readahead->thread = thread;
+	pthread_mutex_init(&readahead->mutex, NULL);
+	pthread_cond_init(&readahead->pause, NULL);
+	readahead->bg_readahead_done = 0;
+	pthread_create(&readahead->pthread, NULL, readahead_bg_loop, readahead);
+}
+
+static void
+readahead_shutdown(e2fsck_t ctx)
+{
+	int threads = ctx->read_threads;
+	struct readahead_state *readahead;
+	int i;
+
+	for (i = 0; i < threads; i++) {
+		readahead = &ctx->readahead[i];
+		pthread_mutex_lock(&readahead->mutex);
+		pthread_cond_signal(&readahead->pause);
+		pthread_mutex_unlock(&readahead->mutex);
+		printf("Shutting down thread %d... ", i);
+		pthread_join(readahead->pthread, NULL);
+		printf("done\n");
+		ext2fs_free_mem(&readahead->ind_blks_bufs[0]);
+		ext2fs_free_mem(&readahead->ind_blks_bufs[1]);
+		ext2fs_free_mem(&readahead->ind_blks_bufs[2]);
+		ext2fs_free_mem(&readahead->ind_blks_queue);
+		ext2fs_close_inode_scan(readahead->scan);	
+	}
+}
+
+/*
+ * Find a block group that's done with readahead.
+ */
+
+static void
+get_ready_blockgroup(struct readahead_state **readaheadp)
+{
+	e2fsck_t ctx = (*readaheadp)->ctx;
+	static int last_index = 0;
+	struct readahead_state *readahead;
+	int i;
+	int index;
+
+	pthread_mutex_lock(&ctx->mutex_ready);
+ restart:
+	printf("Main thread: ");
+	for (i = 0; i < ctx->read_threads; i++) {
+		/* Start from the last thread + 1 to evenly spread the workload */
+		index = (last_index + 1 + i) % ctx->read_threads;
+		printf("%d ", index);
+		readahead = &ctx->readahead[index];
+		if (readahead->bg_readahead_done) {
+			/* Found! */
+			printf("\nPicked thread %d bg %d (%d/%d left)\n",
+			       index, readahead->scan->current_group,
+			       ctx->groups_left, ctx->fs->group_desc_count);
+			ctx->groups_left--;
+			last_index = index;
+			readahead->bg_readahead_done = 0;
+			*readaheadp = readahead;
+			pthread_mutex_unlock(&ctx->mutex_ready);
+			return;
+		}
+	} 
+	printf("...nothing\n");
+	/*
+	 * No readahead threads are ready, go to sleep and wait for
+	 * one to finish.  This is going to happen a lot unless you're
+	 * by some miracle not I/O bound.
+	 */
+	pthread_cond_wait(&ctx->buffer_ready, &ctx->mutex_ready);
+	goto restart;
+}
+
+/*
+ * Called when we're done with the current block group.
+ */
+
+static int
+get_next_blockgroup_threaded(struct readahead_state **readaheadp, ext2_ino_t *ino)
+{
+	int retval;
+	ext2_inode_scan scan = (*readaheadp)->scan;
+	e2fsck_t ctx = (*readaheadp)->ctx;
+
+	if (scan->done_group) {
+		retval = (scan->done_group)
+			(scan->fs, scan, scan->current_group,
+			 scan->done_group_data);
+		if (retval) {
+			printf("*** retval %d\n", retval);
+			return retval;
+		}
+		if (ctx->groups_left <= 0) {
+			*ino = 0;
+			return 0;
+		}
+	}
+	get_ready_blockgroup(readaheadp);
+	return 0;
+}
+
 static __u64 ext2_max_sizes[EXT2_MAX_BLOCK_LOG_SIZE -
 			    EXT2_MIN_BLOCK_LOG_SIZE + 1];
 
@@ -483,7 +905,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		imagic_fs;
 	int		busted_fs_time = 0;
 	int		inode_size;
-	
+	struct readahead_state *readahead;
+
 #ifdef RESOURCE_TRACK
 	init_resource_track(&rtrack);
 #endif
@@ -596,22 +1019,65 @@ void e2fsck_pass1(e2fsck_t ctx)
 	block_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize * 3,
 						    "block interate buffer");
 	e2fsck_use_inode_shortcuts(ctx, 1);
-	old_op = ehandler_operation(_("opening inode scan"));
-	pctx.errcode = ext2fs_open_inode_scan(fs, ctx->inode_buffer_blocks, 
-					      &scan);
-	ehandler_operation(old_op);
-	if (pctx.errcode) {
-		fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
-		ctx->flags |= E2F_FLAG_ABORT;
-		ext2fs_free_mem(&block_buf);
-		ext2fs_free_mem(&inode);
-		return;
-	}
-	ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE, 0);
-	ctx->stashed_inode = inode;
 	scan_struct.ctx = ctx;
 	scan_struct.block_buf = block_buf;
 	ext2fs_set_inode_callback(scan, scan_callback, &scan_struct);
+	/* Set up readahead threads */
+	/* XXX free this mem on error */
+	ctx->readahead = e2fsck_allocate_memory(ctx, sizeof (struct readahead_state) *
+					    ctx->read_threads, "multi-threaded readahead state");
+	pthread_mutex_init(&ctx->mutex_ready, NULL);
+	pthread_cond_init(&ctx->buffer_ready, NULL);
+	ctx->groups_left = ctx->fs->group_desc_count;
+	for(i = 0; i < ctx->read_threads; i++) {
+		readahead = &ctx->readahead[i];
+		/* Each thread needs its own fd to avoid an lseek/read race */
+		if (ext2fs_open2(ctx->filesystem_name, ctx->io_options, 
+				 0, ctx->superblock, ctx->blocksize,
+				 fs->io->manager, &readahead->fs)) {
+			/* XXX better error handling */
+			com_err(ctx->program_name, errno, "reopen for readahead failed\n");
+			ctx->flags |= E2F_FLAG_ABORT;
+			ext2fs_free_mem(&block_buf);
+			ext2fs_free_mem(&inode);
+			return;
+		}
+		readahead->fs->priv_data = ctx;
+		readahead->fs->now = ctx->now;
+		old_op = ehandler_operation(_("opening inode scan"));
+		/* XXX should be ctx->inode_buffer_blocks but want whole bg for simplicity */
+		pctx.errcode = ext2fs_open_inode_scan(fs, fs->inode_blocks_per_group,
+						      &readahead->scan);
+		scan = readahead->scan;
+		ehandler_operation(old_op);
+		if (pctx.errcode) {
+			fix_problem(ctx, PR_1_ISCAN_ERROR, &pctx);
+			ctx->flags |= E2F_FLAG_ABORT;
+			ext2fs_free_mem(&block_buf);
+			ext2fs_free_mem(&inode);
+			return;
+		}
+		ext2fs_inode_scan_flags(scan, EXT2_SF_SKIP_MISSING_ITABLE, 0);
+		ext2fs_set_inode_callback(scan, scan_callback, &scan_struct);
+		readahead->ctx = ctx;
+		/* Queue and buffer for indirect blocks */
+		/* XXX free this mem on error */
+		readahead->ind_blks_bufs[0] = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
+						    "indirect block readahead buffer");
+		readahead->ind_blks_bufs[1] = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
+						    "indirect block readahead buffer");
+		readahead->ind_blks_bufs[2] = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
+						    "indirect block readahead buffer");
+		readahead->ind_blks_queue = (blk_t *) e2fsck_allocate_memory(ctx,
+						     sizeof (blk_t) * ind_blks_queue_size,
+						    "indirect block readahead block list");
+		readahead->ind_blks_count = 0;
+		/* Barf.  Must be a better way to signal no scan has started. */
+		scan->current_group = -1;
+		readahead_start_thread(readahead, i);
+	}
+	ctx->stashed_inode = inode;
+	
 	if (ctx->progress)
 		if ((ctx->progress)(ctx, 1, 0, ctx->fs->group_desc_count))
 			return;
@@ -619,7 +1085,23 @@ void e2fsck_pass1(e2fsck_t ctx)
 	    (fs->super->s_mtime < fs->super->s_inodes_count))
 		busted_fs_time = 1;
 
+	/*
+	 * Find a blockgroup that's already been read in.
+	 */
+	get_ready_blockgroup(&readahead);
+	scan_struct.readahead = readahead;
+	scan = readahead->scan;
 	while (1) {
+		/* Usurp libext2fs's role in refilling inode buffers */
+		if (scan->inodes_left <= 0) {
+			if (ctx->groups_left == 0)
+				break;
+			if (get_next_blockgroup_threaded(&readahead, &ino))
+				break;
+			scan_struct.readahead = readahead;
+			scan = readahead->scan;
+		}
+
 		old_op = ehandler_operation(_("getting next inode from scan"));
 		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino, 
 							  inode, inode_size);
@@ -934,8 +1416,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 	}
 	process_inodes(ctx, block_buf);
+	readahead_shutdown(ctx);
 	ext2fs_close_inode_scan(scan);
-
+	printf("Bad ind blks %u\n", bad_ind_blk_count);
 	/*
 	 * If any extended attribute blocks' reference counts need to
 	 * be adjusted, either up (ctx->refcount_extra), or down
@@ -1009,6 +1492,7 @@ endit:
 	
 	ext2fs_free_mem(&block_buf);
 	ext2fs_free_mem(&inode);
+	ext2fs_free_mem(&ctx->readahead);
 
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
@@ -1020,20 +1504,25 @@ endit:
 
 /*
  * When the inode_scan routines call this callback at the end of the
- * glock group, call process_inodes.
+ * block group, call process_inodes.
  */
 static errcode_t scan_callback(ext2_filsys fs, 
 			       ext2_inode_scan scan EXT2FS_ATTR((unused)),
 			       dgrp_t group, void * priv_data)
 {
-	struct scan_callback_struct *scan_struct;
-	e2fsck_t ctx;
+	struct scan_callback_struct *scan_struct =
+		(struct scan_callback_struct *) priv_data;
+	struct readahead_state *readahead = scan_struct->readahead;
+	e2fsck_t ctx = scan_struct->ctx;
 
-	scan_struct = (struct scan_callback_struct *) priv_data;
-	ctx = scan_struct->ctx;
-	
 	process_inodes((e2fsck_t) fs->priv_data, scan_struct->block_buf);
 
+	pthread_mutex_lock(&readahead->mutex);
+	/* Wake up the sleeping readahead thread for the bg we just finished */
+	printf("Waking thread %d\n", readahead->thread);
+	pthread_cond_signal(&readahead->pause);
+	pthread_mutex_unlock(&readahead->mutex);
+
 	if (ctx->progress)
 		if ((ctx->progress)(ctx, 1, group+1,
 				    ctx->fs->group_desc_count))
@@ -1054,21 +1543,19 @@ static void process_inodes(e2fsck_t ctx,
 	char			buf[80];
 	struct problem_context	pctx;
 	
-#if 0
-	printf("begin process_inodes: ");
-#endif
 	if (process_inode_count == 0)
 		return;
+#if 1
+	printf("begin process_inodes: curr %d\n", process_inode_count);
+#endif
 	old_operation = ehandler_operation(0);
 	old_stashed_inode = ctx->stashed_inode;
 	old_stashed_ino = ctx->stashed_ino;
-	qsort(inodes_to_process, process_inode_count,
-		      sizeof(struct process_inode_block), process_inode_cmp);
 	clear_problem_context(&pctx);
 	for (i=0; i < process_inode_count; i++) {
 		pctx.inode = ctx->stashed_inode = &inodes_to_process[i].inode;
 		pctx.ino = ctx->stashed_ino = inodes_to_process[i].ino;
-		
+
 #if 0
 		printf("%u ", pctx.ino);
 #endif
@@ -1082,7 +1569,7 @@ static void process_inodes(e2fsck_t ctx,
 	ctx->stashed_inode = old_stashed_inode;
 	ctx->stashed_ino = old_stashed_ino;
 	process_inode_count = 0;
-#if 0
+#if 1
 	printf("end process inodes\n");
 #endif
 	ehandler_operation(old_operation);
--- e2fsprogs-1.40.2.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.2/e2fsck/unix.c
@@ -74,6 +74,7 @@ static void usage(e2fsck_t ctx)
 		_("Usage: %s [-panyrcdfvstDFSV] [-b superblock] [-B blocksize]\n"
 		"\t\t[-I inode_buffer_blocks] [-P process_inode_size]\n"
 		"\t\t[-l|-L bad_blocks_file] [-C fd] [-j external_journal]\n"
+		"\t\t[-A readahead_streams] [-z stripe_size]\n"
 		"\t\t[-E extended-options] device\n"),
 		ctx->program_name);
 
@@ -610,8 +611,11 @@ static errcode_t PRS(int argc, char *arg
 		ctx->program_name = *argv;
 	else
 		ctx->program_name = "e2fsck";
-	while ((c = getopt (argc, argv, "panyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDk")) != EOF)
+	while ((c = getopt (argc, argv, "paA:nyrcC:B:dE:fvtFVM:b:I:j:P:l:L:N:SsDkz:")) != EOF)
 		switch (c) {
+		case 'A':
+			ctx->read_threads = atoi(optarg);
+			break;
 		case 'C':
 			ctx->progress = e2fsck_update_progress;
 			ctx->progress_fd = atoi(optarg);
@@ -734,6 +738,9 @@ static errcode_t PRS(int argc, char *arg
 		case 'k':
 			keep_bad_blocks++;
 			break;
+		case 'z':
+			ctx->stripe_size = atoi(optarg);
+			break;
 		default:
 			usage(ctx);
 		}
--- e2fsprogs-1.40.2.orig/lib/ext2fs/ind_block.c
+++ e2fsprogs-1.40.2/lib/ext2fs/ind_block.c
@@ -30,6 +30,9 @@ errcode_t ext2fs_read_ind_block(ext2_fil
 	    (fs->io != fs->image_io))
 		memset(buf, 0, fs->blocksize);
 	else {
+#if 0
+		printf("Final read of ind blk %d\n", blk);
+#endif
 		retval = io_channel_read_blk(fs->io, blk, 1, buf);
 		if (retval)
 			return retval;
