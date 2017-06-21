From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH 12/32] ext4: add missing le32_to_cpu(e_value_inum) conversions
Date: Wed, 21 Jun 2017 14:21:22 -0700
Message-ID: <20170621212142.16581-12-tahsin@google.com>
References: <20170621212142.16581-1-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35713 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752593AbdFUVWG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 17:22:06 -0400
Received: by mail-pg0-f51.google.com with SMTP id 132so48539495pgb.2
        for <linux-ext4@vger.kernel.org>; Wed, 21 Jun 2017 14:22:06 -0700 (PDT)
In-Reply-To: <20170621212142.16581-1-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Two places in code missed converting xattr inode number using
le32_to_cpu().

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 fs/ext4/xattr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8e855fc2eb03..4dd8be16d175 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1997,6 +1997,7 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	struct ext4_inode *raw_inode;
 	struct ext4_iloc iloc;
 	struct ext4_xattr_entry *entry;
+	unsigned int ea_ino;
 	int credits = 3, error = 0;
 
 	if (!ext4_test_inode_state(inode, EXT4_STATE_XATTR))
@@ -2011,8 +2012,8 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	     entry = EXT4_XATTR_NEXT(entry)) {
 		if (!entry->e_value_inum)
 			continue;
-		if (ext4_expand_ino_array(lea_ino_array,
-					  entry->e_value_inum) != 0) {
+		ea_ino = le32_to_cpu(entry->e_value_inum);
+		if (ext4_expand_ino_array(lea_ino_array, ea_ino) != 0) {
 			brelse(iloc.bh);
 			goto cleanup;
 		}
@@ -2044,8 +2045,8 @@ ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	     entry = EXT4_XATTR_NEXT(entry)) {
 		if (!entry->e_value_inum)
 			continue;
-		if (ext4_expand_ino_array(lea_ino_array,
-					  entry->e_value_inum) != 0)
+		ea_ino = le32_to_cpu(entry->e_value_inum);
+		if (ext4_expand_ino_array(lea_ino_array, ea_ino) != 0)
 			goto cleanup;
 		entry->e_value_inum = 0;
 	}
-- 
2.13.1.611.g7e3b11ae1-goog
