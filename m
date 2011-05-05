From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH V2] filefrag: count 0 extents properly when verbose
Date: Thu, 05 May 2011 13:21:08 -0500
Message-ID: <4DC2EA94.8040100@redhat.com>
References: <4CEC4C86.1030806@redhat.com> <4D9F3B71.2050808@redhat.com> <569EBA4C-A6BB-4E64-88B9-F2F946891B56@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755626Ab1EESVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 May 2011 14:21:11 -0400
In-Reply-To: <569EBA4C-A6BB-4E64-88B9-F2F946891B56@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

# rm -f a; touch a; filefrag a
/boot/a: 0 extents found

works properly, but

# rm -f a; touch a; filefrag -v a
Filesystem type is: ef53
Filesystem cylinder groups is approximately 61
File size of a is 0 (0 blocks, blocksize 1024)
 ext logical physical expected length flags
a: 1 extent found

yields 1 extent when it should be 0.

Fix this up by special-casing no extents returned in verbose
mode; skip printing the header for the columns too, since there
are no columns to print.

Also, in nonverbose mode we can set fm_extent_count to 0
so that FIEMAP will just query the extent count without gathering
details; clarify this with a comment.

Addresses-redhat-bugzilla: 653234
Signed-off-by: Eric Sandeen <sandeen@redhat.com>

diff --git a/misc/filefrag.c b/misc/filefrag.c
index d604b6c..2795e15 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -180,6 +180,10 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 
 	memset(fiemap, 0, sizeof(struct fiemap));
 
+	/*
+	 * If count (and therefore fm_extent_count) == 0, FIEMAP
+	 * returns count of extents found without filling in details.
+	 */
 	if (!verbose)
 		count = 0;
 
@@ -204,6 +208,14 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
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

