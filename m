From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 3/4] e2fsprogs: add tests for project quota
Date: Fri, 13 Mar 2015 19:00:10 +0300
Message-ID: <20150313160010.14281.45379.stgit@buzz>
References: <20150313155012.14281.80292.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:53563 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560AbbCMQAQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Mar 2015 12:00:16 -0400
In-Reply-To: <20150313155012.14281.80292.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

t_project_1on: enable project quota by resize2fs/tune2fs
t_project_2off disable project quota by tune2fs

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 tests/m_project/expect.1    |  156 +++++++++++++++++++++++++++++++++++++++++++
 tests/m_project/script      |    7 ++
 tests/t_project_1on/expect  |   66 ++++++++++++++++++
 tests/t_project_1on/name    |    1 
 tests/t_project_1on/script  |   68 +++++++++++++++++++
 tests/t_project_2off/expect |   78 ++++++++++++++++++++++
 tests/t_project_2off/name   |    1 
 tests/t_project_2off/script |   54 +++++++++++++++
 8 files changed, 431 insertions(+)
 create mode 100644 tests/m_project/expect.1
 create mode 100644 tests/m_project/script
 create mode 100644 tests/t_project_1on/expect
 create mode 100644 tests/t_project_1on/name
 create mode 100644 tests/t_project_1on/script
 create mode 100644 tests/t_project_2off/expect
 create mode 100644 tests/t_project_2off/name
 create mode 100644 tests/t_project_2off/script

