From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] e2fsprogs: fix mmp tests on hard 4k devices (resend)
Date: Thu, 10 Nov 2011 17:04:00 -0600
Message-ID: <4EBC5860.60901@redhat.com>
References: <4EBC5524.3000105@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050301020802080706060006"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab1KJXEC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Nov 2011 18:04:02 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAAN41il017156
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 18:04:01 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id pAAN40XH012737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 10 Nov 2011 18:04:01 -0500
In-Reply-To: <4EBC5524.3000105@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050301020802080706060006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Several of the mmp tests were failing on an s390 guest because
direct IO cannot be done on sub-sector sizes, and they were
doing 1k IOs to files on a 4k logical/physical device.

A few tests could just be changed to 4k, but others
needed fixed up output as well.

With this I have all tests passing on s390 again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(attaching patch to deal with ctrl characters in patch)

--------------050301020802080706060006
Content-Type: text/x-diff;
 name="mmp_test_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mmp_test_fixes.patch"

diff --git a/tests/f_mmp/script b/tests/f_mmp/script
index 548734a..4aca447 100644
--- a/tests/f_mmp/script
+++ b/tests/f_mmp/script
@@ -12,7 +12,7 @@ if [ $? == 0 ]; then
 fi
 
 echo "make the test image ..." > $test_name.log
-$MKE2FS -q -F -o Linux -b 1024 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
+$MKE2FS -q -F -o Linux -b 4096 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed
diff --git a/tests/f_mmp_garbage/expect.1 b/tests/f_mmp_garbage/expect.1
index 4ee5cfb..a8add10 100644
--- a/tests/f_mmp_garbage/expect.1
+++ b/tests/f_mmp_garbage/expect.1
@@ -5,5 +5,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16 files (0.0% non-contiguous), 22/100 blocks
+test_filesys: 11/64 files (0.0% non-contiguous), 13/100 blocks
 Exit status is 0
diff --git a/tests/f_mmp_garbage/expect.2 b/tests/f_mmp_garbage/expect.2
index 3bf3869..6630002 100644
--- a/tests/f_mmp_garbage/expect.2
+++ b/tests/f_mmp_garbage/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16 files (0.0% non-contiguous), 22/100 blocks
+test_filesys: 11/64 files (0.0% non-contiguous), 13/100 blocks
 Exit status is 0
diff --git a/tests/f_mmp_garbage/script b/tests/f_mmp_garbage/script
index 3c80032..8b5a22a 100644
--- a/tests/f_mmp_garbage/script
+++ b/tests/f_mmp_garbage/script
@@ -12,7 +12,7 @@ if [ $? == 0 ] ; then
 fi
 
 echo "make the test image ..." > $test_name.log
-$MKE2FS -q -F -o Linux -b 1024 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
+$MKE2FS -q -F -o Linux -b 4096 -O mmp -E mmp_update_interval=1 $TMPFILE 100 >> $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed
diff --git a/tests/m_mmp/expect.1 b/tests/m_mmp/expect.1
index 3a00815..d3319b3 100644
--- a/tests/m_mmp/expect.1
+++ b/tests/m_mmp/expect.1
@@ -1,55 +1,55 @@
 Filesystem label=
 OS type: Linux
-Block size=2048 (log=1)
-Fragment size=2048 (log=1)
+Block size=4096 (log=2)
+Fragment size=4096 (log=2)
 Stride=0 blocks, Stripe width=0 blocks
-16384 inodes, 32768 blocks
-1638 blocks (5.00%) reserved for the super user
+65536 inodes, 65536 blocks
+3276 blocks (5.00%) reserved for the super user
 First data block=0
-Maximum filesystem blocks=33554432
+Maximum filesystem blocks=67108864
 2 block groups
-16384 blocks per group, 16384 fragments per group
-8192 inodes per group
+32768 blocks per group, 32768 fragments per group
+32768 inodes per group
 Superblock backups stored on blocks: 
-	16384
+	32768
 
 Allocating group tables: 0/21/2   done                            
 Writing inode tables: 0/21/2   done                            
 Multiple mount protection is enabled with update interval 5 seconds.
 Writing superblocks and filesystem accounting information: 0/21/2   done
 
-Filesystem features: ext_attr resize_inode dir_index filetype mmp sparse_super
+Filesystem features: ext_attr resize_inode dir_index filetype mmp sparse_super large_file
  
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/16384 files (0.0% non-contiguous), 1105/32768 blocks
+test_filesys: 11/65536 files (0.0% non-contiguous), 2093/65536 blocks
 Exit status is 0
 
 Filesystem volume name:   <none>
 Last mounted on:          <not available>
 Filesystem magic number:  0xEF53
 Filesystem revision #:    1 (dynamic)
