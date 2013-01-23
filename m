From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] quota: fix disabling quota, add quota tests
Date: Tue, 22 Jan 2013 17:00:48 -0700
Message-ID: <1358899248-22575-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Niu Yawei <niu@whamcloud.com>,
	Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:16917 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWAAu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jan 2013 19:00:50 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Niu Yawei <niu@whamcloud.com>

Update all superblock copies when disabling the quota feature.

Added basic tests for the quota feature.

Signed-off-by: Niu Yawei <niu@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 configure                 |    6 ++-
 configure.in              |    4 +
 lib/quota/mkquota.c       |    1 +
 tests/Makefile.in         |    1 +
 tests/m_quota/expect.1    |  170 +++++++++++++++++++++++++++++++++++++++++++++
 tests/m_quota/script      |    8 ++
 tests/t_quota_1on/name    |    1 +
 tests/t_quota_1on/script  |   42 +++++++++++
 tests/t_quota_2off/name   |    1 +
 tests/t_quota_2off/script |   35 +++++++++
 10 files changed, 268 insertions(+), 1 deletions(-)
 create mode 100644 tests/m_quota/expect.1
 create mode 100644 tests/m_quota/script
 create mode 100644 tests/t_quota_1on/name
 create mode 100644 tests/t_quota_1on/script
 create mode 100644 tests/t_quota_2off/name
 create mode 100644 tests/t_quota_2off/script

diff --git a/configure b/configure
index 84e7e03..737bb48 100755
--- a/configure
+++ b/configure
@@ -5304,14 +5304,17 @@ $as_echo "no" >&6; }
         fi
 
 fi
+QUOTA_CMT=
 
 # Check whether --enable-quota was given.
 if test "${enable_quota+set}" = set; then :
   enableval=$enable_quota; if test "$enableval" = "no"
 then
+	QUOTA_CMT=#
 	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support" >&5
 $as_echo "Disabling quota support" >&6; }
 else
+	QUOTA_CMT=
 	$as_echo "#define CONFIG_QUOTA 1" >>confdefs.h
 
 	{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Enabling quota support" >&5
@@ -5319,7 +5322,8 @@ $as_echo "Enabling quota support" >&6; }
 fi
 
 else
-  { $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support by default" >&5
+  QUOTA_CMT=#
+{ $as_echo "$as_me:${as_lineno-$LINENO}: result: Disabling quota support by default" >&5
 $as_echo "Disabling quota support by default" >&6; }
 
 fi
diff --git a/configure.in b/configure.in
index ac3cd92..58cae9a 100644
--- a/configure.in
+++ b/configure.in
@@ -566,17 +566,21 @@ dnl
 dnl handle --enable-quota
 dnl
 PKG_PROG_PKG_CONFIG
+QUOTA_CMT=
 AH_TEMPLATE([CONFIG_QUOTA], [Define to 1 to enable quota support])
 AC_ARG_ENABLE([quota],
 [  --enable-quota	  enable quota support],
 if test "$enableval" = "no"
 then
+	QUOTA_CMT=#
 	AC_MSG_RESULT([Disabling quota support])
 else
+	QUOTA_CMT=
 	AC_DEFINE(CONFIG_QUOTA, 1)
 	AC_MSG_RESULT([Enabling quota support])
 fi
 ,
+QUOTA_CMT=#
 AC_MSG_RESULT([Disabling quota support by default])
 )
 dnl
diff --git a/lib/quota/mkquota.c b/lib/quota/mkquota.c
index 8d087da..a0d3a2a 100644
--- a/lib/quota/mkquota.c
+++ b/lib/quota/mkquota.c
@@ -99,6 +99,7 @@ errcode_t quota_remove_inode(ext2_filsys fs, int qtype)
 		quota_inode_truncate(fs, qf_ino);
 
 	ext2fs_mark_super_dirty(fs);
+	fs->flags &= ~EXT2_FLAG_SUPER_ONLY;
 	ext2fs_write_bitmaps(fs);
 	return 0;
 }
diff --git a/tests/Makefile.in b/tests/Makefile.in
index b9df3b0..37a043e 100644
--- a/tests/Makefile.in
+++ b/tests/Makefile.in
@@ -17,6 +17,7 @@ test_one: $(srcdir)/test_one.in Makefile mke2fs.conf
 	@echo "Creating test_one script..."
 	@echo "#!/bin/sh" > test_one
 @HTREE_CMT@	@echo "HTREE=y" >> test_one
+@QUOTA_CMT@	@echo "QUOTA=y" >> test_one
 	@echo "SRCDIR=@srcdir@" >> test_one
 	@echo "DIFF_OPTS=@UNI_DIFF_OPTS@" >> test_one
 	@cat $(srcdir)/test_one.in >> test_one
