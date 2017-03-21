From: Benjamin Peterson <bp@benjamin.pe>
Subject: [PATCH] ext4: fix spelling of "don't"
Date: Mon, 20 Mar 2017 22:20:11 -0700
Message-ID: <1490073611.313465.918041856.1A5E4239@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53262 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755632AbdCUFUN (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 21 Mar 2017 01:20:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Benjamin Peterson <bp@benjamin.pe>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7385e6a..4247d8d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5400,7 +5400,7 @@ int ext4_getattr(const struct path *path, struct
kstat *stat,
 	 * If there is inline data in the inode, the inode will normally
 	 not
 	 * have data blocks allocated (it may have an external xattr
 	 block).
 	 * Report at least one sector for such files, so tools like tar,
 	 rsync,
-        * others doen't incorrectly think the file is completely
sparse.
+        * others don't incorrectly think the file is completely sparse.
 	 */
 	if (unlikely(ext4_has_inline_data(inode)))
 		stat->blocks += (stat->size + 511) >> 9;
-- 
2.9.3
