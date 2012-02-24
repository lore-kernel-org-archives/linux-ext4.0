From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libext2fs: include sys/time.h for gettimeofday()
Date: Fri, 24 Feb 2012 12:18:07 -0500
Message-ID: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40707 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab2BXRSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 12:18:09 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 8A7BE1B400A
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 17:18:08 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Building on my glibc-2.15 system hits a warning:
	gen_bitmap64.c: In function 'ext2fs_alloc_generic_bmap':
	gen_bitmap64.c:127:2: warning: implicit declaration of function
		'gettimeofday' [-Wimplicit-function-declaration]

Include sys/time.h if it's available for the prototype.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/ext2fs/gen_bitmap64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index bf1a76b..fa8d7b7 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -25,6 +25,9 @@
 #if HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
+#ifdef HAVE_SYS_TIME_H
+#include <sys/time.h>
+#endif
 
 #include "ext2_fs.h"
 #include "ext2fsP.h"
-- 
1.7.8.4

