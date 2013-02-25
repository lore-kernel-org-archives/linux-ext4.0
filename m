From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/5] ext4: add warning to ext4_convert_unwritten_extents_endio
Date: Mon, 25 Feb 2013 20:07:41 +0400
Message-ID: <1361808463-25471-3-git-send-email-dmonakhov@openvz.org>
References: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:34117 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568Ab3BYQIz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Feb 2013 11:08:55 -0500
In-Reply-To: <1361808463-25471-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Splitting extents inside endio is bad thing, but unfortunetly it is still
possible. In fact we are pretty close to the moment when all related
issues will be fixed. Let's warn developer if it still the case.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 1d37f2d..78c2a91 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3386,8 +3386,19 @@ static int ext4_convert_unwritten_extents_endio(handle_t *handle,
 		"block %llu, max_blocks %u\n", inode->i_ino,
 		  (unsigned long long)ee_block, ee_len);
 
-	/* If extent is larger than requested then split is required */
+	/* If extent is larger than requested it is a clear sign that we still
+	 * have some extent state machine issues left. So extent_split is still
+	 * required.
+	 * TODO: Once all related issues will be fixed this situation should be
+	 * illegal.
+	 */
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
+#ifdef EXT4_DEBUG
+		ext4_warning("Inode (%ld) finished: extent logical block %llu,"
+			     " len %u; IO logical block %llu, len %u\n",
+			     inode->i_ino, (unsigned long long)ee_block, ee_len,
+			     (unsigned long long)map->m_lblk, map->m_len);
+#endif
 		err = ext4_split_unwritten_extents(handle, inode, map, path,
 						   EXT4_GET_BLOCKS_CONVERT);
 		if (err < 0)
-- 
1.7.1

