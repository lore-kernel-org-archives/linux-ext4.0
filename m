From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/8] xfstests: get rid of hardcoded /sbin/mkfs
Date: Wed, 13 Feb 2013 12:49:57 +0400
Message-ID: <1360745403-6373-3-git-send-email-dmonakhov@openvz.org>
References: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44063 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab3BMIub (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2013 03:50:31 -0500
In-Reply-To: <1360745403-6373-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common.rc |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index f5027e7..196619d 100644
--- a/common.rc
+++ b/common.rc
@@ -334,7 +334,7 @@ _scratch_mkfs()
         $MKFS_BTRFS_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
     *)
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
+	$MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
     esac
 }
@@ -353,7 +353,7 @@ _scratch_mkfs_sized()
 	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
 	;;
     ext2|ext3|ext4|ext4dev)
-	/sbin/mkfs.$FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
+	$MKFS_PROG -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
 	;;
     btrfs)
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS -b $fssize $SCRATCH_DEV
-- 
1.7.1

