From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/4] tests: add test for resize2fs -M with inode table in middle of block group
Date: Mon, 30 Sep 2013 23:59:34 -0400
Message-ID: <1380599974-2886-4-git-send-email-tytso@mit.edu>
References: <20131001015746.GF5845@thunk.org>
 <1380599974-2886-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40495 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab3JAD7m (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 Sep 2013 23:59:42 -0400
In-Reply-To: <1380599974-2886-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen reported that Fedora's mke2fs when compiled for ppc was
creating a file system which caused problems with resize2fs -M.
Closer examination showed that the problem was file system which
looked like this:

Filesystem features:      ext_attr dir_index filetype sparse_super
Inode count:              512
Block count:              1247
   ...

Group 0: (Blocks 1-1024)
  Primary superblock at 1, Group descriptors at 2-2
  Block bitmap at 66 (+65), Inode bitmap at 67 (+66)
  Inode table at 68-99 (+67)

Group 1: (Blocks 1025-1246)
  Backup superblock at 1025, Group descriptors at 1026-1026
  Block bitmap at 1090 (+65), Inode bitmap at 1091 (+66)
  Inode table at 1092-1123 (+67)

It's not obvious to me why Fedora's ppc mke2fs is creating file
systems like this (I can't reproduce this on debian ppc systems), but
resize2fs -M should be able to deal with such file systems, which is
what this test is designed to check.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/r_min_itable/expect   |  14 ++++++++++++++
 tests/r_min_itable/image.gz | Bin 0 -> 3597 bytes
 tests/r_min_itable/name     |   1 +
 tests/r_min_itable/script   |  43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+)
 create mode 100644 tests/r_min_itable/expect
 create mode 100644 tests/r_min_itable/image.gz
 create mode 100644 tests/r_min_itable/name
 create mode 100644 tests/r_min_itable/script

diff --git a/tests/r_min_itable/expect b/tests/r_min_itable/expect
new file mode 100644
index 0000000..104688a
--- /dev/null
+++ b/tests/r_min_itable/expect
@@ -0,0 +1,14 @@
+resize2fs test
+resize2fs -M test.img
+Resizing the filesystem on test.img to 1124 (1k) blocks.
+The filesystem on test.img is now 1124 blocks long.
+
+Exit status is 0
+e2fsck 1.42.8 (20-Jun-2013)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 13/512 files (0.0% non-contiguous), 1120/1124 blocks
+Exit status is 0
diff --git a/tests/r_min_itable/image.gz b/tests/r_min_itable/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..7c40c5661c86c8fc81e5c73b2adfe1658666df2c
GIT binary patch
literal 3597
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

literal 0
Hc-jL100001

diff --git a/tests/r_min_itable/name b/tests/r_min_itable/name
new file mode 100644
index 0000000..841b043
--- /dev/null
+++ b/tests/r_min_itable/name
@@ -0,0 +1 @@
+resize2fs -M with inode table in middle of last block group
diff --git a/tests/r_min_itable/script b/tests/r_min_itable/script
new file mode 100644
index 0000000..00aaa60
--- /dev/null
+++ b/tests/r_min_itable/script
@@ -0,0 +1,43 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+IMAGE=$test_dir/image.gz
+FSCK_OPT=-yf
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $IMAGE > $TMPFILE
+
+echo "resize2fs test" > $OUT
+
+echo "resize2fs -M test.img" >> $OUT
+$RESIZE2FS -M $TMPFILE 2>&1 >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" $OUT.new >> $OUT
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1 
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.new
+
+#
+# Do the verification
+#
+
+cmp -s $OUT $EXP
+status=$?
+
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset IMAGE FSCK_OPT OUT EXP
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
-- 
1.7.12.rc0.22.gcdd159b

