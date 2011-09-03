From: Prasad Joshi <prasadjoshi.linux@gmail.com>
Subject: [PATCH] Assume yes when test device is not partitioned
Date: Sat,  3 Sep 2011 14:02:03 +0530
Message-ID: <1315038723-2009-1-git-send-email-prasadjoshi.linux@gmail.com>
Cc: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>,
	xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: prasadjoshi.linux@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:43875 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab1ICIcO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Sep 2011 04:32:14 -0400
Received: by pzk34 with SMTP id 34so2789847pzk.1
        for <linux-ext4@vger.kernel.org>; Sat, 03 Sep 2011 01:32:13 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an entire device used for file system creation, the mkfs.ext2/3/4
asks for confirmation before proceeding. Since the device is
configured for testing it is safe to assume positive response
during mkfs.

The patch also replaces hard coded mkfs path with MKFS_PROG variable.

Signed-off-by: Chaitanya Kulkarni <chaitanyakulkarni15@gmail.com>
Signed-off-by: Prasad Joshi <prasadjoshi.linux@gmail.com>
---
 032       |    4 ++--
 049       |    2 +-
 073       |    2 +-
 common.rc |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/032 b/032
index 4261ca2..bf88492 100755
--- a/032
+++ b/032
@@ -45,7 +45,7 @@ _require_nobigloopfs
 _require_scratch
 
 echo "Silence is golden."
-for fs in `echo /sbin/mkfs.* | sed -e 's/.sbin.mkfs.//g'`
+for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
 do
 	preop=""	# for special input needs
 	preargs=""	# for any special pre-device options
@@ -78,7 +78,7 @@ do
 	if [ $? -eq 0 ] ; then
 		# next, ensure we don't overwrite it
 		echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
-		/sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
+		${MKFS_PROG}.xfs $SCRATCH_DEV >>$seq.full 2>&1
 
 		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
 	else
diff --git a/049 b/049
index c6c4faa..8d4a22f 100755
--- a/049
+++ b/049
@@ -83,7 +83,7 @@ mount -t ext2 $SCRATCH_DEV $SCRATCH_MNT >> $seq.full 2>&1 \
     || _fail "!!! failed to mount"
 
 _log "Create xfs fs in file on scratch"
-/sbin/mkfs.xfs -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
+${MKFS_PROG}.xfs -f -dfile,name=$SCRATCH_MNT/test.xfs,size=40m \
     >> $seq.full 2>&1 \
     || _fail "!!! failed to mkfs xfs"
 
diff --git a/073 b/073
index 18257d4..fc0951f 100755
--- a/073
+++ b/073
@@ -155,7 +155,7 @@ _verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-/sbin/mkfs.xfs -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
+${MKFS_PROG}.xfs -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
 rmdir $imgs.source_dir 2>/dev/null
 mkdir $imgs.source_dir
 
diff --git a/common.rc b/common.rc
index 35f782b..a356c02 100644
--- a/common.rc
+++ b/common.rc
@@ -314,7 +314,7 @@ _scratch_mkfs()
         $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
     *)
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
+	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
     esac
 }
@@ -333,7 +333,7 @@ _scratch_mkfs_sized()
 	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
 	;;
     ext2|ext3|ext4|ext4dev)
-	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+	yes | ${MKFS_PROG}.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     btrfs)
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
-- 
1.7.4.1

