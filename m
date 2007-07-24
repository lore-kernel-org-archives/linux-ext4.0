From: Girish Shilamkar <girish@clusterfs.com>
Subject: [Patch 1/13] iostats
Date: Tue, 24 Jul 2007 16:34:36 +0530
Message-ID: <1185275076.3789.66.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Theodore Tso <tytso@mit.edu>
To: Ext4 Mailing List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:40546 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765112AbXGXLDs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Jul 2007 07:03:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch instruments the libext2fs unix I/O manager and adds bytes 
read/written and data rate to e2fsck -tt pass/overall timing output.

Signed-off-by: Jim Garlick <garlick@llnl.gov>

Index: e2fsprogs-1.40.1/lib/ext2fs/unix_io.c
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/unix_io.c
+++ e2fsprogs-1.40.1/lib/ext2fs/unix_io.c
@@ -70,6 +70,7 @@ struct unix_private_data {
 	int	access_time;
 	ext2_loff_t offset;
 	struct unix_cache cache[CACHE_SIZE];
+	struct struct_io_stats io_stats;
 };
 
 static errcode_t unix_open(const char *name, int flags, io_channel *channel);
@@ -84,6 +85,8 @@ static errcode_t unix_write_byte(io_chan
 				int size, const void *data);
 static errcode_t unix_set_option(io_channel channel, const char *option, 
 				 const char *arg);
+static errcode_t unix_get_stats(io_channel channel,
+				struct struct_io_stats *stats);
 
 static void reuse_cache(io_channel channel, struct unix_private_data *data,
 		 struct unix_cache *cache, unsigned long block);
@@ -110,11 +113,29 @@ static struct struct_io_manager struct_u
 #else
 	unix_write_byte,
 #endif
-	unix_set_option
+	unix_set_option,
+	unix_get_stats,
 };
 
 io_manager unix_io_manager = &struct_unix_manager;
 
+static errcode_t unix_get_stats(io_channel channel,
+				struct struct_io_stats *stats)
+{
+	errcode_t 	retval = 0;
+
+	struct unix_private_data *data;
+
+	EXT2_CHECK_MAGIC(channel, EXT2_ET_MAGIC_IO_CHANNEL);
+	data = (struct unix_private_data *) channel->private_data;
+	EXT2_CHECK_MAGIC(data, EXT2_ET_MAGIC_UNIX_IO_CHANNEL);
+
+	if (stats)
+		*stats = data->io_stats;
+
+	return retval;
+}
+
 /*
  * Here are the raw I/O functions
  */
