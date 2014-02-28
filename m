From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 6/8] fsstress: translate flags in fiemap_f
Date: Fri, 28 Feb 2014 17:11:03 +0100
Message-ID: <1393603865-26198-6-git-send-email-lczerner@redhat.com>
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbaB1QLU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Feb 2014 11:11:20 -0500
In-Reply-To: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Translate flags in fiemap_f output to human readable strings.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 ltp/fsstress.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 24864db..869a8ac 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2252,6 +2252,18 @@ fdatasync_f(int opno, long r)
 	free_pathname(&f);
 	close(fd);
 }
+
+#ifdef HAVE_LINUX_FIEMAP_H
+struct print_flags fiemap_flags[] = {
+	{ FIEMAP_FLAG_SYNC, "SYNC"},
+	{ FIEMAP_FLAG_XATTR, "XATTR"},
+	{ -1, NULL}
+};
+
+#define translate_fiemap_flags(mode)	\
+	({translate_flags(mode, "|", fiemap_flags);})
+#endif
+
 void
 fiemap_f(int opno, long r)
 {
@@ -2314,9 +2326,10 @@ fiemap_f(int opno, long r)
 
 	e = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
 	if (v)
-		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld %x %d\n",
+		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld (%s) %d\n",
 		       procid, opno, f.path, st, (long long)fiemap->fm_start,
-		       (long long) fiemap->fm_length, fiemap->fm_flags, e);
+		       (long long) fiemap->fm_length,
+		       translate_fiemap_flags(fiemap->fm_flags), e);
 	free(fiemap);
 	free_pathname(&f);
 	close(fd);
-- 
1.8.3.1

