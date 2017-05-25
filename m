From: Jan Kara <jack@suse.cz>
Subject: [PATCH] generic: Add regression test for tail page zeroing
Date: Thu, 25 May 2017 15:49:47 +0200
Message-ID: <20170525134947.15130-1-jack@suse.cz>
Cc: Michael Zimmer <michael@swarm64.com>, <linux-ext4@vger.kernel.org>,
        Eryu Guan <eguan@redhat.com>, Jan Kara <jack@suse.cz>
To: <fstests@vger.kernel.org>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add test checking for a race in ext4 writeback that could result in
zeroing too much from the tail page during writeback.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 src/Makefile           |  2 +-
 src/t_mmap_fallocate.c | 61 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/438      | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/438.out  |  2 ++
 tests/generic/group    |  1 +
 5 files changed, 140 insertions(+), 1 deletion(-)
 create mode 100644 src/t_mmap_fallocate.c
 create mode 100755 tests/generic/438
 create mode 100644 tests/generic/438.out

diff --git a/src/Makefile b/src/Makefile
index 47246622ce7f..adbfd286fe89 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -13,7 +13,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
 	holetest t_truncate_self t_mmap_dio af_unix t_mmap_stale_pmd \
-	t_mmap_cow_race
+	t_mmap_cow_race t_mmap_fallocate
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_mmap_fallocate.c b/src/t_mmap_fallocate.c
new file mode 100644
index 000000000000..fd69fb0ae833
--- /dev/null
+++ b/src/t_mmap_fallocate.c
@@ -0,0 +1,61 @@
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+int main(int argc, char **argv)
+{
+	int fd;
+	char *buf;
+	size_t fsize, i;
+
+	if (argc != 3) {
+		fputs("Usage: mmap_fallocate <file> <size-in-MB>\n", stderr);
+		exit(1);
+	}
+
+	fsize = strtol(argv[2], NULL, 10);
+	if (fsize <= 0) {
+		fprintf(stderr, "Invalid file size: %s\n", argv[2]);
+		exit(1);
+	}
+	fsize <<= 20;
+
+	fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0644);
+	if (fd < 0) {
+		perror("Cannot open file");
+	        exit(1);
+	}
+
+	buf = mmap(NULL, fsize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (buf == MAP_FAILED) {
+		perror("Cannot memory map");
+		exit(1);
+	}
+
+	for (i = 0; i < fsize; i++) {
+		if (posix_fallocate(fd, i, 1) != 0) {
+			perror("Cannot fallocate");
+			exit(1);
+		}
+		buf[i] = 0x78;
+
+		if (buf[i] != 0x78) {
+			fprintf(stderr,
+				"Value not written correctly (off=%lu)\n",
+				(unsigned long)i);
+			exit(1);
+		}
+	}
+
+	for (i = 0; i < fsize; i++) {
+		if (buf[i] != 0x78) {
+			fprintf(stderr, "Value has been modified (off=%lu)\n",
+				(unsigned long)i);
+			exit(1);
+		}
+	}
+
+	return 0;
+}
diff --git a/tests/generic/438 b/tests/generic/438
new file mode 100755
index 000000000000..d935ac0362ad
--- /dev/null
+++ b/tests/generic/438
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test 438
+#
+# This is a regression test for kernel patch
+#   "ext4: Fix data corruption for mmap writes"
+#
+# The problem this test checks for is when too much is zeroed in the tail
+# page that gets written out just while the file gets extended and written
+# to through mmap.
+#
+# Based on test program by Michael Zimmer <michael@swarm64.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 SUSE.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_test_program "t_mmap_fallocate"
+
+# real QA test starts here
+FILE=$TEST_DIR/testfile_fallocate
+# Make sure file exists
+echo >$FILE
+# Force frequent writeback of the file
+while true; do fsync $FILE; done &
+SYNCPID=$!
+
+# Run the test
+src/t_mmap_fallocate $FILE 10 && echo "Silence is golden"
+
+kill $SYNCPID
+wait
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/438.out b/tests/generic/438.out
new file mode 100644
index 000000000000..4968f4d7f691
--- /dev/null
+++ b/tests/generic/438.out
@@ -0,0 +1,2 @@
+QA output created by 438
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 438c299030f2..d88f5bb44514 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -440,3 +440,4 @@
 435 auto encrypt
 436 auto quick rw
 437 auto quick
+438 auto quick
-- 
2.12.0