@@ -130,6 +151,7 @@ static errcode_t raw_read_blk(io_channel
 	int		actual = 0;
 
 	size = (count < 0) ? -count : count * channel->block_size;
+	data->io_stats.reads += size;
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
 	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
 		retval = errno ? errno : EXT2_ET_LLSEEK_FAILED;
@@ -168,6 +190,7 @@ static errcode_t raw_read_blk(io_channel
 	char		sector[BLOCKALIGN];
 
 	size = (count < 0) ? -count : count * channel->block_size;
+	data->io_stats.reads += size;
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
 #ifdef DEBUG
 	printf("count=%d, size=%d, block=%lu, blk_size=%d, location=%llx\n",
@@ -224,6 +247,7 @@ static errcode_t raw_write_blk(io_channe
 		else
 			size = count * channel->block_size;
 	}
+	data->io_stats.writes += size;
 
 	location = ((ext2_loff_t) block * channel->block_size) + data->offset;
 	if (ext2fs_llseek(data->dev, location, SEEK_SET) != location) {
Index: e2fsprogs-1.40.1/lib/ext2fs/ext2_io.h
===================================================================
--- e2fsprogs-1.40.1.orig/lib/ext2fs/ext2_io.h
+++ e2fsprogs-1.40.1/lib/ext2fs/ext2_io.h
@@ -55,6 +55,11 @@ struct struct_io_channel {
 	void		*app_data;
 };
 
+struct struct_io_stats {
+	unsigned long long reads;
+	unsigned long long writes;
+};
+
 struct struct_io_manager {
 	errcode_t magic;
 	const char *name;
@@ -70,6 +75,8 @@ struct struct_io_manager {
 				int count, const void *data);
 	errcode_t (*set_option)(io_channel channel, const char *option, 
 				const char *arg);
+	errcode_t (*get_stats)(io_channel channel,
+			       struct struct_io_stats *io_stats);
 	int		reserved[14];
 };
 
Index: e2fsprogs-1.40.1/e2fsck/e2fsck.h
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/e2fsck.h
+++ e2fsprogs-1.40.1/e2fsck/e2fsck.h
@@ -135,6 +135,7 @@ struct resource_track {
 	struct timeval user_start;
 	struct timeval system_start;
 	void	*brk_start;
+	struct struct_io_stats io_start;
 };
 #endif
 
@@ -469,8 +470,10 @@ extern void preenhalt(e2fsck_t ctx);
 extern char *string_copy(e2fsck_t ctx, const char *str, int len);
 #ifdef RESOURCE_TRACK
 extern void print_resource_track(const char *desc,
-				 struct resource_track *track);
-extern void init_resource_track(struct resource_track *track);
+				 struct resource_track *track,
+				 io_channel channel);
+extern void init_resource_track(struct resource_track *track,
+				io_channel channel);
 #endif
 extern int inode_has_valid_blocks(struct ext2_inode *inode);
 extern void e2fsck_read_inode(e2fsck_t ctx, unsigned long ino,
Index: e2fsprogs-1.40.1/e2fsck/util.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/util.c
+++ e2fsprogs-1.40.1/e2fsck/util.c
@@ -276,7 +276,7 @@ void preenhalt(e2fsck_t ctx)
 }
 
 #ifdef RESOURCE_TRACK
-void init_resource_track(struct resource_track *track)
+void init_resource_track(struct resource_track *track, io_channel channel)
 {
 #ifdef HAVE_GETRUSAGE
 	struct rusage r;
@@ -295,6 +295,9 @@ void init_resource_track(struct resource
 	track->user_start.tv_sec = track->user_start.tv_usec = 0;
 	track->system_start.tv_sec = track->system_start.tv_usec = 0;
 #endif
+	memset(&track->io_start, 0, sizeof(struct struct_io_stats));
+	if (channel && channel->manager && channel->manager->get_stats)
+		channel->manager->get_stats(channel, &track->io_start);
 }
 
 #ifdef __GNUC__
@@ -310,7 +313,8 @@ static _INLINE_ float timeval_subtract(s
 		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
 }
 
-void print_resource_track(const char *desc, struct resource_track *track)
+void print_resource_track(const char *desc, struct resource_track *track,
+			  io_channel channel)
 {
 #ifdef HAVE_GETRUSAGE
 	struct rusage r;
@@ -347,6 +351,21 @@ void print_resource_track(const char *de
 	printf(_("elapsed time: %6.3f\n"),
 	       timeval_subtract(&time_end, &track->time_start));
 #endif
+#define mbytes(x)	(((x) + 1048575) / 1048576)
+	if (channel && channel->manager && channel->manager->get_stats) {
+		struct struct_io_stats delta;
+
+		if (desc)
+			printf("%s: ", desc);
+
+		channel->manager->get_stats(channel, &delta);
+		delta.reads -= track->io_start.reads;
+		delta.writes -= track->io_start.writes;
+		printf("I/O read: %lluMB, write: %lluMB, rate: %.2fMB/s\n",
+		       mbytes(delta.reads), mbytes(delta.writes),
+		       (double)mbytes(delta.reads + delta.writes) /
+		       timeval_subtract(&time_end, &track->time_start));
+	}
 }
 #endif /* RESOURCE_TRACK */
 
Index: e2fsprogs-1.40.1/e2fsck/pass5.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass5.c
+++ e2fsprogs-1.40.1/e2fsck/pass5.c
@@ -30,7 +30,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 #endif
 
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 	
 	clear_problem_context(&pctx);
@@ -67,7 +67,7 @@ void e2fsck_pass5(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 5"), &rtrack);
+		print_resource_track(_("Pass 5"), &rtrack, ctx->fs->io);
 	}
 #endif
 }
Index: e2fsprogs-1.40.1/e2fsck/unix.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/unix.c
+++ e2fsprogs-1.40.1/e2fsck/unix.c
@@ -883,7 +883,7 @@ int main (int argc, char *argv[])
 	reserve_stdio_fds();
 	
 #ifdef RESOURCE_TRACK
-	init_resource_track(&ctx->global_rtrack);
+	init_resource_track(&ctx->global_rtrack, NULL);
 #endif
 
 	if (!(ctx->options & E2F_OPT_PREEN) || show_version_only)
@@ -1293,16 +1293,16 @@ no_journal:
 	}
 
 	e2fsck_write_bitmaps(ctx);
-	
+#ifdef RESOURCE_TRACK
+	io_channel_flush(ctx->fs->io);
+	if (ctx->options & E2F_OPT_TIME)
+		print_resource_track(NULL, &ctx->global_rtrack, ctx->fs->io);
+#endif
 	ext2fs_close(fs);
 	ctx->fs = NULL;
 	free(ctx->filesystem_name);
 	free(ctx->journal_name);
 
-#ifdef RESOURCE_TRACK
-	if (ctx->options & E2F_OPT_TIME)
-		print_resource_track(NULL, &ctx->global_rtrack);
-#endif
 	e2fsck_free_context(ctx);
 	remove_error_table(&et_ext2_error_table);
 	remove_error_table(&et_prof_error_table);
Index: e2fsprogs-1.40.1/e2fsck/swapfs.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/swapfs.c
+++ e2fsprogs-1.40.1/e2fsck/swapfs.c
@@ -219,7 +219,7 @@ void swap_filesys(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	struct resource_track	rtrack;
 
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 
 	if (!(ctx->options & E2F_OPT_PREEN))
@@ -265,7 +265,7 @@ void swap_filesys(e2fsck_t ctx)
 	
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2)
-		print_resource_track(_("Byte swap"), &rtrack);
+		print_resource_track(_("Byte swap"), &rtrack, fs->io);
 #endif
 }
 
Index: e2fsprogs-1.40.1/e2fsck/pass1.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass1.c
+++ e2fsprogs-1.40.1/e2fsck/pass1.c
@@ -485,7 +485,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	int		inode_size;
 	
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 	clear_problem_context(&pctx);
 
@@ -1013,7 +1013,7 @@ endit:
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 1"), &rtrack);
+		print_resource_track(_("Pass 1"), &rtrack, ctx->fs->io);
 	}
 #endif
 }
