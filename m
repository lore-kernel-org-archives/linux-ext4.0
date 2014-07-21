From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: use correct depth value
Date: Mon, 21 Jul 2014 19:04:48 +0400
Message-ID: <1405955089-12777-2-git-send-email-dmonakhov@openvz.org>
References: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:38083 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbaGUPFK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jul 2014 11:05:10 -0400
In-Reply-To: <1405955089-12777-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's depth can be changed from here:
ext4_ext_try_to_merge() ->ext4_ext_try_to_merge_up()
We must use correct value.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ee93f82..6950bab 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3254,7 +3254,7 @@ out:
 
 fix_extent_len:
 	ex->ee_len = orig_ex.ee_len;
-	ext4_ext_dirty(handle, inode, path + depth);
+	ext4_ext_dirty(handle, inode, path + path->p_depth);
 	return err;
 }
 
-- 
1.7.1

