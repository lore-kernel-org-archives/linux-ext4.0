From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH v2 18/31] ext4: retry storing value in external inode with xattr block too
Date: Tue, 20 Jun 2017 01:56:44 -0700
Message-ID: <20170620085644.5629-1-tahsin@google.com>
References: <20170531081517.11438-18-tahsin@google.com>
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33578 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbdFTI4t (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jun 2017 04:56:49 -0400
Received: by mail-pf0-f182.google.com with SMTP id 83so66398616pfr.0
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jun 2017 01:56:48 -0700 (PDT)
In-Reply-To: <20170531081517.11438-18-tahsin@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When value size is <= EXT4_XATTR_MIN_LARGE_EA_SIZE(), and it
doesn't fit in either inline or xattr block, a second try is made to
store it in an external inode while storing the entry itself in inline
area. There should also be an attempt to store the entry in xattr block.

This patch adds a retry loop to do that. It also makes the caller the
sole decider on whether to store a value in an external inode.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
v2: fix checkpatch.pl warning about indented retry_inode: label

 fs/ext4/xattr.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index dcf7ec98f138..0dfae3f8e209 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -911,11 +911,6 @@ static int ext4_xattr_set_entry(struct ext4_xattr_info *i,
 	int in_inode = i->in_inode;
 	int rc;
 
-	if (ext4_has_feature_ea_inode(inode->i_sb) &&
-	    (EXT4_XATTR_SIZE(i->value_len) >
-	     EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
-		in_inode = 1;
-
 	/* Compute min_offs and last. */
 	last = s->first;
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
@@ -1097,7 +1092,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 {
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *new_bh = NULL;
-	struct ext4_xattr_search *s = &bs->s;
+	struct ext4_xattr_search s_copy = bs->s;
+	struct ext4_xattr_search *s = &s_copy;
 	struct mb_cache_entry *ce = NULL;
 	int error = 0;
 	struct mb_cache *ext4_mb_cache = EXT4_GET_MB_CACHE(inode);
@@ -1519,6 +1515,11 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (!bs.s.not_found && ext4_xattr_value_same(&bs.s, &i))
 			goto cleanup;
 
+		if (ext4_has_feature_ea_inode(inode->i_sb) &&
+		    (EXT4_XATTR_SIZE(i.value_len) >
+			EXT4_XATTR_MIN_LARGE_EA_SIZE(inode->i_sb->s_blocksize)))
+			i.in_inode = 1;
+retry_inode:
 		error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
@@ -1530,20 +1531,20 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 					goto cleanup;
 			}
 			error = ext4_xattr_block_set(handle, inode, &i, &bs);
-			if (ext4_has_feature_ea_inode(inode->i_sb) &&
-			    error == -ENOSPC) {
-				/* xattr not fit to block, store at external
-				 * inode */
-				i.in_inode = 1;
-				error = ext4_xattr_ibody_set(handle, inode,
-							     &i, &is);
-			}
-			if (error)
-				goto cleanup;
-			if (!is.s.not_found) {
+			if (!error && !is.s.not_found) {
 				i.value = NULL;
 				error = ext4_xattr_ibody_set(handle, inode, &i,
 							     &is);
+			} else if (error == -ENOSPC) {
+				/*
+				 * Xattr does not fit in the block, store at
+				 * external inode if possible.
+				 */
+				if (ext4_has_feature_ea_inode(inode->i_sb) &&
+				    !i.in_inode) {
+					i.in_inode = 1;
+					goto retry_inode;
+				}
 			}
 		}
 	}
-- 
2.13.1.518.g3df882009-goog
