From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: [PATCH 1/2] Make orphan functions no-op in no-journal mode
Date: Mon, 17 Sep 2012 10:47:16 -0700
Message-ID: <1347904037-24229-1-git-send-email-anatol.pomozov@gmail.com>
Cc: dmonakhov@openvz.org, Anatol Pomozov <anatol.pomozov@gmail.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33456 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2IQRro (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Sep 2012 13:47:44 -0400
Received: by lbbge1 with SMTP id ge1so416750lbb.1
        for <linux-ext4@vger.kernel.org>; Mon, 17 Sep 2012 10:47:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This avoids using shared mutext and thus improves scalability of
no-journal mode. The goal of this change is similar to 3d287de3b828
but it avoids mutex usage for all ext4_orphan_del(NULL,..) calls.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
---
 fs/ext4/namei.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 2a42cc0..6863cdf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2362,6 +2362,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
+	if (!EXT4_SB(sb)->s_journal)
+		return 0;
 	if (!ext4_handle_valid(handle))
 		return 0;
 
@@ -2436,6 +2438,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		return 0;
 	/* ext4_handle_valid() assumes a valid handle_t pointer */
 	if (handle && !ext4_handle_valid(handle))
 		return 0;
@@ -2456,7 +2460,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-- 
1.7.12

