From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
Date: Thu, 17 Nov 2011 00:04:08 +0900
Message-ID: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Namjae Jeon <linkinjeon@gmail.com>,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1KPPEd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Nov 2011 10:04:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If slab caches set to SLAB_MEM_SPREAD flags, The allocation is spread evenly over all the memory nodes instead of favoring allocation on the node local to current cpu.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/ext4/mballoc.c |    9 +++++----
 fs/ext4/page-io.c |    6 ++++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e2d8be8..86efde7 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2407,7 +2407,8 @@ static int ext4_groupinfo_create_slab(size_t size)
 				bb_counters[blocksize_bits + 2]);
 
 	cachep = kmem_cache_create(ext4_groupinfo_slab_names[cache_index],
-					slab_size, 0, SLAB_RECLAIM_ACCOUNT,
+					slab_size, 0, SLAB_RECLAIM_ACCOUNT |
+					SLAB_MEM_SPREAD,
 					NULL);
 
 	ext4_groupinfo_caches[cache_index] = cachep;
@@ -2730,19 +2731,19 @@ static void ext4_remove_debugfs_entry(void)
 int __init ext4_init_mballoc(void)
 {
 	ext4_pspace_cachep = KMEM_CACHE(ext4_prealloc_space,
-					SLAB_RECLAIM_ACCOUNT);
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD);
 	if (ext4_pspace_cachep == NULL)
 		return -ENOMEM;
 
 	ext4_ac_cachep = KMEM_CACHE(ext4_allocation_context,
-				    SLAB_RECLAIM_ACCOUNT);
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD);
 	if (ext4_ac_cachep == NULL) {
 		kmem_cache_destroy(ext4_pspace_cachep);
 		return -ENOMEM;
 	}
 
 	ext4_free_ext_cachep = KMEM_CACHE(ext4_free_data,
-					  SLAB_RECLAIM_ACCOUNT);
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD);
 	if (ext4_free_ext_cachep == NULL) {
 		kmem_cache_destroy(ext4_pspace_cachep);
 		kmem_cache_destroy(ext4_ac_cachep);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 7ce1d0b..4f848e0 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -34,10 +34,12 @@ static struct kmem_cache *io_page_cachep, *io_end_cachep;
 
 int __init ext4_init_pageio(void)
 {
-	io_page_cachep = KMEM_CACHE(ext4_io_page, SLAB_RECLAIM_ACCOUNT);
+	io_page_cachep = KMEM_CACHE(ext4_io_page, SLAB_RECLAIM_ACCOUNT |
+				SLAB_MEM_SPREAD);
 	if (io_page_cachep == NULL)
 		return -ENOMEM;
-	io_end_cachep = KMEM_CACHE(ext4_io_end, SLAB_RECLAIM_ACCOUNT);
+	io_end_cachep = KMEM_CACHE(ext4_io_end, SLAB_RECLAIM_ACCOUNT |
+				SLAB_MEM_SPREAD);
 	if (io_end_cachep == NULL) {
 		kmem_cache_destroy(io_page_cachep);
 		return -ENOMEM;
-- 
1.7.4.4

