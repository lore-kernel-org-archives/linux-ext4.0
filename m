From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag
Date: Thu,  7 Jan 2010 00:52:41 +0530
Message-ID: <1262805762-6862-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:60105 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab0AFTWv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jan 2010 14:22:51 -0500
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by e28smtp02.in.ibm.com (8.14.3/8.13.1) with ESMTP id o06JMlQW013214
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:47 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o06JMlow2551896
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 00:52:47 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o06JMkA7002138
	for <linux-ext4@vger.kernel.org>; Thu, 7 Jan 2010 06:22:47 +1100
In-Reply-To: <1262805762-6862-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We should update reserve space if it is delalloc buffer
and thtat is indicated by EXT4_GET_BLOCKS_DELALLOC_RESERVE flag.
So use EXT4_GET_BLOCKS_DELALLOC_RESERVE in place of
EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    7 ++-----
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    8 ++++----
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b98de17..874d169 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -361,14 +361,11 @@ struct ext4_new_group_data {
 	   so set the magic i_delalloc_reserve_flag after taking the 
 	   inode allocation semaphore for */
 #define EXT4_GET_BLOCKS_DELALLOC_RESERVE	0x0004
-	/* Call ext4_da_update_reserve_space() after successfully 
-	   allocating the blocks */
-#define EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE	0x0008
 	/* caller is from the direct IO path, request to creation of an
 	unitialized extents if not allocated, split the uninitialized
 	extent if blocks has been preallocated already*/
-#define EXT4_GET_BLOCKS_DIO			0x0010
-#define EXT4_GET_BLOCKS_CONVERT			0x0020
+#define EXT4_GET_BLOCKS_DIO			0x0008
+#define EXT4_GET_BLOCKS_CONVERT			0x0010
 #define EXT4_GET_BLOCKS_DIO_CREATE_EXT		(EXT4_GET_BLOCKS_DIO|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
 	/* Convert extent to initialized after direct IO complete */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 3b6ff72..765a482 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3142,7 +3142,7 @@ out:
 	 * But fallocate would have already updated quota and block
 	 * count for this offset. So cancel these reservation
 	 */
-	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		ext4_da_update_reserve_space(inode, allocated, 0);
 
 map_out:
@@ -3388,7 +3388,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	 * Update reserved blocks/metadata blocks after successful
 	 * block allocation which had been deferred till now.
 	 */
-	if (flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE)
+	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
 		ext4_da_update_reserve_space(inode, allocated, 1);
 
 	/*
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3d1a1d6..fec4ea1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1309,7 +1309,7 @@ int ext4_get_blocks(handle_t *handle, struct inode *inode, sector_t block,
 		 * reserve space here.
 		 */
 		if ((retval > 0) &&
-			(flags & EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE))
+			(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE))
 			ext4_da_update_reserve_space(inode, retval, 1);
 	}
 	if (flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE)
@@ -2224,10 +2224,10 @@ static int mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * variables are updated after the blocks have been allocated.
 	 */
 	new.b_state = 0;
-	get_blocks_flags = (EXT4_GET_BLOCKS_CREATE |
-			    EXT4_GET_BLOCKS_DELALLOC_RESERVE);
+	get_blocks_flags = EXT4_GET_BLOCKS_CREATE ;
 	if (mpd->b_state & (1 << BH_Delay))
-		get_blocks_flags |= EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE;
+		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
+
 	blks = ext4_get_blocks(handle, mpd->inode, next, max_blocks,
 			       &new, get_blocks_flags);
 	if (blks < 0) {
-- 
1.6.6.75.g37bae

