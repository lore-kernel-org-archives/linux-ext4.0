From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] ext4: fix comments in ext4_can_extents_be_merged()
Date: Wed, 4 Feb 2015 19:11:45 +0800
Message-ID: <1423048305-11335-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <darrick.wong@oracle.com>,
	Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21232 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751033AbbBDLR5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Feb 2015 06:17:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since commit 66369e0, we are allowed to merge unwritten extents,
so here these comments are wrong, remove it.

Signed-off-by: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
---
 fs/ext4/extents.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bed4308..2e6af88 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1717,12 +1717,6 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 {
 	unsigned short ext1_ee_len, ext2_ee_len;
 
-	/*
-	 * Make sure that both extents are initialized. We don't merge
-	 * unwritten extents so that we can be sure that end_io code has
-	 * the extent that was written properly split out and conversion to
-	 * initialized is trivial.
-	 */
 	if (ext4_ext_is_unwritten(ex1) != ext4_ext_is_unwritten(ex2))
 		return 0;
 
-- 
1.8.3.1

