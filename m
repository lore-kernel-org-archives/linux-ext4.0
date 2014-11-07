From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/47] tests: testcases for enabling/disabling metadata_csum
 via tune2fs
Date: Fri, 07 Nov 2014 13:53:10 -0800
Message-ID: <20141107215310.883.69338.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45825 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaKGVxO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:53:14 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/filter.sed                       |    1 
 tests/j_ext_dumpe2fs/expect            |    1 
 tests/t_disable_mcsum/expect           |   45 +++++++++++++++
 tests/t_disable_mcsum/name             |    1 
 tests/t_disable_mcsum/script           |   67 ++++++++++++++++++++++
 tests/t_disable_mcsum_noinitbg/expect  |   68 ++++++++++++++++++++++
 tests/t_disable_mcsum_noinitbg/name    |    1 
 tests/t_disable_mcsum_noinitbg/script  |   67 ++++++++++++++++++++++
 tests/t_disable_mcsum_yesinitbg/expect |   45 +++++++++++++++
 tests/t_disable_mcsum_yesinitbg/name   |    1 
 tests/t_disable_mcsum_yesinitbg/script |   67 ++++++++++++++++++++++
 tests/t_enable_mcsum/expect            |   78 +++++++++++++++++++++++++
 tests/t_enable_mcsum/name              |    1 
 tests/t_enable_mcsum/script            |   70 +++++++++++++++++++++++
 tests/t_enable_mcsum_ext3/expect       |   73 ++++++++++++++++++++++++
 tests/t_enable_mcsum_ext3/name         |    1 
 tests/t_enable_mcsum_ext3/script       |   70 +++++++++++++++++++++++
 tests/t_enable_mcsum_initbg/expect     |   98 ++++++++++++++++++++++++++++++++
 tests/t_enable_mcsum_initbg/name       |    1 
 tests/t_enable_mcsum_initbg/script     |   70 +++++++++++++++++++++++
 20 files changed, 825 insertions(+), 1 deletion(-)
 create mode 100644 tests/t_disable_mcsum/expect
 create mode 100644 tests/t_disable_mcsum/name
 create mode 100644 tests/t_disable_mcsum/script
 create mode 100644 tests/t_disable_mcsum_noinitbg/expect
 create mode 100644 tests/t_disable_mcsum_noinitbg/name
 create mode 100644 tests/t_disable_mcsum_noinitbg/script
 create mode 100644 tests/t_disable_mcsum_yesinitbg/expect
 create mode 100644 tests/t_disable_mcsum_yesinitbg/name
 create mode 100644 tests/t_disable_mcsum_yesinitbg/script
 create mode 100644 tests/t_enable_mcsum/expect
 create mode 100644 tests/t_enable_mcsum/name
 create mode 100644 tests/t_enable_mcsum/script
 create mode 100644 tests/t_enable_mcsum_ext3/expect
 create mode 100644 tests/t_enable_mcsum_ext3/name
 create mode 100644 tests/t_enable_mcsum_ext3/script
 create mode 100644 tests/t_enable_mcsum_initbg/expect
 create mode 100644 tests/t_enable_mcsum_initbg/name
 create mode 100644 tests/t_enable_mcsum_initbg/script


diff --git a/tests/filter.sed b/tests/filter.sed
index a31b00f..4a630bf 100644
--- a/tests/filter.sed
+++ b/tests/filter.sed
@@ -25,3 +25,4 @@ s/\\015//g
 /^  Checksum /d
 s/, csum 0x\([0-9a-f]*\)//g
 s/ csum 0x\([0-9a-f]*\)//g
+/^Checksum:/d
diff --git a/tests/j_ext_dumpe2fs/expect b/tests/j_ext_dumpe2fs/expect
index c75f74c..8dc95cd 100644
--- a/tests/j_ext_dumpe2fs/expect
+++ b/tests/j_ext_dumpe2fs/expect
@@ -42,7 +42,6 @@ Required extra isize:     28
 Desired extra isize:      28
 Default directory hash:   half_md4
 Checksum type:            crc32c
