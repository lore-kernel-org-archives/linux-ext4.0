From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 07/11] ext4: request for blocks with ar.excepted_group = -1
Date: Wed, 27 Aug 2008 20:58:32 +0530
Message-ID: <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:57315 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757058AbYH0P3H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:07 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFT5U1023431
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:05 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFT57n1314880
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:05 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFT4RW021946
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:05 +0530
In-Reply-To: <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise we skip group 0 during block allocation.
This cause ENOSPC even if we have free blocks in
group 0. This should be merged with defrag. The
expected_group changes are introduced by defrag patches.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |    1 +
 fs/ext4/extents.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b19346a..53fdb05 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -2023,6 +2023,7 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = *count;
 	ar.logical = iblock;
+	ar.excepted_group = -1;
 
 	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
 		/* enable in-core preallocation for data block allocation */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bf612a7..268e96d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2879,6 +2879,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = ext4_ext_find_goal(inode, path, iblock);
 	ar.logical = iblock;
 	ar.len = allocated;
+	ar.excepted_group = -1;
 	if (S_ISREG(inode->i_mode))
 		ar.flags = EXT4_MB_HINT_DATA;
 	else
-- 
1.6.0.1.90.g27a6e

