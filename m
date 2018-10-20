Return-Path: <SRS0=ulrH=NA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40478 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbeJUDZx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 Oct 2018 23:25:53 -0400
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: move inode and its interior extent tree block
Date: Sat, 20 Oct 2018 15:14:15 -0400
Message-Id: <20181020191415.24653-2-tytso@mit.edu>
In-Reply-To: <20181020191415.24653-1-tytso@mit.edu>
References: <20181020191415.24653-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a test case for the bug fixed in 4b3038134baf: "resize2fs: update
checksums in the extent tree's relocated block"

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/r_move_inode_int_extent/expect   |  15 +++++++++
 tests/r_move_inode_int_extent/image.gz | Bin 0 -> 20687 bytes
 tests/r_move_inode_int_extent/name     |   1 +
 tests/r_move_inode_int_extent/script   |  42 +++++++++++++++++++++++++
 4 files changed, 58 insertions(+)
 create mode 100644 tests/r_move_inode_int_extent/expect
 create mode 100644 tests/r_move_inode_int_extent/image.gz
 create mode 100644 tests/r_move_inode_int_extent/name
 create mode 100644 tests/r_move_inode_int_extent/script

diff --git a/tests/r_move_inode_int_extent/expect b/tests/r_move_inode_int_extent/expect
new file mode 100644
index 000000000..1de31d075
--- /dev/null
+++ b/tests/r_move_inode_int_extent/expect
@@ -0,0 +1,15 @@
+resize2fs test
+resize2fs test.img 8M
+Resizing the filesystem on test.img to 8192 (1k) blocks.
+The filesystem on test.img is now 8192 (1k) blocks long.
+
+Exit status is 0
+ 
+fsck -yf -E fixes_only -N test_filesys test.img
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 14/2048 files (0.0% non-contiguous), 1445/8192 blocks
+Exit status is 0
diff --git a/tests/r_move_inode_int_extent/image.gz b/tests/r_move_inode_int_extent/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..d5de18f259a033c4223184ac51d6f5f7c3a6d2da
GIT binary patch
literal 20687
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
bufJ7x0g`#WGTxDY1%kiz)v39Qip75i=o3@I

literal 0
Hc-jL100001

diff --git a/tests/r_move_inode_int_extent/name b/tests/r_move_inode_int_extent/name
new file mode 100644
index 000000000..64a55b559
--- /dev/null
+++ b/tests/r_move_inode_int_extent/name
@@ -0,0 +1 @@
+move inode and its interior extent tree block
diff --git a/tests/r_move_inode_int_extent/script b/tests/r_move_inode_int_extent/script
new file mode 100644
index 000000000..9c1a3928c
--- /dev/null
+++ b/tests/r_move_inode_int_extent/script
@@ -0,0 +1,42 @@
+if ! test -x $RESIZE2FS_EXE -o ! -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped (no debugfs/resize2fs)"
+	return 0
+fi
+
+IMAGE=$test_dir/image.gz
+FSCK_OPT="-yf -E fixes_only"
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+gunzip < $IMAGE > $TMPFILE
+
+echo "resize2fs test" > $OUT.new
+
+echo "resize2fs test.img 8M" >> $OUT.new
+$RESIZE2FS $TMPFILE 8M >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+
+echo " " >> $OUT.new
+echo fsck $FSCK_OPT -N test_filesys test.img >> $OUT.new
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+echo Exit status is $status >> $OUT.new
+sed -f $cmd_dir/filter.sed $OUT.new > $OUT
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
-- 
2.18.0.rc0
