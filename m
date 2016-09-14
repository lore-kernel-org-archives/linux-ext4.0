From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] blockgroup_lock.h: remove debris from bgl_lock_ptr() conversion
Date: Wed, 14 Sep 2016 12:27:59 -0700
Message-ID: <1473881279-122959-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

An obsolete comment and extra parentheses were left over from when the
sb_bgl_lock() macro was replaced with the bgl_lock_ptr() function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/blockgroup_lock.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/include/linux/blockgroup_lock.h b/include/linux/blockgroup_lock.h
index e44b88b..61b583d 100644
--- a/include/linux/blockgroup_lock.h
+++ b/include/linux/blockgroup_lock.h
@@ -49,14 +49,10 @@ static inline void bgl_lock_init(struct blockgroup_lock *bgl)
 		spin_lock_init(&bgl->locks[i].lock);
 }
 
-/*
- * The accessor is a macro so we can embed a blockgroup_lock into different
- * superblock types
- */
 static inline spinlock_t *
 bgl_lock_ptr(struct blockgroup_lock *bgl, unsigned int block_group)
 {
-	return &bgl->locks[(block_group) & (NR_BG_LOCKS-1)].lock;
+	return &bgl->locks[block_group & (NR_BG_LOCKS-1)].lock;
 }
 
 #endif
-- 
2.8.0.rc3.226.g39d4020
