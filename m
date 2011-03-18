From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: critical info format fix in __ext4_grp_locked_error
Date: Fri, 18 Mar 2011 17:58:03 +0800
Message-ID: <1300442283-31421-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, Tao Ma <boyu.mt@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42145 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab1CRJ6O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Mar 2011 05:58:14 -0400
Received: by iyb26 with SMTP id 26so3794054iyb.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2011 02:58:14 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When we do performence-testing on ext4 filesystem, we observe a warning like this:

"[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd"

indeed, it should be

"group 2598, 25901 blocks in bitmap, 26057 in gd"

This bug is found on upstream 2.6.36 kernel. We ran a 2.6.36 kernel on the online system with 8 Ext4 file systems. 2 of them are mounted with delayed allocation feature. This warning is only observed on delayed allocation enabled Ext4 file systems.

This issue is not easy to reproduce, on two servers with 2.6.36 kenrel + ext4, after running 110+ days, the error starts to appear on kernel log. When check the error log, we found the info format should be fixed, that's how this patch comes.

Reviewed-by: Coly Li <bosong.ly@taobao.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f6a318f..bb38475 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -594,7 +594,7 @@ __acquires(bitlock)
 
 	vaf.fmt = fmt;
 	vaf.va = &args;
-	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u",
+	printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
 	       sb->s_id, function, line, grp);
 	if (ino)
 		printk(KERN_CONT "inode %lu: ", ino);
-- 
1.7.3.5

