From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] tests: regression test for resizing inodes on a
 metadata_csum fs
Date: Wed, 12 Nov 2014 14:47:53 -0800
Message-ID: <20141112224753.GJ10043@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37450 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaKLWsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2014 17:48:03 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Regression test for a problem inadvertently fixed by the patchset
"e2fsprogs/tune2fs: fix memory leak in inode_scan_and_fix()" by Xiaoguang Wang.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/t_iexpand_full/expect |   38 +++++++++++++++++++++
 tests/t_iexpand_full/name   |    1 +
 tests/t_iexpand_full/script |   79 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 tests/t_iexpand_full/expect
 create mode 100644 tests/t_iexpand_full/name
 create mode 100644 tests/t_iexpand_full/script

diff --git a/tests/t_iexpand_full/expect b/tests/t_iexpand_full/expect
new file mode 100644
index 0000000..3eb1715
--- /dev/null
+++ b/tests/t_iexpand_full/expect
@@ -0,0 +1,38 @@
+tune2fs test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 6368 huge file(s) with 117 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -I 256 test.img
+Setting inode size 256
+Exit status is 0
+Change in FS metadata:
+@@ -13 +13 @@
+-Free blocks:              12301
++Free blocks:              12
+@@ -22 +22 @@
+-Inode blocks per group:   128
++Inode blocks per group:   256
+@@ -28 +28 @@
+-Inode size:	          128
++Inode size:	          256
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_iexpand_full/name b/tests/t_iexpand_full/name
new file mode 100644
index 0000000..2241b34
--- /dev/null
+++ b/tests/t_iexpand_full/name
@@ -0,0 +1 @@
+expand inodes on a totally full filesystem
diff --git a/tests/t_iexpand_full/script b/tests/t_iexpand_full/script
new file mode 100644
index 0000000..9e34090
--- /dev/null
+++ b/tests/t_iexpand_full/script
@@ -0,0 +1,79 @@
+if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+#gzip -d < $EXP.gz > $EXP
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,^resize_inode,^meta_bg,^flex_bg,metadata_csum,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 12000K
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 117K
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -I 128 $TMPFILE 786432 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.before 2> /dev/null
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# convert it
+echo "tune2fs -I 256 test.img" >> $OUT
+dd if=/dev/zero of=$TMPFILE conv=notrunc bs=1 count=1 seek=3221225471 2> /dev/null
+$TUNE2FS -I 256 $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+($DUMPE2FS -h $TMPFILE; $DUMPE2FS -g $TMPFILE) 2>&1 | sed -f $cmd_dir/filter.sed -e '/^Checksum:.*/d' >> $OUT.after 2> /dev/null
+echo "Change in FS metadata:" >> $OUT
+diff -u0 $OUT.before $OUT.after | sed -e '/^---.*/d' -e '/^+++.*/d' >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+#
+# Do the verification
+#
+
+sed -f $cmd_dir/filter.sed -e "s;$TMPFILE;test.img;" -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
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
+rm $OUT.before $OUT.after
+
+unset IMAGE FSCK_OPT OUT EXP CONF
+
+else #if test -x $RESIZE2FS_EXE -a -x $DEBUGFS_EXE; then
+	echo "$test_name: $test_description: skipped"
+fi
+
