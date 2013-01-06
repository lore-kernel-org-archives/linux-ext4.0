From: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Subject: [PATCH] =?UTF-8?q?lib/ext2fs:=20Use=20=5F=5Fbuiltin=5Fpopcount=20?= =?UTF-8?q?when=20available=20Signed-off-by:=20Cristian=20Rodr=C3=ADguez?= =?UTF-8?q?=20<crrodriguez@opensuse.org>?=
Date: Sun,  6 Jan 2013 12:04:43 -0300
Message-ID: <1357484683-3021-1-git-send-email-crrodriguez@opensuse.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?q?Cristian=20Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gh0-f169.google.com ([209.85.160.169]:64185 "EHLO
	mail-gh0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3AFP2m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Jan 2013 10:28:42 -0500
Received: by mail-gh0-f169.google.com with SMTP id r11so2276927ghr.28
        for <linux-ext4@vger.kernel.org>; Sun, 06 Jan 2013 07:28:41 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

---
 lib/ext2fs/bitops.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/ext2fs/bitops.c b/lib/ext2fs/bitops.c
index 7c3f215..0668469 100644
--- a/lib/ext2fs/bitops.c
+++ b/lib/ext2fs/bitops.c
@@ -125,11 +125,15 @@ static unsigned int popcount8(unsigned int w)
 
 static unsigned int popcount32(unsigned int w)
 {
+#if __GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4)
+	return __builtin_popcount(w);
+#else
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
 	res = (res + (res >> 4)) & 0x0F0F0F0F;
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
+#endif
 }
 
 unsigned int ext2fs_bitcount(const void *addr, unsigned int nbytes)
-- 
1.8.1

