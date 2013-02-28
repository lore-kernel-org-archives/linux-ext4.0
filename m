From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 5/6] ext4: ext4_split_extent shoult take care about extent zeroout v3
Date: Fri,  1 Mar 2013 02:26:43 +0800
Message-ID: <1362076004-10087-6-git-send-email-wenqing.lz@taobao.com>
References: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:54681 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab3B1SMC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2013 13:12:02 -0500
Received: by mail-da0-f53.google.com with SMTP id n34so963604dal.40
        for <linux-ext4@vger.kernel.org>; Thu, 28 Feb 2013 10:12:01 -0800 (PST)
In-Reply-To: <1362076004-10087-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/extents.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0793a13..835d82b 100644
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
1.7.12.rc2.18.g61b472e

