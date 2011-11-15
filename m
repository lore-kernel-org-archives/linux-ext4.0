From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] debugfs: add the freefrag command
Date: Tue, 15 Nov 2011 00:05:09 -0500
Message-ID: <1321333509-4607-3-git-send-email-tytso@mit.edu>
References: <1321333509-4607-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35180 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab1KOFFQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Nov 2011 00:05:16 -0500
In-Reply-To: <1321333509-4607-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The freefrag command provides the functionality of e2freefrag on the
currently open file system in debugfs.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debugfs/Makefile.in      |    8 ++++-
 debugfs/debug_cmds.ct    |    3 ++
 debugfs/debugfs.8.in     |   10 ++++++
 debugfs/debugfs.h        |    1 +
 debugfs/ro_debug_cmds.ct |    3 ++
 misc/e2freefrag.c        |   74 +++++++++++++++++++++++++++++-----------------
 6 files changed, 70 insertions(+), 29 deletions(-)

diff --git a/debugfs/Makefile.in b/debugfs/Makefile.in
index 4674ba6..e03a3c6 100644
--- a/debugfs/Makefile.in
+++ b/debugfs/Makefile.in
@@ -17,10 +17,10 @@ MANPAGES=	debugfs.8
 MK_CMDS=	_SS_DIR_OVERRIDE=../lib/ss ../lib/ss/mk_cmds
 
 DEBUG_OBJS= debug_cmds.o debugfs.o util.o ncheck.o icheck.o ls.o \
-	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o
+	lsdel.o dump.o set_fields.o logdump.o htree.o unused.o e2freefrag.o
 
 RO_DEBUG_OBJS= ro_debug_cmds.o ro_debugfs.o util.o ncheck.o icheck.o ls.o \
-	lsdel.o logdump.o htree.o
+	lsdel.o logdump.o htree.o e2freefrag.o
 
 SRCS= debug_cmds.c $(srcdir)/debugfs.c $(srcdir)/util.c $(srcdir)/ls.c \
 	$(srcdir)/ncheck.c $(srcdir)/icheck.c $(srcdir)/lsdel.c \
@@ -58,6 +58,10 @@ ro_debugfs.o: debugfs.c
 	$(E) "	CC $@"
 	$(Q) $(CC) -c $(ALL_CFLAGS) $< -DREAD_ONLY -o $@
 
+e2freefrag.o: $(srcdir)/../misc/e2freefrag.c
+	$(E) "	CC $@"
+	$(Q) $(CC) -c $(ALL_CFLAGS) -I$(srcdir) $< -DDEBUGFS -o $@
+
 debugfs.8: $(DEP_SUBSTITUTE) $(srcdir)/debugfs.8.in
 	$(E) "	SUBST $@"
 	$(Q) $(SUBSTITUTE_UPTIME) $(srcdir)/debugfs.8.in debugfs.8
diff --git a/debugfs/debug_cmds.ct b/debugfs/debug_cmds.ct
index ea677da..47de672 100644
--- a/debugfs/debug_cmds.ct
+++ b/debugfs/debug_cmds.ct
@@ -13,6 +13,9 @@ request do_open_filesys, "Open a filesystem",
 request do_close_filesys, "Close the filesystem",
 	close_filesys, close;
 
+request do_freefrag, "Report free space fragmentation",
+	freefrag, e2freefrag;
+
 request do_features, "Set/print superblock features",
 	feature, features;
 
diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 17ddc24..69490ff 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -280,6 +280,16 @@ blocks starting at block number
 .I block
 will be marked as not allocated.
 .TP
+.I freefrag [-c chunk_kb ]
+Report free space fragmentation on the currently open file system.
+If the
+.I \-c
+option is specified then the filefrag command will print how many free
+chunks of size
+.I chunk_kb
+can be found in the file system.  The chunk size must be a power of two
+and be larger than the file system block size.
+.TP
 .I freei filespec
 Free the inode specified by 
 .IR filespec .
diff --git a/debugfs/debugfs.h b/debugfs/debugfs.h
index 24c4dce..6d7dfcd 100644
--- a/debugfs/debugfs.h
+++ b/debugfs/debugfs.h
@@ -133,3 +133,4 @@ extern void do_set_current_time(int argc, char **argv);
 extern void do_supported_features(int argc, char **argv);
 extern void do_punch(int argc, char **argv);
 
