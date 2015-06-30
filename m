From: Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH 1/2] bufferhead: Add _gfp version for sb_getblk()
Date: Tue, 30 Jun 2015 09:26:48 +0300
Message-ID: <1435645609-20387-1-git-send-email-kernel@kyup.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

sb_getblk() is used during ext4 (and possibly other FSes) writeback
paths. Sometimes such path require allocating memory and guaranteeing
that such allocation won't block. Currently, however, there is no way
to provide user flags for sb_getblk which could lead to deadlocks.

This patch implements a sb_getblk_gfp with the only difference it can
accept user-provided GFP flags.

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
---

As per the discussion in this thread (http://marc.info/?l=linux-ext4&m=143563347324528&w=2)
here are the patches which hopefully implement Ted's suggestion. 

 include/linux/buffer_head.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 73b4522..e6797de 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -317,6 +317,13 @@ sb_getblk(struct super_block *sb, sector_t block)
 	return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MOVABLE);
 }
 
+
+static inline struct buffer_head *
+sb_getblk_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
+{
+	return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
+}
+
 static inline struct buffer_head *
 sb_find_get_block(struct super_block *sb, sector_t block)
 {
-- 
1.7.1