-Checksum:                 0x3a9935ab
 Journal checksum type:    crc32c
 Journal checksum:         0x661e816f
 Journal features:         journal_64bit journal_checksum_v3
diff --git a/tests/t_disable_mcsum/expect b/tests/t_disable_mcsum/expect
new file mode 100644
index 0000000..e04f26a
--- /dev/null
+++ b/tests/t_disable_mcsum/expect
@@ -0,0 +1,45 @@
+tune2fs ^metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O ^metadata_csum test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -33,7 +33,6 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
+-Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_disable_mcsum/name b/tests/t_disable_mcsum/name
new file mode 100644
index 0000000..cf9dc8d
--- /dev/null
+++ b/tests/t_disable_mcsum/name
@@ -0,0 +1 @@
+disable metadata_csum
diff --git a/tests/t_disable_mcsum/script b/tests/t_disable_mcsum/script
new file mode 100644
index 0000000..7f1b3b4
--- /dev/null
+++ b/tests/t_disable_mcsum/script
@@ -0,0 +1,67 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit,metadata_csum
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs ^metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# remove mcsum
+echo "tune2fs -O ^metadata_csum test.img" >> $OUT
+$TUNE2FS -O ^metadata_csum $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/t_disable_mcsum_noinitbg/expect b/tests/t_disable_mcsum_noinitbg/expect
new file mode 100644
index 0000000..a022631
--- /dev/null
+++ b/tests/t_disable_mcsum_noinitbg/expect
@@ -0,0 +1,68 @@
+tune2fs ^metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O ^metadata_csum,^uninit_bg test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -33,7 +33,6 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
+-Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+@@ -47,18 +46,18 @@
+   Block bitmap at 262 (+261)
+   Inode bitmap at 278 (+277)
+   Inode table at 294-549 (+293)
+-  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  21 free blocks, 536 free inodes, 2 directories
+   Free blocks: 4413-4433
+   Free inodes: 489-1024
+-Group 1: (Blocks 8193-16384) [INODE_UNINIT]
++Group 1: (Blocks 8193-16384)
+   Backup superblock at 8193, Group descriptors at 8194-8197
+   Reserved GDT blocks at 8198-8453
+   Block bitmap at 263 (bg #0 + 262)
+   Inode bitmap at 279 (bg #0 + 278)
+   Inode table at 550-805 (bg #0 + 549)
+-  0 free blocks, 1024 free inodes, 0 directories, 1024 unused inodes
++  0 free blocks, 1024 free inodes, 0 directories
+   Free blocks: 
+   Free inodes: 1025-2048
+-Group 2: (Blocks 16385-24576) [INODE_UNINIT]
++Group 2: (Blocks 16385-24576)
+   Block bitmap at 264 (bg #0 + 263)
+   Inode bitmap at 280 (bg #0 + 279)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_disable_mcsum_noinitbg/name b/tests/t_disable_mcsum_noinitbg/name
new file mode 100644
index 0000000..4b906be
--- /dev/null
+++ b/tests/t_disable_mcsum_noinitbg/name
@@ -0,0 +1 @@
+disable metadata_csum and uninit_bg
diff --git a/tests/t_disable_mcsum_noinitbg/script b/tests/t_disable_mcsum_noinitbg/script
new file mode 100644
index 0000000..db49864
--- /dev/null
+++ b/tests/t_disable_mcsum_noinitbg/script
@@ -0,0 +1,67 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit,metadata_csum
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs ^metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# remove mcsum
+echo "tune2fs -O ^metadata_csum,^uninit_bg test.img" >> $OUT
+$TUNE2FS -O ^metadata_csum,^uninit_bg $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/t_disable_mcsum_yesinitbg/expect b/tests/t_disable_mcsum_yesinitbg/expect
new file mode 100644
index 0000000..df3d6c0
--- /dev/null
+++ b/tests/t_disable_mcsum_yesinitbg/expect
@@ -0,0 +1,45 @@
+tune2fs ^metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O ^metadata_csum,uninit_bg test.img
+Exit status is 0
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -33,7 +33,6 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
+-Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_disable_mcsum_yesinitbg/name b/tests/t_disable_mcsum_yesinitbg/name
new file mode 100644
index 0000000..880de1c
--- /dev/null
+++ b/tests/t_disable_mcsum_yesinitbg/name
@@ -0,0 +1 @@
+disable metadata_csum and enable uninit_bg
diff --git a/tests/t_disable_mcsum_yesinitbg/script b/tests/t_disable_mcsum_yesinitbg/script
new file mode 100644
index 0000000..2d04041
--- /dev/null
+++ b/tests/t_disable_mcsum_yesinitbg/script
@@ -0,0 +1,67 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit,metadata_csum
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs ^metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# remove mcsum
+echo "tune2fs -O ^metadata_csum,uninit_bg test.img" >> $OUT
+$TUNE2FS -O ^metadata_csum,uninit_bg $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/t_enable_mcsum/expect b/tests/t_enable_mcsum/expect
new file mode 100644
index 0000000..2ee3c27
--- /dev/null
+++ b/tests/t_enable_mcsum/expect
@@ -0,0 +1,78 @@
+tune2fs metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O metadata_csum test.img
+
+Please run e2fsck -D on the filesystem.
+
+Exit status is 0
+test_filesys was not cleanly unmounted, check forced.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+
+
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,7 +10,7 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              571
++Free blocks:              568
+ Free inodes:              65048
+ First block:              1
+ Block size:               1024
+@@ -33,6 +33,7 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
++Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+@@ -46,8 +47,8 @@
+   Block bitmap at 262 (+261)
+   Inode bitmap at 278 (+277)
+   Inode table at 294-549 (+293)
+-  21 free blocks, 536 free inodes, 2 directories, 536 unused inodes
+-  Free blocks: 4413-4433
++  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  Free blocks: 4413, 4417-4433
+   Free inodes: 489-1024
+ Group 1: (Blocks 8193-16384) [INODE_UNINIT]
+   Backup superblock at 8193, Group descriptors at 8194-8197
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_enable_mcsum/name b/tests/t_enable_mcsum/name
new file mode 100644
index 0000000..22f295a
--- /dev/null
+++ b/tests/t_enable_mcsum/name
@@ -0,0 +1 @@
+enable metadata_csum
diff --git a/tests/t_enable_mcsum/script b/tests/t_enable_mcsum/script
new file mode 100644
index 0000000..5239eb3
--- /dev/null
+++ b/tests/t_enable_mcsum/script
@@ -0,0 +1,70 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# add mcsum
+echo "tune2fs -O metadata_csum test.img" >> $OUT
+$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# check
+$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/t_enable_mcsum_ext3/expect b/tests/t_enable_mcsum_ext3/expect
new file mode 100644
index 0000000..1e005bd
--- /dev/null
+++ b/tests/t_enable_mcsum_ext3/expect
@@ -0,0 +1,73 @@
+tune2fs metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+mke2fs: Operation not supported for inodes containing extents while creating huge files
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O metadata_csum test.img
+Extents are not enabled.  The file extent tree can be checksummed, whereas block maps cannot.  Not enabling extents reduces the coverage of metadata checksumming.  Re-run with -O extent to rectify.
+Exit status is 0
+
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype sparse_super large_file
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype sparse_super large_file metadata_csum
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -29,6 +29,7 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
++Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+@@ -36,7 +37,7 @@
+ Journal start:            0
+ 
+ 
+-Group 0: (Blocks 1-8192)
++Group 0: (Blocks 1-8192) [ITABLE_ZEROED]
+   Primary superblock at 1, Group descriptors at 2-3
+   Reserved GDT blocks at 4-259
+   Block bitmap at 260 (+259)
+@@ -45,7 +46,7 @@
+   7789 free blocks, 1013 free inodes, 2 directories
+   Free blocks: 404-8192
+   Free inodes: 12-1024
+-Group 1: (Blocks 8193-16384)
++Group 1: (Blocks 8193-16384) [ITABLE_ZEROED]
+   Backup superblock at 8193, Group descriptors at 8194-8195
+   Reserved GDT blocks at 8196-8451
+   Block bitmap at 8452 (+259)
+@@ -54,6 +55,6 @@
+   7803 free blocks, 1024 free inodes, 0 directories
+   Free blocks: 8582-16384
+   Free inodes: 1025-2048
+-Group 2: (Blocks 16385-24576)
++Group 2: (Blocks 16385-24576) [ITABLE_ZEROED]
+   Block bitmap at 16385 (+0)
+   Inode bitmap at 16386 (+1)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_enable_mcsum_ext3/name b/tests/t_enable_mcsum_ext3/name
new file mode 100644
index 0000000..d9a29c8
--- /dev/null
+++ b/tests/t_enable_mcsum_ext3/name
@@ -0,0 +1 @@
+enable metadata_csum on ext3 fs
diff --git a/tests/t_enable_mcsum_ext3/script b/tests/t_enable_mcsum_ext3/script
new file mode 100644
index 0000000..ac63866
--- /dev/null
+++ b/tests/t_enable_mcsum_ext3/script
@@ -0,0 +1,70 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,^extent,^huge_file,^flex_bg,^uninit_bg,^dir_nlink,^extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,^64bit
+		blocksize = 1024
+		inode_size = 128
+		make_hugefiles = true
+		hugefiles_dir = /
+		num_hugefiles = 10
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# add mcsum
+echo "tune2fs -O metadata_csum test.img" >> $OUT
+$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# check
+$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF
diff --git a/tests/t_enable_mcsum_initbg/expect b/tests/t_enable_mcsum_initbg/expect
new file mode 100644
index 0000000..d3b4444
--- /dev/null
+++ b/tests/t_enable_mcsum_initbg/expect
@@ -0,0 +1,98 @@
+tune2fs metadata_csum test
+Creating filesystem with 524288 1k blocks and 65536 inodes
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729, 204801, 221185, 401409
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Creating journal (16384 blocks): done
+Creating 477 huge file(s) with 1024 blocks each: done
+Writing superblocks and filesystem accounting information:      done
+
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
+tune2fs -O metadata_csum test.img
+
+Please run e2fsck -D on the filesystem.
+
+Exit status is 0
+test_filesys was not cleanly unmounted, check forced.
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 3A: Optimizing directories
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+
+
+Change in FS metadata:
+@@ -2,7 +2,7 @@
+ Last mounted on:          <not available>
+ Filesystem magic number:  0xEF53
+ Filesystem revision #:    1 (dynamic)
+-Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize
++Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
+ Default mount options:    user_xattr acl
+ Filesystem state:         clean
+ Errors behavior:          Continue
+@@ -10,7 +10,7 @@
+ Inode count:              65536
+ Block count:              524288
+ Reserved block count:     26214
+-Free blocks:              571
++Free blocks:              568
+ Free inodes:              65048
+ First block:              1
+ Block size:               1024
+@@ -33,6 +33,7 @@
+ Journal inode:            8
+ Default directory hash:   half_md4
+ Journal backup:           inode blocks
++Checksum type:            crc32c
+ Journal features:         (none)
+ Journal size:             16M
+ Journal length:           16384
+@@ -40,24 +41,24 @@
+ Journal start:            0
+ 
+ 
+-Group 0: (Blocks 1-8192)
++Group 0: (Blocks 1-8192) [ITABLE_ZEROED]
+   Primary superblock at 1, Group descriptors at 2-5
+   Reserved GDT blocks at 6-261
+   Block bitmap at 262 (+261)
+   Inode bitmap at 278 (+277)
+   Inode table at 294-549 (+293)
+-  21 free blocks, 536 free inodes, 2 directories
+-  Free blocks: 4413-4433
++  18 free blocks, 536 free inodes, 2 directories, 536 unused inodes
++  Free blocks: 4413, 4417-4433
+   Free inodes: 489-1024
+-Group 1: (Blocks 8193-16384)
++Group 1: (Blocks 8193-16384) [INODE_UNINIT, ITABLE_ZEROED]
+   Backup superblock at 8193, Group descriptors at 8194-8197
+   Reserved GDT blocks at 8198-8453
+   Block bitmap at 263 (bg #0 + 262)
+   Inode bitmap at 279 (bg #0 + 278)
+   Inode table at 550-805 (bg #0 + 549)
+-  0 free blocks, 1024 free inodes, 0 directories
++  0 free blocks, 1024 free inodes, 0 directories, 1024 unused inodes
+   Free blocks: 
+   Free inodes: 1025-2048
+-Group 2: (Blocks 16385-24576)
++Group 2: (Blocks 16385-24576) [INODE_UNINIT, ITABLE_ZEROED]
+   Block bitmap at 264 (bg #0 + 263)
+   Inode bitmap at 280 (bg #0 + 279)
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+Exit status is 0
diff --git a/tests/t_enable_mcsum_initbg/name b/tests/t_enable_mcsum_initbg/name
new file mode 100644
index 0000000..291eb6b
--- /dev/null
+++ b/tests/t_enable_mcsum_initbg/name
@@ -0,0 +1 @@
+enable metadata_csum when ^uninit_bg
diff --git a/tests/t_enable_mcsum_initbg/script b/tests/t_enable_mcsum_initbg/script
new file mode 100644
index 0000000..35c4541
--- /dev/null
+++ b/tests/t_enable_mcsum_initbg/script
@@ -0,0 +1,70 @@
+FSCK_OPT=-fn
+OUT=$test_name.log
+EXP=$test_dir/expect
+CONF=$TMPFILE.conf
+
+cat > $CONF << ENDL
+[fs_types]
+	ext4h = {
+		features = has_journal,extent,huge_file,flex_bg,^uninit_bg,dir_nlink,extra_isize,sparse_super,filetype,dir_index,ext_attr,resize_inode,64bit
+		blocksize = 1024
+		inode_size = 256
+		make_hugefiles = true
+		hugefiles_dir = /
+		hugefiles_slack = 0
+		hugefiles_name = aaaaa
+		hugefiles_digits = 4
+		hugefiles_size = 1M
+		zero_hugefiles = false
+	}
+ENDL
+
+echo "tune2fs metadata_csum test" > $OUT
+
+MKE2FS_CONFIG=$CONF $MKE2FS -F -T ext4h $TMPFILE 524288 >> $OUT 2>&1
+rm -rf $CONF
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.before
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# add mcsum
+echo "tune2fs -O metadata_csum test.img" >> $OUT
+$TUNE2FS -O metadata_csum $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+# check
+$FSCK -yD -N test_filesys $TMPFILE >> $OUT 2>&1
+
+# dump and check
+$DUMPE2FS $TMPFILE 2> /dev/null | grep '^Group 0:' -B99 -A20 | sed -f $cmd_dir/filter.sed > $OUT.after
+echo "Change in FS metadata:" >> $OUT
+diff -u $OUT.before $OUT.after | tail -n +3 >> $OUT
+$FSCK $FSCK_OPT -N test_filesys $TMPFILE >> $OUT 2>&1
+status=$?
+echo Exit status is $status >> $OUT
+
+rm $TMPFILE $OUT.before $OUT.after
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
+unset IMAGE FSCK_OPT OUT EXP CONF