+extern void do_freefrag(int argc, char **argv);
diff --git a/debugfs/ro_debug_cmds.ct b/debugfs/ro_debug_cmds.ct
index 4b16a67..7eb552d 100644
--- a/debugfs/ro_debug_cmds.ct
+++ b/debugfs/ro_debug_cmds.ct
@@ -15,6 +15,9 @@ request do_open_filesys, "Open a filesystem",
 request do_close_filesys, "Close the filesystem",
 	close_filesys, close;
 
+request do_freefrag, "Report free space fragmentation",
+	freefrag, e2freefrag;
+
 request do_show_super_stats, "Show superblock statistics",
 	show_super_stats, stats;
 
diff --git a/misc/e2freefrag.c b/misc/e2freefrag.c
index a09df6b..0964e66 100644
--- a/misc/e2freefrag.c
+++ b/misc/e2freefrag.c
@@ -34,7 +34,9 @@ void usage(const char *prog)
 {
 	fprintf(stderr, "usage: %s [-c chunksize in kb] [-h] "
 		"device_name\n", prog);
+#ifndef DEBUGFS
 	exit(1);
+#endif
 }
 
 static int ul_log2(unsigned long arg)
@@ -140,7 +142,7 @@ void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
 		update_chunk_stats(info, last_chunk_size);
 }
 
-errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
+errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info, FILE *f)
 {
 	unsigned long total_chunks;
 	char *unitp = "KMGTPEZY";
@@ -150,20 +152,20 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 
 	scan_block_bitmap(fs, info);
 
-	printf("Total blocks: %llu\nFree blocks: %u (%0.1f%%)\n",
-	       ext2fs_blocks_count(fs->super), fs->super->s_free_blocks_count,
-	       (double)fs->super->s_free_blocks_count * 100 /
-	       ext2fs_blocks_count(fs->super));
+	fprintf(f, "Total blocks: %llu\nFree blocks: %u (%0.1f%%)\n",
+		ext2fs_blocks_count(fs->super), fs->super->s_free_blocks_count,
+		(double)fs->super->s_free_blocks_count * 100 /
+		ext2fs_blocks_count(fs->super));
 
 	if (info->chunkbytes) {
-		printf("\nChunksize: %lu bytes (%u blocks)\n",
-		       info->chunkbytes, info->blks_in_chunk);
+		fprintf(f, "\nChunksize: %lu bytes (%u blocks)\n",
+			info->chunkbytes, info->blks_in_chunk);
 		total_chunks = (ext2fs_blocks_count(fs->super) +
 				info->blks_in_chunk) >>
 			(info->chunkbits - info->blocksize_bits);
-		printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
-		       total_chunks, info->free_chunks,
-		       (double)info->free_chunks * 100 / total_chunks);
+		fprintf(f, "Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
+			total_chunks, info->free_chunks,
+			(double)info->free_chunks * 100 / total_chunks);
 	}
 
 	/* Display chunk information in KB */
@@ -176,13 +178,13 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 		info->min = 0;
 	}
 
-	printf("\nMin. free extent: %lu KB \nMax. free extent: %lu KB\n"
-	       "Avg. free extent: %lu KB\n", info->min, info->max, info->avg);
-	printf("Num. free extent: %lu\n", info->real_free_chunks);
+	fprintf(f, "\nMin. free extent: %lu KB \nMax. free extent: %lu KB\n"
+		"Avg. free extent: %lu KB\n", info->min, info->max, info->avg);
+	fprintf(f, "Num. free extent: %lu\n", info->real_free_chunks);
 
