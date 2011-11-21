From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfstests: always us test option when checking large scratch device
Date: Mon, 21 Nov 2011 22:31:27 +1100
Message-ID: <1321875088-30801-8-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Some tests call _check_scratch_device directly and when using a
large filesystem this needs to run with a -t option to avoid
consuming large amounts of memory. Make this happen in all cases
that the scratch device is checked.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 017       |    7 ++-----
 common.rc |    2 ++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/017 b/017
index 9ca0e72..0a3ede3 100755
--- a/017
+++ b/017
@@ -48,9 +48,6 @@ _supported_os Linux
 
 _require_scratch
 
-checkopts=""
-[ "$USE_BIG_LOOPFS" = yes ] && checkopts=-t
-
 echo "*** init FS"
 
 rm -f $seq.full
@@ -81,8 +78,8 @@ do
         echo ""                             >>$seq.full
         echo "*** XFS_CHECK ***"            >>$seq.full
         echo ""                             >>$seq.full
-        _scratch_xfs_check $checkopts       >>$seq.full 2>&1 \
-            || _fail "xfs_check $checkopts failed"
+        _scratch_xfs_check                  >>$seq.full 2>&1 \
+            || _fail "xfs_check failed"
         _scratch_mount -o remount,rw \
             || _fail "remount rw failed"
 done
diff --git a/common.rc b/common.rc
index 12bd349..9b9041f 100644
--- a/common.rc
+++ b/common.rc
@@ -470,6 +470,8 @@ _scratch_xfs_check()
     SCRATCH_OPTIONS=""
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
+    [ "$LARGE_SCRATCH_DEV" = yes ] && \
+        SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
     $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
-- 
1.7.5.4

