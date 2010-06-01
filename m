From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] quota: check quota reservation on remove_dquot_ref
Date: Tue,  1 Jun 2010 11:39:48 +0400
Message-ID: <1275377988-4299-2-git-send-email-dmonakhov@openvz.org>
References: <20100531191130.GE5334@quack.suse.cz>
 <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46153 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0FAHj4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jun 2010 03:39:56 -0400
In-Reply-To: <1275377988-4299-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reserved space must being claimed before remove_dquot_ref() for a
given inode. Filesystem is responsible for performing force blocks
allocation in case of dealloc in ->quota_off. Let's add sanity check
for that case. Do it similar to add_dquot_ref().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/quota/dquot.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 12c233d..dfb8c16 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -986,6 +986,7 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 		struct list_head *tofree_head)
 {
 	struct inode *inode;
+	int reserved = 0;
 
 	spin_lock(&inode_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
@@ -995,10 +996,21 @@ static void remove_dquot_ref(struct super_block *sb, int type,
 		 *  only quota pointers and these have separate locking
 		 *  (dqptr_sem).
 		 */
-		if (!IS_NOQUOTA(inode))
+		if (!IS_NOQUOTA(inode)) {
+			if (unlikely(inode_get_rsv_space(inode) > 0))
+				reserved = 1;
 			remove_inode_dquot_ref(inode, type, tofree_head);
+		}
 	}
 	spin_unlock(&inode_lock);
+#ifdef CONFIG_QUOTA_DEBUG
+	if (reserved) {
+		printk(KERN_WARNING "VFS (%s): Writes happened after quota"
+			" was disabled thus quota information is probably "
+			"inconsistent. Please run quotacheck(8).\n", sb->s_id);
+	}
+#endif
+
 }
 
 /* Gather all references from inodes and drop them */
-- 
1.6.6.1

