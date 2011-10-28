From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/7] ext4: punch_hole fix extent conversion
Date: Fri, 28 Oct 2011 21:00:07 +0400
Message-ID: <1319821210-7374-5-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1J1RAY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:24 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so624020bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:23 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently punched extent converted to uninitialized incorrectly,
in fact i'm not shure whenever we actually need that conversion,
but if we do that let's do it right.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 02dfe38..0365173 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3275,8 +3275,15 @@ ext4_ext_handle_punched_extent(handle_t *handle, struct inode *inode,
 		ex = path[path->p_depth].p_ext;
 	}
 
-	ext4_ext_mark_uninitialized(ex);
+	err = ext4_ext_get_access(handle, inode, path + path->p_depth);
+	if (err)
+		goto out;
 	ext4_ext_invalidate_cache(inode);
+	ext4_ext_mark_uninitialized(ex);
+	err = ext4_ext_dirty(handle, inode, path + path->p_depth);
+	if (err)
+		goto out;
+
 	err = ext4_ext_rm_leaf(handle, inode, path, &partial_cluster,
 			       map->m_lblk, map->m_lblk + punched_out);
 	if (!err && ext4_ext_try_shrink(handle, inode))
-- 
1.7.1

