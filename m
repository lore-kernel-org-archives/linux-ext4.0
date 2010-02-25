From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: Handle non empty on-disk orphan link
Date: Fri, 26 Feb 2010 00:20:07 +0300
Message-ID: <1267132807-5882-3-git-send-email-dmonakhov@openvz.org>
References: <1267132807-5882-1-git-send-email-dmonakhov@openvz.org>
 <1267132807-5882-2-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:57660 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab0BYVUT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Feb 2010 16:20:19 -0500
Received: by mail-bw0-f209.google.com with SMTP id 1so3261752bwz.21
        for <linux-ext4@vger.kernel.org>; Thu, 25 Feb 2010 13:20:18 -0800 (PST)
In-Reply-To: <1267132807-5882-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In case of truncate errors we explicitly remove inode from in-core
orphan list via orphan_del(NULL, inode) without on-disk list
modification.
But later same inode may be inserted in the orphan list again which
result in on-disk link corruption.  If inode i_dtime contains valid
value let skip on-disk list modification.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/namei.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 17a17e1..19ca9bf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2020,6 +2020,13 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
 		goto out_unlock;
+	/*
+	 * Due to previous errors inode may be already a part of on-disk
+	 * orphan list. If so skipp on-disk list modification.
+	 */
+	if (NEXT_ORPHAN(inode) && NEXT_ORPHAN(inode) <=
+		(le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count)))
+			goto mem_insert;
 
 	/* Insert this inode at the head of the on-disk orphan list... */
 	NEXT_ORPHAN(inode) = le32_to_cpu(EXT4_SB(sb)->s_es->s_last_orphan);
@@ -2037,6 +2044,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	 *
 	 * This is safe: on error we're going to ignore the orphan list
 	 * anyway on the next recovery. */
+mem_insert:
 	if (!err)
 		list_add(&EXT4_I(inode)->i_orphan, &EXT4_SB(sb)->s_orphan);
 
-- 
1.6.6

