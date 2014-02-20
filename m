From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: don't calculate total xattr header size unless needed
Date: Wed, 19 Feb 2014 20:29:11 -0500
Message-ID: <1392859751-23513-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60230 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaBTB3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Feb 2014 20:29:15 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The function ext4_expand_extra_isize_ea() doesn't need the size of all
of the extended attribute headers.  So if we don't calculate it when
it is unneeded, it we can skip some undeeded memory references, and as
a bonus, we eliminate some kvetching by static code analysis tools.

Addresses-Coverity-Id: #741291

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/xattr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index e175e94..185066f 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -567,12 +567,13 @@ static size_t ext4_xattr_free_space(struct ext4_xattr_entry *last,
 				    size_t *min_offs, void *base, int *total)
 {
 	for (; !IS_LAST_ENTRY(last); last = EXT4_XATTR_NEXT(last)) {
-		*total += EXT4_XATTR_LEN(last->e_name_len);
 		if (!last->e_value_block && last->e_value_size) {
 			size_t offs = le16_to_cpu(last->e_value_offs);
 			if (offs < *min_offs)
 				*min_offs = offs;
 		}
+		if (total)
+			*total += EXT4_XATTR_LEN(last->e_name_len);
 	}
 	return (*min_offs - ((void *)last - base) - sizeof(__u32));
 }
@@ -1228,7 +1229,7 @@ int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 	struct ext4_xattr_block_find *bs = NULL;
 	char *buffer = NULL, *b_entry_name = NULL;
 	size_t min_offs, free;
-	int total_ino, total_blk;
+	int total_ino;
 	void *base, *start, *end;
 	int extra_isize = 0, error = 0, tried_min_extra_isize = 0;
 	int s_min_extra_isize = le16_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_min_extra_isize);
@@ -1286,8 +1287,7 @@ retry:
 		first = BFIRST(bh);
 		end = bh->b_data + bh->b_size;
 		min_offs = end - base;
-		free = ext4_xattr_free_space(first, &min_offs, base,
-					     &total_blk);
+		free = ext4_xattr_free_space(first, &min_offs, base, NULL);
 		if (free < new_extra_isize) {
 			if (!tried_min_extra_isize && s_min_extra_isize) {
 				tried_min_extra_isize++;
-- 
1.9.0

