From: <zhangaihua1@huawei.com>
Subject: [PATCH] fix compile error while opening the macro DOUBLE_CHECK
Date: Tue, 17 Nov 2015 11:04:03 +0800
Message-ID: <1447729443-14698-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Aihua Zhang <zhangaihua1@huawei.com>
To: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
	<stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aihua Zhang <zhangaihua1@huawei.com>

the error is:
    fs/ext4/mballoc.c:475:43: error: 'struct ext4_group_info' has
no member named 'bb_bitmap'
    the definition of macro should before 'struct ext4_group_info'

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 fs/ext4/ext4.h    |   12 ++++++++++++
 fs/ext4/mballoc.h |   12 ------------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 750063f..e743955 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -41,6 +41,18 @@
  */
 
 /*
+ * with AGGRESSIVE_CHECK allocator runs consistency checks over
+ * structures. these checks slow things down a lot
+ * /
+#define AGGRESSIVE_CHECK__
+
+/*
+ * with DOUBLE_CHECK defined mballoc creates persistent in-core
+ * bitmaps, maintains and uses them to check for double allocations
+ * /
+#define DOUBLE_CHECK__
+
+/*
  * Define EXT4FS_DEBUG to produce debug messages
  */
 #undef EXT4FS_DEBUG
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index d634e18..3ef1df6 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -23,18 +23,6 @@
 #include "ext4.h"
 
 /*
- * with AGGRESSIVE_CHECK allocator runs consistency checks over
- * structures. these checks slow things down a lot
- */
-#define AGGRESSIVE_CHECK__
-
-/*
- * with DOUBLE_CHECK defined mballoc creates persistent in-core
- * bitmaps, maintains and uses them to check for double allocations
- */
-#define DOUBLE_CHECK__
-
-/*
  */
 #ifdef CONFIG_EXT4_DEBUG
 extern ushort ext4_mballoc_debug;
-- 
1.7.1
