From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] [PATCH] xfstests: use -F when making scratch ext4 fs
Date: Fri, 26 Apr 2013 15:16:53 -0400
Message-ID: <1367003813-17686-1-git-send-email-jbacik@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-ext4@vger.kernel.org>, <xfs@oss.sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58072 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab3DZTQz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Apr 2013 15:16:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 9FE799A033F
	for <linux-ext4@vger.kernel.org>; Fri, 26 Apr 2013 13:16:55 -0600 (MDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

mkfs.ext4 will ask you if you are sure if you try to mkfs an entire disk instead
of just a partition, so any xfstest that uses a scratch device and you specify a
full disk will appear to hang because it's waiting for you to say yes.  This
fixes the problem by just forcing it to do its thing.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 common/rc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common/rc b/common/rc
index ff18cc2..9d1c3fc 100644
--- a/common/rc
+++ b/common/rc
@@ -485,7 +485,7 @@ _scratch_mkfs_ext4()
 {
 	local tmp_dir=/tmp/
 
-	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
+	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
 			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
 	local mkfs_status=$?
 
-- 
1.7.7.6

