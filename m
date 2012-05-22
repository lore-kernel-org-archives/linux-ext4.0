From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libquota: add missing time.h include
Date: Tue, 22 May 2012 15:41:50 -0400
Message-ID: <1337715710-9484-1-git-send-email-vapier@gentoo.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57696 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab2EVTkp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2012 15:40:45 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 7796B1B400C
	for <linux-ext4@vger.kernel.org>; Tue, 22 May 2012 19:40:44 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This code uses time() but doesn't include time.h leading to:
quotaio.c:89:2: warning: implicit declaration of function 'time'

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/quota/quotaio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 481d5f5..6e917f0 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <stdlib.h>
+#include <time.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/file.h>
-- 
1.7.8.6

