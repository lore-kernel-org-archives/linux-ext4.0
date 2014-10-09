From: Steven Honeyman <stevenhoneyman@gmail.com>
Subject: [PATCH] misc: fix build without magic.h
Date: Thu, 9 Oct 2014 22:39:22 +0100
Message-ID: <CABz95_A18aY0VkamhuoZ-ziAVf2mzs6vsCmxbUyVVxDet49++A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41228 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaJIVjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2014 17:39:24 -0400
Received: by mail-wi0-f181.google.com with SMTP id hi2so275061wib.2
        for <linux-ext4@vger.kernel.org>; Thu, 09 Oct 2014 14:39:22 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This prevents a failed build if magic.h doesn't exist, because type
magic_t will be unknown.

Fixes: d2e3c0dc60cd ("misc: if dlopen() is available, use it to load
the libmagic library")
Signed-off-by: Steven Honeyman <stevenhoneyman@gmail.com>
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
2.1.2
