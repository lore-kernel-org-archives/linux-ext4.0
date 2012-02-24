From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libext2fs: include config.h for HAVE_xxx defines
Date: Fri, 24 Feb 2012 12:18:08 -0500
Message-ID: <1330103888-7005-2-git-send-email-vapier@gentoo.org>
References: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:40710 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987Ab2BXRSJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Feb 2012 12:18:09 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 34EE91B4017
	for <linux-ext4@vger.kernel.org>; Fri, 24 Feb 2012 17:18:09 +0000 (UTC)
In-Reply-To: <1330103888-7005-1-git-send-email-vapier@gentoo.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We check HAVE_UNISTD_H but haven't included config.h yet, so we end up
hitting warnings about missing prototypes for close/read/etc... funcs.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/ext2fs/mmp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index b27d9a4..49a11da 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -13,6 +13,8 @@
 #define _GNU_SOURCE
 #endif
 
+#include "config.h"
+
 #if HAVE_UNISTD_H
 #include <unistd.h>
 #endif
-- 
1.7.8.4

