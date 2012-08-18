From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] respect HAVE_MALLOC_H
Date: Sat, 18 Aug 2012 18:17:41 -0400
Message-ID: <1345328261-3004-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:60287 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab2HRWRk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Aug 2012 18:17:40 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id C3CD11B4004
	for <linux-ext4@vger.kernel.org>; Sat, 18 Aug 2012 22:17:39 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Most places respect this define, but this one doesn't.

Reported-by: Dmitri Bogomolov <4glitch@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 util/symlinks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/util/symlinks.c b/util/symlinks.c
index f3a632a..abb33f8 100644
--- a/util/symlinks.c
+++ b/util/symlinks.c
@@ -8,7 +8,9 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#ifdef HAVE_MALLOC_H
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #include <sys/param.h>
-- 
1.7.9.7

