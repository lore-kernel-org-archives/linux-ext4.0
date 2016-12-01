From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] ext4: Move is_32bit_api() to generic code
Date: Thu,  1 Dec 2016 23:02:16 +0100
Message-ID: <1480629741-18375-2-git-send-email-richard@nod.at>
References: <1480629741-18375-1-git-send-email-richard@nod.at>
Cc: david@sigma-star.at, tytso@mit.edu, dedekind1@gmail.com,
        adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, adilger.kernel@dilger.ca,
        akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480629741-18375-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since UBIFS will also use this function, move it to compat.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ext4/dir.c          | 9 ---------
 include/linux/compat.h | 2 ++
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8b365000d73..464e6e99d744 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -290,15 +290,6 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 	return err;
 }
 
-static inline int is_32bit_api(void)
-{
-#ifdef CONFIG_COMPAT
-	return in_compat_syscall();
-#else
-	return (BITS_PER_LONG == 32);
-#endif
-}
-
 /*
  * These functions convert from the major/minor hash to an f_pos
  * value for dx directories
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 63609398ef9f..8412382e8d08 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -730,11 +730,13 @@ asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 #ifndef in_compat_syscall
 static inline bool in_compat_syscall(void) { return is_compat_task(); }
 #endif
+static inline int is_32bit_api(void) { return in_compat_syscall(); }
 
 #else
 
 #define is_compat_task() (0)
 static inline bool in_compat_syscall(void) { return false; }
+static inline int is_32bit_api(void) { return BITS_PER_LONG == 32; }
 
 #endif /* CONFIG_COMPAT */
 
-- 
2.7.3
