From: Artemiy Volkov <artemiyv@acm.org>
Subject: [PATCH] misc: fix build on absence of magic.h
Date: Fri,  3 Oct 2014 21:58:38 +1000
Message-ID: <1412337518-2250-1-git-send-email-artemiyv@acm.org>
References: <1411277306-29807-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com,
	Artemiy Volkov <artemiyv@acm.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40031 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJCL6w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Oct 2014 07:58:52 -0400
Received: by mail-pd0-f172.google.com with SMTP id ft15so2546791pdb.3
        for <linux-ext4@vger.kernel.org>; Fri, 03 Oct 2014 04:58:51 -0700 (PDT)
In-Reply-To: <1411277306-29807-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If magic.h is not present, there will be unresolved references to the magic_t
type in plausible.c. Fix that by moving the protecting #ifdef directive.

Signed-off-by: Artemiy Volkov <artemiyv@acm.org>
---
 misc/plausible.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/plausible.c b/misc/plausible.c
index aea4fce..00bc6e2 100644
--- a/misc/plausible.c
+++ b/misc/plausible.c
@@ -36,12 +36,12 @@
 #include "nls-enable.h"
 #include "blkid/blkid.h"
 
+#ifdef HAVE_MAGIC_H
 static magic_t (*dl_magic_open)(int);
 static const char *(*dl_magic_file)(magic_t, const char *);
 static int (*dl_magic_load)(magic_t, const char *);
 static void (*dl_magic_close)(magic_t);
 
-#ifdef HAVE_MAGIC_H
 #ifdef HAVE_DLOPEN
 #include <dlfcn.h>
 
-- 
1.9.1

