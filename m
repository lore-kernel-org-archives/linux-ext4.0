From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 3/5] ext4: fix wrong m_len value after unwritten extent conversion
Date: Wed,  6 Mar 2013 22:17:13 +0800
Message-ID: <1362579435-6333-4-git-send-email-wenqing.lz@taobao.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:60241 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3CFOC0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Mar 2013 09:02:26 -0500
Received: by mail-pb0-f41.google.com with SMTP id um15so6070528pbc.0
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2013 06:02:25 -0800 (PST)
In-Reply-To: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We always assume that the return value of ext4_ext_map_blocks is equal
to map->m_len but when we try to convert an unwritten extent 'm_len'
value will break this assumption.  It is harmless until we use status
tree as a extent cache because we need to update status tree according
to 'm_len' value.

Meanwhile this commit marks EXT4_MAP_MAPPED flag after unwritten extent
conversion.  It shouldn't cause a bug because we update status tree
according to checking EXT4_MAP_UNWRITTEN flag.  But it should be fixed.

After applied this commit, the following error message from self-testing
infrastructure disappears.

    ...
    kernel: ES len assertation failed for inode: 230 retval 1 !=
    map->m_len 3 in ext4_map_blocks (allocation)
    ...

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 25c86aa..110e85a 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3650,6 +3650,10 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
 						 path, map->m_len);
 		} else
 			err = ret;
+		map->m_flags |= EXT4_MAP_MAPPED;
+		if (allocated > map->m_len)
+			allocated = map->m_len;
+		map->m_len = allocated;
 		goto out2;
 	}
 	/* buffered IO case */
-- 
1.7.12.rc2.18.g61b472e

