From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 4/6 v5] ext4: Correct large hole offset calcuation
Date: Sat, 20 Aug 2011 19:29:45 -0700
Message-ID: <1313893787-25460-5-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38777 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1HUC0n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:43 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L22Xh6022414
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:02:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2QgsC3125300
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:42 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2QfK2008811
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:41 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bug was reported by Lukas Czerner while working on a
new patch to add discard support for loop devices using
punch hole.

The bug is happens because the data type for logical blocks is
not large enough to calculate the block offset for holes that are
very large.  This bug is resolved by casting the ext4_lblk_t
to an loff_t before calculating the byte offset of the block.

Reviewed-and-Tested-by: Lukas Czerner <lczerner@redhat.com>

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 0d7617d... b417e47... M	fs/ext4/extents.c
 fs/ext4/extents.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0d7617d..b417e47 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4179,8 +4179,8 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		EXT4_BLOCK_SIZE_BITS(sb);
 	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
 
-	first_block_offset = first_block << EXT4_BLOCK_SIZE_BITS(sb);
-	last_block_offset = last_block << EXT4_BLOCK_SIZE_BITS(sb);
+	first_block_offset = ((loff_t)first_block) << EXT4_BLOCK_SIZE_BITS(sb);
+	last_block_offset = ((loff_t)last_block) << EXT4_BLOCK_SIZE_BITS(sb);
 
 	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
-- 
1.7.1

