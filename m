From: <zeng.zhaoming@freescale.com>
Subject: [PATCH] ext4: Fix memory leak in groupinfo cache name
Date: Mon, 22 Nov 2010 06:02:11 +0800
Message-ID: <1290376931-2129-2-git-send-email-zeng.zhaoming@freescale.com>
References: <1290376931-2129-1-git-send-email-zeng.zhaoming@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <mpm@selenic.com>,
	<rientjes@google.com>, <penberg@cs.helsinki.fi>,
	Zeng Zhaoming <zengzm.kernel@gmail.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9490 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967Ab0KVGBU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Nov 2010 01:01:20 -0500
In-Reply-To: <1290376931-2129-1-git-send-email-zeng.zhaoming@freescale.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zeng Zhaoming <zengzm.kernel@gmail.com>

please check the discuss with allocator guys.
http://marc.info/?l=linux-kernel&m=129004890020256&w=2

Get a memory leak about ext4:
  comm "mount", pid 1159, jiffies 4294904647 (age 6077.804s)
  hex dump (first 32 bytes):
    65 78 74 34 5f 67 72 6f 75 70 69 6e 66 6f 5f 31  ext4_groupinfo_1
    30 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  0.kkkkkkkkkkkkk.
  backtrace:
    [<c068ade3>] kmemleak_alloc+0x93/0xd0
    [<c024e54c>] __kmalloc_track_caller+0x30c/0x380
    [<c02269d3>] kstrdup+0x33/0x60
    [<c0318a70>] ext4_mb_init+0x4e0/0x550
    [<c0304e0e>] ext4_fill_super+0x1e6e/0x2f60
    [<c0261140>] mount_bdev+0x1c0/0x1f0
    [<c02fc00f>] ext4_mount+0x1f/0x30
    [<c02603d8>] vfs_kern_mount+0x78/0x250
    [<c026060e>] do_kern_mount+0x3e/0x100
    [<c027b4c2>] do_mount+0x2e2/0x780
    [<c027ba04>] sys_mount+0xa4/0xd0
    [<c010429f>] sysenter_do_call+0x12/0x38
    [<ffffffff>] 0xffffffff

ext4 allocate memory for cache name by:
    namep = kstrdup(name, GFP_KERNEL);
and reclaim it by:
    name = kmem_cache_name(cache);
    kfree(name)

This is ok if allocator only reference to the cache name memory, and return
the name memory pass to kmem_cache_create() by kmem_cache_name();
But not true in slub, when using slub, memory leak and double free error appears.

In this patch, we track the cache name memory in ext4, rather than allocator.

Signed-off-by: Zeng Zhaoming <zengzm.kernel@gmail.com>
---
 fs/ext4/mballoc.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5b4d4e3..c744661 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -344,7 +344,13 @@ static struct kmem_cache *ext4_free_ext_cachep;
  * each unique s_blocksize_bits */
 #define NR_GRPINFO_CACHES	\
 	(EXT4_MAX_BLOCK_LOG_SIZE - EXT4_MIN_BLOCK_LOG_SIZE + 1)
-static struct kmem_cache *ext4_groupinfo_caches[NR_GRPINFO_CACHES];
+
+static struct {
+	/* memory cache */
+	struct kmem_cache *cache;
+	/* name of the cache */
+	char*	cache_name;
+} ext4_groupinfo_caches[NR_GRPINFO_CACHES];
 
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
@@ -2245,7 +2251,7 @@ static const struct file_operations ext4_mb_seq_groups_fops = {
 static struct kmem_cache *get_groupinfo_cache(int blocksize_bits)
 {
 	int cache_index = blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
-	struct kmem_cache *cachep = ext4_groupinfo_caches[cache_index];
+	struct kmem_cache *cachep = ext4_groupinfo_caches[cache_index].cache;
 
 	BUG_ON(!cachep);
 	return cachep;
@@ -2441,7 +2447,7 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	}
 
 	cache_index = sb->s_blocksize_bits - EXT4_MIN_BLOCK_LOG_SIZE;
-	cachep = ext4_groupinfo_caches[cache_index];
+	cachep = ext4_groupinfo_caches[cache_index].cache;
 	if (!cachep) {
 		char name[32];
 		int len = offsetof(struct ext4_group_info,
@@ -2462,7 +2468,8 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 			ret = -ENOMEM;
 			goto out;
 		}
-		ext4_groupinfo_caches[cache_index] = cachep;
+		ext4_groupinfo_caches[cache_index].cache = cachep;
+		ext4_groupinfo_caches[cache_index].cache_name = namep;
 	}
 
 	/* order 0 is regular bitmap */
@@ -2745,12 +2752,13 @@ void ext4_exit_mballoc(void)
 	kmem_cache_destroy(ext4_free_ext_cachep);
 
 	for (i = 0; i < NR_GRPINFO_CACHES; i++) {
-		struct kmem_cache *cachep = ext4_groupinfo_caches[i];
-		if (cachep) {
-			char *name = (char *)kmem_cache_name(cachep);
+		struct kmem_cache *cachep = ext4_groupinfo_caches[i].cache;
+		char *name = ext4_groupinfo_caches[i].cache_name;
+
+		if (cachep)
 			kmem_cache_destroy(cachep);
+		if (name)
 			kfree(name);
-		}
 	}
 	ext4_remove_debugfs_entry();
 }
-- 
1.7.0.4


