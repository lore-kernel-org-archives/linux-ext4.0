From: Paul Paulson <paul.paulson@seagate.com>
Subject: [PATCH] generic/017: skip tests with mkfs failures
Date: Mon,  6 Oct 2014 13:23:50 -0500
Message-ID: <1412619830-23088-1-git-send-email-paul.paulson@seagate.com>
Cc: linux-ext4@vger.kernel.org, Paul Paulson <paul.paulson@seagate.com>
To: fstests@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:11210 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143AbaJFSi2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Oct 2014 14:38:28 -0400
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id s96IK1Lu013651
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2014 14:23:58 -0400
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-00003501.pphosted.com with ESMTP id 1puy7ggcwq-1
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Mon, 06 Oct 2014 14:23:58 -0400
Received: from m0075552.ppops.net (m0075552.ppops.net [127.0.0.1])
	by pps.reinject (8.14.5/8.14.5) with SMTP id s96ILmsf015560
	for <linux-ext4@vger.kernel.org>; Mon, 6 Oct 2014 14:23:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The mkfs command fails to create ext4 filesystems on partition sizes
greater than 1998080 MiB when using 1024 byte blocks and the default
calculation for the number of inodes reserved for the filesystem.

The following error message is produced when the maximum number of
inodes is exceeded:

    "Cannot create filesystem with requested number of inodes while
     setting up superblock"

The generic/017 test was modified to skip the 1K block size test
for partitions with an inode count that exceeds the maximum.

The QA output for the test was also changed to a simple pass/fail
indication to account for a variable number of test iterations.
---
 common/config         |  1 +
 tests/generic/017     | 21 +++++++++++++++++++--
 tests/generic/017.out |  4 +---
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/common/config b/common/config
index d68d4d0..824985e 100644
--- a/common/config
+++ b/common/config
@@ -184,6 +184,7 @@ export LOGGER_PROG="`set_prog_path logger`"
 export DBENCH_PROG="`set_prog_path dbench`"
 export DMSETUP_PROG="`set_prog_path dmsetup`"
 export WIPEFS_PROG="`set_prog_path wipefs`"
+export TUNE2FS_PROG="`set_prog_path tune2fs`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/tests/generic/017 b/tests/generic/017
index 13b7254..eb38d4d 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -49,8 +49,16 @@ _do_die_on_error=y
 testfile=$SCRATCH_MNT/$seq.$$
 BLOCKS=10240
 
-for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
+MAX_INODE_COUNT_1K=127877120
+inode_count=`$TUNE2FS_PROG -l $SCRATCH_DEV | awk '/Inode count:/ { print $3 }'`
+initial_bsize=$(($inode_count <= $MAX_INODE_COUNT_1K ? 1024 : 2048))
 
+iterations=0
+passcount=0
+
+for (( BSIZE = $initial_bsize; BSIZE <= 4096; BSIZE *= 2 )); do
+
+	let iterations++
 	length=$(($BLOCKS * $BSIZE))
 	case $FSTYP in
 	xfs)
@@ -74,7 +82,10 @@ for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
 	done
 
 	# Check if 80 extents are present
-	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+	extents=`$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" | wc -l`
+	if [ $extents -eq 80 ]; then
+		let passcount++
+	fi
 
 	_check_scratch_fs
 	if [ $? -ne 0 ]; then
@@ -85,6 +96,12 @@ for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
 	umount $SCRATCH_MNT
 done
 
+if [ $iterations -gt 0 -a $passcount -eq $iterations ]; then
+	echo pass
+else
+	echo fail
+fi
+
 # success, all done
 status=0
 exit
diff --git a/tests/generic/017.out b/tests/generic/017.out
index cc524ac..008ac18 100644
--- a/tests/generic/017.out
+++ b/tests/generic/017.out
@@ -1,4 +1,2 @@
 QA output created by 017
-80
-80
-80
+pass
-- 
1.9.1

