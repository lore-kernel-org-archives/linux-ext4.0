From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Avoid memory leak of ext4_groupinfo_caches in ext4_groupinfo_create_slab.
Date: Mon, 11 Jul 2011 23:26:55 +0800
Message-ID: <1310398016-8104-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51715 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757753Ab1GKP1L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 11:27:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

In ext4_groupinfo_create_slab, we create ext4_groupinfo_caches within
ext4_grpinfo_slab_create_mutex, but set it outside the lock, and there
does exist some case that we may create it twice and causes a memory
leak. So set it before we call mutex_unlock.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9a35263..c680641 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2404,14 +2404,14 @@ static int ext4_groupinfo_create_slab(size_t size)
 					slab_size, 0, SLAB_RECLAIM_ACCOUNT,
 					NULL);
 
+	ext4_groupinfo_caches[cache_index] = cachep;
+
 	mutex_unlock(&ext4_grpinfo_slab_create_mutex);
 	if (!cachep) {
 		printk(KERN_EMERG "EXT4: no memory for groupinfo slab cache\n");
 		return -ENOMEM;
 	}
 
-	ext4_groupinfo_caches[cache_index] = cachep;
