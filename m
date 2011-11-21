From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfstest: enable xfs_repair for large filesystem testing
Date: Mon, 21 Nov 2011 22:31:26 +1100
Message-ID: <1321875088-30801-7-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that large filesystem testing does not play free space games to
fill the space without IO, we can enable xfs_repair when running in
this mode. xfs_repair has had it's scalability problems solved, too,
so this is a safe thing to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/common.rc b/common.rc
index 34467ec..12bd349 100644
--- a/common.rc
+++ b/common.rc
@@ -1200,12 +1200,12 @@ _check_xfs_filesystem()
     extra_mount_options=""
     device=$1
     if [ "$2" != "none" ]; then
-       	extra_log_options="-l$2"
+	extra_log_options="-l$2"
         extra_mount_options="-ologdev=$2"
     fi
 
     if [ "$3" != "none" ]; then
-       	extra_rt_options="-r$3"
+	extra_rt_options="-r$3"
         extra_mount_options=$extra_mount_options" -ortdev=$3"
     fi
     extra_mount_options=$extra_mount_options" $MOUNT_OPTIONS"
@@ -1250,8 +1250,7 @@ _check_xfs_filesystem()
 
         ok=0
     fi
-    # repair doesn't scale massively at this stage, optionally skip it for now
-    [ "$LARGE_SCRATCH_DEV" = yes ] || \
+
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
-- 
1.7.5.4

