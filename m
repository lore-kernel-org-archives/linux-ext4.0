From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH v6 1/4] vfs: Add file timestamp range support
Date: Sun, 21 Jan 2018 18:04:23 -0800
Message-ID: <20180122020426.2988-2-deepa.kernel@gmail.com>
References: <20180122020426.2988-1-deepa.kernel@gmail.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, y2038@lists.linaro.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180122020426.2988-1-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add fields to the superblock to track the min and max
timestamps supported by filesystems.

Initially, when a superblock is allocated, initialize
it to the max and min values the fields can hold.
Individual filesystems override these to match their
actual limits.

Pseudo filesystems are assumed to always support the
min and max allowable values for the fields.

Note that the time ranges are saved in type time64_t
rather than time_t.
This is required because if we save ranges in time_t
then we would not be able to save timestamp ranges
for files that support timestamps beyond y2038.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
---
 fs/super.c             | 2 ++
 include/linux/fs.h     | 3 +++
 include/linux/time64.h | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 672538ca9831..9e0c97e54e46 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -244,6 +244,8 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
 	s->s_maxbytes = MAX_NON_LFS;
 	s->s_op = &default_op;
 	s->s_time_gran = 1000000000;
+	s->s_time_min = TIME64_MIN;
+	s->s_time_max = TIME64_MAX;
 	s->cleancache_poolid = CLEANCACHE_NO_POOL;
 
 	s->s_shrink.seeks = DEFAULT_SEEKS;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d01c0951a8..406f3de71c22 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1379,6 +1379,9 @@ struct super_block {
 	/* Granularity of c/m/atime in ns.
 	   Cannot be worse than a second */
 	u32		   s_time_gran;
+	/* Time limits for c/m/atime in seconds. */
+	time64_t           s_time_min;
+	time64_t           s_time_max;
 
 	/*
 	 * The next field is for VFS *only*. No filesystems have any business
diff --git a/include/linux/time64.h b/include/linux/time64.h
index 93d39499838e..76ed46db7a7f 100644
--- a/include/linux/time64.h
+++ b/include/linux/time64.h
@@ -36,6 +36,8 @@ struct itimerspec64 {
 
 /* Located here for timespec[64]_valid_strict */
 #define TIME64_MAX			((s64)~((u64)1 << 63))
+#define TIME64_MIN			(-TIME64_MAX - 1)
+
 #define KTIME_MAX			((s64)~((u64)1 << 63))
 #define KTIME_SEC_MAX			(KTIME_MAX / NSEC_PER_SEC)
 
-- 
2.14.1
