From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix incorrect lock ordering for ext4_ext_migrate
Date: Mon,  1 Apr 2013 11:31:02 +0400
Message-ID: <1364801462-13120-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:10916 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758168Ab3DAHbO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 03:31:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

existing locking ordering: journal-> i_data_sem, but
ext4_ext_migrate() grab locks in opposite order which may result
in deacklock.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e4a6844..1530cf4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4627,6 +4627,10 @@ int ext4_ind_migrate(struct inode *inode)
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
 		return -EINVAL;
 
+	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_ext_check_inode(inode);
 	if (ret)
@@ -4650,19 +4654,13 @@ int ext4_ind_migrate(struct inode *inode)
 		}
 	}
 
-	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto errout;
-	}
