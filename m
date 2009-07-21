From: Andreas Dilger <adilger@sun.com>
Subject: [PATCH] e2freefrag utility
Date: Mon, 20 Jul 2009 18:17:50 -0600
Message-ID: <20090721001750.GD4231@webber.adilger.int>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Boundary_(ID_MgKD0vdkAF1ifVUgfl534g)"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60916 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbZGUASW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 20:18:22 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6L0IKtS017590
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 17:18:20 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN300I00VDFTZ00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Jul 2009 17:18:20 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Boundary_(ID_MgKD0vdkAF1ifVUgfl534g)
Content-type: text/plain; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: inline

Attached is the e2freefrag tool.  It grabs the block bitmaps, creates
buddy bitmaps from them and displays the total/free chunks (default
1MB chunk size), and a histogram of free space.

It could probably be enhanced to print the chunk sizes based on the
RAID chunk size stored in the superblock, but I just thought of that
this minute...

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


--Boundary_(ID_MgKD0vdkAF1ifVUgfl534g)
Content-type: text/plain; NAME=e2fsprogs-e2freefrag.patch; CHARSET=US-ASCII
Content-transfer-encoding: 7BIT
Content-disposition: attachment; filename=e2fsprogs-e2freefrag.patch

Index: e2fsprogs-1.41.4/misc/e2freefrag.8.in
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.41.4/misc/e2freefrag.8.in	2009-04-21 13:24:09.000000000 -0600
@@ -0,0 +1,99 @@
+.\" -*- nroff -*-
+.TH E2FREEFRAG 8
+.SH NAME
+e2freefrag \- report free space fragmentation information
+.SH SYNOPSIS
+.B e2freefrag
+[
+.B \-c chunk_kb
+]
+[
+.B \-h
+]
+.B filesys
+
+.SH DESCRIPTION
+.B e2freefrag
+is used to report free space fragmentation on ext2/3/4 file systems.
+.I filesys
+is the filesystem device name (e.g.
+.IR /dev/hdc1 ", " /dev/md0 ).
+The
+.B e2freefrag
+program will scan the block bitmap information to check how many free blocks
+are present as contiguous and aligned free space. The percentage of contiguous
+free blocks of size and of alignment
+.IR chunk_kb
+is reported.  It also displays the minimum/maximum/average free chunk size in
+the filesystem, along with a histogram of all free chunks.  This information
+can be used to gauge the level of free space fragmentation in the filesystem.
+.SH OPTIONS
+.TP
+.BI \-c " chunk_kb"
+Desired size of chunk. It is specified in units of kilobytes (KB). If no
+.I chunk_kb
+is specified on the command line, then the default value is 1024KB.
+.TP
+.BI \-h
+Print the usage of the program.
+.SH EXAMPLE
+# e2freefrag /dev/vgroot/lvhome
+.br
+Device: /dev/vgroot/lvhome
+.br
+Blocksize: 4096 bytes
+.br
+Total blocks: 5120710
+.br
+Free blocks: 831744 (16.2%)
+.br
+Chunk size: 1048576 bytes (256 blocks)
+.br
+Total chunks: 20003
+.br
+Free chunks: 2174 (10.9%)
+.br
+
+Min free chunk: 4 KB
+.br
+Max free chunk: 24576 KB
+.br
+Avg. free chunk: 340 KB
+.br
+
+HISTOGRAM OF FREE CHUNK SIZES:
+.br
+          Range         Free chunks
+.br
+    4K...    8K- :        2824
+.br
+    8K...   16K- :        1760
+.br
+   16K...   32K- :        1857
+.br
+   32K...   64K- :        1003
+.br
+   64K...  128K- :         616
+.br
+  128K...  256K- :         479
+.br
+  256K...  512K- :         302
+.br
+  512K... 1024K- :         238
+.br
+    1M...    2M- :         213
+.br
+    2M...    4M- :         173
+.br
+    4M...    8M- :         287
+.br
+    8M...   16M- :           4
+.br
+   16M...   32M- :           1
+.SH AUTHOR
+This version of e2freefrag was written by Rupesh Thakare, and modified by
+Andreas Dilger <adilger@sun.com>, and Kalpak Shah.
+.SH SEE ALSO
+.IR debugfs (8),
+.IR dumpe2fs (8),
+.IR e2fsck (8)
Index: e2fsprogs-1.41.4/misc/e2freefrag.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.41.4/misc/e2freefrag.c	2009-04-21 13:18:30.000000000 -0600
@@ -0,0 +1,275 @@
+/*
+ * e2freefrag - report filesystem free-space fragmentation
+ *
+ * Copyright (C) 2009 Sun Microsystems, Inc.
+ *
+ * Author: Rupesh Thakare <rupesh@sun.com>
+ *         Andreas Dilger <adilger@sun.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License version 2.
+ * %End-Header%
+ */
+#include <stdio.h>
+#ifdef HAVE_UNISTD_H
+#include <unistd.h>
+#endif
+#ifdef HAVE_STDLIB_H
+#include <stdlib.h>
+#endif
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#else
+extern char *optarg;
+extern int optind;
+#endif
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+#include "e2freefrag.h"
+
+void usage(const char *prog)
+{
+	fprintf(stderr, "usage: %s [-c chunksize in kb] [-h] "
+		"device_name\n", prog);
+	exit(1);
+}
+
+static int ul_log2(unsigned long arg)
+{
+        int     l = 0;
+
+        arg >>= 1;
+        while (arg) {
+                l++;
+                arg >>= 1;
+        }
+        return l;
+}
+
+void init_chunk_info(ext2_filsys fs, struct chunk_info *info)
+{
+	int i;
+
+	info->chunkbits = ul_log2(info->chunkbytes);
+	info->blocksize_bits = ul_log2((unsigned long)fs->blocksize);
+	info->blks_in_chunk = info->chunkbytes >> info->blocksize_bits;
+
+	info->min = ~0UL;
+	info->max = info->avg = 0;
+	info->real_free_chunks = 0;
+
+	for (i = 0; i < MAX_HIST; i++)
+		info->histogram.fc_buckets[i] = 0;
+}
+
+void scan_block_bitmap(ext2_filsys fs, struct chunk_info *info)
+{
+	unsigned long long blocks_count = fs->super->s_blocks_count;
+	unsigned long long chunks = (blocks_count + info->blks_in_chunk) >>
+				(info->chunkbits - info->blocksize_bits);
+	unsigned long long chunk_num;
+	unsigned long last_chunk_size = 0;
+	unsigned long long chunk_start_blk = 0;
+
+	for (chunk_num = 0; chunk_num < chunks; chunk_num++) {
+		unsigned long long blk, num_blks;
+		int chunk_free;
+
+		/* Last chunk may be smaller */
+		if (chunk_start_blk + info->blks_in_chunk > blocks_count)
+			num_blks = blocks_count - chunk_start_blk;
+		else
+			num_blks = info->blks_in_chunk;
+
+		chunk_free = 0;
+
+		/* Initialize starting block for first chunk correctly else
+		 * there is a segfault when blocksize = 1024 in which case
+		 * block_map->start = 1 */
+		for (blk = (chunk_num == 0 ? fs->super->s_first_data_block : 0);
+		     blk < num_blks; blk++, chunk_start_blk++) {
+			int used = ext2fs_fast_test_block_bitmap(fs->block_map,
+							       chunk_start_blk);
+			if (!used) {
+				last_chunk_size++;
+				chunk_free++;
+			}
+
+			if (used && last_chunk_size != 0) {
+				unsigned long index;
+
+				index = ul_log2(last_chunk_size) + 1;
+				info->histogram.fc_buckets[index]++;
+
+				if (last_chunk_size > info->max)
+					info->max = last_chunk_size;
+				if (last_chunk_size < info->min)
+					info->min = last_chunk_size;
+				info->avg += last_chunk_size;
+
+				info->real_free_chunks++;
+				last_chunk_size = 0;
+			}
+		}
+
+		if (chunk_free == info->blks_in_chunk)
+			info->free_chunks++;
+	}
+}
+
+errcode_t get_chunk_info(ext2_filsys fs, struct chunk_info *info)
+{
+	unsigned long total_chunks;
+	char *unitp = "KMGTPEZY";
+	int units = 10;
+	unsigned long start = 0, end, cum;
+	int i, retval = 0;
+
+	scan_block_bitmap(fs, info);
+
+	printf("Total blocks: %lu\nFree blocks: %lu (%0.1f%%)\n",
+	       fs->super->s_blocks_count, fs->super->s_free_blocks_count,
+	       (double)fs->super->s_free_blocks_count * 100 /
+						fs->super->s_blocks_count);
+
+	printf("\nChunksize: %u bytes (%u blocks)\n",
+	       info->chunkbytes, info->blks_in_chunk);
+	total_chunks = (fs->super->s_blocks_count + info->blks_in_chunk) >>
+                                       (info->chunkbits - info->blocksize_bits);
+	printf("Total chunks: %lu\nFree chunks: %lu (%0.1f%%)\n",
+	       total_chunks, info->free_chunks,
+	       (double)info->free_chunks * 100 / total_chunks);
+
+	/* Display chunk information in KB */
+	if (info->real_free_chunks) {
+		info->min = (info->min * fs->blocksize) >> 10;
+		info->max = (info->max * fs->blocksize) >> 10;
+		info->avg = (info->avg / info->real_free_chunks *
+			     fs->blocksize) >> 10;
+	} else {
+		info->min = 0;
+	}
+
+	printf("\nMin free chunk: %lu KB \nMax free chunk: %lu KB\n"
+	       "Avg free chunk: %lu KB\n", info->min, info->max, info->avg);
+
+	printf("\nHISTOGRAM OF FREE CHUNK SIZES:\n");
+	printf("%s\t%10s\n", "Chunk Size Range :", "Free chunks");
+	for (i = 0; i < MAX_HIST; i++) {
+		end = 1 << (i + info->blocksize_bits - units);
+		if (info->histogram.fc_buckets[i] != 0)
+			printf("%5lu%c...%5lu%c- :  %10lu\n", start, *unitp,
+			       end, *unitp, info->histogram.fc_buckets[i]);
+		start = end;
+		if (start == 1<<10) {
+			start = 1;
+			units += 10;
+			unitp++;
+		}
+	}
+
+	return retval;
+}
+
+void close_device(char *device_name, ext2_filsys fs)
+{
+	int retval = ext2fs_close(fs);
+
+	if (retval)
+		com_err(device_name, retval, "while closing the filesystem.\n");
+}
+
+void collect_info(ext2_filsys fs, struct chunk_info *chunk_info)
+{
+	unsigned int retval = 0, i, free_blks;
+
+	printf("Device: %s\n", fs->device_name);
+	printf("Blocksize: %u bytes\n", fs->blocksize);
+
+	retval = ext2fs_read_block_bitmap(fs);
+	if (retval) {
+		com_err(fs->device_name, retval, "while reading block bitmap");
+		close_device(fs->device_name, fs);
+		exit(1);
+	}
+
+	init_chunk_info(fs, chunk_info);
+
+	retval = get_chunk_info(fs, chunk_info);
+	if (retval) {
+		com_err(fs->device_name, retval, "while collecting chunk info");
+                close_device(fs->device_name, fs);
+		exit(1);
+	}
+}
+
+void open_device(char *device_name, ext2_filsys *fs)
+{
+	int retval;
+	int flag = EXT2_FLAG_FORCE;
+
+	retval = ext2fs_open(device_name, flag, 0, 0, unix_io_manager, fs);
+	if (retval) {
+		com_err(device_name, retval, "while opening filesystem");
+		exit(1);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	struct chunk_info chunk_info = { .chunkbytes = DEFAULT_CHUNKSIZE };
+	errcode_t retval = 0;
+	ext2_filsys fs = NULL;
+	char *device_name;
+	char *progname;
+	char c, *end;
+
+	progname = argv[0];
+
+	while ((c = getopt(argc, argv, "c:h")) != EOF) {
+		switch (c) {
+		case 'c':
+			chunk_info.chunkbytes = strtoull(optarg, &end, 0);
+			if (*end != '\0') {
+				fprintf(stderr, "%s: bad chunk size '%s'\n",
+					progname, optarg);
+				usage(progname);
+			}
+			if (chunk_info.chunkbytes &
+			    (chunk_info.chunkbytes - 1)) {
+				fprintf(stderr, "%s: chunk size must be a "
+					"power of 2.");
+				usage(progname);
+			}
+			chunk_info.chunkbytes *= 1024;
+			break;
+		default:
+			fprintf(stderr, "%s: bad option '%c'\n",
+				progname, c);
+		case 'h':
+			usage(progname);
+			break;
+		}
+	}
+
+	if (optind == argc) {
+		fprintf(stderr, "%s: missing device name.\n", progname);
+		usage(progname);
+	}
+
+	device_name = argv[optind];
+
+	open_device(device_name, &fs);
+
+	if (chunk_info.chunkbytes < fs->blocksize) {
+		fprintf(stderr, "%s: chunksize must be greater than or equal "
+			"to filesystem blocksize.\n", progname);
+		exit(1);
+	}
+	collect_info(fs, &chunk_info);
+	close_device(device_name, fs);
+
+	return retval;
+}
Index: e2fsprogs-1.41.4/misc/e2freefrag.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ e2fsprogs-1.41.4/misc/e2freefrag.h	2009-04-21 13:19:48.000000000 -0600
@@ -0,0 +1,19 @@
+#include <sys/types.h>
+
+#define DEFAULT_CHUNKSIZE (1024*1024)
+
+#define MAX_HIST	32
+struct free_chunk_histogram {
+	unsigned long fc_buckets[MAX_HIST];
+};
+
+struct chunk_info {
+	unsigned long chunkbytes;	/* chunk size in bytes */
+	int chunkbits;			/* chunk size in bits */
+	unsigned long free_chunks;	/* total free chunks of given size */
+	unsigned long real_free_chunks; /* free chunks of any size */
+	int blocksize_bits;		/* fs blocksize in bits */
+	int blks_in_chunk;		/* number of blocks in a chunk */
+	unsigned long min, max, avg;	/* chunk size stats */
+	struct free_chunk_histogram histogram; /* histogram of all chunk sizes*/
+};
Index: e2fsprogs-1.41.4/e2fsprogs.spec.in
===================================================================
--- e2fsprogs-1.41.4.orig/e2fsprogs.spec.in	2009-04-14 05:56:43.000000000 -0600
+++ e2fsprogs-1.41.4/e2fsprogs.spec.in	2009-04-21 13:25:19.000000000 -0600
@@ -143,6 +143,7 @@
 %{_root_sbindir}/tune2fs
 %{_sbindir}/filefrag
 %{_sbindir}/mklost+found
+%{_sbindir}/e2freefrag
 
 %{_root_libdir}/libblkid.so.*
 %{_root_libdir}/libcom_err.so.*
@@ -187,6 +188,7 @@
 %{_mandir}/man8/resize2fs.8*
 %{_mandir}/man8/tune2fs.8*
 %{_mandir}/man8/filefrag.8*
+%{_mandir}/man8/e2freefrag.8*
 
 %files devel
 %defattr(-,root,root)
Index: e2fsprogs-1.41.4/misc/Makefile.in
===================================================================
--- e2fsprogs-1.41.4.orig/misc/Makefile.in	2009-04-14 05:56:43.000000000 -0600
+++ e2fsprogs-1.41.4/misc/Makefile.in	2009-04-14 06:09:57.000000000 -0600
@@ -19,10 +19,10 @@
 
 SPROGS=		mke2fs badblocks tune2fs dumpe2fs $(BLKID_PROG) logsave \
 			$(E2IMAGE_PROG) @FSCK_PROG@ e2undo
-USPROGS=	mklost+found filefrag $(UUIDD_PROG)
+USPROGS=	mklost+found filefrag e2freefrag $(UUIDD_PROG)
 SMANPAGES=	tune2fs.8 mklost+found.8 mke2fs.8 dumpe2fs.8 badblocks.8 \
 			e2label.8 $(FINDFS_MAN) $(BLKID_MAN) $(E2IMAGE_MAN) \
-			logsave.8 filefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
+			logsave.8 filefrag.8 e2freefrag.8 e2undo.8 $(UUIDD_MAN) @FSCK_MAN@
 FMANPAGES=	mke2fs.conf.5
 
 UPROGS=		chattr lsattr uuidgen
@@ -44,6 +44,7 @@
 BLKID_OBJS=	blkid.o
 FILEFRAG_OBJS=	filefrag.o
 E2UNDO_OBJS=  e2undo.o
+E2FREEFRAG_OBJS= e2freefrag.o
 
 PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
 PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
@@ -71,7 +72,7 @@
 		$(srcdir)/uuidgen.c $(srcdir)/blkid.c $(srcdir)/logsave.c \
 		$(srcdir)/filefrag.c $(srcdir)/base_device.c \
 		$(srcdir)/ismounted.c $(srcdir)/../e2fsck/profile.c \
-		$(srcdir)/e2undo.c
+		$(srcdir)/e2undo.c $(srcdir)/e2freefrag.c
 
 LIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
 DEPLIBS= $(LIBEXT2FS) $(LIBCOM_ERR) 
@@ -276,6 +277,10 @@
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -g -pg -o logsave.profiled profiled/logsave.o
 
+e2freefrag: $(E2FREEFRAG_OBJS)
+	@echo "LD $@"
+	@$(CC) $(ALL_LDFLAGS) -o e2freefrag $(E2FREEFRAG_OBJS) $(LIBS)
+
 filefrag: $(FILEFRAG_OBJS)
 	@echo "	LD $@"
 	@$(CC) $(ALL_LDFLAGS) -o filefrag $(FILEFRAG_OBJS) 
@@ -361,6 +366,10 @@
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/blkid.1.in blkid.1 
 
+e2freefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/e2freefrag.8.in
+	@echo "	SUBST $@"
+	@$(SUBSTITUTE_UPTIME) $(srcdir)/e2freefrag.8.in e2freefrag.8
+
 filefrag.8: $(DEP_SUBSTITUTE) $(srcdir)/filefrag.8.in
 	@echo "	SUBST $@"
 	@$(SUBSTITUTE_UPTIME) $(srcdir)/filefrag.8.in filefrag.8
@@ -522,7 +531,7 @@
 clean:
 	$(RM) -f $(SPROGS) $(USPROGS) $(UPROGS) $(UMANPAGES) $(SMANPAGES) \
 		$(FMANPAGES) \
-		base_device base_device.out mke2fs.static filefrag \
+		base_device base_device.out mke2fs.static filefrag e2freefrag \
 		e2initrd_helper partinfo prof_err.[ch] default_profile.c \
 		uuidd e2image tune2fs.static tst_ismounted fsck.profiled \
 		blkid.profiled tune2fs.profiled e2image.profiled \
@@ -603,6 +612,9 @@
 blkid.o: $(srcdir)/blkid.c $(top_srcdir)/lib/blkid/blkid.h \
  $(top_builddir)/lib/blkid/blkid_types.h
 logsave.o: $(srcdir)/logsave.c
+e2freefrag.o: $(srcdir)/e2freefrag.c e2freefrag.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext2fs.h \
+ $(top_srcdir)/lib/ext2fs/bitops.h
 filefrag.o: $(srcdir)/filefrag.c
 base_device.o: $(srcdir)/base_device.c $(srcdir)/fsck.h
 ismounted.o: $(srcdir)/ismounted.c $(top_srcdir)/lib/et/com_err.h

--Boundary_(ID_MgKD0vdkAF1ifVUgfl534g)--
