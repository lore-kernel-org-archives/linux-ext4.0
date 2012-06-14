From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH] E2fsprogs/filefrag: fix filefrag regression
Date: Thu, 14 Jun 2012 16:44:46 +0800
Message-ID: <1339663486-5417-1-git-send-email-liubo2009@cn.fujitsu.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab2FNIhT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Jun 2012 04:37:19 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q5E8bGUQ031950
	for <linux-ext4@vger.kernel.org>; Thu, 14 Jun 2012 16:37:16 +0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

filefrag has several bugs:

1.
$ touch f1
$ filefrag f1
f1: 1 extent found  ----> bug!
$ filefrag -v f1
Filesystem type is: ef53
File size of f1 is 0 (0 blocks, blocksize 4096)
f1: 0 extents found

2.
$ truncate -s 1m f2
$ filefrag f2
f2: 1 extent found  ----> bug!
$ filefrag -v f2
Filesystem type is: ef53
File size of f2 is 1048576 (256 blocks, blocksize 4096)
f2: 0 extents found

3.
$ for i in `seq 11 -2 0`; do dd if=/dev/zero of=f4 bs=4k count=1 seek=$i conv=notrunc oflag=sync &>/dev/null; done
$ ll f4
-rw-r--r-- 1 root root 49152 Jun  9 15:09 f4
$ filefrag f4
f4: 7 extents found
$ filefrag -v f4
Filesystem type is: ef53
File size of f4 is 49152 (12 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       1  1109993               1
   1       3  1109992  1109994      1
   2       5  1109991  1109993      1
   3       7  1109990  1109992      1
   4       9  1109989  1109991      1
   5      11  1108207  1109990      1 eof
f4: 7 extents found  --------------------------> but we only have 6 extents, bug!

All of these bugs come from the fact that we've made a mistake on calculating
total extents:
o   we set 1 as default for 'total extents', and this will report 1 extent found
    even when we don't get any extent from fiemap.
o   if our first extent does not start from 0(logical addr), total extents will
    be one more than what it should be.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 misc/filefrag.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 0583e91..af008fb 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -175,7 +175,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	unsigned int i;
 	static int fiemap_incompat_printed;
 	int fiemap_header_printed = 0;
-	int tot_extents = 1, n = 0;
+	int tot_extents = 0, n = 0;
 	int last = 0;
 	int rc;
 
@@ -201,25 +201,17 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 			return rc;
 		}
 
+		/* If 0 extents are returned, then more ioctls are not needed */
+		if (fiemap->fm_mapped_extents == 0)
+			break;
+
 		if (verbose && !fiemap_header_printed) {
-			/*
-			 * No extents on first call?
-			 * Skip header and show 0 extents.
-			 */
-			if (fiemap->fm_mapped_extents == 0) {
-				*num_extents = 0;
-				goto out;
-			}
 			printf(" ext %*s %*s %*s length flags\n", logical_width,
 			       "logical", physical_width, "physical",
 			       physical_width, "expected");
 			fiemap_header_printed = 1;
 		}
 
-		/* If 0 extents are returned, then more ioctls are not needed */
-		if (fiemap->fm_mapped_extents == 0)
-			break;
