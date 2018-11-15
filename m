Return-Path: <SRS0=JALT=N2=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:39195 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbeKOQsc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Nov 2018 11:48:32 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext4: change variable reusable to bool type
Date: Thu, 15 Nov 2018 14:41:46 +0800
Message-Id: <20181115064146.21232-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Reusable parameter of mb_cache_entry_create() is bool type,
so change variable resuable to bool type from int.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext4/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7643d52c776c..cda5dd16a8cb 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2979,8 +2979,8 @@ ext4_xattr_block_cache_insert(struct mb_cache *ea_block_cache,
 {
 	struct ext4_xattr_header *header = BHDR(bh);
 	__u32 hash = le32_to_cpu(header->h_hash);
-	int reusable = le32_to_cpu(header->h_refcount) <
-		       EXT4_XATTR_REFCOUNT_MAX;
+	bool reusable = (le32_to_cpu(header->h_refcount) <
+		       EXT4_XATTR_REFCOUNT_MAX) ? true : false;
 	int error;
 
 	if (!ea_block_cache)
-- 
2.17.2
