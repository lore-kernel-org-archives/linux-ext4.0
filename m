From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/24] e2fuzz: Create a tool to fuzz ext* filesystems
Date: Fri, 18 Jul 2014 15:55:44 -0700
Message-ID: <20140718225544.31374.24010.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33807 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaGRWzz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:55:55 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Creates a program that fuzzes only the metadata blocks (or optionally
all in-use blocks) of an ext* filesystem.  There's also a script to
automate fuzz testing of the kernel and e2fsck in a loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/Makefile.in |   17 ++-
 misc/e2fuzz.c    |  352 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/e2fuzz.sh   |  262 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 630 insertions(+), 1 deletion(-)
 create mode 100644 misc/e2fuzz.c
 create mode 100755 misc/e2fuzz.sh


diff --git a/misc/Makefile.in b/misc/Makefile.in
index 94fac22..d178ff0 100644
--- a/misc/Makefile.in
+++ b/misc/Makefile.in
@@ -57,6 +57,7 @@ FILEFRAG_OBJS=	filefrag.o
 E2UNDO_OBJS=  e2undo.o
 E4DEFRAG_OBJS=	e4defrag.o
 E2FREEFRAG_OBJS= e2freefrag.o
+E2FUZZ_OBJS=	e2fuzz.o
 
 PROFILED_TUNE2FS_OBJS=	profiled/tune2fs.o profiled/util.o
 PROFILED_MKLPF_OBJS=	profiled/mklost+found.o
@@ -107,7 +108,7 @@ COMPILE_ET=$(top_builddir)/lib/et/compile_et --build-tree
 @PROFILE_CMT@	$(Q) $(CC) $(ALL_CFLAGS) -g -pg -o profiled/$*.o -c $<
 
 all:: profiled $(SPROGS) $(UPROGS) $(USPROGS) $(SMANPAGES) $(UMANPAGES) \
-	$(FMANPAGES) $(LPROGS) $(E4DEFRAG_PROG)
+	$(FMANPAGES) $(LPROGS) $(E4DEFRAG_PROG) e2fuzz
 
 @PROFILE_CMT@all:: tune2fs.profiled blkid.profiled e2image.profiled \
 	e2undo.profiled mke2fs.profiled dumpe2fs.profiled fsck.profiled \
@@ -344,6 +345,12 @@ e2freefrag.profiled: $(E2FREEFRAG_OBJS) $(PROFILED_DEPLIBS)
 	$(Q) $(CC) $(ALL_LDFLAGS) -g -pg -o e2freefrag.profiled \
 		$(PROFILED_E2FREEFRAG_OBJS) $(PROFILED_LIBS) $(SYSLIBS)
 
+e2fuzz: $(E2FUZZ_OBJS) $(DEPLIBS) $(DEPLIBBLKID) $(DEPLIBUUID) \
+		$(DEPLIBQUOTA) $(LIBEXT2FS)
+	$(E) "	LD $@"
+	$(Q) $(CC) $(ALL_LDFLAGS) -o e2fuzz $(E2FUZZ_OBJS) $(LIBS) \
+		$(LIBBLKID) $(LIBUUID) $(LIBEXT2FS)
+
 filefrag: $(FILEFRAG_OBJS)
 	$(E) "	LD $@"
 	$(Q) $(CC) $(ALL_LDFLAGS) -o filefrag $(FILEFRAG_OBJS) $(SYSLIBS)
@@ -738,6 +745,14 @@ e2freefrag.o: $(srcdir)/e2freefrag.c $(top_builddir)/lib/config.h \
  $(top_srcdir)/lib/ext2fs/ext2_io.h $(top_builddir)/lib/ext2fs/ext2_err.h \
  $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
  $(srcdir)/e2freefrag.h
+e2fuzz.o: $(srcdir)/e2fuzz.c $(top_builddir)/lib/config.h \
+ $(top_builddir)/lib/dirpaths.h $(top_srcdir)/lib/ext2fs/tdb.h \
+ $(top_srcdir)/lib/ext2fs/ext2fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
+ $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_srcdir)/lib/ext2fs/ext3_extents.h \
+ $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/ext2fs/ext2_io.h \
+ $(top_builddir)/lib/ext2fs/ext2_err.h \
+ $(top_srcdir)/lib/ext2fs/ext2_ext_attr.h $(top_srcdir)/lib/ext2fs/bitops.h \
+ $(srcdir)/nls-enable.h
 create_inode.o: $(srcdir)/create_inode.c $(srcdir)/create_inode.h \
  $(top_srcdir)/lib/et/com_err.h $(top_srcdir)/lib/e2p/e2p.h \
  $(top_srcdir)/lib/ext2fs/ext2_fs.h $(top_builddir)/lib/ext2fs/ext2_types.h \
diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
new file mode 100644
index 0000000..644c9c5
--- /dev/null
+++ b/misc/e2fuzz.c
@@ -0,0 +1,352 @@
+/*
+ * e2fuzz.c -- Fuzz an ext4 image, for testing purposes.
+ *
+ * Copyright (C) 2014 Oracle.
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+#define _XOPEN_SOURCE		600
+#define _FILE_OFFSET_BITS       64
+#define _LARGEFILE64_SOURCE     1
+#define _GNU_SOURCE		1
+
+#include "config.h"
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <stdint.h>
+#ifdef HAVE_GETOPT_H
+#include <getopt.h>
+#endif
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+static int dryrun = 0;
+static int verbose = 0;
+static int metadata_only = 1;
+static unsigned long long user_corrupt_bytes = 0;
+static double user_corrupt_pct = 0.0;
+
+int getseed(void)
+{
+	int r;
+	int fd;
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		exit(0);
+	}
+	read(fd, &r, sizeof(r));
+	close(fd);
+	return r;
+}
+
+struct find_block {
+	ext2_ino_t ino;
+	ext2fs_block_bitmap bmap;
+	struct ext2_inode *inode;
+	blk64_t corrupt_blocks;
+};
+
+int find_block_helper(ext2_filsys fs, blk64_t *blocknr, e2_blkcnt_t blockcnt,
+		      blk64_t ref_blk, int ref_offset, void *priv_data)
+{
+	struct find_block *fb = (struct find_block *)priv_data;
+
+	if (S_ISDIR(fb->inode->i_mode) || !metadata_only || blockcnt < 0) {
+		ext2fs_mark_block_bitmap2(fb->bmap, *blocknr);
+		fb->corrupt_blocks++;
+	}
+
+	return 0;
+}
+
+errcode_t find_metadata_blocks(ext2_filsys fs, ext2fs_block_bitmap bmap,
+			       off_t *corrupt_bytes)
+{
+	dgrp_t i;
+	blk64_t b, c, d, j, old_desc_blocks;
+	ext2_inode_scan scan;
+	ext2_ino_t ino;
+	struct ext2_inode inode;
+	struct find_block fb;
+	errcode_t retval;
+
+	*corrupt_bytes = 0;
+	fb.corrupt_blocks = 0;
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT2_FEATURE_INCOMPAT_META_BG))
+		old_desc_blocks = fs->super->s_first_meta_bg;
+	else
+		old_desc_blocks = fs->desc_blocks +
+				  fs->super->s_reserved_gdt_blocks;
+
+	/* Construct bitmaps of super/descriptor blocks */
+	for (i = 0; i < fs->group_desc_count; i++) {
+		ext2fs_reserve_super_and_bgd(fs, i, bmap);
+
+		/* bitmaps and inode table */
+		b = ext2fs_block_bitmap_loc(fs, i);
+		ext2fs_mark_block_bitmap2(bmap, b);
+		fb.corrupt_blocks++;
+
+		b = ext2fs_inode_bitmap_loc(fs, i);
+		ext2fs_mark_block_bitmap2(bmap, b);
+		fb.corrupt_blocks++;
+
+		c = ext2fs_inode_table_loc(fs, i);
+		ext2fs_mark_block_bitmap_range2(bmap, c,
+						fs->inode_blocks_per_group);
+		fb.corrupt_blocks += fs->inode_blocks_per_group;
+	}
+
+	/* Scan inodes */
+	fb.bmap = bmap;
+	fb.inode = &inode;
+	memset(&inode, 0, sizeof(inode));
+	retval = ext2fs_open_inode_scan(fs, 0, &scan);
+	if (retval)
+		goto out;
+
+	retval = ext2fs_get_next_inode_full(scan, &ino, &inode, sizeof(inode));
+	if (retval)
+		goto out2;
+	while (ino) {
+		if (inode.i_links_count == 0)
+			goto next_loop;
+
+		b = ext2fs_file_acl_block(fs, &inode);
+		if (b) {
+			ext2fs_mark_block_bitmap2(bmap, b);
+			fb.corrupt_blocks++;
+		}
+
+		/*
+		 * Inline data, sockets, devices, and symlinks have
+		 * no blocks to iterate.
+		 */
+		if ((inode.i_flags & EXT4_INLINE_DATA_FL) ||
+		    S_ISLNK(inode.i_mode) || S_ISFIFO(inode.i_mode) ||
+		    S_ISCHR(inode.i_mode) || S_ISBLK(inode.i_mode) ||
+		    S_ISSOCK(inode.i_mode))
+			goto next_loop;
+		fb.ino = ino;
+		retval = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY,
+					       NULL, find_block_helper, &fb);
+		if (retval)
+			goto out2;
+next_loop:
+		retval = ext2fs_get_next_inode_full(scan, &ino, &inode,
+						    sizeof(inode));
+		if (retval)
+			goto out2;
+	}
+out2:
+	ext2fs_close_inode_scan(scan);
+out:
+	if (!retval)
+		*corrupt_bytes = fb.corrupt_blocks * fs->blocksize;
+	return retval;
+}
+
+uint64_t rand_num(uint64_t min, uint64_t max)
+{
+	uint64_t x;
+	int i;
+	uint8_t *px = (uint8_t *)&x;
+
+	for (i = 0; i < sizeof(x); i++)
+		px[i] = random();
+
+	return min + (uint64_t)((double)(max - min) * (x / (UINT64_MAX + 1.0)));
+}
+
+int process_fs(const char *fsname)
+{
+	errcode_t ret;
+	int flags, fd;
+	ext2_filsys fs = NULL;
+	ext2fs_block_bitmap corrupt_map;
+	off_t hsize, count, off, offset, corrupt_bytes;
+	unsigned char c;
+	unsigned long i;
+
+	/* If mounted rw, force dryrun mode */
+	ret = ext2fs_check_if_mounted(fsname, &flags);
+	if (ret) {
+		fprintf(stderr, "%s: failed to determine filesystem mount "
+			"state.\n", fsname);
+		return 1;
+	}
+
+	if (!dryrun && (flags & EXT2_MF_MOUNTED) &&
+	    !(flags & EXT2_MF_READONLY)) {
+		fprintf(stderr, "%s: is mounted rw, performing dry run.\n",
+			fsname);
+		dryrun = 1;
+	}
+
+	/* Ensure the fs is clean and does not have errors */
+	ret = ext2fs_open(fsname, EXT2_FLAG_64BITS, 0, 0, unix_io_manager,
+			  &fs);
+	if (ret) {
+		fprintf(stderr, "%s: failed to open filesystem.\n",
+			fsname);
+		return 1;
+	}
+
+	if ((fs->super->s_state & EXT2_ERROR_FS)) {
+		fprintf(stderr, "%s: errors detected, run fsck.\n",
+			fsname);
+		goto fail;
+	}
+
+	if (!dryrun && (fs->super->s_state & EXT2_VALID_FS) == 0) {
+		fprintf(stderr, "%s: unclean shutdown, performing dry run.\n",
+			fsname);
+		dryrun = 1;
+	}
+
+	/* Construct a bitmap of whatever we're corrupting */
+	if (!metadata_only) {
+		/* Load block bitmap */
+		ret = ext2fs_read_block_bitmap(fs);
+		if (ret) {
+			fprintf(stderr, "%s: error while reading block bitmap\n",
+				fsname);
+			goto fail;
+		}
+		corrupt_map = fs->block_map;
+		corrupt_bytes = (ext2fs_blocks_count(fs->super) -
+				 ext2fs_free_blocks_count(fs->super)) *
+				fs->blocksize;
+	} else {
+		ret = ext2fs_allocate_block_bitmap(fs, "metadata block map",
+						   &corrupt_map);
+		if (ret) {
+			fprintf(stderr, "%s: unable to create block bitmap\n",
+				fsname);
+			goto fail;
+		}
+
+		/* Iterate everything... */
+		ret = find_metadata_blocks(fs, corrupt_map, &corrupt_bytes);
+		if (ret) {
+			fprintf(stderr, "%s: while finding metadata\n",
+				fsname);
+			goto fail;
+		}
+	}
+
+	/* Run around corrupting things */
+	fd = open(fsname, O_RDWR);
+	if (fd < 0) {
+		perror(fsname);
+		goto fail;
+	}
+	srandom(getseed());
+	hsize = fs->blocksize * ext2fs_blocks_count(fs->super);
+	if (user_corrupt_bytes > 0)
+		count = user_corrupt_bytes;
+	else if (user_corrupt_pct > 0.0)
+		count = user_corrupt_pct * corrupt_bytes / 100;
+	else
+		count = rand_num(0, corrupt_bytes / 100);
+	offset = 4096; /* never corrupt superblock */
+	for (i = 0; i < count; i++) {
+		do
+			off = rand_num(offset, hsize);
+		while (!ext2fs_test_block_bitmap2(corrupt_map,
+						    off / fs->blocksize));
+		c = rand() % 256;
+		if ((rand() % 2) && c < 128)
+			c |= 0x80;
+		if (verbose)
+			printf("Corrupting byte %jd in block %jd to 0x%x\n",
+			       off % fs->blocksize, off / fs->blocksize, c);
+		if (dryrun)
+			continue;
+		if (pwrite64(fd, &c, sizeof(c), off) != sizeof(c)) {
+			perror(fsname);
+			goto fail3;
+		}
+	}
+	close(fd);
+
+	/* Clean up */
+	ret = ext2fs_close(fs);
+	if (ret) {
+		fs = NULL;
+		fprintf(stderr, "%s: error while closing filesystem\n",
+			fsname);
+		goto fail2;
+	}
+
+	return 0;
+fail3:
+	close(fd);
+fail2:
+	if (corrupt_map != fs->block_map)
+		ext2fs_free_block_bitmap(corrupt_map);
+fail:
+	if (fs)
+		ext2fs_close(fs);
+	return 1;
+}
+
+void print_help(const char *progname)
+{
+	printf("Usage: %s OPTIONS device\n", progname);
+	printf("-b:	Corrupt this many bytes.\n");
+	printf("-d:	Fuzz data blocks too.\n");
+	printf("-n:	Dry run only.\n");
+	printf("-v:	Verbose output.\n");
+	exit(0);
+}
+
+int main(int argc, char *argv[])
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "b:dnv")) != -1) {
+		switch (c) {
+		case 'b':
+			if (optarg[strlen(optarg) - 1] == '%') {
+				user_corrupt_pct = strtod(optarg, NULL);
+				if (user_corrupt_pct > 100 ||
+				    user_corrupt_pct < 0) {
+					fprintf(stderr, "%s: Invalid percentage.\n",
+						optarg);
+					return 1;
+				}
+			} else
+				user_corrupt_bytes = strtoull(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'd':
+			metadata_only = 0;
+			break;
+		case 'n':
+			dryrun = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			print_help(argv[0]);
+		}
+	}
+
+	for (c = optind; c < argc; c++)
+		if (process_fs(argv[c]))
+			return 1;
+	return 0;
+}
diff --git a/misc/e2fuzz.sh b/misc/e2fuzz.sh
new file mode 100755
index 0000000..a261d5a
--- /dev/null
+++ b/misc/e2fuzz.sh
@@ -0,0 +1,262 @@
+#!/bin/bash
+
+# Test harness to fuzz a filesystem over and over...
+# Copyright (C) 2014 Oracle.
+
+DIR=/tmp
+PASSES=10000
+SZ=32m
+SCRIPT_DIR="$(dirname "$0")"
+FEATURES="has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,64bit,metadata_csum,bigalloc,sparse_super2,inline_data"
+BLK_SZ=4096
+INODE_SZ=256
+EXTENDED_OPTS="discard"
+EXTENDED_FSCK_OPTIONS=""
+RUN_FSCK=1
+OVERRIDE_PATH=1
+HAS_FUSE2FS=0
+USE_FUSE2FS=0
+MAX_FSCK=10
+SRCDIR=/etc
+test -x "${SCRIPT_DIR}/fuse2fs" && HAS_FUSE2FS=1
+
+print_help() {
+	echo "Usage: $0 OPTIONS"
+	echo "-b:	FS block size is this. (${BLK_SZ})"
+	echo "-B:	Corrupt this many bytes per run."
+	echo "-d:	Create test files in this directory. (${DIR})"
+	echo "-E:	Extended mke2fs options."
+	echo "-f:	Do not run e2fsck after each pass."
+	echo "-F:	Extended e2fsck options."
+	echo "-I:	Create inodes of this size. (${INODE_SZ})"
+	echo "-n:	Run this many passes. (${PASSES})"
+	echo "-O:	Create FS with these features."
+	echo "-p:	Use system's mke2fs/e2fsck/tune2fs tools."
+	echo "-s:	Create FS images of this size. (${SZ})"
+	echo "-S:	Copy files from this dir. (${SRCDIR})"
+	echo "-x:	Run e2fck at most this many times. (${MAX_FSCK})"
+	test "${HAS_FUSE2FS}" -gt 0 && echo "-u:	Use fuse2fs instead of the kernel."
+	exit 0
+}
+
+GETOPT="d:n:s:O:I:b:B:E:F:fpx:S:"
+test "${HAS_FUSE2FS}" && GETOPT="${GETOPT}u"
+
+while getopts "${GETOPT}" opt; do
+	case "${opt}" in
+	"B")
+		E2FUZZ_ARGS="${E2FUZZ_ARGS} -b ${OPTARG}"
+		;;
+	"d")
+		DIR="${OPTARG}"
+		;;
+	"n")
+		PASSES="${OPTARG}"
+		;;
+	"s")
+		SZ="${OPTARG}"
+		;;
+	"O")
+		FEATURES="${FEATURES},${OPTARG}"
+		;;
+	"I")
+		INODE_SZ="${OPTARG}"
+		;;
+	"b")
+		BLK_SZ="${OPTARG}"
+		;;
+	"E")
+		EXTENDED_OPTS="${OPTARG}"
+		;;
+	"F")
+		EXTENDED_FSCK_OPTS="-E ${OPTARG}"
+		;;
+	"f")
+		RUN_FSCK=0
+		;;
+	"p")
+		OVERRIDE_PATH=0
+		;;
+	"u")
+		USE_FUSE2FS=1
+		;;
+	"x")
+		MAX_FSCK="${OPTARG}"
+		;;
+	"S")
+		SRCDIR="${OPTARG}"
+		;;
+	*)
+		print_help
+		;;
+	esac
+done
+
+if [ "${OVERRIDE_PATH}" -gt 0 ]; then
+	PATH="${SCRIPT_DIR}:${SCRIPT_DIR}/../e2fsck/:${PATH}"
+	export PATH
+fi
+
+TESTDIR="${DIR}/tests/"
+TESTMNT="${DIR}/mnt/"
+BASE_IMG="${DIR}/e2fuzz.img"
+
+cat > /tmp/mke2fs.conf << ENDL
+[defaults]
+        base_features = ${FEATURES}
+        default_mntopts = acl,user_xattr,block_validity
+        enable_periodic_fsck = 0
+        blocksize = ${BLK_SZ}
+        inode_size = ${INODE_SZ}
+        inode_ratio = 4096
+	cluster_size = $((BLK_SZ * 2))
+	options = ${EXTENDED_OPTS}
+ENDL
+MKE2FS_CONFIG=/tmp/mke2fs.conf
+export MKE2FS_CONFIG
+
+# Set up FS image
+echo "+ create fs image"
+umount "${TESTDIR}"
+umount "${TESTMNT}"
+rm -rf "${TESTDIR}"
+rm -rf "${TESTMNT}"
+mkdir -p "${TESTDIR}"
+mkdir -p "${TESTMNT}"
+rm -rf "${BASE_IMG}"
+truncate -s "${SZ}" "${BASE_IMG}"
+mke2fs -F -v "${BASE_IMG}"
+if [ $? -ne 0 ]; then
+	exit $?
+fi
+
+# Populate FS image
+echo "+ populate fs image"
+modprobe loop
+mount "${BASE_IMG}" "${TESTMNT}" -o loop
+if [ $? -ne 0 ]; then
+	exit $?
+fi
+SRC_SZ="$(du -ks "${SRCDIR}" | awk '{print $1}')"
+FS_SZ="$(( $(stat -f "${TESTMNT}" -c '%a * %S') / 1024 ))"
+NR="$(( (FS_SZ * 6 / 10) / SRC_SZ ))"
+if [ "${NR}" -lt 1 ]; then
+	NR=1
+fi
+echo "+ make ${NR} copies"
+seq 1 "${NR}" | while read nr; do
+	cp -pRdu "${SRCDIR}" "${TESTMNT}/test.${nr}" 2> /dev/null
+done
+umount "${TESTMNT}"
+e2fsck -fn "${BASE_IMG}"
+if [ $? -ne 0 ]; then
+	echo "fsck failed??"
+	exit 1
+fi
+
+# Run tests
+echo "+ run test"
+ret=0
+seq 1 "${PASSES}" | while read pass; do
+	echo "+ pass ${pass}"
+	PASS_IMG="${TESTDIR}/e2fuzz-${pass}.img"
+	FSCK_IMG="${TESTDIR}/e2fuzz-${pass}.fsck"
+	FUZZ_LOG="${TESTDIR}/e2fuzz-${pass}.fuzz.log"
+	OPS_LOG="${TESTDIR}/e2fuzz-${pass}.ops.log"
+
+	echo "++ corrupt image"
+	cp "${BASE_IMG}" "${PASS_IMG}"
+	if [ $? -ne 0 ]; then
+		exit $?
+	fi
+	tune2fs -L "e2fuzz-${pass}" "${PASS_IMG}"
+	e2fuzz -v "${PASS_IMG}" ${E2FUZZ_ARGS} > "${FUZZ_LOG}"
+	if [ $? -ne 0 ]; then
+		exit $?
+	fi
+
+	echo "++ mount image"
+	if [ "${USE_FUSE2FS}" -gt 0 ]; then
+		"${SCRIPT_DIR}/fuse2fs" "${PASS_IMG}" "${TESTMNT}"
+		res=$?
+	else
+		mount "${PASS_IMG}" "${TESTMNT}" -o loop
+		res=$?
+	fi
+
+	if [ "${res}" -eq 0 ]; then
+		echo "+++ ls -laR"
+		ls -laR "${TESTMNT}/test.1/" > /dev/null 2> "${OPS_LOG}"
+
+		echo "+++ cat files"
+		find "${TESTMNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat > /dev/null 2>> "${OPS_LOG}"
+
+		echo "+++ expand"
+		find "${TESTMNT}/test.1/" -type f 2> /dev/null | while read f; do
+			attr -l "$f" > /dev/null 2>> "${OPS_LOG}"
+			mv "$f" "$f.longer" > /dev/null 2>> "${OPS_LOG}"
+			if [ -f "$f" -a -w "$f" ]; then
+				dd if=/dev/zero bs="${BLK_SZ}" count=1 >> "$f" 2>> "${OPS_LOG}"
+			fi
+		done
+		sync
+
+		echo "+++ create files"
+		cp -pRdu "${SRCDIR}" "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+		sync
+
+		echo "+++ remove files"
+		rm -rf "${TESTMNT}/test.moo" 2>> "${OPS_LOG}"
+
+		umount "${TESTMNT}"
+		res=$?
+		if [ "${res}" -ne 0 ]; then
+			ret=1
+			break
+		fi
+		sync
+		test "${USE_FUSE2FS}" -gt 0 && sleep 2
+	fi
+	if [ "${RUN_FSCK}" -gt 0 ]; then
+		cp "${PASS_IMG}" "${FSCK_IMG}"
+
+		seq 1 "${MAX_FSCK}" | while read fsck_pass; do
+			echo "++ fsck pass ${fsck_pass}: $(which e2fsck) -fy ${FSCK_IMG} ${EXTENDED_FSCK_OPTS}"
+			FSCK_LOG="${TESTDIR}/e2fuzz-${pass}-${fsck_pass}.log"
+			e2fsck -fy "${FSCK_IMG}" ${EXTENDED_FSCK_OPTS} > "${FSCK_LOG}" 2>&1
+			res=$?
+			echo "++ fsck returns ${res}"
+			if [ "${res}" -eq 0 ]; then
+				exit 0
+			elif [ "${fsck_pass}" -eq "${MAX_FSCK}" ]; then
+				echo "++ fsck did not fix in ${MAX_FSCK} passes."
+				exit 1
+			fi
+			if [ "${res}" -gt 0 -a \
+			     "$(grep 'Memory allocation failed' "${FSCK_LOG}" | wc -l)" -gt 0 ]; then
+				echo "++ Ran out of memory, get more RAM"
+				exit 0
+			fi
+			if [ "${res}" -gt 0 -a \
+			     "$(grep 'Could not allocate block' "${FSCK_LOG}" | wc -l)" -gt 0 -a \
+			     "$(dumpe2fs -h "${FSCK_IMG}" | grep '^Free blocks:' | awk '{print $3}')0" -eq 0 ]; then
+				echo "++ Ran out of space, get a bigger image"
+				exit 0
+			fi
+			if [ "${fsck_pass}" -gt 1 ]; then
+				diff -u "${TESTDIR}/e2fuzz-${pass}-$((fsck_pass - 1)).log" "${FSCK_LOG}"
+				if [ $? -eq 0 ]; then
+					echo "++ fsck makes no progress"
+					exit 2
+				fi
+			fi
+		done
+		fsck_loop_ret=$?
+		if [ "${fsck_loop_ret}" -gt 0 ]; then
+			break;
+		fi
+	fi
+	rm -rf "${FSCK_IMG}" "${PASS_IMG}" "${FUZZ_LOG}" "${TESTDIR}"/e2fuzz*.log
+done
+
+exit $ret

