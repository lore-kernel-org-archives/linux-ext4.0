From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/6] ext4: invalidate exntent-status-tree during extent_migration
Date: Fri,  1 Mar 2013 02:26:39 +0800
Message-ID: <1362076004-10087-2-git-send-email-wenqing.lz@taobao.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53394 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3B1SLt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:11:49 -0500
Received: by mail-pb0-f42.google.com with SMTP id xb4so1221794pbc.29
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:11:49 -0800 (PST)
In-Reply-To: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

mext_replace_branches() will change inode's extents layout so
we have to drop corresponding cache.

TESTCASE:  301'th xfstest was not yet accepted to official xfstest's branch
and can be found here: https://github.com/dmonakhov/xfstests/commit/7b7efeee30a41109201e2040034e71db9b66ddc0

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/move_extent.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index d78c33e..c1f15b2 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -666,6 +666,14 @@ mext_replace_branches(handle_t *handle, struct inode *orig_inode,
 	int replaced_count = 0;
 	int dext_alen;
 
+	*err = ext4_es_remove_extent(orig_inode, from, count);
+	if (*err)
+		goto out;
+
+	*err = ext4_es_remove_extent(donor_inode, from, count);
+	if (*err)
+		goto out;
+
 	/* Get the original extent for the block "orig_off" */
 	*err = get_ext_path(orig_inode, orig_off, &orig_path);
 	if (*err)
-- 
1.7.12.rc2.18.g61b472e

