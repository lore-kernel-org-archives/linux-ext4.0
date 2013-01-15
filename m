From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] tests: create test for debugfs creating special files
Date: Tue, 15 Jan 2013 14:53:45 -0500
Message-ID: <1358279625-3098-2-git-send-email-tytso@mit.edu>
References: <20130115194330.GF17719@thunk.org>
 <1358279625-3098-1-git-send-email-tytso@mit.edu>
Cc: dvhart@infradead.org, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43570 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3AOTxs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jan 2013 14:53:48 -0500
In-Reply-To: <1358279625-3098-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 tests/d_special_files/expect | 85 +++++++++++++++++++++++++++++++++++++++
 tests/d_special_files/name   |  1 +
 tests/d_special_files/script | 94 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 180 insertions(+)
 create mode 100644 tests/d_special_files/expect
 create mode 100644 tests/d_special_files/name
 create mode 100644 tests/d_special_files/script

diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
new file mode 100644
index 0000000..2b2dbfa
--- /dev/null
+++ b/tests/d_special_files/expect
@@ -0,0 +1,85 @@
+debugfs create special files
+mke2fs -Fq -b 1024 test.img 512
+Exit status is 0
+debugfs -R ''stat foo'' -w test.img
+Inode: 12   Type: symlink    Mode:  0777   Flags: 0x0
+Generation: 0    Version: 0x00000000
+User:     0   Group:     0   Size: 3
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+Fast_link_dest: bar
+Exit status is 0
+debugfs -R ''stat foo2'' -w test.img
+Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
+Generation: 0    Version: 0x00000000
+User:     0   Group:     0   Size: 80
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 2
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+BLOCKS:
+(0):28
+TOTAL: 1
+
+Exit status is 0
+debugfs -R ''block_dump 28'' -w test.img
+0000  3132 3334 3536 3738 3930 3132 3334 3536  1234567890123456
+0020  3738 3930 3132 3334 3536 3738 3930 3132  7890123456789012
+0040  3334 3536 3738 3930 3132 3334 3536 3738  3456789012345678
+0060  3930 3132 3334 3536 3738 3930 3132 3334  9012345678901234
+0100  3536 3738 3930 3132 3334 3536 3738 3930  5678901234567890
+0120  0000 0000 0000 0000 0000 0000 0000 0000  ................
+*
+
+Exit status is 0
+debugfs -R ''stat pipe'' -w test.img
+Inode: 14   Type: FIFO    Mode:  0000   Flags: 0x0
+Generation: 0    Version: 0x00000000
+User:     0   Group:     0   Size: 0
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+BLOCKS:
+
+Exit status is 0
+debugfs -R ''stat sda'' -w test.img
+Inode: 15   Type: block special    Mode:  0000   Flags: 0x0
+Generation: 0    Version: 0x00000000
+User:     0   Group:     0   Size: 0
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+Device major/minor number: 08:00 (hex 08:00)
+Exit status is 0
+debugfs -R ''stat null'' -w test.img
+Inode: 16   Type: character special    Mode:  0000   Flags: 0x0
+Generation: 0    Version: 0x00000000
+User:     0   Group:     0   Size: 0
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 0
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
+Device major/minor number: 01:03 (hex 01:03)
+Exit status is 0
+e2fsck -yf -N test_filesys
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 16/64 files (0.0% non-contiguous), 29/512 blocks
+Exit status is 0
diff --git a/tests/d_special_files/name b/tests/d_special_files/name
new file mode 100644
index 0000000..98d10d2
--- /dev/null
+++ b/tests/d_special_files/name
@@ -0,0 +1 @@
+create special files in debugfs
diff --git a/tests/d_special_files/script b/tests/d_special_files/script
new file mode 100644
index 0000000..85cbb4d
--- /dev/null
+++ b/tests/d_special_files/script
@@ -0,0 +1,94 @@
+if test -x $DEBUGFS_EXE; then
+
+OUT=$test_name.log
+EXP=$test_dir/expect
+VERIFY_FSCK_OPT=-yf
+
+TEST_DATA=$test_name.tmp
+VERIFY_DATA=$test_name.ver.tmp
+
+echo "debugfs create special files" > $OUT
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo "mke2fs -Fq -b 1024 test.img 512" >> $OUT
+
+$MKE2FS -Fq $TMPFILE 512 > /dev/null 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+$DEBUGFS -w $TMPFILE << EOF > /dev/null 2>&1
+set_current_time 201301151400
+set_super_value lastcheck 0
+set_super_value hash_seed null
+set_super_value mkfs_time 0
+symlink foo bar
+symlink foo2 12345678901234567890123456789012345678901234567890123456789012345678901234567890
+mknod pipe p
+mknod sda b 8 0
+mknod null c 1 3
+EOF
+
+echo "debugfs -R ''stat foo'' -w test.img" > $OUT.new
+$DEBUGFS -R "stat foo" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo "debugfs -R ''stat foo2'' -w test.img" > $OUT.new
+$DEBUGFS -R "stat foo2" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo "debugfs -R ''block_dump 28'' -w test.img" > $OUT.new
+$DEBUGFS -R "block_dump 28" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo "debugfs -R ''stat pipe'' -w test.img" > $OUT.new
+$DEBUGFS -R "stat pipe" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo "debugfs -R ''stat sda'' -w test.img" > $OUT.new
+$DEBUGFS -R "stat sda" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo "debugfs -R ''stat null'' -w test.img" > $OUT.new
+$DEBUGFS -R "stat null" -w $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+echo e2fsck $VERIFY_FSCK_OPT -N test_filesys > $OUT.new
+$FSCK $VERIFY_FSCK_OPT -N test_filesys $TMPFILE >> $OUT.new 2>&1
+status=$?
+echo Exit status is $status >> $OUT.new
+sed -e '2d' $OUT.new >> $OUT
+
+#
+# Do the verification
+#
+
+rm -f $TMPFILE $OUT.new
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
+unset VERIFY_FSCK_OPT NATIVE_FSCK_OPT OUT EXP TEST_DATA VERIFY_DATA
+
+else #if test -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi 
-- 
1.7.12.rc0.22.gcdd159b

