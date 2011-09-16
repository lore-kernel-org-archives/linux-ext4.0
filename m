From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/25] libe2p: reach unreachable code
Date: Fri, 16 Sep 2011 15:49:26 -0500
Message-ID: <1316206180-6375-12-git-send-email-sandeen@redhat.com>
References: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46746 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755667Ab1IPUtp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Sep 2011 16:49:45 -0400
In-Reply-To: <1316206180-6375-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The EOPNOTSUPP case is unreachable, being outside a set of:
 #if
	...
	return;
 #else
	...
	return;
 #endif

Fix this up so that if neither HAVE_CHFLAGS nor
HAVE_EXT2_IOCTLS applies, we set EOPNOTSUPP.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/e2p/setflags.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/lib/e2p/setflags.c b/lib/e2p/setflags.c
index 72cf441..b203606 100644
--- a/lib/e2p/setflags.c
+++ b/lib/e2p/setflags.c
@@ -55,7 +55,7 @@ int setflags (int fd, unsigned long flags)
 #endif
 
 	return fchflags (fd, bsd_flags);
-#else
+#else /* ! HAVE_CHFLAGS */
 #if HAVE_EXT2_IOCTLS
 	struct stat buf;
 	int	f;
@@ -68,8 +68,9 @@ int setflags (int fd, unsigned long flags)
 	f = (int) flags;
 
 	return ioctl(fd, EXT2_IOC_SETFLAGS, &f);
-#endif /* HAVE_EXT2_IOCTLS */
-#endif
+#else
 	errno = EOPNOTSUPP;
 	return -1;
+#endif /* HAVE_EXT2_IOCTLS */
+#endif /* HAVE_CHFLAGS */
 }
-- 
1.7.4.1

