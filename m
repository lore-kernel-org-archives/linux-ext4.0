From: Damien Guibouret <damien.guibouret@partition-saving.com>
Subject: [PATCH] ext4/hash.c: remove useless test and assignment in strtohash
Date: Thu, 27 Jul 2017 22:53:27 +0200
Message-ID: <1501188807-4459-1-git-send-email-damien.guibouret@partition-saving.com>
Cc: Damien Guibouret <damien.guibouret@partition-saving.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:2384 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdG0Utj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Jul 2017 16:49:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On transformation of str to hash, computed value is initialised before
first byte modulo 4. But it is already initialised before entering loop
and after processing last byte modulo 4. So the corresponding test and
initialisation could be removed.

Signed-off-by: Damien Guibouret <damien.guibouret@partition-saving.com>
---
 fs/ext4/hash.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/ext4/hash.c b/fs/ext4/hash.c
index 38b8a96..00c6dd2 100644
--- a/fs/ext4/hash.c
+++ b/fs/ext4/hash.c
@@ -148,8 +148,6 @@ static void str2hashbuf_signed(const char *msg, int len, __u32 *buf, int num)
 	if (len > num*4)
 		len = num * 4;
 	for (i = 0; i < len; i++) {
-		if ((i % 4) == 0)
-			val = pad;
 		val = ((int) scp[i]) + (val << 8);
 		if ((i % 4) == 3) {
 			*buf++ = val;
@@ -176,8 +174,6 @@ static void str2hashbuf_unsigned(const char *msg, int len, __u32 *buf, int num)
 	if (len > num*4)
 		len = num * 4;
 	for (i = 0; i < len; i++) {
-		if ((i % 4) == 0)
-			val = pad;
 		val = ((int) ucp[i]) + (val << 8);
 		if ((i % 4) == 3) {
 			*buf++ = val;
-- 
2.5.0
