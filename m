From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] filefrag: fix issues with 29758d2
Date: Thu, 29 May 2014 12:40:59 -0500
Message-ID: <5387712B.1060009@redhat.com>
References: <53876D7D.8050108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbaE2RmN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 29 May 2014 13:42:13 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4THfaGn002129
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 29 May 2014 13:41:37 -0400
In-Reply-To: <53876D7D.8050108@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

29758d2 filefrag: exit with error code if an error is hit

introduced a couple errors; in one case it missed returning
a value, and in the other used a test where it needed an
assignment.

Also fix a precedence problem with:

	if (fe_flags & mask == 0)

which is equivalent to:

	if (fe_flags & (mask == 0))

but we need:

	if ((fe_flags & mask) == 0)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 37c4416..1d05f47 100644
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
@@ -387,8 +387,9 @@ static int frag_report(const char *filename)
 	if (last_device != st.st_dev) {
 		if (fstatfs(fd, &fsinfo) < 0) {
 			close(fd);
+			rc = -errno;
 			perror("fstatfs");
-			return;
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