diff --git a/tests/m_project/expect.1 b/tests/m_project/expect.1
new file mode 100644
index 000000000000..e8140f5cc963
--- /dev/null
+++ b/tests/m_project/expect.1
@@ -0,0 +1,156 @@
+Creating filesystem with 131072 1k blocks and 32768 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Writing superblocks and filesystem accounting information:      done
+
+Filesystem features: ext_attr resize_inode dir_index filetype sparse_super quota project
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 21/32768 files (4.8% non-contiguous), 5697/131072 blocks
+Exit status is 0
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super quota project
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              125375
+Free inodes:              32747
+First block:              1
+Block size:               1024
+Fragment size:            1024
+Reserved GDT blocks:      256
+Blocks per group:         8192
+Fragments per group:      8192
+Inodes per group:         2048
+Inode blocks per group:   256
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              21
+Inode size:	          128
+Default directory hash:   half_md4
+Project quota inode:      11
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7656 free blocks, 2027 free inodes, 2 directories
+  Free blocks: 537-8192
+  Free inodes: 22-2048
+Group 1: (Blocks 8193-16384)
+  Backup superblock at 8193, Group descriptors at 8194-8194
+  Reserved GDT blocks at 8195-8450
+  Block bitmap at 8451 (+258), Inode bitmap at 8452 (+259)
+  Inode table at 8453-8708 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 8709-16384
+  Free inodes: 2049-4096
+Group 2: (Blocks 16385-24576)
+  Block bitmap at 16385 (+0), Inode bitmap at 16386 (+1)
+  Inode table at 16387-16642 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 16643-24576
+  Free inodes: 4097-6144
+Group 3: (Blocks 24577-32768)
+  Backup superblock at 24577, Group descriptors at 24578-24578
+  Reserved GDT blocks at 24579-24834
+  Block bitmap at 24835 (+258), Inode bitmap at 24836 (+259)
+  Inode table at 24837-25092 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 25093-32768
+  Free inodes: 6145-8192
+Group 4: (Blocks 32769-40960)
+  Block bitmap at 32769 (+0), Inode bitmap at 32770 (+1)
+  Inode table at 32771-33026 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 33027-40960
+  Free inodes: 8193-10240
+Group 5: (Blocks 40961-49152)
+  Backup superblock at 40961, Group descriptors at 40962-40962
+  Reserved GDT blocks at 40963-41218
+  Block bitmap at 41219 (+258), Inode bitmap at 41220 (+259)
+  Inode table at 41221-41476 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 41477-49152
+  Free inodes: 10241-12288
+Group 6: (Blocks 49153-57344)
+  Block bitmap at 49153 (+0), Inode bitmap at 49154 (+1)
+  Inode table at 49155-49410 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 49411-57344
+  Free inodes: 12289-14336
+Group 7: (Blocks 57345-65536)
+  Backup superblock at 57345, Group descriptors at 57346-57346
+  Reserved GDT blocks at 57347-57602
+  Block bitmap at 57603 (+258), Inode bitmap at 57604 (+259)
+  Inode table at 57605-57860 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 57861-65536
+  Free inodes: 14337-16384
+Group 8: (Blocks 65537-73728)
+  Block bitmap at 65537 (+0), Inode bitmap at 65538 (+1)
+  Inode table at 65539-65794 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 65795-73728
+  Free inodes: 16385-18432
+Group 9: (Blocks 73729-81920)
+  Backup superblock at 73729, Group descriptors at 73730-73730
+  Reserved GDT blocks at 73731-73986
+  Block bitmap at 73987 (+258), Inode bitmap at 73988 (+259)
+  Inode table at 73989-74244 (+260)
+  7676 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 74245-81920
+  Free inodes: 18433-20480
+Group 10: (Blocks 81921-90112)
+  Block bitmap at 81921 (+0), Inode bitmap at 81922 (+1)
+  Inode table at 81923-82178 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 82179-90112
+  Free inodes: 20481-22528
+Group 11: (Blocks 90113-98304)
+  Block bitmap at 90113 (+0), Inode bitmap at 90114 (+1)
+  Inode table at 90115-90370 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 90371-98304
+  Free inodes: 22529-24576
+Group 12: (Blocks 98305-106496)
+  Block bitmap at 98305 (+0), Inode bitmap at 98306 (+1)
+  Inode table at 98307-98562 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 98563-106496
+  Free inodes: 24577-26624
+Group 13: (Blocks 106497-114688)
+  Block bitmap at 106497 (+0), Inode bitmap at 106498 (+1)
+  Inode table at 106499-106754 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 106755-114688
+  Free inodes: 26625-28672
+Group 14: (Blocks 114689-122880)
+  Block bitmap at 114689 (+0), Inode bitmap at 114690 (+1)
+  Inode table at 114691-114946 (+2)
+  7934 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 114947-122880
+  Free inodes: 28673-30720
+Group 15: (Blocks 122881-131071)
+  Block bitmap at 122881 (+0), Inode bitmap at 122882 (+1)
+  Inode table at 122883-123138 (+2)
+  7933 free blocks, 2048 free inodes, 0 directories
+  Free blocks: 123139-131071
+  Free inodes: 30721-32768
diff --git a/tests/m_project/script b/tests/m_project/script
new file mode 100644
index 000000000000..a420ae523c6b
--- /dev/null
+++ b/tests/m_project/script
@@ -0,0 +1,7 @@
+DESCRIPTION="enable project feature on mkfs"
+FS_SIZE=131072
+MKE2FS_OPTS="-O project"
+DUMPE2FS_IGNORE_80COL=1
+export DUMPE2FS_IGNORE_80COL
+. $cmd_dir/run_mke2fs
+unset DUMPE2FS_IGNORE_80COL
diff --git a/tests/t_project_1on/expect b/tests/t_project_1on/expect
new file mode 100644
index 000000000000..adf4aa023b6b
--- /dev/null
+++ b/tests/t_project_1on/expect
@@ -0,0 +1,66 @@
+Exit status is 0
+debugfs
+debugfs: write test.img.2 file1
+Allocated inode: 12
+Exit status is 0
+resize2fs -I 21
+Reserving special inodes.
+The filesystem on test.img is now 10000 (4k) blocks long.
+
+Exit status is 0
+tune2fs -O project
+Exit status is 0
+fsck
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test.img: 22/10016 files (0.0% non-contiguous), 584/10000 blocks
+Exit status is 0
+debugfs list_quota project
+ project     blocks    quota    limit      inodes    quota    limit
+       0    1073152        0        0           3        0        0
+Exit status is 0
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super large_file quota project
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              10016
+Block count:              10000
+Reserved block count:     500
+Free blocks:              9416
+Free inodes:              9994
+First block:              0
+Block size:               4096
+Fragment size:            4096
+Reserved GDT blocks:      2
+Blocks per group:         32768
+Fragments per group:      32768
+Inodes per group:         10016
+Inode blocks per group:   313
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              21
+Inode size:	          128
+Default directory hash:   half_md4
+Project quota inode:      11
+
+
+Group 0: (Blocks 0-9999)
+  Primary superblock at 0, Group descriptors at 1-1
+  Reserved GDT blocks at 2-3
+  Block bitmap at 4 (+4)
+  Inode bitmap at 5 (+5)
+  Inode table at 6-318 (+6)
+  9416 free blocks, 9994 free inodes, 2 directories
+  Free blocks: 584-9999
+  Free inodes: 23-10016
+Exit status is 0
diff --git a/tests/t_project_1on/name b/tests/t_project_1on/name
new file mode 100644
index 000000000000..e9113aa7d10f
--- /dev/null
+++ b/tests/t_project_1on/name
@@ -0,0 +1 @@
+enable project quota using tune2fs
diff --git a/tests/t_project_1on/script b/tests/t_project_1on/script
new file mode 100644
index 000000000000..798e67c39b71
--- /dev/null
+++ b/tests/t_project_1on/script
@@ -0,0 +1,68 @@
+FSCK_OPT=-yf
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+echo "mke2fs" >> $OUT
+$MKE2FS -q -F -o Linux -b 4096 $TMPFILE 10000 > $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+dd if=/dev/zero of=$TMPFILE.2 bs=1048576 count=1 > /dev/null 2>&1
+echo "debugfs" >> $OUT
+cat <<- EOF | $DEBUGFS -w -f /dev/stdin $TMPFILE >> $OUT 2>&1
+	write $TMPFILE.2 file1
+EOF
+status=$?
+echo Exit status is $status >> $OUT
+rm -f $TMPFILE.2
+
+echo "resize2fs -I 21" >> $OUT
+$RESIZE2FS -I 21 $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "tune2fs -O project" >> $OUT
+$TUNE2FS -O project $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "fsck" >> $OUT
+$FSCK $FSCK_OPT $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "debugfs list_quota project" >> $OUT
+$DEBUGFS $TMPFILE -R "list_quota project" >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm -f $TMPFILE
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
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset FSCK_OPT OUT EXP
+
diff --git a/tests/t_project_2off/expect b/tests/t_project_2off/expect
new file mode 100644
index 000000000000..6606b305a097
--- /dev/null
+++ b/tests/t_project_2off/expect
@@ -0,0 +1,78 @@
+Exit status is 0
+debugfs set_inode_field / project 1
+debugfs: set_inode_field / project 1
+Exit status is 0
+tune2fs -O ^project
+
+Please run e2fsck on the filesystem.
+
+Exit status is 0
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+i_faddr for inode 2 (/) is 1, should be zero.
+Clear? yes
+
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test.img: ***** FILE SYSTEM WAS MODIFIED *****
+
+          21 inodes used (32.81%, out of 64)
+           0 non-contiguous files (0.0%)
+           0 non-contiguous directories (0.0%)
+             # of inodes with ind/dind/tind blocks: 0/0/0
+          12 blocks used (12.00%, out of 100)
+           0 bad blocks
+           1 large file
+
+           0 regular files
+           2 directories
+           0 character device files
+           0 block device files
+           0 fifos
+           0 links
+           0 symbolic links (0 fast symbolic links)
+           0 sockets
+------------
+           2 files
+Exit status is 1
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super large_file
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              64
+Block count:              100
+Reserved block count:     5
+Free blocks:              88
+Free inodes:              43
+First block:              0
+Block size:               4096
+Fragment size:            4096
+Blocks per group:         32768
+Fragments per group:      32768
+Inodes per group:         64
+Inode blocks per group:   2
+Mount count:              0
+Check interval:           15552000 (6 months)
+Reserved blocks uid:      0
+Reserved blocks gid:      0
+First inode:              21
+Inode size:	          128
+Default directory hash:   half_md4
+
+
+Group 0: (Blocks 0-99)
+  Primary superblock at 0, Group descriptors at 1-1
+  Block bitmap at 2 (+2)
+  Inode bitmap at 3 (+3)
+  Inode table at 4-5 (+4)
+  88 free blocks, 43 free inodes, 2 directories
+  Free blocks: 12-99
+  Free inodes: 22-64
+Exit status is 0
diff --git a/tests/t_project_2off/name b/tests/t_project_2off/name
new file mode 100644
index 000000000000..b7e9993d6ddc
--- /dev/null
+++ b/tests/t_project_2off/name
@@ -0,0 +1 @@
+disable project quota using tune2fs
diff --git a/tests/t_project_2off/script b/tests/t_project_2off/script
new file mode 100644
index 000000000000..2a36643260e2
--- /dev/null
+++ b/tests/t_project_2off/script
@@ -0,0 +1,54 @@
+FSCK_OPT=-yf
+OUT=$test_name.log
+EXP=$test_dir/expect
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+echo "mke2fs -O project" >> $OUT
+$MKE2FS -q -F -o Linux -b 4096 -O project $TMPFILE 100 > $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "debugfs set_inode_field / project 1" >> $OUT
+cat <<- EOF | $DEBUGFS -w -f /dev/stdin $TMPFILE >> $OUT 2>&1
+	set_inode_field / project 1
+EOF
+status=$?
+echo Exit status is $status >> $OUT
+
+echo "tune2fs -O ^project" >> $OUT
+$TUNE2FS -O ^project $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+$FSCK $FSCK_OPT -v $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+$DUMPE2FS $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm -f $TMPFILE
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
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "$test_name: $test_description: failed"
+	diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+fi
+
+unset FSCK_OPT OUT EXP

