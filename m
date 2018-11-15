Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:37645 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbeKOQrb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 11:47:31 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: jack@suse.com
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext2: change reusable parameter to true when calling mb_cache_entry_create()
Date: Thu, 15 Nov 2018 14:40:08 +0800
Message-Id: <20181115064008.21056-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reusable parameter of mb_cache_entry_create() is bool type,
so it's better to set true instead of 1.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext2/xattr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 62d9a659a8ff..6bab2432b717 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -835,7 +835,8 @@ ext2_xattr_cache_insert(struct mb_cache *cache, struct buffer_head *bh)
 	__u32 hash = le32_to_cpu(HDR(bh)->h_hash);
 	int error;
 
-	error = mb_cache_entry_create(cache, GFP_NOFS, hash, bh->b_blocknr, 1);
+	error = mb_cache_entry_create(cache, GFP_NOFS, hash,
+					bh->b_blocknr,true);
 	if (error) {
 		if (error == -EBUSY) {
 			ea_bdebug(bh, "already in cache (%d cache entries)",
-- 
2.17.2