-Filesystem features:      ext_attr resize_inode dir_index filetype mmp sparse_super
+Filesystem features:      ext_attr resize_inode dir_index filetype mmp sparse_super large_file
 Default mount options:    (none)
 Filesystem state:         clean
 Errors behavior:          Continue
 Filesystem OS type:       Linux
-Inode count:              16384
-Block count:              32768
-Reserved block count:     1638
-Free blocks:              31663
-Free inodes:              16373
+Inode count:              65536
+Block count:              65536
+Reserved block count:     3276
+Free blocks:              63443
+Free inodes:              65525
 First block:              0
-Block size:               2048
-Fragment size:            2048
-Reserved GDT blocks:      31
-Blocks per group:         16384
-Fragments per group:      16384
-Inodes per group:         8192
-Inode blocks per group:   512
+Block size:               4096
+Fragment size:            4096
+Reserved GDT blocks:      15
+Blocks per group:         32768
+Fragments per group:      32768
+Inodes per group:         32768
+Inode blocks per group:   1024
 Mount count:              0
 Check interval:           15552000 (6 months)
 Reserved blocks uid:      0
@@ -57,23 +57,23 @@ Reserved blocks gid:      0
 First inode:              11
 Inode size:	          128
 Default directory hash:   half_md4
-MMP block number:         557
+MMP block number:         1049
 MMP update interval:      5
 
 
-Group 0: (Blocks 0-16383)
+Group 0: (Blocks 0-32767)
   Primary superblock at 0, Group descriptors at 1-1
-  Reserved GDT blocks at 2-32
-  Block bitmap at 33 (+33), Inode bitmap at 34 (+34)
-  Inode table at 35-546 (+35)
-  15826 free blocks, 8181 free inodes, 2 directories
-  Free blocks: 558-16383
-  Free inodes: 12-8192
-Group 1: (Blocks 16384-32767)
-  Backup superblock at 16384, Group descriptors at 16385-16385
-  Reserved GDT blocks at 16386-16416
-  Block bitmap at 16417 (+33), Inode bitmap at 16418 (+34)
-  Inode table at 16419-16930 (+35)
-  15837 free blocks, 8192 free inodes, 0 directories
-  Free blocks: 16931-32767
-  Free inodes: 8193-16384
+  Reserved GDT blocks at 2-16
+  Block bitmap at 17 (+17), Inode bitmap at 18 (+18)
+  Inode table at 19-1042 (+19)
+  31718 free blocks, 32757 free inodes, 2 directories
+  Free blocks: 1050-32767
+  Free inodes: 12-32768
+Group 1: (Blocks 32768-65535)
+  Backup superblock at 32768, Group descriptors at 32769-32769
+  Reserved GDT blocks at 32770-32784
+  Block bitmap at 32785 (+17), Inode bitmap at 32786 (+18)
+  Inode table at 32787-33810 (+19)
+  31725 free blocks, 32768 free inodes, 0 directories
+  Free blocks: 33811-65535
+  Free inodes: 32769-65536
diff --git a/tests/m_mmp/script b/tests/m_mmp/script
index 1547463..b3e206a 100644
--- a/tests/m_mmp/script
+++ b/tests/m_mmp/script
@@ -10,6 +10,6 @@ if [ $? == 0 ]; then
 	echo "skipped for tmpfs (no O_DIRECT support)"
 	return 0
 fi
-MKE2FS_OPTS="-O mmp"
+MKE2FS_OPTS="-b 4096 -O mmp"
 . $cmd_dir/run_mke2fs
 unset MKE2FS_DEVICE_SECTSIZE
diff --git a/tests/t_mmp_1on/script b/tests/t_mmp_1on/script
index ee9884f..3b0a376 100644
--- a/tests/t_mmp_1on/script
+++ b/tests/t_mmp_1on/script
@@ -11,7 +11,7 @@ if [ $? == 0 ] ; then
 	return 0
 fi
 
-$MKE2FS -q -F -o Linux -b 1024 $TMPFILE 100 > $test_name.log 2>&1
+$MKE2FS -q -F -o Linux -b 4096 $TMPFILE 100 > $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs failed" > $test_name.failed
diff --git a/tests/t_mmp_2off/script b/tests/t_mmp_2off/script
index ec9f71e..56c6bed 100644
--- a/tests/t_mmp_2off/script
+++ b/tests/t_mmp_2off/script
@@ -11,7 +11,7 @@ if [ $? == 0 ]; then
 	return 0
 fi
 
-$MKE2FS -q -F -o Linux -b 1024 -O mmp $TMPFILE 100 > $test_name.log 2>&1
+$MKE2FS -q -F -o Linux -b 4096 -O mmp $TMPFILE 100 > $test_name.log 2>&1
 status=$?
 if [ "$status" != 0 ] ; then
 	echo "mke2fs -O mmp failed" > $test_name.failed

--------------050301020802080706060006--
