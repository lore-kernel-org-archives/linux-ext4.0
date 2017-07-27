From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: [PATCH] e2fsprogs - dirhash.c: remove useless test and assignment in strtohash
Date: Thu, 27 Jul 2017 22:53:54 +0200
Message-ID: <1501188834-4499-1-git-send-email-damien.guibouret@partition-saving.com>
Cc: Damien Guibouret <damien.guibouret@partition-saving.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:3146 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751042AbdG0Ut4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Jul 2017 16:49:56 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On transformation of str to hash, computed value is initialised before
first byte modulo 4. But it is already initialised before entering loop
and after processing last byte modulo 4. So the corresponding test and
initialisation could be removed.

Signed-off-by: Damien Guibouret <damien.guibouret@partition-saving.com>
---
 lib/ext2fs/dirhash.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/ext2fs/dirhash.c b/lib/ext2fs/dirhash.c
index c4ac94e..4ba3f35 100644
--- a/lib/ext2fs/dirhash.c
+++ b/lib/ext2fs/dirhash.c
@@ -154,8 +154,6 @@ static void str2hashbuf(const char *msg, int len, __u32 *buf, int num,
 	if (len > num*4)
 		len = num * 4;
 	for (i=0; i < len; i++) {
-		if ((i % 4) == 0)
-			val = pad;
 		if (unsigned_flag)
 			c = (int) ucp[i];
 		else
-- 
2.5.0
