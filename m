From: Radek Pazdera <rpazdera@redhat.com>
Subject: [RFC 4/9] ext4: Adding itree structures
Date: Sat,  4 May 2013 23:28:37 +0200
Message-ID: <1367702922-3236-5-git-send-email-rpazdera@redhat.com>
References: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Cc: lczerner@redhat.com, kasparek@fit.vutbr.cz,
	Radek Pazdera <rpazdera@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759290Ab3EDVe0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 May 2013 17:34:26 -0400
In-Reply-To: <1367702922-3236-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds 5 new structures that will be used in the itree code.

On-disk:
    struct itree_entry      Single entry in an itree_node.
    struct itree_node       A non-leaf node in the itree.
    struct itree_leaf_head  Comes first in every itree leaf block.
    struct itree_leaf_entry A dirent in itree leaf.

Memory only:
    struct itree_frame      Represents a path through a tree to one of
                            its leaves.
    struct itree_key        For representing the key for itree, which
                            is an inode number and file name hash

Signed-off-by: Radek Pazdera <rpazdera@redhat.com>
---
 fs/ext4/namei.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a3697a7..56caf3a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -261,6 +261,56 @@ struct dx_tail {
 	struct dx_itree_entry *itree;
 };
 
+/*
+ * itree structures
+ */
+
+/* A single entry in the itree_node */
+struct itree_entry {
+	__le32 inode;
+	__le32 hash;
+	__le64 block;
+	__u8 fullness;
+	__u8 flags;
+};
+
+#define ITREE_NODE_FL_CONT	1
+
+/* A non-leaf node of the itree */
+struct itree_node {
+	__le16 count;
+	__le16 limit;
+	__le32 checksum;
+	__u8 indirect_levels;
+	struct itree_entry entries[0];
+};
+
+/* Comes first in every itree leaf block */
+struct itree_leaf_head {
+	__le32 checksum;
+	__le32 used_length;
+};
+
+/* A dirent with hash in an itree leaf block */
+#define ITREE_LE_HEAD_LEN 4
+struct itree_leaf_entry {
+	__le32 hash;
+	struct ext4_dir_entry_2 dirent;
+};
+
+/* For easier manipulation of the compound key */
+struct itree_key {
+	u32 inode;
+	u32 hash;
+};
+
+/* Represents a position within an itree_node block */
+struct itree_frame {
+	struct buffer_head *bh;
+	struct itree_entry *entries;
+	struct itree_entry *at;
+};
+
 static inline ext4_lblk_t dx_get_block(struct dx_entry *entry);
 static void dx_set_block(struct dx_entry *entry, ext4_lblk_t value);
 static inline unsigned dx_get_hash(struct dx_entry *entry);
-- 
1.7.11.7

