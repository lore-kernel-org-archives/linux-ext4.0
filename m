Return-Path: <SRS0=kdxW=OC=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:43449 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436603AbeKXCIm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 23 Nov 2018 21:08:42 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2] ext4: change variable reusable to bool type
Date: Fri, 23 Nov 2018 23:23:38 +0800
Message-Id: <20181123152338.16364-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reusable parameter of mb_cache_entry_create() is bool type,
so change variable resuable to bool type from int.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
v1->v2:
- Only change variable type to bool from int.

 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7643d52c776c..d7596bab7eb4 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2979,7 +2979,7 @@ ext4_xattr_block_cache_insert(struct mb_cache *ea_block_cache,
 {
 	struct ext4_xattr_header *header = BHDR(bh);
 	__u32 hash = le32_to_cpu(header->h_hash);
-	int reusable = le32_to_cpu(header->h_refcount) <
+	bool reusable = le32_to_cpu(header->h_refcount) <
 		       EXT4_XATTR_REFCOUNT_MAX;
 	int error;
 
-- 
2.17.2
