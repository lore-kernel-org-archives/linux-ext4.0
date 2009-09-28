From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] blkid/Makefile.in: ignore rmdir non-empty dir error
Date: Mon, 28 Sep 2009 18:57:22 +0800
Message-ID: <1254135442-28755-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Peng Tao <bergwolf@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f191.google.com ([209.85.222.191]:51750 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZI1K52 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Sep 2009 06:57:28 -0400
Received: by pzk29 with SMTP id 29so2316201pzk.33
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2009 03:57:32 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Otherwise, make clean returns the following error, which is missleading.
rmdir tests
rmdir: failed to remove `tests': Directory not empty
make: [clean] Error 1 (ignored)

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 lib/blkid/Makefile.in |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/blkid/Makefile.in b/lib/blkid/Makefile.in
index 9169226..618c0b2 100644
--- a/lib/blkid/Makefile.in
+++ b/lib/blkid/Makefile.in
@@ -181,7 +181,7 @@ clean::
 		tests/*.img results test_probe core profiled/* \
 		checker/* blkid_types.h ../libblkid.a ../libblkid_p.a \
 		$(SMANPAGES) blkid
-	-rmdir tests
+	-rmdir --ignore-fail-on-non-empty tests
 
 mostlyclean:: clean
 distclean:: clean
-- 
1.6.5.rc2.262.g5224f

