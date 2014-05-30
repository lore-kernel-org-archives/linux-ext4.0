From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V3] filefrag: filefrag: fix issues with 29758d2
Date: Fri, 30 May 2014 13:10:17 -0500
Message-ID: <5388C989.8050100@redhat.com>
References: <53876D7D.8050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbaE3SKU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 May 2014 14:10:20 -0400
In-Reply-To: <53876D7D.8050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

29758d2 filefrag: exit with error code if an error is hit

introduced a couple errors; in one case it missed returning
a value, and possibly picked up errno from (unchecked) close(),
and in the other used a test where it needed an
assignment.  So capture the error, move perror() directly
after the failed call in both cases, and fix the assignment.

Also fix a precedence problem with:

	if (fe_flags & mask == 0)

which is equivalent to:

	if (fe_flags & (mask == 0))

but we need:

	if ((fe_flags & mask) == 0)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 37c4416..820821b 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -175,7 +175,7 @@ static void print_extent_info(struct fiemap_extent *fm_extent, int cur_ex,
 	for (mask = 1; fe_flags != 0 && mask != 0; mask <<= 1) {
 		char hex[6];
 
-		if (fe_flags & mask == 0)
+		if ((fe_flags & mask) == 0)
 			continue;
 		sprintf(hex, "%#04x,", mask);
 		print_flag(&fe_flags, mask, flags, hex);
@@ -378,17 +378,18 @@ static int frag_report(const char *filename)
 #else
 	if (fstat(fd, &st) < 0) {
 #endif
-		close(fd);
 		rc = -errno;
 		perror("stat");
+		close(fd);
 		return rc;
 	}
 
 	if (last_device != st.st_dev) {
 		if (fstatfs(fd, &fsinfo) < 0) {
-			close(fd);
+			rc = -errno;
 			perror("fstatfs");
-			return;
+			close(fd);
+			return rc;
 		}
 		if (verbose)
 			printf("Filesystem type is: %lx\n",
@@ -556,7 +557,7 @@ int main(int argc, char**argv)
 		int rc2 = frag_report(*cpp);
 
 		if (rc2 < 0 && rc == 0)
-			rc == rc2;
+			rc = rc2;
 	}
 
 	return rc;

