From: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Subject: [PATCH] plausible: fix compilation on RHEL 5.x due to missing magic define
Date: Thu, 20 Oct 2016 09:25:05 +0200
Message-ID: <1476948305-563-1-git-send-email-patrickdepinguin@gmail.com>
Cc: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33348 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756877AbcJTHZ2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2016 03:25:28 -0400
Received: by mail-lf0-f67.google.com with SMTP id l131so5995965lfl.0
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2016 00:25:27 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

RHEL 5.x does have magic.h, but it does not define all expected symbols. In
particular, the NO_CHECK symbols were only added in file 4.20 and RHEL 5.x
is using 4.17.

Add substitute defines to allow continued usage of magic but without the
requested exclude checks.

Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
---
 lib/support/plausible.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

Note: instead of filling in the actual (current) values for these defines, we
could also have filled them with zero as libmagic will not recognize them
anyway.

diff --git a/lib/support/plausible.c b/lib/support/plausible.c
index 6f0c4bc..0636061 100644
--- a/lib/support/plausible.c
+++ b/lib/support/plausible.c
@@ -43,6 +43,17 @@ static const char *(*dl_magic_file)(magic_t, const char *);
 static int (*dl_magic_load)(magic_t, const char *);
 static void (*dl_magic_close)(magic_t);
 
+/*
+ * NO_CHECK functionality was only added in file 4.20.
+ * Older systems like RHEL 5.x still have file 4.17
+ */
+#ifndef MAGIC_NO_CHECK_COMPRESS
+#define MAGIC_NO_CHECK_COMPRESS 0x0001000
+#endif
+#ifndef MAGIC_NO_CHECK_ELF
+#define MAGIC_NO_CHECK_ELF 0x0010000
+#endif
+
 #ifdef HAVE_DLOPEN
 #include <dlfcn.h>
 
-- 
2.7.3

