From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] ext4: Move is_32bit_api() to generic code
Date: Sun, 21 May 2017 22:20:46 +0200
Message-ID: <1495398051-4604-2-git-send-email-richard@nod.at>
References: <1495398051-4604-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: david@sigma-star.at, bfields@redhat.com, dedekind1@gmail.com,
 Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
 hyc.lee@gmail.com, adrian.hunter@intel.com, leon.pollak@gmail.com,
 adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
 marcus.folkesson@gmail.com, akpm@linux-foundation.org,
 linux-ext4@vger.kernel.org, rockdotlee@gmail.com
To: linux-mtd@lists.infradead.org
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <1495398051-4604-1-git-send-email-richard@nod.at>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

Since UBIFS will also use this function, move it to compat.h.

Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
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
index 1c5f3152cbb5..f33ffd8040a1 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -736,6 +736,7 @@ asmlinkage long compat_sys_arch_prctl(int option, unsigned long arg2);
 #ifndef in_compat_syscall
 static inline bool in_compat_syscall(void) { return is_compat_task(); }
 #endif
+static inline int is_32bit_api(void) { return in_compat_syscall(); }
 
 /**
  * ns_to_compat_timeval - Compat version of ns_to_timeval
@@ -759,6 +760,7 @@ static inline struct compat_timeval ns_to_compat_timeval(s64 nsec)
 
 #define is_compat_task() (0)
 static inline bool in_compat_syscall(void) { return false; }
+static inline int is_32bit_api(void) { return BITS_PER_LONG == 32; }
 
 #endif /* CONFIG_COMPAT */
 
-- 
2.12.0


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
