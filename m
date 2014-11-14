From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH 1/4] tests: regression test for resizing inodes on a metadata_csum fs
Date: Fri, 14 Nov 2014 17:58:27 +0800
Message-ID: <1415959107-14267-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964989AbaKNKBT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2014 05:01:19 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When using tune2fs to resize inodes,  there is a bug that we do not
update the block group descriptor and inode checksum, this test is
written to check whether this bug has been fixed.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 tests/t_iexpand_csum/expect | 21 ++++++++++++++++
 tests/t_iexpand_csum/name   |  1 +
 tests/t_iexpand_csum/script | 59 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)
 create mode 100644 tests/t_iexpand_csum/expect
 create mode 100644 tests/t_iexpand_csum/name
 create mode 100644 tests/t_iexpand_csum/script

diff --git a/tests/t_iexpand_csum/expect b/tests/t_iexpand_csum/expect
new file mode 100644
index 0000000..9cba9dc
--- /dev/null
+++ b/tests/t_iexpand_csum/expect
@@ -0,0 +1,21 @@
+tune2fs -I test
+Creating filesystem with 786432 1k blocks and 98304 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409, 663553
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Writing superblocks and filesystem accounting information:      done
+
+Exit status is 0
+tune2fs -I 256 test.img
+Setting inode size 256
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_iexpand_csum/name b/tests/t_iexpand_csum/name
new file mode 100644
index 0000000..8ac8be3
--- /dev/null
+++ b/tests/t_iexpand_csum/name
@@ -0,0 +1 @@
+expand inodes on a metadata_csum filesystem
diff --git a/tests/t_iexpand_csum/script b/tests/t_iexpand_csum/script
new file mode 100644
index 0000000..a7c6390
--- /dev/null
+++ b/tests/t_iexpand_csum/script
@@ -0,0 +1,59 @@
+if test -x $TUNE2FS -a -x $FSCK; then
+
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,^flex_bg,metadata_csum,64bit
+		blocksize = 1024
+	}
+ENDL
+
+echo "tune2fs -I test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h -I 128 $TMPFILE 786432 >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+rm -rf $CONF
+
+# expand inode size to 256
+echo "tune2fs -I 256 test.img" >> $OUT
+$TUNE2FS -I 256 $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+sed -f $cmd_dir/filter.sed < $OUT > $OUT.new
+mv $OUT.new $OUT
+
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE
+
+sed -f $cmd_dir/filter.sed  -e 's/test_filesys:.*//g' < $OUT > $OUT.new
+mv $OUT.new $OUT
+
+#
+# Do the verification
+#
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
+unset FSCK_OPT OUT EXP CONF
+
+else
+	echo "$test_name: $test_description: skipped"
+fi
-- 
1.8.3.1

