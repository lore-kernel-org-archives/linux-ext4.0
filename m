From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] filefrag: count optimize non-verbose mode; count 0 extents
 properly when verbose
Date: Tue, 23 Nov 2010 17:21:42 -0600
Message-ID: <4CEC4C86.1030806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316Ab0KWXVp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Nov 2010 18:21:45 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oANNLiVp013414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Nov 2010 18:21:44 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oANNLgcC020059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 23 Nov 2010 18:21:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

# rm -f a; touch a; filefrag -v a

yields 1 extent when it should be 0.  Without -v, 0 is returned.

Fix this up by special-casing no extents returned in verbose
mode; skip printing the header for the columns too, since there
are no columns to print.

Also, in nonverbose mode we can set fm_extent_count to 0
so that FIEMAP will just query the extent count without gathering
details; as it is today I think a non-verbose query may under-report
the extent count once "count" extents have been filled in.

Addresses-redhat-bugzilla: 653234
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index bd4486d..a48b9b0 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -194,7 +194,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	do {
 		fiemap->fm_length = ~0ULL;
 		fiemap->fm_flags = flags;
-		fiemap->fm_extent_count = count;
+		/*
+		 * If fm_extent_count == 0, FIEMAP returns count of
+		 * extents found without filling in details.
+		 */
+		if (!verbose)
+			fiemap->fm_extent_count = 0;
+		else
+			fiemap->fm_extent_count = count;
 		rc = ioctl(fd, FS_IOC_FIEMAP, (unsigned long) fiemap);
 		if (rc < 0) {
 			if (errno == EBADR && fiemap_incompat_printed == 0) {
@@ -206,6 +213,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 		}
 
 		if (verbose && !fiemap_header_printed) {
+			/*
+			 * No extents on first call?
+			 * Skip header and show 0 extents.
+			 */
+			if (fiemap->fm_mapped_extents == 0) {
+				*num_extents = 0;
+				goto out;
+			}
 			printf(" ext %*s %*s %*s length flags\n", logical_width,
 			       "logical", physical_width, "physical",
 			       physical_width, "expected");
