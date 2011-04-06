From: Amerigo Wang <amwang@redhat.com>
Subject: [Patch] ext4: remove a useless #ifdef in super.c
Date: Wed,  6 Apr 2011 14:02:01 +0800
Message-ID: <1302069721-19718-1-git-send-email-amwang@redhat.com>
Cc: akpm@linux-foundation.org, WANG Cong <amwang@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1DFGCW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Apr 2011 02:02:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is already an #ifdef CONFIG_QUOTA some lines above,
so this one is totally useless.

Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 22546ad..a5a73ac 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1170,9 +1170,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
 
 static const struct dquot_operations ext4_quota_operations = {
-#ifdef CONFIG_QUOTA
 	.get_reserved_space = ext4_get_reserved_space,
-#endif
 	.write_dquot	= ext4_write_dquot,
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
