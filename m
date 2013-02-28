From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/6] ext4: fix wrong m_len value after unwritten extent conversion
Date: Fri,  1 Mar 2013 02:26:42 +0800
Message-ID: <1362076004-10087-5-git-send-email-wenqing.lz@taobao.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:48661 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3B1SL6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:11:58 -0500
Received: by mail-pa0-f54.google.com with SMTP id fa10so1284476pad.27
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:11:58 -0800 (PST)
In-Reply-To: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
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
index 372b2cb..0793a13 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3626,6 +3626,10 @@ ext4_ext_handle_uninitialized_extents(handle_t *handle, struct inode *inode,
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

