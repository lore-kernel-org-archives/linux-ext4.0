From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/8] xfstests: rename RETAIN_AG_BYTES
Date: Mon, 21 Nov 2011 22:31:23 +1100
Message-ID: <1321875088-30801-4-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4924 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755631Ab1KULgs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Nov 2011 06:36:48 -0500
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dave Chinner <dchinner@redhat.com>

Rename the $RETAIN_AG_BYTES variable to be more generic so that it
reflects the fact that it is designed to retain a certain amount of
extra free space above the default amount in the filesystem when
doing large scratch device testing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index fdeef1c..455886d 100644
--- a/common.rc
+++ b/common.rc
@@ -311,8 +311,8 @@ _scratch_mkfs_xfs()
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
     if [ "$LARGE_SCRATCH_DEV" = yes ]; then
-        [ -z "$RETAIN_AG_BYTES" ] && RETAIN_AG_BYTES=0
-        ./tools/ag-wipe -q -r $RETAIN_AG_BYTES $SCRATCH_DEV
+        [ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+        ./tools/ag-wipe -q -r $SCRATCH_DEV_EMPTY_SPACE $SCRATCH_DEV
     fi
 
     return $mkfs_status
-- 
1.7.5.4

