From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] ext4: reserve metadata block for every delayed write
Date: Fri,  8 Mar 2013 09:24:19 +0100
Message-ID: <1362731059-3508-3-git-send-email-lczerner@redhat.com>
References: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Cc: gnehzuil.liu@gmail.com, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283Ab3CHIY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Mar 2013 03:24:27 -0500
In-Reply-To: <1362731059-3508-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently we only reserve space (data+metadata) in delayed allocation if
we're allocating from new cluster (which is always in non-bigalloc file
system) which is ok for data blocks, because we reserve whole cluster.

However we have to reserve metadata for every delayed block we're going
to write because every block could potentially require metedata block
when we need to grow the extent tree.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c3b88ec..e0d5bc6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1905,8 +1905,11 @@ add_delayed:
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
-		/* If the block was allocated from previously allocated cluster,
-		 * then we dont need to reserve it again. */
+		/*
+		 * If the block was allocated from previously allocated cluster,
+		 * then we don't need to reserve it again. However we still need
+		 * to reserve metadata for every block we're going to write.
+		 */
 		if (!(map->m_flags & EXT4_MAP_FROM_CLUSTER)) {
 			ret = ext4_da_reserve_space(inode, iblock);
 			if (ret) {
@@ -1914,6 +1917,13 @@ add_delayed:
 				retval = ret;
 				goto out_unlock;
 			}
+		} else {
+			ret = ext4_da_reserve_metadata(inode, iblock);
+			if (ret) {
+				/* not enough space to reserve */
+				retval = ret;
+				goto out_unlock;
+			}
 		}
 
 		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
-- 
1.7.7.6

