From: mingming cao <mingming.cao@oracle.com>
Subject: [RFC 1/2] btree header
Date: Mon, 22 Jun 2015 20:24:37 -0700
Message-ID: <1435029878-4517-2-git-send-email-mingming.cao@oracle.com>
References: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
Cc: mingming cao <mingming.cao@oracle.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34888 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbbFWGQD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2015 02:16:03 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t5N6G2fh004207
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id t5N6G2oH028631
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:02 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id t5N6G29i025667
	for <linux-ext4@vger.kernel.org>; Tue, 23 Jun 2015 06:16:02 GMT
In-Reply-To: <1435029878-4517-1-git-send-email-mingming.cao@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 ext4_btree.h | 146 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 ext4_btree.h

diff --git a/ext4_btree.h b/ext4_btree.h
new file mode 100644
index 0000000..efd5ce3
--- /dev/null
+++ b/ext4_btree.h
@@ -0,0 +1,146 @@
+/*
+ * copyright (C) 2015 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#ifndef EXT4_BTREE_H
+#define EXT4_BTREE_H
+
+/*
+ * This btree geometry structure is used to defines how the btree block
+ * layout for different type of btrees. This is used to implement a generic
+ * btree implementation. The record length, value lenth, etc, are variable
+ * based on different btree type, like reflink btree, and other btree use cases.
+ */
+struct ext4_btree_geo {
+	__le16 node_len;
+	__le16 header_len;
+	__le16 key_len;
+	__le16 val_len;
+	__le16 rec_len;
+	__le16 max_pairs;
+	__le16 max_records;
+};
+
+/*
+ * Every btree block starts from a header structure, including the index node
+ * and the leaf node.
+ * The index btree node started from this header structure, followed by 
+ * (key,value) pairs
+ * Index node:
+ * ---------------------------------------------------------------------------
+ * |header| key | key | key | key|...........| value | value | value | value |
+ * |--------------------------------------------------------------------------
+ *
+ * And the leaf node begins with ext4_btree_header, and followed by records.
+ * leaf node
+ * * ------------------------------------------------------------------------
+ * |header| rec | rec | rec | rec |...........| rec | rec | rec | rec | rec |
+ * |-------------------------------------------------------------------------
+ */
+
+#define REF_BTREE_MAGIC  0x52454642 /* "REFB" magic number for refcount btree */
+
+struct ext4_btree_header {
+	__le32	btree_magic;	/* type of btree */
+	__le32	btree_generation; /* generation for this type of btree */
+	__le32	btree_level;	/* the level of this node in the tree */
+	__le32	btree_numkeys;	/* # of records for leaf node*/
+	__le32	btree_padding1;
+	__le64	btree_blockno;	/* remember the blk# of this node */
+	__le64	btree_leftsib;	/* used for fast search sibling nodes */
+	__le64	btree_rightsib; 
+	__le64	btree_crc;	/* this node checksums */
+	__le64	btree_padding2;
+};
+
+# define EXT4_BLOCK_SIZE	4096
+#define EXT4_BTREE_HEADER_SIZE	sizeof(struct ext4_btree_header)
+#define EXT4_BTREE_NODESIZE	EXT4_BLOCK_SIZE	
+
+struct ext4_btree_key {
+	__le64		blockno;
+};
+#define EXT4_BTREE_KEY_SIZE	sizeof(struct ext4_btree_key)
+
+struct ext4_btree_val {
+	__le64		blockno;
+};
+#define EXT4_BTREE_VAL_SIZE	sizeof(struct ext4_btree_val)
+
+struct ext4_btree_rec {
+	struct ext4_btree_key	key;
+	__le32			len;
+	__le32			ref_count;
+};
+#define EXT4_BTREE_REC_SIZE	sizeof(struct ext4_btree_rec)
+
+#define EXT4_BTREE_MAX_KEY_VAL_PAIRS \
+	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
+	 (EXT4_BTREE_KEY_SIZE + EXT4_BTREE_VAL_SIZE))
+
+#define EXT4_BTREE_MIN_KEY_VAL_PAIRS \
+        (EXT4_BTREE_MAX_KEY_VAL_PAIRS / 2)
+
+#define EXT4_BTREE_MAX_RECS \
+	((EXT4_BTREE_NODESIZE - EXT4_BTREE_HEADER_SIZE) / \
+	  EXT4_BTREE_REC_SIZE)
+
+#define EXT4_BTREE_MIN_RECS \
+	(EXT4_BTREE_MAX_RECS / 2)
+
+#define EXT4_BTREE_MAX_LEVELS		8
+
+
+/* Index node */
+struct ext4_btree_index_node {
+	struct ext4_btree_header	node_header;
+	struct ext4_btree_key		key[EXT4_BTREE_MAX_KEY_VAL_PAIRS];
+	struct ext4_btree_val		val[EXT4_BTREE_MAX_KEY_VAL_PAIRS];
+};
+
+/* Record Node */
+struct ext4_btree_leaf_node {
+	struct ext4_btree_header	node_header;
+	struct ext4_btree_rec		rec[EXT4_BTREE_MAX_RECS];
+};
+
+struct ext4_btree_node {
+	struct ext4_btree_header	node_header;
+};
+
+struct ext4_btree_root {
+	struct ext4_btree_node *node;
+	struct ext4_btree_geo	geo;
+};
+
+#define ext4_btree_trace printf
+
+/* Ref B+Tree interface */
+struct ext4_btree_node * ext4_btree_node_alloc();
+void ext4_btree_node_free( struct ext4_btree_node *node);
+struct ext4_btree_rec * ext4_btree_lookup(struct ext4_btree_root * root, 
+					  struct ext4_btree_key * key);
+int ext4_btree_insert(struct ext4_btree_root *root, 
+		      struct ext4_btree_rec *rec);
+int ext4_btree_delete(struct ext4_btree_root *root, 
+		  struct ext4_btree_key *key);
+void ext4_btree_print(struct ext4_btree_root * root);
+int ext4_btree_valid_check(struct ext4_btree_root *root);
+void ext4_ref_btree_init(struct ext4_btree_root * root);
+
+
+#endif
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
