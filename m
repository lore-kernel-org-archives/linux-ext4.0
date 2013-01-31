From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4:  ext4_split_extent shoult take care about extent zeroout
Date: Thu, 31 Jan 2013 11:24:58 +0400
Message-ID: <1359617098-18451-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, xiaoqiangnk@gmail.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:21701 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab3AaH0D (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 02:26:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We have to update extent's state after first ext4_split_extent_at otherwise this result
in following trace:
->ext4_ext_handle_uninitialized_extents (ex=[1000:20:uninit], lblock 1000, max_blocks 10)
  ->ext4_split_extent_at(ex=[1000,128], lblk 10010) /// First split
    ->ext4_ext_split() -> ENOSPC
    ->ext4_ext_zeroout
      ->ext4_ext_dirty  -> ex=[1000:20:init]
  ->ext4_split_extent_at(ex=[1000,128], lblk 10000) /// Second split
     if(split == ee_block)
         if (split_flag & EXT4_EXT_MARK_UNINIT2)
            ext4_ext_mark_uninitialized(ex); ex=[1000:20:uninit] /// The bug!
     ->ext4_ext_dirty ->ex=[1000:20:uninit]

At the end ext4_convert_unwritten_extents_endio() will findout large uninitialized
extent.

TESTCASE: https://github.com/dmonakhov/xfstests/commit/1a1c4f337d4d198803436c63a56625b1a78d8a5e

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 97cac01..7a3f679 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3091,18 +3091,24 @@ static int ext4_split_extent(handle_t *handle,
 		if (err)
 			goto out;
 	}
-
+	/* Update path is required because previous ext4_split_extent_at() may
+	 * result in split of original leaf or extent zeroout.
+	 */
 	ext4_ext_drop_refs(path);
 	path = ext4_ext_find_extent(inode, map->m_lblk, path);
 	if (IS_ERR(path))
 		return PTR_ERR(path);
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	uninitialized = ext4_ext_is_uninitialized(ex);
 
 	if (map->m_lblk >= ee_block) {
 		split_flag1 = split_flag & EXT4_EXT_MAY_ZEROOUT;
-		if (uninitialized)
+		if (uninitialized) {
 			split_flag1 |= EXT4_EXT_MARK_UNINIT1;
-		if (split_flag & EXT4_EXT_MARK_UNINIT2)
-			split_flag1 |= EXT4_EXT_MARK_UNINIT2;
+			if (split_flag & EXT4_EXT_MARK_UNINIT2)
+				split_flag1 |= EXT4_EXT_MARK_UNINIT2;
+		}
 		err = ext4_split_extent_at(handle, inode, path,
 				map->m_lblk, split_flag1, flags);
 		if (err)
-- 
1.7.1

