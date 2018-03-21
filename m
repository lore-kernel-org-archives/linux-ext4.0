From: Qu Wenruo <wqu@suse.com>
Subject: [PATCH 2/3] fstests: log-writes: Add support for METADATA flag
Date: Wed, 21 Mar 2018 16:01:24 +0800
Message-ID: <20180321080125.30404-2-wqu@suse.com>
References: <20180321080125.30404-1-wqu@suse.com>
Cc: amir73il@gmail.com, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20180321080125.30404-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 src/log-writes/log-writes.c | 3 ++-
 src/log-writes/log-writes.h | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/log-writes/log-writes.c b/src/log-writes/log-writes.c
index a872429d..5dc22c24 100644
--- a/src/log-writes/log-writes.c
+++ b/src/log-writes/log-writes.c
@@ -130,7 +130,8 @@ struct flags_to_str_entry {
 	DEFINE_LOG_FLAGS_STR_ENTRY(FLUSH),
 	DEFINE_LOG_FLAGS_STR_ENTRY(FUA),
 	DEFINE_LOG_FLAGS_STR_ENTRY(DISCARD),
-	DEFINE_LOG_FLAGS_STR_ENTRY(MARK)
+	DEFINE_LOG_FLAGS_STR_ENTRY(MARK),
+	DEFINE_LOG_FLAGS_STR_ENTRY(METADATA)
 };
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/src/log-writes/log-writes.h b/src/log-writes/log-writes.h
index 35ca3583..75fb8ac0 100644
--- a/src/log-writes/log-writes.h
+++ b/src/log-writes/log-writes.h
@@ -20,10 +20,11 @@ typedef __u32 u32;
 /*
  * Constants copied from kernel file drivers/md/dm-log-writes.c
  */
-#define LOG_FLUSH_FLAG (1 << 0)
-#define LOG_FUA_FLAG (1 << 1)
-#define LOG_DISCARD_FLAG (1 << 2)
-#define LOG_MARK_FLAG (1 << 3)
+#define LOG_FLUSH_FLAG		(1 << 0)
+#define LOG_FUA_FLAG		(1 << 1)
+#define LOG_DISCARD_FLAG	(1 << 2)
+#define LOG_MARK_FLAG		(1 << 3)
+#define LOG_METADATA_FLAG	(1 << 4)
 
 #define WRITE_LOG_VERSION 1
 #define WRITE_LOG_MAGIC 0x6a736677736872
-- 
2.15.1

