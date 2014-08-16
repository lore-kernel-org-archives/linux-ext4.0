From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/27] e2fuzz: fix pwrite64/pwrite usage
Date: Sat, 16 Aug 2014 16:45:57 -0700
Message-ID: <20140816234557.11171.51119.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43319 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaHPXqE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:04 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Select pwrite64 or pwrite depending on what autoconf finds.  This
makes e2fuzz find a suitable pwrite variant regardless of platform.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/e2fuzz.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
index 91aafe5..5794f97 100644
--- a/misc/e2fuzz.c
+++ b/misc/e2fuzz.c
@@ -32,15 +32,15 @@ static int metadata_only = 1;
 static unsigned long long user_corrupt_bytes = 0;
 static double user_corrupt_pct = 0.0;
 
-#ifndef HAVE_PWRITE
-ssize_t pwrite(int fd, const void *buf, size_t count, off_t offset)
+#if !defined HAVE_PWRITE64 && !defined HAVE_PWRITE
+static ssize_t my_pwrite(int fd, const void *buf, size_t count, off_t offset)
 {
 	if (lseek(fd, offset, SEEK_SET) < 0)
 		return 0;
 
 	return write(fd, buf, count);
 }
-#endif /* HAVE_PWRITE */
+#endif /* !defined HAVE_PWRITE64 && !defined HAVE_PWRITE */
 
 int getseed(void)
 {
@@ -276,10 +276,22 @@ int process_fs(const char *fsname)
 			       off % fs->blocksize, off / fs->blocksize, c);
 		if (dryrun)
 			continue;
+#ifdef HAVE_PWRITE64
+		if (pwrite64(fd, &c, sizeof(c), off) != sizeof(c)) {
+			perror(fsname);
+			goto fail3;
+		}
+#elif HAVE_PWRITE
 		if (pwrite(fd, &c, sizeof(c), off) != sizeof(c)) {
 			perror(fsname);
 			goto fail3;
 		}
+#else
+		if (my_pwrite(fd, &c, sizeof(c), off) != sizeof(c)) {
+			perror(fsname);
+			goto fail3;
+		}
+#endif
 	}
 	close(fd);
 

