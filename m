From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: fix the incorrect info of /proc/mounts after mount no-journal fs
Date: Thu, 19 May 2011 10:11:34 +0800
Message-ID: <1305771094-2976-1-git-send-email-sanbai@taobao.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45267 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1ESCLp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 May 2011 22:11:45 -0400
Received: by pwi15 with SMTP id 15so1017194pwi.19
        for <linux-ext4@vger.kernel.org>; Wed, 18 May 2011 19:11:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After mkfs without journal:

  # mkfs.ext4 -O ^has_journal /dev/sda
  # mount -t ext4 /dev/sda /test

the /proc/mounts will show:
"/dev/sda /test ext4 rw,relatime,user_xattr,acl,barrier=1,data=writeback 0 0"
which usually make users think the fs is using writeback-mode.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/super.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..4ea1e85 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3474,7 +3474,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount_wq;
 	} else {
 		clear_opt(sb, DATA_FLAGS);
-		set_opt(sb, WRITEBACK_DATA);
+		if (EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_HAS_JOURNAL))
+			set_opt(sb, WRITEBACK_DATA);
 		sbi->s_journal = NULL;
 		needs_recovery = 0;
 		goto no_journal;
-- 
1.7.1

