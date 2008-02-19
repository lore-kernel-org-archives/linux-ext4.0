From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v2] ext4: Don't mark the filesystem with errors if we fail to fallocate.
Date: Tue, 19 Feb 2008 09:14:00 +0530
Message-ID: <1203392640-14335-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:60629 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbYBSDoG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Feb 2008 22:44:06 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1J3hgUY007097
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 14:43:42 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1J3i3p44390990
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 14:44:04 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1J3i7GV025140
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 14:44:07 +1100
In-Reply-To: <1203392640-14335-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

IF we fail allocate blocks don't call ext4_error. Also don't hide errors
from ext4_get_blocks_wrap

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5b22f71..9a27e88 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2653,13 +2653,14 @@ retry:
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
 					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
-		WARN_ON(ret <= 0);
 		if (ret <= 0) {
-			ext4_error(inode->i_sb, "ext4_fallocate",
-				    "ext4_ext_get_blocks returned error: "
-				    "inode#%lu, block=%u, max_blocks=%lu",
+#ifdef EXT4FS_DEBUG
+			WARN_ON(ret <= 0);
+			printk(KERN_ERR "%s: ext4_ext_get_blocks "
+				    "returned error inode#%lu, block=%u, "
+				    "max_blocks=%lu", __FUNCTION__,
 				    inode->i_ino, block, max_blocks);
-			ret = -EIO;
+#endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
 			break;
-- 
1.5.4.1.97.g40aab-dirty
