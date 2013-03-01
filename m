From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests: use right defrag program path
Date: Fri,  1 Mar 2013 22:17:13 +0800
Message-ID: <1362147433-5788-1-git-send-email-wenqing.lz@taobao.com>
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:57232 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CAOCP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Mar 2013 09:02:15 -0500
Received: by mail-pa0-f45.google.com with SMTP id kl14so1830668pab.18
        for <linux-ext4@vger.kernel.org>; Fri, 01 Mar 2013 06:02:14 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In _require_defrag defragmentation command path is fixed.  That will
cause that this test case is skipped in some distributions.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Dave Chinner <david@fromorbit.com>
---
[*NOTE*: this patch is Cc'ed to linux-ext4 mailing list because after
applied it xfstests #218 will fail against 3.8 and dev branch.]

v2 <- v1:
 * Define 'E4DEFRAG_PROG' and 'FILEFRAG_PROG' in common.config with
   set_prog_path

 common.config |  2 ++
 common.defrag | 10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/common.config b/common.config
index 7174127..9c99bfe 100644
--- a/common.config
+++ b/common.config
@@ -160,6 +160,8 @@ export INDENT_PROG="`set_prog_path indent`"
 export XFS_COPY_PROG="`set_prog_path xfs_copy`"
 export FSTRIM_PROG="`set_prog_path fstrim`"
 export DUMPE2FS_PROG="`set_prog_path dumpe2fs`"
+export FILEFRAG_PROG="`set_prog_path filefrag`"
+export E4DEFRAG_PROG="`set_prog_path e4defrag`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common.defrag b/common.defrag
index ea6c14c..9c9eb9b 100644
--- a/common.defrag
+++ b/common.defrag
@@ -24,10 +24,10 @@ _require_defrag()
 {
     case "$FSTYP" in
     xfs)
-        DEFRAG_PROG=/usr/sbin/xfs_fsr
+        DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4|ext4dev)
-        DEFRAG_PROG=/usr/bin/e4defrag
+        DEFRAG_PROG="$E4DEFRAG_PROG"
 	;;
     btrfs)
 	DEFRAG_PROG="$BTRFS_UTIL_PROG filesystem defragment"
@@ -38,13 +38,13 @@ _require_defrag()
     esac
 
     _require_command $DEFRAG_PROG
-    _require_command /usr/sbin/filefrag
+    _require_command $FILEFRAG_PROG
 }
 
 _extent_count()
 {
-	filefrag $1 | awk '{print $2}'
-	filefrag -v $1  >> $seq.full 2>&1
+	$FILEFRAG_PROG $1 | awk '{print $2}'
+	$FILEFRAG_PROG -v $1  >> $seq.full 2>&1
 }
 
 # Defrag file, check it, and remove it.
-- 
1.7.12.rc2.18.g61b472e

