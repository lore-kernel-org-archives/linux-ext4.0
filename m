From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] fs: prevent null pointer dereference for fs-less devices
Date: Wed, 20 Mar 2013 16:48:18 +0400
Message-ID: <1363783698-28092-2-git-send-email-dmonakhov@openvz.org>
References: <1363783698-28092-1-git-send-email-dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
	jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1251 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab3CTMtR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 08:49:17 -0400
In-Reply-To: <1363783698-28092-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/block_dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 172f849..e13d1df 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -228,7 +228,8 @@ struct super_block *freeze_bdev(struct block_device *bdev)
 		 * thaw_bdev drops it.
 		 */
 		sb = get_super(bdev);
-		drop_super(sb);
+		if (sb)
+			drop_super(sb);
 		mutex_unlock(&bdev->bd_fsfreeze_mutex);
 		return sb;
 	}
-- 
1.7.1

