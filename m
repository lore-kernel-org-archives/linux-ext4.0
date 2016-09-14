From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] blockgroup_lock.h: simplify definition of NR_BG_LOCKS
Date: Wed, 14 Sep 2016 12:28:40 -0700
Message-ID: <1473881320-123184-1-git-send-email-ebiggers@google.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We can use ilog2() to more easily produce the desired NR_BG_LOCKS.  This
works because ilog2() is evaluated at compile-time when its argument is
a compile-time constant.

I did not change the chosen NR_BG_LOCKS values.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/blockgroup_lock.h | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/include/linux/blockgroup_lock.h b/include/linux/blockgroup_lock.h
index 61b583d..225bdb7 100644
--- a/include/linux/blockgroup_lock.h
+++ b/include/linux/blockgroup_lock.h
@@ -10,28 +10,10 @@
 #include <linux/cache.h>
 
 #ifdef CONFIG_SMP
-
-/*
- * We want a power-of-two.  Is there a better way than this?
- */
-
-#if NR_CPUS >= 32
-#define NR_BG_LOCKS	128
-#elif NR_CPUS >= 16
-#define NR_BG_LOCKS	64
-#elif NR_CPUS >= 8
-#define NR_BG_LOCKS	32
-#elif NR_CPUS >= 4
-#define NR_BG_LOCKS	16
-#elif NR_CPUS >= 2
-#define NR_BG_LOCKS	8
+#define NR_BG_LOCKS	(4 << ilog2(NR_CPUS < 32 ? NR_CPUS : 32))
 #else
-#define NR_BG_LOCKS	4
-#endif
-
-#else	/* CONFIG_SMP */
 #define NR_BG_LOCKS	1
-#endif	/* CONFIG_SMP */
+#endif
 
 struct bgl_lock {
 	spinlock_t lock;
-- 
2.8.0.rc3.226.g39d4020
