From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/2] common: make _dmerror_init accept device and mount point as param
Date: Fri, 11 Mar 2016 23:40:21 +0800
Message-ID: <1457710822-30532-1-git-send-email-eguan@redhat.com>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>
To: fstests@vger.kernel.org
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Currently dmerror code takes use of SCRATCH_DEV and SCRATCH_MNT as the
backend device and mount point, and there's no way to change them.

Now teach _dmerror_init to accept first argument as backend device and
second argument as the alternative mount point, this can be useful when
SCRATCH_DEV and/or SCRATCH_MNT is not suitable for the test.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/dmerror | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/common/dmerror b/common/dmerror
index 004530d..b2f1e8f 100644
--- a/common/dmerror
+++ b/common/dmerror
@@ -20,7 +20,8 @@
 
 _dmerror_init()
 {
-	local dm_backing_dev=$SCRATCH_DEV
+	local dm_backing_dev=${1:-$SCRATCH_DEV}
+	DMERROR_MNT=${2:-$SCRATCH_MNT}
 
 	$DMSETUP_PROG remove error-test > /dev/null 2>&1
 
@@ -38,7 +39,7 @@ _dmerror_init()
 
 _dmerror_mount_options()
 {
-	echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
+	echo `_common_dev_mount_options $*` $DMERROR_DEV $DMERROR_MNT
 }
 
 _dmerror_mount()
@@ -48,12 +49,12 @@ _dmerror_mount()
 
 _dmerror_unmount()
 {
-	umount $SCRATCH_MNT
+	umount $DMERROR_MNT
 }
 
 _dmerror_cleanup()
 {
-	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	$UMOUNT_PROG $DMERROR_MNT > /dev/null 2>&1
 	$DMSETUP_PROG remove error-test > /dev/null 2>&1
 }
 
-- 
2.5.0
