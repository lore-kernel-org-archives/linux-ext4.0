From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 5/5] ext4: fix wrong the number of the allocted blocks in ext4_split_extent
Date: Wed,  6 Mar 2013 22:17:15 +0800
Message-ID: <1362579435-6333-6-git-send-email-wenqing.lz@taobao.com>
References: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62033 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3CFOCg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Mar 2013 09:02:36 -0500
Received: by mail-pb0-f44.google.com with SMTP id wz12so6041967pbc.31
        for <linux-ext4@vger.kernel.org>; Wed, 06 Mar 2013 06:02:35 -0800 (PST)
In-Reply-To: <1362579435-6333-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit fixes a wrong return value of the number of the allocated
blocks in ext4_split_extent.  When the length of blocks we want to
allocated is greater than the length of the current extent, we return a
wrong number.  Let's see what happens in the following case when we call
ext4_split_extent().

  map: [48, 72]
  ex:  [32, 64, u]

'ex' will be splitted in to two parts:
  ex1: [32, 47, u]
  ex2: [48, 64, w]

'map->m_len' is returned from this function, and the value is 24.  But
the real length is 16.  So it should be fixed.

Meanwhile in this commit we use right length of the allocated blocks
when get_reserved_cluster_alloc in ext4_ext_handle_uninitialized_extents
is called.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7e37018..69df02f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3067,6 +3067,7 @@ static int ext4_split_extent(handle_t *handle,
 	int err = 0;
 	int uninitialized;
 	int split_flag1, flags1;
+	int allocated = map->m_len;
 
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
@@ -3086,6 +3087,8 @@ static int ext4_split_extent(handle_t *handle,
 				map->m_lblk + map->m_len, split_flag1, flags1);
 		if (err)
 			goto out;
+	} else {
+		allocated = ee_len - (map->m_lblk - ee_block);
 	}
 	/*
 	 * Update path is required because previous ext4_split_extent_at() may
@@ -3115,7 +3118,7 @@ static int ext4_split_extent(handle_t *handle,
 
 	ext4_ext_show_leaf(inode, path);
 out:
-	return err ? err : map->m_len;
+	return err ? err : allocated;
 }
 
 /*
@@ -3730,6 +3733,7 @@ out:
 					allocated - map->m_len);
 		allocated = map->m_len;
 	}
+	map->m_len = allocated;
 
 	/*
 	 * If we have done fallocate with the offset that is already
-- 
1.7.12.rc2.18.g61b472e