Index: e2fsprogs-1.40.1/e2fsck/pass2.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass2.c
+++ e2fsprogs-1.40.1/e2fsck/pass2.c
@@ -102,7 +102,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	int			bad_dir;
 
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 
 	clear_problem_context(&cd.pctx);
@@ -287,7 +287,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 2"), &rtrack);
+		print_resource_track(_("Pass 2"), &rtrack, fs->io);
 	}
 #endif
 }
Index: e2fsprogs-1.40.1/e2fsck/pass3.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass3.c
+++ e2fsprogs-1.40.1/e2fsck/pass3.c
@@ -61,7 +61,7 @@ void e2fsck_pass3(e2fsck_t ctx)
 	unsigned long maxdirs, count;
 
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 
 	clear_problem_context(&pctx);
@@ -87,7 +87,8 @@ void e2fsck_pass3(e2fsck_t ctx)
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Peak memory"), &ctx->global_rtrack);
+		print_resource_track(_("Peak memory"), &ctx->global_rtrack,
+				     NULL);
 	}
 #endif
 
@@ -142,7 +143,7 @@ abort_exit:
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 3"), &rtrack);
+		print_resource_track(_("Pass 3"), &rtrack, ctx->fs->io);
 	}
 #endif
 }
Index: e2fsprogs-1.40.1/e2fsck/pass4.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/pass4.c
+++ e2fsprogs-1.40.1/e2fsck/pass4.c
@@ -93,7 +93,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	int	group, maxgroup;
 	
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 
 #ifdef MTRACE
@@ -173,7 +173,7 @@ errout:
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track(_("Pass 4"), &rtrack);
+		print_resource_track(_("Pass 4"), &rtrack, ctx->fs->io);
 	}
 #endif
 }
Index: e2fsprogs-1.40.1/e2fsck/rehash.c
===================================================================
--- e2fsprogs-1.40.1.orig/e2fsck/rehash.c
+++ e2fsprogs-1.40.1/e2fsck/rehash.c
@@ -778,7 +778,7 @@ void e2fsck_rehash_directories(e2fsck_t 
 	int			cur, max, all_dirs, dir_index, first = 1;
 
 #ifdef RESOURCE_TRACK
-	init_resource_track(&rtrack);
+	init_resource_track(&rtrack, ctx->fs->io);
 #endif
 
 	all_dirs = ctx->options & E2F_OPT_COMPRESS_DIRS;
@@ -847,7 +847,7 @@ void e2fsck_rehash_directories(e2fsck_t 
 #ifdef RESOURCE_TRACK
 	if (ctx->options & E2F_OPT_TIME2) {
 		e2fsck_clear_progbar(ctx);
-		print_resource_track("Pass 3A", &rtrack);
+		print_resource_track("Pass 3A", &rtrack, ctx->fs->io);
 	}
 #endif
 }
