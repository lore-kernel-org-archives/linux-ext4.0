From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libquota: add a quotactl prototype
Date: Tue, 22 May 2012 15:41:29 -0400
Message-ID: <1337715689-7116-1-git-send-email-vapier@gentoo.org>
Cc: adilger@whamcloud.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:57656 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab2EVTkZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2012 15:40:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The commit 0df8a27bbaf51b55c0e8c3a533ef4c2ff9d79c9f removed the system
quota.h include, but in doing so, added the problem:
mkquota.c:55:2: warning: implicit declaration of function 'quotactl'

Since we're maintaining a copy of quota.h, add a proper func prototype.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/quota/quota.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/quota/quota.h b/lib/quota/quota.h
index a943ec6..3eaec1d 100644
--- a/lib/quota/quota.h
+++ b/lib/quota/quota.h
@@ -152,4 +152,9 @@ enum {
 };
 #define QUOTA_NL_A_MAX (__QUOTA_NL_A_MAX - 1)
 
+#ifdef HAVE_QUOTACTL
+extern int quotactl(int __cmd, const char *__special, int __id,
+		    caddr_t __addr);
+#endif
+
 #endif /* _QUOTA_ */
-- 
1.7.8.6

