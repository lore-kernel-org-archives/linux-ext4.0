From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 15/32] ext4: fix ext4_xattr_move_to_block()
Date: Wed, 21 Jun 2017 14:21:25 -0700
Message-ID: <20170621212142.16581-15-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36020 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752593AbdFUVWK (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:10 -0400
Received: by mail-pg0-f52.google.com with SMTP id u62so62813667pgb.3
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:10 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When moving xattr entries from inline area to a xattr block, entries
that refer to external xattr inodes need special handling because
value data is not available in the inline area but rather should be
read from its external inode.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 6a6bee246873..9c243b3510b7 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1658,18 +1658,16 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	struct ext4_xattr_ibody_find *is = NULL;
 	struct ext4_xattr_block_find *bs = NULL;
 	char *buffer = NULL, *b_entry_name = NULL;
-	size_t value_offs, value_size;
+	size_t value_size = le32_to_cpu(entry->e_value_size);
 	struct ext4_xattr_info i = {
 		.value = NULL,
 		.value_len = 0,
 		.name_index = entry->e_name_index,
+		.in_inode = !!entry->e_value_inum,
 	};
 	struct ext4_xattr_ibody_header *header = IHDR(inode, raw_inode);
 	int error;
 
-	value_offs = le16_to_cpu(entry->e_value_offs);
-	value_size = le32_to_cpu(entry->e_value_size);
-
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
 	buffer = kmalloc(value_size, GFP_NOFS);
@@ -1685,7 +1683,17 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	bs->bh = NULL;
 
 	/* Save the entry name and the entry value */
-	memcpy(buffer, (void *)IFIRST(header) + value_offs, value_size);
+	if (entry->e_value_inum) {
+		error = ext4_xattr_inode_get(inode,
+					     le32_to_cpu(entry->e_value_inum),
+					     buffer, value_size);
+		if (error)
+			goto out;
+	} else {
+		size_t value_offs = le16_to_cpu(entry->e_value_offs);
+		memcpy(buffer, (void *)IFIRST(header) + value_offs, value_size);
+	}
+
 	memcpy(b_entry_name, entry->e_name, entry->e_name_len);
 	b_entry_name[entry->e_name_len] = '\0';
 	i.name = b_entry_name;
@@ -1703,7 +1711,6 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
-	i.name = b_entry_name;
 	i.value = buffer;
 	i.value_len = value_size;
 	error = ext4_xattr_block_find(inode, &i, bs);
-- 
2.13.1.611.g7e3b11ae1-goog
