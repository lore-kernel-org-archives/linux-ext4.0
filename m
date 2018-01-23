From: harshads <harshads@google.com>
Subject: [PATCH v4] ext4: Ext4 online resize with bigalloc tests.
Date: Tue, 23 Jan 2018 13:53:57 -0800
Message-ID: <20180123215357.261381-1-harshads@google.com>
References: <20180111070740.GE5123@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        harshads <harshads@google.com>
To: eguan@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:45746 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752591AbeAWVyw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jan 2018 16:54:52 -0500
Received: by mail-pf0-f193.google.com with SMTP id a88so1374264pfe.12
        for <linux-ext4@vger.kernel.org>; Tue, 23 Jan 2018 13:54:52 -0800 (PST)
In-Reply-To: <20180111070740.GE5123@eguan.usersys.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add tests to verify Ext4 online resizing feature with bigalloc feature
enabled. We test various resizing scenarios with different cluster
sizes.

Signed-off-by: Harshad Shirwadkar <harshads@google.com>
---
 tests/ext4/030     | 174 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/030.out | 172 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/group   |   1 +
 3 files changed, 347 insertions(+)
 create mode 100755 tests/ext4/030
 create mode 100644 tests/ext4/030.out

diff --git a/tests/ext4/030 b/tests/ext4/030
new file mode 100755
index 00000000..9e91b96a
--- /dev/null
+++ b/tests/ext4/030
@@ -0,0 +1,174 @@
+#! /bin/bash
+# FS QA Test ext4/030
+#
+# Ext4 online resize tests of small and crucial resizes with bigalloc
+# feature.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
+#
+# Author: Harshad Shirwadkar <harshads@google.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,	 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+BLK_SIZ=4096
+CLUSTER_SIZ=4096
+
+IMG_FILE=$SCRATCH_DIR/$seq.fs
+IMG_MNT=$SCRATCH_DIR/$seq.mnt
+
+## Num clusters to blocks.
+c2b()
+{
+	local clusters=$1
+	echo $(($clusters * $CLUSTER_SIZ / $BLK_SIZ))
+}
+
+_ext4_online_resize()
+{
+	## sizes are in number of blocks.
+	local original_size=$1
+	local final_size=$2
+
+	## Start with a clean image file.
+	echo "" > ${IMG_FILE}
+	echo "+++ truncate image file to $final_size" | \
+		tee -a $seqres.full
+	$XFS_IO_PROG -f -c "truncate $(($final_size * $BLK_SIZ))" ${IMG_FILE}
+	LOOP_DEVICE=`_create_loop_device $IMG_FILE || _fail "losetup failed"`
+
+	echo "+++ create fs on image file $original_size" | \
+		tee -a $seqres.full
+
+	${MKFS_PROG}.${FSTYP} -F -O bigalloc,resize_inode -C $CLUSTER_SIZ \
+		-b $BLK_SIZ ${LOOP_DEVICE} $original_size >> \
+		$seqres.full 2>&1 || _fail "mkfs failed"
+
+	echo "+++ mount image file" | tee -a $seqres.full
+	$MOUNT_PROG -t ${FSTYP} ${LOOP_DEVICE} ${IMG_MNT} > \
+		/dev/null 2>&1 || _fail "mount failed"
+
+	echo "+++ resize fs to $final_size" | tee -a $seqres.full
+
+	resize2fs -f ${LOOP_DEVICE} $final_size >> \
+		  $seqres.full 2>&1 || return 1
+
+	echo "+++ umount fs" | tee -a $seqres.full
+	$UMOUNT_PROG ${IMG_MNT}
+
+	echo "+++ check fs" | tee -a $seqres.full
+	_check_generic_filesystem $LOOP_DEVICE >> $seqres.full 2>&1 || \
+		_fail "fsck should not fail"
+	_destroy_loop_device $LOOP_DEVICE && LOOP_DEVICE=
+}
+
+_cleanup()
+{
+	cd /
+	[ -n "$LOOP_DEVICE" ] && _destroy_loop_device $LOOP_DEVICE > /dev/null 2>&1
+	rm -f $tmp.*
+	$UMOUNT_PROG ${IMG_MNT} > /dev/null 2>&1
+	rm -f ${IMG_FILE} > /dev/null 2>&1
+}
+
+# get standard environment and checks
+. ./common/rc
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_loop
+_require_scratch
+# We use resize_inode to make sure that block group descriptor table
+# can be extended.
+_require_scratch_ext4_feature "bigalloc,resize_inode,metadata_csum"
+
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount
+
+rm -f $seqres.full
+
+mkdir -p $IMG_MNT || _fail "cannot create loopback mount point"
+
+# Check if online resizing with bigalloc is supported by the kernel
+_ext4_online_resize 4096 8192 || \
+	_notrun "Kernel doesn't support online resizing with bigalloc"
+
+## We perform resizing to various multiples of block group sizes to
+## ensure that we cover maximum edge cases in the kernel code.
+for CLUSTER_SIZ in 4096 16384 65536; do
+	echo "++ set cluster size to $CLUSTER_SIZ" | tee -a $seqres.full
+
+	##
+	## Extend last group tests
+	##
+
+	## Extending a 1/2 block group to a 2/3 block group.
+	_ext4_online_resize $(c2b 16384) $(c2b 24576) \
+		|| _fail "resize failed"
+	## Extending a 2/3rd block group to one cluster less than a
+	## full block group.
+	_ext4_online_resize $(c2b 24576) $(c2b 32767) \
+		|| _fail "resize failed"
+	## Extending a 2/3rd block group to a full block group.
+	_ext4_online_resize $(c2b 24576) $(c2b 32768) \
+		|| _fail "resize failed"
+
+	##
+	## Extend last group and add more block groups.
+	##
+
+	## Extending a 2/3rd block group to 2 block groups.
+	_ext4_online_resize $(c2b 24576) $(c2b 65536) \
+		|| _fail "resize failed"
+	## Extending a 2/3rd block group to 15 block groups and one
+	## cluster.
+	_ext4_online_resize $(c2b 24576) $(c2b 491521) \
+		|| _fail "resize failed"
+	## Extending a 2/3rd block group to 15 and a half block groups.
+	_ext4_online_resize $(c2b 24576) $(c2b 507904) \
+		|| _fail "resize failed"
+
+	## Extending a 2/3rd block group to 16 block groups.
+	_ext4_online_resize $(c2b 24576) $(c2b 524288) \
+		|| _fail "resize failed"
+	## Extending a 2/3rd block group to 160 block groups.
+	_ext4_online_resize $(c2b 24576) $(c2b 5242880) \
+		|| _fail "resize failed"
+
+	##
+	## Convert to meta_bg.
+	##
+
+	## Extending a 2/3rd block group to 1280 block groups.
+	_ext4_online_resize $(c2b 24576) $(c2b 41943040) \
+		|| _fail "resize failed"
+done
+
+status=0
+exit
diff --git a/tests/ext4/030.out b/tests/ext4/030.out
new file mode 100644
index 00000000..49304654
--- /dev/null
+++ b/tests/ext4/030.out
@@ -0,0 +1,172 @@
+QA output created by 030
++++ truncate image file to 8192
++++ create fs on image file 4096
++++ mount image file
++++ resize fs to 8192
++++ umount fs
++++ check fs
+++ set cluster size to 4096
++++ truncate image file to 24576
++++ create fs on image file 16384
++++ mount image file
++++ resize fs to 24576
++++ umount fs
++++ check fs
++++ truncate image file to 32767
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 32767
++++ umount fs
++++ check fs
++++ truncate image file to 32768
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 32768
++++ umount fs
++++ check fs
++++ truncate image file to 65536
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 65536
++++ umount fs
++++ check fs
++++ truncate image file to 491521
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 491521
++++ umount fs
++++ check fs
++++ truncate image file to 507904
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 507904
++++ umount fs
++++ check fs
++++ truncate image file to 524288
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 524288
++++ umount fs
++++ check fs
++++ truncate image file to 5242880
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 5242880
++++ umount fs
++++ check fs
++++ truncate image file to 41943040
++++ create fs on image file 24576
++++ mount image file
++++ resize fs to 41943040
++++ umount fs
++++ check fs
+++ set cluster size to 16384
++++ truncate image file to 98304
++++ create fs on image file 65536
++++ mount image file
++++ resize fs to 98304
++++ umount fs
++++ check fs
++++ truncate image file to 131068
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 131068
++++ umount fs
++++ check fs
++++ truncate image file to 131072
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 131072
++++ umount fs
++++ check fs
++++ truncate image file to 262144
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 262144
++++ umount fs
++++ check fs
++++ truncate image file to 1966084
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 1966084
++++ umount fs
++++ check fs
++++ truncate image file to 2031616
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 2031616
++++ umount fs
++++ check fs
++++ truncate image file to 2097152
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 2097152
++++ umount fs
++++ check fs
++++ truncate image file to 20971520
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 20971520
++++ umount fs
++++ check fs
++++ truncate image file to 167772160
++++ create fs on image file 98304
++++ mount image file
++++ resize fs to 167772160
++++ umount fs
++++ check fs
+++ set cluster size to 65536
++++ truncate image file to 393216
++++ create fs on image file 262144
++++ mount image file
++++ resize fs to 393216
++++ umount fs
++++ check fs
++++ truncate image file to 524272
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 524272
++++ umount fs
++++ check fs
++++ truncate image file to 524288
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 524288
++++ umount fs
++++ check fs
++++ truncate image file to 1048576
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 1048576
++++ umount fs
++++ check fs
++++ truncate image file to 7864336
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 7864336
++++ umount fs
++++ check fs
++++ truncate image file to 8126464
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 8126464
++++ umount fs
++++ check fs
++++ truncate image file to 8388608
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 8388608
++++ umount fs
++++ check fs
++++ truncate image file to 83886080
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 83886080
++++ umount fs
++++ check fs
++++ truncate image file to 671088640
++++ create fs on image file 393216
++++ mount image file
++++ resize fs to 671088640
++++ umount fs
++++ check fs
diff --git a/tests/ext4/group b/tests/ext4/group
index 257bb646..f29d3de6 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -32,6 +32,7 @@
 027 auto quick fsmap
 028 auto quick fsmap
 029 auto quick fsmap
+030 auto quick ioctl resize
 271 auto rw quick
 301 aio auto ioctl rw stress defrag
 302 aio auto ioctl rw stress defrag
-- 
2.16.0.rc1.238.g530d649a79-goog
