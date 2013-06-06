From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH] ext4: return FIEMAP_EXTENT_UNKNOWN if an extent is delayed
 allocations
Date: Thu, 06 Jun 2013 21:31:49 +0800
Message-ID: <51B08F45.1050605@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FFNb4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jun 2013 09:31:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jie Liu <jeff.liu@oracle.com>

Return the FIEMAP_EXTENT_UNKNOWN flag as well except the
FIEMAP_EXTENT_DELALLOC because the data location of an
delayed allocation extent is unknown.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/ext4/extents.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bc0f191..47e17b1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2125,7 +2125,8 @@ static int ext4_fill_fiemap_extents(struct inode *inode,
 		next_del = ext4_find_delayed_extent(inode, &es);
 		if (!exists && next_del) {
 			exists = 1;
-			flags |= FIEMAP_EXTENT_DELALLOC;
+			flags |= (FIEMAP_EXTENT_DELALLOC |
+				  FIEMAP_EXTENT_UNKNOWN);
 		}
 		up_read(&EXT4_I(inode)->i_data_sem);
 
-- 
1.7.9.5
