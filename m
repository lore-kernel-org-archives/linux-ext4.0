From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH] Make orphan functions no-op in no-journal mode
Date: Tue, 18 Sep 2012 08:53:05 -0700
Message-ID: <1347983585-22940-1-git-send-email-anatol.pomozov@gmail.com>
References: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:65226 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757332Ab2IRPxP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Sep 2012 11:53:15 -0400
Received: by vbis24 with SMTP id s24so843274vbi.1
        for <linux-ext4@vger.kernel.org>; Tue, 18 Sep 2012 08:53:14 -0700 (PDT)
In-Reply-To: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of checking whether the handle is valid, we check if journal is
enabled. This avoids using shared mutext usage in all cases when
ext4_orphan_del(NULL,..) is called in no-journal mode (i.e. in error
path).

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..341ab7e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2362,7 +2362,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle))
+	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2436,8 +2436,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
+	if (!EXT4_SB(inode->i_sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
@@ -2456,7 +2455,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-- 
1.7.12