diff --git a/tests/m_quota/expect.1 b/tests/m_quota/expect.1
new file mode 100644
index 0000000..1c86f59
--- /dev/null
+++ b/tests/m_quota/expect.1
@@ -0,0 +1,170 @@
+Filesystem label=
+OS type: Linux
+Block size=1024 (log=0)
+Fragment size=1024 (log=0)
+Stride=0 blocks, Stripe width=0 blocks
+32768 inodes, 131072 blocks
+6553 blocks (5.00%) reserved for the super user
+First data block=1
+Maximum filesystem blocks=67371008
+16 block groups
+8192 blocks per group, 8192 fragments per group
+2048 inodes per group
+Superblock backups stored on blocks: 
+	8193, 24577, 40961, 57345, 73729
+
+Allocating group tables:      done                            
+Writing inode tables:      done                            
+Writing superblocks and filesystem accounting information:      done
+
+Filesystem features: ext_attr resize_inode dir_index filetype sparse_super quota
+ 
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 11/32768 files (18.2% non-contiguous), 5703/131072 blocks
+Exit status is 0
+
+Filesystem volume name:   <none>
+Last mounted on:          <not available>
+Filesystem magic number:  0xEF53
+Filesystem revision #:    1 (dynamic)
+Filesystem features:      ext_attr resize_inode dir_index filetype sparse_super quota
+Default mount options:    (none)
+Filesystem state:         clean
+Errors behavior:          Continue
+Filesystem OS type:       Linux
+Inode count:              32768
+Block count:              131072
+Reserved block count:     6553
+Free blocks:              125369
+Free inodes:              32757
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
+First inode:              11
+Inode size:	          128
+Default directory hash:   half_md4
+User quota inode:         3
+Group quota inode:        4
+
+
+Group 0: (Blocks 1-8192)
+  Primary superblock at 1, Group descriptors at 2-2
+  Reserved GDT blocks at 3-258
+  Block bitmap at 259 (+258), Inode bitmap at 260 (+259)
+  Inode table at 261-516 (+260)
+  7650 free blocks, 2037 free inodes, 2 directories
+  Free blocks: 543-8192
+  Free inodes: 12-2048
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
diff --git a/tests/m_quota/script b/tests/m_quota/script
new file mode 100644
index 0000000..36ab630
--- /dev/null
+++ b/tests/m_quota/script
@@ -0,0 +1,8 @@
+DESCRIPTION="enable quota feature on mkfs"
+FS_SIZE=131072
+MKE2FS_OPTS="-O quota"
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $DESCRIPTION: skipped"
+	return 0
+fi
+. $cmd_dir/run_mke2fs
diff --git a/tests/t_quota_1on/name b/tests/t_quota_1on/name
new file mode 100644
index 0000000..f92e2d5
--- /dev/null
+++ b/tests/t_quota_1on/name
@@ -0,0 +1 @@
+enable quota using tune2fs
diff --git a/tests/t_quota_1on/script b/tests/t_quota_1on/script
new file mode 100644
index 0000000..ed17f33
--- /dev/null
+++ b/tests/t_quota_1on/script
@@ -0,0 +1,42 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 $TMPFILE 10000 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+dd if=/dev/zero of=$TMPFILE.2 bs=1048576 count=1 >> $test_name.log 2>&1
+cat <<- EOF | $DEBUGFS -w -f /dev/stdin $TMPFILE >> $test_name.log 2>&1
+	write $TMPFILE.2 file1
+	set_inode_field file1 uid 500
+	set_inode_field file1 gid 500
+EOF
+rm -f $TMPFILE.2
+
+$TUNE2FS -O quota  $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O quota failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with quota enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+rm -f $TMPFILE
diff --git a/tests/t_quota_2off/name b/tests/t_quota_2off/name
new file mode 100644
index 0000000..bb0ec98
--- /dev/null
+++ b/tests/t_quota_2off/name
@@ -0,0 +1 @@
+disable quota using tune2fs
diff --git a/tests/t_quota_2off/script b/tests/t_quota_2off/script
new file mode 100644
index 0000000..b170c59
--- /dev/null
+++ b/tests/t_quota_2off/script
@@ -0,0 +1,35 @@
+FSCK_OPT=-yf
+
+if [ "$QUOTA" != "y" ]; then
+	echo "$test_name: $test_description: skipped"
+	return 0
+fi
+
+$MKE2FS -q -F -o Linux -b 4096 -O quota $TMPFILE 100 > $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "mke2fs -O quota failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$TUNE2FS -O ^quota $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" != 0 ] ; then
+	echo "tune2fs -O ^quota failed" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+$FSCK $FSCK_OPT $TMPFILE >> $test_name.log 2>&1
+status=$?
+if [ "$status" = 0 ] ; then
+	echo "$test_name: $test_description: ok"
+	touch $test_name.ok
+else
+	echo "e2fsck with quota enabled failed with $status" > $test_name.failed
+	echo "$test_name: $test_description: failed"
+	return $status
+fi
+
+rm -f $TMPFILE
-- 
1.7.3.4

