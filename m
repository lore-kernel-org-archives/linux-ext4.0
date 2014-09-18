From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] ext4: fold ext4_nojournal_sops into ext4_sops
Date: Thu, 18 Sep 2014 16:26:29 -0400
Message-ID: <1411071989-4974-3-git-send-email-tytso@mit.edu>
References: <1411071989-4974-1-git-send-email-tytso@mit.edu>
Cc: Dexuan Cui <decui@microsoft.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36313 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbaIRU0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 16:26:40 -0400
In-Reply-To: <1411071989-4974-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There's no longer any need to have a separate set of super_operations
for nojournal mode.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 27 +--------------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 921d5b4..e747b97 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1123,27 +1123,6 @@ static const struct super_operations ext4_sops = {
 	.bdev_try_to_free_page = bdev_try_to_free_page,
 };
 
-static const struct super_operations ext4_nojournal_sops = {
-	.alloc_inode	= ext4_alloc_inode,
-	.destroy_inode	= ext4_destroy_inode,
-	.write_inode	= ext4_write_inode,
-	.dirty_inode	= ext4_dirty_inode,
-	.drop_inode	= ext4_drop_inode,
-	.evict_inode	= ext4_evict_inode,
-	.sync_fs	= ext4_sync_fs,
-	.freeze_fs	= ext4_freeze,
-	.unfreeze_fs	= ext4_unfreeze,
-	.put_super	= ext4_put_super,
-	.statfs		= ext4_statfs,
-	.remount_fs	= ext4_remount,
-	.show_options	= ext4_show_options,
-#ifdef CONFIG_QUOTA
-	.quota_read	= ext4_quota_read,
-	.quota_write	= ext4_quota_write,
-#endif
-	.bdev_try_to_free_page = bdev_try_to_free_page,
-};
