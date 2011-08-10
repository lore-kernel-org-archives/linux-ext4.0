From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 2/2] e2fsck: regression tests for INCOMPAT_MMP feature
Date: Wed, 10 Aug 2011 15:48:15 -0600
Message-ID: <1313012895-31185-2-git-send-email-adilger@whamcloud.com>
References: <1313012895-31185-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:37599 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1HJVsW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 17:48:22 -0400
In-Reply-To: <1313012895-31185-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add tests for the MMP feature - creating a filesystem with mke2fs and
MMP enabled, enable/disable MMP with tune2fs, disabling the e2fsck MMP
flag with tune2fs after a failed e2fsck, and e2fsck checking and fixing
a corrupt MMP block.

The MMP tests need to be run from a real disk, not tmpfs, because tmpfs
doesn't support O_DIRECT reads, which MMP uses to ensure that reads from
the MMP block are not filled from the page cache.  Using a local disk
does not slow down the tests noticably, since they wait to detect if
the MMP block is being modified.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 tests/f_mmp/expect.1         |   79 ++++++++++++++++++++++++++++++++++++++++++
 tests/f_mmp/script           |   15 ++++++++
 tests/f_mmp_1on/name         |    1 +
 tests/f_mmp_1on/script       |   40 +++++++++++++++++++++
 tests/f_mmp_2off/name        |    1 +
 tests/f_mmp_2off/script      |   40 +++++++++++++++++++++
 tests/f_mmp_e2fsck/name      |    1 +
 tests/f_mmp_e2fsck/script    |   67 +++++++++++++++++++++++++++++++++++
 tests/f_mmp_garbage/expect.1 |    9 +++++
 tests/f_mmp_garbage/expect.2 |    7 ++++
 tests/f_mmp_garbage/name     |    1 +
 tests/f_mmp_garbage/script   |   28 +++++++++++++++
 12 files changed, 289 insertions(+), 0 deletions(-)
 create mode 100644 tests/f_mmp/expect.1
 create mode 100644 tests/f_mmp/script
 create mode 100644 tests/f_mmp_1on/name
 create mode 100644 tests/f_mmp_1on/script
 create mode 100644 tests/f_mmp_2off/name
 create mode 100644 tests/f_mmp_2off/script
 create mode 100644 tests/f_mmp_e2fsck/name
 create mode 100644 tests/f_mmp_e2fsck/script
 create mode 100644 tests/f_mmp_garbage/expect.1
 create mode 100644 tests/f_mmp_garbage/expect.2
 create mode 100644 tests/f_mmp_garbage/name
 create mode 100644 tests/f_mmp_garbage/script

