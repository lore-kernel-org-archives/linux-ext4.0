From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH V2] xfstests: several 274 fixups
Date: Thu, 08 Mar 2012 16:23:03 -0600
Message-ID: <4F593147.8050603@sandeen.net>
References: <4F271967.10308@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: xfs-oss <xfs@oss.sgi.com>, WuBo <wu.bo@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53601 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862Ab2CHWXG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Mar 2012 17:23:06 -0500
In-Reply-To: <4F271967.10308@sandeen.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This changes quite a few things about 274 to make it more robust
and useful.

* More comments
* Use xfs_io for falloc (not all systems have /usr/bin/fallocate)
* use _require_xfs_io_falloc to be sure system & fs support preallocation
* Do not remove all of the files in $SCRATCH_MNT/ post-mkfs
* Do not remove all of the files in $SCRATCH_MNT/ on completion
  (this breaks e2fsck when lost+found/ goes missing)
* Don't cd into $SCRATCH_MNT
* Try harder to completely fill the fs
* Use a larger preallocated space, and write into all of it (hopefully
  avoid just accidentally succeeding by writing into fs reserved
  space that may be there)
* Save more output in $seq.full instead of /dev/null
* Fill preallocated space diabolically

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Several fixes suggested by Dave.
Also fills prealloc space diabolically.  This fails on ext4.

diff --git a/274 b/274
index b658004..bba5eb4 100755
--- a/274
+++ b/274
@@ -1,7 +1,9 @@
 #! /bin/bash
 # FS QA Test No. 274
 #
-# preallocation test
+# preallocation test:
+# Preallocate space to a file, and fill the rest of the fs to 100%.
+# Then test a write into that preallocated space, which should succeed.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2011-2012 Fujitsu, Inc.  All Rights Reserved.
@@ -35,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -f $SCRATCH_MNT/* $tmp.*
+	rm -f $tmp.*
 	_scratch_unmount
 }
 
@@ -46,6 +48,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 _require_scratch
+_require_xfs_io_falloc
 
 echo "------------------------------"
 echo "preallocation test"
@@ -57,35 +60,42 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-rm -rf $SCRATCH_MNT/*
-cd $SCRATCH_MNT
-dd if=/dev/zero of=test bs=4K count=1 >/dev/null 2>&1
-if [ $? -ne 0 ]
-then
-	echo "create file err"
-	status=1
-	exit
-fi
+# Create a 4k file and Allocate 4M past EOF on that file
+xfs_io -F -f -c "pwrite 0 4k" -c "falloc -k 4k 4m" $SCRATCH_MNT/test \
+	>>$seq.full 2>&1 || _fail "failed to create test file"
 
-fallocate -n -o 4K -l 1M test >/dev/null 2>&1
-if [ $? -ne 0 ]
-then
-	echo "fallocate file err"
-	status=1
-	exit
-fi
-
-dd if=/dev/zero of=tmp1 bs=1M >/dev/null 2>&1
-dd if=/dev/zero of=tmp2 bs=4K >/dev/null 2>&1
+# Fill the rest of the fs completely
+# Note, this will show ENOSPC errors in $seq.full, that's ok.
+echo "Fill fs with 1M IOs; EIO expected" >> $seq.full
+dd if=/dev/zero of=$SCRATCH_MNT/tmp1 bs=1M >>$seq.full 2>&1
+echo "Fill fs with 4K IOs; EIO expected" >> $seq.full
+dd if=/dev/zero of=$SCRATCH_MNT/tmp2 bs=4K >>$seq.full 2>&1
 sync
+# Last effort, use O_SYNC
+echo "Fill fs with 4K DIOs; EIO expected" >> $seq.full
+dd if=/dev/zero of=$SCRATCH_MNT/tmp3 bs=4K oflag=sync >>$seq.full 2>&1
+# Save space usage info
+echo "Post-fill space:" >> $seq.full
+df $SCRATCH_MNT >>$seq.full 2>&1
 
-dd if=/dev/zero of=test seek=1 bs=4K count=2 conv=notrunc >/dev/null 2>&1
-if [ $? -ne 0 ]
-then
-	echo "fill prealloc range err"
-	status=1
-	exit
-fi
+# Now attempt a write into all of the preallocated space -
+# in a very nasty way, badly fragmenting it and then filling it in.
+echo "Fill in prealloc space; fragment at offsets:" >> $seq.full
+for i in `seq 1 2 1023`; do
+	echo -n "$i " >> $seq.full
+	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
+		>>$seq.full 2>/dev/null || _fail "failed to write to test file"
+done
+sync
+echo >> $seq.full
+echo "Fill in prealloc space; fill holes at offsets:" >> $seq.full
+for i in `seq 2 2 1023`; do
+	echo -n "$i " >> $seq.full
+	dd if=/dev/zero of=$SCRATCH_MNT/test seek=$i bs=4K count=1 conv=notrunc \
+		>>$seq.full 2>/dev/null || _fail "failed to fill test file"
+done
+sync
+echo >> $seq.full
 
 echo "done"
 exit


