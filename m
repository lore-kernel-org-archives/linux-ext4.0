From: Jun He <jhe@cs.wisc.edu>
Subject: [PATCH] Allow extents equal to max_zeroout to be zero-ed
Date: Mon, 30 May 2016 13:23:47 -0500
Message-ID: <1464632627-37583-1-git-send-email-jhe@cs.wisc.edu>
Cc: tytso@mit.edu, Jun He <jhe@cs.wisc.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40896 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161330AbcE3SYL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 30 May 2016 14:24:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just to be consistent with the rest of the code: if size == max_zeroout,
then allow it to be zero-ed.

Signed-off-by: Jun He <jhe@cs.wisc.edu>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2a2eef9..dc0b04c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3609,7 +3609,7 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 				goto out;
 			split_map.m_lblk = map->m_lblk;
 			split_map.m_len = allocated;
-		} else if (map->m_lblk - ee_block + map->m_len < max_zeroout) {
+		} else if (map->m_lblk - ee_block + map->m_len <= max_zeroout) {
 			/* case 2 */
 			if (map->m_lblk != ee_block) {
 				zero_ex.ee_block = ex->ee_block;
--
1.9.1

