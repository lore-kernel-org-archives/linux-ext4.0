From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH 2/3] lib: improve the performance of memcpy and memmove of
 the general version
Date: Wed, 01 Sep 2010 18:36:28 +0800
Message-ID: <4C7E2CAC.6080102@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65356 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab0IAKhC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 1 Sep 2010 06:37:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

the performance of memcpy and memmove of the general version is
very inefficient, this patch improved them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 lib/string.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index f71bead..6cbf6d8 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -23,6 +23,7 @@
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/module.h>
+#include <linux/memcopy.h>
 
 #ifndef __HAVE_ARCH_STRNICMP
 /**
@@ -567,11 +568,12 @@ EXPORT_SYMBOL(memset);
  */
 void *memcpy(void *dest, const void *src, size_t count)
 {
-	char *tmp = dest;
-	const char *s = src;
+	unsigned long dstp = (unsigned long)dest;
+	unsigned long srcp = (unsigned long)src;
+
+	/* Copy from the beginning to the end */
+	mem_copy_fwd(dstp, srcp, count);
 
-	while (count--)
-		*tmp++ = *s++;
 	return dest;
 }
 EXPORT_SYMBOL(memcpy);
@@ -588,21 +590,15 @@ EXPORT_SYMBOL(memcpy);
  */
 void *memmove(void *dest, const void *src, size_t count)
 {
-	char *tmp;
-	const char *s;
-
-	if (dest <= src) {
-		tmp = dest;
-		s = src;
-		while (count--)
-			*tmp++ = *s++;
+	unsigned long dstp = (unsigned long)dest;
+	unsigned long srcp = (unsigned long)src;
+
+	if (dest - src >= count) {
+		/* Copy from the beginning to the end */
+		mem_copy_fwd(dstp, srcp, count);
 	} else {
-		tmp = dest;
-		tmp += count;
-		s = src;
-		s += count;
-		while (count--)
-			*--tmp = *--s;
+		/* Copy from the end to the beginning */
+		mem_copy_bwd(dstp, srcp, count);
 	}
 	return dest;
 }
-- 
1.7.0.1
