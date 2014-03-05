From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
Date: Wed,  5 Mar 2014 16:51:37 +0100
Message-ID: <1394034699-21187-7-git-send-email-lczerner@redhat.com>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Translate flags in fiemap_f output to human readable strings.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 ltp/fsstress.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 00fda36..40f9a03 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2266,6 +2266,18 @@ fdatasync_f(int opno, long r)
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
@@ -2328,9 +2340,10 @@ fiemap_f(int opno, long r)
 
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

