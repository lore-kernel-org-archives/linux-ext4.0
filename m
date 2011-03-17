From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: critical info format fix in __ext4_grp_locked_error
Date: Thu, 17 Mar 2011 09:56:31 +0800
Message-ID: <1300326991-22794-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>, stable@kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45422 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab1CQB4z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Mar 2011 21:56:55 -0400
Received: by pzk9 with SMTP id 9so367050pzk.19
        for <linux-ext4@vger.kernel.org>; Wed, 16 Mar 2011 18:56:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When we do performence-testing on ext4 filesystem, we observe a warning like this:

"[ 1684.113205] EXT4-fs error (device sda7): ext4_mb_generate_buddy:718: group 259825901 blocks in bitmap, 26057 in gd"

indeed, it should be

"group 2598, 25901 blocks in bitmap, 26057 in gd"

Reviewed-by: Coly Li <bosong.ly@taobao.com>
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