-	printf("\nHISTOGRAM OF FREE EXTENT SIZES:\n");
-	printf("%s :  %12s  %12s  %7s\n", "Extent Size Range", "Free extents",
-	       "Free Blocks", "Percent");
+	fprintf(f, "\nHISTOGRAM OF FREE EXTENT SIZES:\n");
+	fprintf(f, "%s :  %12s  %12s  %7s\n", "Extent Size Range",
+		"Free extents", "Free Blocks", "Percent");
 	for (i = 0; i < MAX_HIST; i++) {
 		end = 1 << (i + info->blocksize_bits - units);
 		if (info->histogram.fc_chunks[i] != 0) {
@@ -191,12 +193,12 @@ errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
 			sprintf(end_str, "%5lu%c-", end, *unitp);
 			if (i == MAX_HIST-1)
 				strcpy(end_str, "max ");
-			printf("%5lu%c...%7s  :  %12lu  %12lu  %6.2f%%\n",
-			       start, *unitp, end_str,
-			       info->histogram.fc_chunks[i],
-			       info->histogram.fc_blocks[i],
-			       (double)info->histogram.fc_blocks[i] * 100 /
-			       fs->super->s_free_blocks_count);
+			fprintf(f, "%5lu%c...%7s  :  %12lu  %12lu  %6.2f%%\n",
+				start, *unitp, end_str,
+				info->histogram.fc_chunks[i],
+				info->histogram.fc_blocks[i],
+				(double)info->histogram.fc_blocks[i] * 100 /
+				fs->super->s_free_blocks_count);
 		}
 		start = end;
 		if (start == 1<<10) {
@@ -217,12 +219,12 @@ void close_device(char *device_name, ext2_filsys fs)
 		com_err(device_name, retval, "while closing the filesystem.\n");
 }
 
-void collect_info(ext2_filsys fs, struct chunk_info *chunk_info)
+void collect_info(ext2_filsys fs, struct chunk_info *chunk_info, FILE *f)
 {
 	unsigned int retval = 0;
 
-	printf("Device: %s\n", fs->device_name);
-	printf("Blocksize: %u bytes\n", fs->blocksize);
+	fprintf(f, "Device: %s\n", fs->device_name);
+	fprintf(f, "Blocksize: %u bytes\n", fs->blocksize);
 
 	retval = ext2fs_read_block_bitmap(fs);
 	if (retval) {
@@ -233,7 +235,7 @@ void collect_info(ext2_filsys fs, struct chunk_info *chunk_info)
 
 	init_chunk_info(fs, chunk_info);
 
-	retval = get_chunk_info(fs, chunk_info);
+	retval = get_chunk_info(fs, chunk_info, f);
 	if (retval) {
 		com_err(fs->device_name, retval, "while collecting chunk info");
                 close_device(fs->device_name, fs);
@@ -253,7 +255,14 @@ void open_device(char *device_name, ext2_filsys *fs)
 	}
 }
 
+#ifdef DEBUGFS
+
+#include "debugfs.h"
+
+void do_freefrag(int argc, char **argv)
+#else
 int main(int argc, char *argv[])
+#endif
 {
 	struct chunk_info chunk_info = { };
 	errcode_t retval = 0;
@@ -263,7 +272,12 @@ int main(int argc, char *argv[])
 	char *end;
 	int c;
 
+#ifdef DEBUGFS
+	if (check_fs_open(argv[0]))
+		return;
+#else
 	add_error_table(&et_ext2_error_table);
+#endif
 	progname = argv[0];
 
 	while ((c = getopt(argc, argv, "c:h")) != EOF) {
@@ -290,6 +304,7 @@ int main(int argc, char *argv[])
 		}
 	}
 
+#ifndef DEBUGFS
 	if (optind == argc) {
 		fprintf(stderr, "%s: missing device name.\n", progname);
 		usage(progname);
@@ -298,14 +313,19 @@ int main(int argc, char *argv[])
 	device_name = argv[optind];
 
 	open_device(device_name, &fs);
+#else
+	fs = current_fs;
+#endif
 
 	if (chunk_info.chunkbytes && (chunk_info.chunkbytes < fs->blocksize)) {
 		fprintf(stderr, "%s: chunksize must be greater than or equal "
 			"to filesystem blocksize.\n", progname);
 		exit(1);
 	}
-	collect_info(fs, &chunk_info);
+	collect_info(fs, &chunk_info, stdout);
+#ifndef DEBUGFS
 	close_device(device_name, fs);
 
 	return retval;
+#endif
 }
-- 
1.7.4.1.22.gec8e1.dirty

