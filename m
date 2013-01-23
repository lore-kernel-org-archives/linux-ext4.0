From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 03/10 v3] ext4: add physical block and status member into extent status tree
Date: Wed, 23 Jan 2013 20:03:53 +0800
Message-ID: <1358942640-2262-4-git-send-email-wenqing.lz@taobao.com>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

es_pblk is used to record physical block that maps to the disk.
es_status is used to record the status of the extent.  Three status
are defined, which are written, unwritten and delayed.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents_status.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
index 81e9339..2eb9cc3 100644
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -20,10 +20,22 @@
 #define es_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
+enum {
+	EXTENT_STATUS_WRITTEN = 0,	/* written extent */
+	EXTENT_STATUS_UNWRITTEN = 1,	/* unwritten extent */
+	EXTENT_STATUS_DELAYED = 2,	/* delayed extent */
+};
+
+/*
+ * Here for save memory es_status is stashed into es_pblk because we only have
+ * 48 bits physical block and es_status only needs 2 bits.
+ */
 struct extent_status {
 	struct rb_node rb_node;
-	ext4_lblk_t es_lblk;	/* first logical block extent covers */
-	ext4_lblk_t es_len;	/* length of extent in block */
+	ext4_lblk_t es_lblk;		/* first logical block extent covers */
+	ext4_lblk_t es_len;		/* length of extent in block */
+	ext4_fsblk_t es_pblk : 62;	/* first physical block */
+	ext4_fsblk_t es_status : 2;	/* record the status of extent */
 };
 
 struct ext4_es_tree {
-- 
1.7.12.rc2.18.g61b472e

