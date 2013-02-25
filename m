From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/5] ext4: ext4_split_extent shoult take care about extent zeroout v3
Date: Mon, 25 Feb 2013 20:07:39 +0400
Message-ID: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:9550 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab3BYQI4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 11:08:56 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_split_extent_at() ends up doing zeroout & conversion to
initialized instead of split & conversion, ext4_split_extent() gets
confused and can wrongly mark the extent back as uninitialized resulting in
end IO code getting confused from large unwritten extents and may result in
data loss.

The example of problematic behavior is:
			    lblk len              lblk len
  ext4_split_extent() (ex=[1000,30,uninit], map=[1010,10])
    ext4_split_extent_at() (split [1000,30,uninit] at 1020)
      ext4_ext_insert_extent() -> ENOSPC
      ext4_ext_zeroout()
	 -> extent [1000,30] is now initialized
    ext4_split_extent_at() (split [1000,30,init] at 1010,
			     MARK_UNINIT1 | MARK_UNINIT2)
      -> extent is split and parts marked as uninitialized

Fix the problem by rechecking extent type after the first
ext4_split_extent_at() returns. None of split_flags can not be applied to
initialized extent so this patch also add BUG_ON to prevent similar issues
in future.

TESTCASE: https://github.com/dmonakhov/xfstests/commit/b8a55eb5ce28c6ff29e620ab090902fcd5833597

Changes since V2: Patch no longer depends on Jan's "disable-uninit-ext-mergring" patch.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 372b2cb..3bd3ca5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2943,6 +2943,10 @@ static int ext4_split_extent_at(handle_t *handle,
 	newblock = split - ee_block + ext4_ext_pblock(ex);
 
 	BUG_ON(split < ee_block || split >= (ee_block + ee_len));
+	BUG_ON(!ext4_ext_is_uninitialized(ex) &&
+	       split_flag & (EXT4_EXT_MAY_ZEROOUT |
+			     EXT4_EXT_MARK_UNINIT1 |
+			     EXT4_EXT_MARK_UNINIT2));
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
 	if (err)
@@ -3061,19 +3065,25 @@ static int ext4_split_extent(handle_t *handle,
 		if (err)
 			goto out;
 	}
-
+	/*
+	 * Update path is required because previous ext4_split_extent_at() may
+	 * result in split of original leaf or extent zeroout.
+	 */
 	ext4_ext_drop_refs(path);
 	path = ext4_ext_find_extent(inode, map->m_lblk, path);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	uninitialized = ext4_ext_is_uninitialized(ex);
+	split_flag1 = 0;
 
 	if (map->m_lblk >= ee_block) {
-		split_flag1 = split_flag & (EXT4_EXT_MAY_ZEROOUT |
-					    EXT4_EXT_DATA_VALID2);
-		if (uninitialized)
+		split_flag1 = split_flag & EXT4_EXT_DATA_VALID2;
+		if (uninitialized) {
 			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
-		if (split_flag & EXT4_EXT_MARK_UNINIT2)
-			split_flag1 |= EXT4_EXT_MARK_UNINIT2;
+			split_flag1 |= split_flag & (EXT4_EXT_MAY_ZEROOUT | EXT4_EXT_MARK_UNINIT2);
+		}
 		err = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk, split_flag1, flags);
 		if (err)
-- 
1.7.1

