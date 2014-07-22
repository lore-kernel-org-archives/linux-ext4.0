From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] xfstests: add new defragmentation test (compacting case)
Date: Wed, 23 Jul 2014 00:37:35 +0400
Message-ID: <1406061455-731-2-git-send-email-dmonakhov@openvz.org>
References: <1406061455-731-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:4853 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaGVUhq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2014 16:37:46 -0400
In-Reply-To: <1406061455-731-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

EXT4_MOVE_EXTENT is ready to support case where orig_offset != donor_offset.
This case is usable for compacting small files together.
Test generate file hierarchy via fsstress and then compact all files
to one adjacent block.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 src/Makefile       |    2 +-
 src/e4compact.c    |  206 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/308     |   73 ++++++++++++++++++
 tests/ext4/308.out |    6 ++
 tests/ext4/group   |    1 +
 5 files changed, 287 insertions(+), 1 deletions(-)
 create mode 100644 src/e4compact.c
 create mode 100755 tests/ext4/308
 create mode 100644 tests/ext4/308.out

diff --git a/src/Makefile b/src/Makefile
index 7a7984a..a539c4a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
-	renameat2 t_getcwd
+	renameat2 t_getcwd e4compact
 
 SUBDIRS =
 
diff --git a/src/e4compact.c b/src/e4compact.c
new file mode 100644
index 0000000..4771418
--- /dev/null
+++ b/src/e4compact.c
@@ -0,0 +1,206 @@
+/* E4COMPACT
+ *
+ * Compact list of files sequentially
+ *
+ * Usage example:
+ * find /etc -type f > etc_list
+ * fallocate -l100M /etc/.tmp_donor_file
+ * cat etc_list | ./e4defrag /etc/.tmp_donor_file
+ * unlink /etc/.tmp_donor_file
+ */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+
+#include <assert.h>
+#include <ctype.h>
+#include <limits.h>
+#include <errno.h>
+#include <linux/types.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/param.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <unistd.h>
+
+#ifndef EXT4_IOC_MOVE_EXT
+struct move_extent {
+	__s32 reserved;	/* original file descriptor */
+	__u32 donor_fd;	/* donor file descriptor */
+	__u64 orig_start;	/* logical start offset in block for orig */
+	__u64 donor_start;	/* logical start offset in block for donor */
+	__u64 len;	/* block length to be moved */
+	__u64 moved_len;	/* moved block length */
+};
+
+#define EXT4_IOC_MOVE_EXT      _IOWR('f', 15, struct move_extent)
+#endif
+
+struct donor_info
+{
+	int fd;
+	__u64 offset;
+	__u64 length;
+};
+
+static int ignore_error = 0;
+static int verbose = 0;
+
+
+static int do_defrag_one(int fd, char *name,__u64 start, __u64 len, struct donor_info *donor)
+{
+	int ret, retry;
+	struct move_extent mv_ioc;
+	__u64 moved = 0;
+	int i = 0;
+
+	assert(donor->length >= len);
+
+	mv_ioc.donor_fd = donor->fd;
+	mv_ioc.orig_start = start;
+	mv_ioc.donor_start = donor->offset;
+	mv_ioc.moved_len = 0;
+	mv_ioc.len = len;
+
+	if (verbose)
+		printf("%s %s start:%lld len:%lld donor [%lld, %lld]\n",  __func__,
+		       name, (unsigned long long) start,
+		       (unsigned long long) len,
+		       (unsigned long long)donor->offset,
+		       (unsigned long long)donor->length);
+	retry= 3;
+	do {
+		i++;
+		errno = 0;
+		ret = ioctl(fd, EXT4_IOC_MOVE_EXT, &mv_ioc);
+		if (verbose)
+			printf("process %s  it:%d start:%lld len:%lld donor:%lld,"
+			       "moved:%lld ret:%d errno:%d\n",
+			       name, i,
+			       (unsigned long long) mv_ioc.orig_start,
+			       (unsigned long long) mv_ioc.len,
+			       (unsigned long long)mv_ioc.donor_start,
+			       (unsigned long long)mv_ioc.moved_len,
+		       ret, errno);
+		if (ret < 0) {
+			if (verbose)
+				printf("%s EXT4_IOC_MOVE_EXT failed err:%d\n",
+				       __func__, errno);
+			if (errno != EBUSY || !retry--)
+				break;
+		} else {
+			retry = 3;
+			/* Nothing to swap */
+			if (mv_ioc.moved_len == 0)
+				break;
+		}
+		assert(mv_ioc.len >= mv_ioc.moved_len);
+		mv_ioc.len -= mv_ioc.moved_len;
+		mv_ioc.orig_start += mv_ioc.moved_len;
+		mv_ioc.donor_start = mv_ioc.orig_start;
+		moved += mv_ioc.moved_len;
+
+	} while (mv_ioc.len);
+
+	if (ret && (errno == EBUSY || errno == ENODATA))
+		ret = 0;
+	donor->length -= moved;
+	donor->offset += moved;
+	return ret;
+}
+
+void usage()
+{
+	printf("Usage: -f donor_file [-o donor_offset] [-v] [-i]\n"
+	       "\t\t -v: verbose\n"
+	       "\t\t -i: ignore errors\n");
+}
+
+int main(int argc, char **argv)
+{
+	int fd, ret = 0;
+	char *line = NULL;
+	size_t len = 0;
+	ssize_t read;
+	struct donor_info donor;
+	struct stat st;
+	extern char *optarg;
+	extern int optind;
+	int c;
+	char * donor_name = NULL;
+	donor.offset = 0;
+	while ((c = getopt(argc, argv, "f:o:iv")) != -1) {
+		switch (c) {
+		case 'o':
+			donor.offset = atol(optarg);
+			break;
+		case 'i':
+			ignore_error = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'f':
+			donor_name = (optarg);
+			break;
+
+		default:
+			usage();
+			exit(1);
+		}
+	}
+	donor.fd = open(donor_name, O_RDWR);
+	if (donor.fd < 0) {
+		perror("can not open donor file");
+		exit(1);
+	}
+	if (fstat(donor.fd, &st)) {
+		perror("can not stat donor fd");
+		exit(1);
+	}
+	donor.length = st.st_size / st.st_blksize;
+	if (donor.offset)
+		donor.offset /= st.st_blksize;
+
+	if (verbose)
+		printf("Init donor :%s off:%lld len:%lld\n", argv[1], donor.offset, donor.length);
+	while ((read = getline(&line, &len, stdin)) != -1) {
+
+		if (line[read -1] == '\n')
+			line[read -1] = 0;
+
+		fd = open(line, O_RDWR);
+		if (fd < 0) {
+			if (verbose)
+				printf("Can not open %s errno:%d", line, errno);
+			if (ignore_error)
+				continue;
+			else
+				break;
+		}
+		if(fstat(fd, &st)) {
+			if (verbose)
+				perror("Can not stat ");
+			continue;
+			if (ignore_error)
+				continue;
+			else
+				break;
+
+		}
+		if (st.st_size && st.st_blocks) {
+			ret = do_defrag_one(fd, line, 0,
+					    (st.st_size  + st.st_blksize-1)/
+					    st.st_blksize, &donor);
+			if (ret && ignore_error)
+				break;
+		}
+	}
+	free(line);
+	return ret;
+}
diff --git a/tests/ext4/308 b/tests/ext4/308
new file mode 100755
index 0000000..7833213
--- /dev/null
+++ b/tests/ext4/308
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FSQA Test No. 308
+#
+# Check data integrity during defragmentation(compacting).
+# 
+#-----------------------------------------------------------------------
+# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/defrag
+# Disable all sync operations to get higher load
+FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0"
+_workout()
+{
+    	echo ""
+	echo "Run fsstress"
+	out=$SCRATCH_MNT/fsstress.$$
+	args=`_scale_fsstress_args -p4 -n999 -f setattr=1 $FSSTRESS_AVOID -d $out`
+	echo "fsstress $args" >> $seqres.full
+	$FSSTRESS_PROG $args > /dev/null 2>&1 
+	find $out -type f > $out.list
+	cat $out.list | xargs  sha1sum > $out.sha1sum
+	usage=`du -sch $out | tail -n1 | gawk '{ print $1 }'`
+	echo "Allocate donor file"
+	fallocate -l $usage $SCRATCH_MNT/donor
+	echo "Perform compacting"
+	cat $out.list | run_check $here/src/e4compact \
+	    -i -v -f $SCRATCH_MNT/donor  >> $seqres.full 2>&1
+	echo "Check data"
+	run_check sha1sum -c $out.sha1sum
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_defrag
+
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full 2>&1
+_scratch_mount
+
+_workout
+_check_scratch_fs
+status=$?
+exit
diff --git a/tests/ext4/308.out b/tests/ext4/308.out
new file mode 100644
index 0000000..96d3dd6
--- /dev/null
+++ b/tests/ext4/308.out
@@ -0,0 +1,6 @@
+QA output created by 308
+
+Run fsstress
+Allocate donor file
+Perform compacting
+Check data
diff --git a/tests/ext4/group b/tests/ext4/group
index 5c5cb05..e92a725 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -13,3 +13,4 @@
 305 auto
 306 auto rw resize quick
 307 auto ioctl rw quick
+308 auto ioctl rw quick
\ No newline at end of file
-- 
1.7.1