diff --git a/tests/f_mmp/expect.1 b/tests/f_mmp/expect.1
new file mode 100644
index 0000000..3a00815
--- /dev/null
+++ b/tests/f_mmp/expect.1
@@ -0,0 +1,79 @@
+Filesystem label=
+OS type: Linux
+Block size=2048 (log=1)
+Fragment size=2048 (log=1)
+Stride=0 blocks, Stripe width=0 blocks
+16384 inodes, 32768 blocks
+1638 blocks (5.00%) reserved for the super user
+First data block=0
+Maximum filesystem blocks=33554432
+2 block groups
+16384 blocks per group, 16384 fragments per group
+8192 inodes per group
+Superblock backups stored on blocks: 
+	16384
+
+Allocating group tables: 0/21/2   done                            
+Writing inode tables: 0/21/2   done                            
+Multiple mount protection is enabled with update interval 5 seconds.
+Writing superblocks and filesystem accounting information: 0/21/2   done
+
+Filesystem features: ext_attr resize_inode dir_index filetype mmp sparse_super
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16384 files (0.0% non-contiguous), 1105/32768 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype mmp sparse_super
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              16384
+Block count:              32768
+Reserved block count:     1638
+Free blocks:              31663
+Free inodes:              16373
+First block:              0
+Block size:               2048
+Fragment size:            2048
+Reserved GDT blocks:      31
+Blocks per group:         16384
+Fragments per group:      16384
+Inodes per group:         8192
+Inode blocks per group:   512
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              11
+Inode size:	          128
+Default directory hash:   half_md4
+MMP block number:         557
+MMP update interval:      5
+
+
+Group 0: (Blocks 0-16383)
+  Primary superblock at 0, Group descriptors at 1-1
+  Reserved GDT blocks at 2-32
+  Block bitmap at 33 (+33), Inode bitmap at 34 (+34)
+  Inode table at 35-546 (+35)
+  15826 free blocks, 8181 free inodes, 2 directories
+  Free blocks: 558-16383
+  Free inodes: 12-8192
+Group 1: (Blocks 16384-32767)
+  Backup superblock at 16384, Group descriptors at 16385-16385
+  Reserved GDT blocks at 16386-16416
+  Block bitmap at 16417 (+33), Inode bitmap at 16418 (+34)
+  Inode table at 16419-16930 (+35)
+  15837 free blocks, 8192 free inodes, 0 directories
+  Free blocks: 16931-32767
+  Free inodes: 8193-16384
diff --git a/tests/f_mmp/script b/tests/f_mmp/script
new file mode 100644
index 0000000..1547463
--- /dev/null
+++ b/tests/f_mmp/script
@@ -0,0 +1,15 @@
+DESCRIPTION="enable MMP during mke2fs"
+FS_SIZE=65536
+MKE2FS_DEVICE_SECTSIZE=2048
+export MKE2FS_DEVICE_SECTSIZE
+TMPFILE=test.img
+> $TMPFILE
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? == 0 ]; then
+	rm -f $TMPFILE
+	echo "skipped for tmpfs (no O_DIRECT support)"
+	return 0
+fi
+MKE2FS_OPTS="-O mmp"
+. $cmd_dir/run_mke2fs
+unset MKE2FS_DEVICE_SECTSIZE
diff --git a/tests/f_mmp_1on/name b/tests/f_mmp_1on/name
new file mode 100644
index 0000000..62e16b2
--- /dev/null
+++ b/tests/f_mmp_1on/name
@@ -0,0 +1 @@
+enable MMP using tune2fs
diff --git a/tests/f_mmp_1on/script b/tests/f_mmp_1on/script
new file mode 100644
index 0000000..ee9884f
--- /dev/null
+++ b/tests/f_mmp_1on/script
@@ -0,0 +1,40 @@
+FSCK_OPT=-yf
+
+TMPFILE=test.img
+rm -f $test_name.failed $test_name.ok
+> $TMPFILE
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? == 0 ] ; then
+	rm -f $TMPFILE
+	echo "skipped for tmpfs (no O_DIRECT support)"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 1024 $TMPFILE 100 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+$TUNE2FS -O mmp -E mmp_update_interval=1 $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O mmp failed with $status" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with MMP enabled failed with $status" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+rm -f $TMPFILE
diff --git a/tests/f_mmp_2off/name b/tests/f_mmp_2off/name
new file mode 100644
index 0000000..d7cac51
--- /dev/null
+++ b/tests/f_mmp_2off/name
@@ -0,0 +1 @@
+disable MMP using tune2fs
diff --git a/tests/f_mmp_2off/script b/tests/f_mmp_2off/script
new file mode 100644
index 0000000..ec9f71e
--- /dev/null
+++ b/tests/f_mmp_2off/script
@@ -0,0 +1,40 @@
+FSCK_OPT=-yf
+
+TMPFILE=test.img
+rm -f $test_name.failed $test_name.ok
+> $TMPFILE
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? == 0 ]; then
+	rm -f $TMPFILE
+	echo "skipped for tmpfs (no O_DIRECT support)"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 1024 -O mmp $TMPFILE 100 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O mmp failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+$TUNE2FS -O ^mmp $TMPFILE > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O ^mmp failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE > $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "ok"
+	touch $test_name.ok
+else
+	echo "e2fsck after MMP disable failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+rm -f $TMPFILE
diff --git a/tests/f_mmp_e2fsck/name b/tests/f_mmp_e2fsck/name
new file mode 100644
index 0000000..20d66d6
--- /dev/null
+++ b/tests/f_mmp_e2fsck/name
@@ -0,0 +1 @@
+disable MMP with tune2fs after e2fsck killed
diff --git a/tests/f_mmp_e2fsck/script b/tests/f_mmp_e2fsck/script
new file mode 100644
index 0000000..548734a
--- /dev/null
+++ b/tests/f_mmp_e2fsck/script
@@ -0,0 +1,67 @@
+FSCK_OPT=-yf
+
+TMPFILE=test.img
+rm -f $test_name.failed $test_name.ok
+> $TMPFILE
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? == 0 ]; then
+	rm -f $TMPFILE
+	echo "skipped for tmpfs (no O_DIRECT support)"
+	return 0
+fi
+
+echo "make the test image ..." > $test_name.log
+$MKE2FS -q -F -o Linux -b 1024 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O mmp failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+# this will cause debugfs to create the $test_name.mark file once it has
+# passed the MMP startup, then continue reading input until it is killed
+MARKFILE=$test_name.new
+rm -f $MARKFILE
+echo "set mmp sequence to EXT2_MMP_SEQ_FSCK..." >> $test_name.log
+( { echo dump_mmp; echo "dump_inode <2> $MARKFILE"; cat /dev/zero; } |
+	$DEBUGFS -w $TMPFILE >> $test_name.log 2>&1 & ) > /dev/null 2>&1 &
+echo "wait until debugfs has started ..." >> $test_name.log
+while [ ! -e $MARKFILE ]; do
+	sleep 1
+done
+rm -f $MARKFILE
+echo "kill debugfs abruptly (simulates e2fsck failure) ..." >> $test_name.log
+killall -9 debugfs >> $test_name.log
+
+
+echo "e2fsck (should fail mmp_seq = EXT2_MMP_SEQ_FSCK) ..." >> $test_name.log
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" == 0 ] ; then
+	echo "e2fsck with MMP as EXT2_MMP_SEQ_FSCK ran!" > $test_name.failed
+	echo "failed"
+	return 1
+fi
+
+echo "clear mmp_seq with tune2fs ..." >> $test_name.log
+$TUNE2FS -f -E clear_mmp $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs clearing EXT2_MMP_SEQ_FSCK failed" > $test_name.failed
+	echo "failed"
+	return 1
+fi
+
+echo "run e2fsck again (should pass with clean mmp_seq) ..." >> $test_name.log
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "e2fsck after clearing EXT2_MMP_SEQ_FSCK failed"> $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+echo "ok"
+rm -f $TMPFILE
diff --git a/tests/f_mmp_garbage/expect.1 b/tests/f_mmp_garbage/expect.1
new file mode 100644
index 0000000..4ee5cfb
--- /dev/null
+++ b/tests/f_mmp_garbage/expect.1
@@ -0,0 +1,9 @@
+Superblock has invalid MMP magic.  Fix? yes
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16 files (0.0% non-contiguous), 22/100 blocks
+Exit status is 0
diff --git a/tests/f_mmp_garbage/expect.2 b/tests/f_mmp_garbage/expect.2
new file mode 100644
index 0000000..3bf3869
--- /dev/null
+++ b/tests/f_mmp_garbage/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/16 files (0.0% non-contiguous), 22/100 blocks
+Exit status is 0
diff --git a/tests/f_mmp_garbage/name b/tests/f_mmp_garbage/name
new file mode 100644
index 0000000..17e0b14
--- /dev/null
+++ b/tests/f_mmp_garbage/name
@@ -0,0 +1 @@
+repair MMP when it is corrupted
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
new file mode 100644
index 0000000..3c80032
--- /dev/null
+++ b/tests/f_mmp_garbage/script
@@ -0,0 +1,28 @@
+FSCK_OPT=-yf
+
+TMPFILE=test.img
+rm -f $test_name.failed $test_name.ok
+> $TMPFILE
+
+stat -f $TMPFILE | grep -q "Type: tmpfs"
+if [ $? == 0 ] ; then
+	rm -f $TMPFILE
+	echo "skipped for tmpfs (no O_DIRECT support)"
+	return 0
+fi
+
+echo "make the test image ..." > $test_name.log
+$MKE2FS -q -F -o Linux -b 1024 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O mmp failed" > $test_name.failed
+	echo "failed"
+	return $status
+fi
+
+# create a corrupted image
+echo "modify the mmp sequence ..." >> $test_name.log
+$DEBUGFS -w -R "set_mmp_value magic 0x12345678" $TMPFILE >> $test_name.log 2>&1
+
+SKIP_GUNZIP=true
+. $cmd_dir/run_e2fsck
-- 
1.7.3.4

