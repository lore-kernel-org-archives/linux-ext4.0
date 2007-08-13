From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/6] e2fsprogs: Add test case for undoe2fs
Date: Mon, 13 Aug 2007 15:56:26 +0530
Message-ID: <1187000808916-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11870007861341-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007892653-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007931987-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007962358-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870007992253-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870008042147-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:56057 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939041AbXHMK2H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:28:07 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DAUE9B179710
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:30:18 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l7DAQpOX4550804
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:26:51 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DBQpcD007335
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 21:26:51 +1000
In-Reply-To: <11870008042147-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This adds two test case for undoe2fs.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 tests/test_config               |    1 +
 tests/u_undoe2fs_mke2fs/script  |   31 +++++++++++++++++++++++++++++++
 tests/u_undoe2fs_tune2fs/script |   31 +++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 tests/u_undoe2fs_mke2fs/script
 create mode 100644 tests/u_undoe2fs_tune2fs/script

diff --git a/tests/test_config b/tests/test_config
index f5ae0fe..f79ec79 100644
--- a/tests/test_config
+++ b/tests/test_config
@@ -13,6 +13,7 @@ DEBUGFS="$USE_VALGRIND ../debugfs/debugfs"
 TEST_BITS="../debugfs/debugfs"
 RESIZE2FS_EXE="../resize/resize2fs"
 RESIZE2FS="$USE_VALGRIND $RESIZE2FS_EXE"
+UNDOE2FS_EXE="../misc/undoe2fs"
 TEST_REL=../tests/progs/test_rel
 TEST_ICOUNT=../tests/progs/test_icount
 LD_LIBRARY_PATH=../lib:../lib/ext2fs:../lib/e2p:../lib/et:../lib/ss
diff --git a/tests/u_undoe2fs_mke2fs/script b/tests/u_undoe2fs_mke2fs/script
new file mode 100644
index 0000000..82ee6b3
--- /dev/null
+++ b/tests/u_undoe2fs_mke2fs/script
@@ -0,0 +1,31 @@
+printf "undoe2fs with mke2fs: "
+if test -x $UNDOE2FS_EXE; then
+
+export MKE2FS_SCRATCH_DIR=./
+TDB_FILE=./mke2fs-test.img
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 test.img  > $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >/dev/null 2>&1
+md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum before mke2fs $md5 >> $OUT
+
+echo using mke2fs to test undoe2fs >> $OUT
+$MKE2FS -q -F -o Linux -I 256 -b 1024 $TMPFILE  >/dev/null 2>&1
+new_md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum after mke2fs $new_md5 >> $OUT
+
+$UNDOE2FS_EXE  $TDB_FILE $TMPFILE  >/dev/null 2>&1
+new_md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum after undoe2fs $new_md5 >> $OUT
+
+if [ $md5 = $new_md5 ]; then
+	echo "ok"
+	touch $test_name.ok
+else
+	echo "failed"
+fi
+fi
diff --git a/tests/u_undoe2fs_tune2fs/script b/tests/u_undoe2fs_tune2fs/script
new file mode 100644
index 0000000..d01628d
--- /dev/null
+++ b/tests/u_undoe2fs_tune2fs/script
@@ -0,0 +1,31 @@
+printf "undoe2fs with tune2fs: "
+if test -x $UNDOE2FS_EXE; then
+
+export TUNE2FS_SCRATCH_DIR=./
+TDB_FILE=./tune2fs-test.img
+OUT=$test_name.log
+rm -f $TDB_FILE >/dev/null 2>&1
+
+dd if=/dev/zero of=$TMPFILE bs=1k count=512 > /dev/null 2>&1
+
+echo mke2fs -q -F -o Linux -b 1024 test.img  >> $OUT
+$MKE2FS -q -F -o Linux -I 128 -b 1024 $TMPFILE  >/dev/null 2>&1
+md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum before tune2fs $md5 >> $OUT
+
+echo using tune2fs to test undoe2fs >> $OUT
+$TUNE2FS -I 256 $TMPFILE  >/dev/null 2>&1
+new_md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum after tune2fs $new_md5 >> $OUT
+
+$UNDOE2FS_EXE  $TDB_FILE $TMPFILE  >/dev/null 2>&1
+new_md5=$(md5sum $TMPFILE | cut -d " " -f 1)
+echo md5sum after undoe2fs $new_md5 >> $OUT
+
+if [ $md5 = $new_md5 ]; then
+	echo "ok"
+	touch $test_name.ok
+else
+	echo "failed"
+fi
+fi
-- 
1.5.3.rc4.67.gf9286-dirty
