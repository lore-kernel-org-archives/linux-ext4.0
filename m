From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] jbd2: export __jbd2_debug for modular builds
Date: Thu, 13 Jun 2013 09:45:30 -0400
Message-ID: <1371131130-1894-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-ext4@vger.kernel.org>,
	Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:44238 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab3FMNpj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Jun 2013 09:45:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit "jbd2: use a single printk for jbd_debug()" introduced
a new function, __jbd2_debug.  However it needs to be exported
or the final modpost stage of the build will fail with:

  ERROR: "__jbd2_debug" [fs/ext4/ext4.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[Feel free to squash this into the original commit since it is
in your dev branch.]

 fs/jbd2/journal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 331fd59..4c8b8d4 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -118,6 +118,7 @@ void __jbd2_debug(int level, const char *file, const char *func,
 	printk(KERN_DEBUG "%s: (%s, %u): %pV\n", file, func, line, &vaf);
 	va_end(args);
 }
+EXPORT_SYMBOL(__jbd2_debug);
 #endif
 
 /* Checksumming functions */
-- 
1.8.1.2

