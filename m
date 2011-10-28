From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/7] ext4: Update inode's transaction id after punch_hole
Date: Fri, 28 Oct 2011 21:00:08 +0400
Message-ID: <1319821210-7374-6-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64725 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1J1RAZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:25 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so624053bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:25 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0365173..5cce39a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3289,6 +3289,7 @@ ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
 	if (!err && ext4_ext_try_shrink(handle, inode))
 		err = ext4_mark_inode_dirty(handle, inode);
 out:
+	ext4_update_inode_fsync_trans(handle, inode, 0);
 	if (path) {
 		ext4_ext_drop_refs(path);
 		kfree(path);
-- 
1.7.1

