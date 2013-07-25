From: Andi Shyti <andi@etezian.org>
Subject: [PATCH] ext4: extents: len and lblock may be used uninitialized
Date: Thu, 25 Jul 2013 02:33:05 +0200
Message-ID: <1374712385-6691-1-git-send-email-andi@etezian.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	andi@etezian.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:40163 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab3GYAdO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Jul 2013 20:33:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

if ext_debugging is enabled and path[depth].p_ext is NULL, len
and lblock are printed non initialized

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 fs/ext4/extents.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a618738..acaf53c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2195,8 +2195,8 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 				ext4_lblk_t block)
 {
 	int depth = ext_depth(inode);
-	unsigned long len;
-	ext4_lblk_t lblock;
+	unsigned long len = 0;
+	ext4_lblk_t lblock = 0;
 	struct ext4_extent *ex;
 
 	ex = path[depth].p_ext;
@@ -2233,7 +2233,6 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 			ext4_es_insert_extent(inode, lblock, len, ~0,
 					      EXTENT_STATUS_HOLE);
 	} else {
-		lblock = len = 0;
 		BUG();
 	}
 
-- 
1.8.3.2

