From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] filefrag: don't print extent header on bmap fallback
Date: Wed, 05 Aug 2009 22:30:48 -0500
Message-ID: <4A7A4E68.3050202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49524 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZHFDat (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Aug 2009 23:30:49 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n763Uo5M010167
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 23:30:50 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n763UnX8013824
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 23:30:50 -0400
Received: from liberator.sandeen.net (sebastian-int.corp.redhat.com [172.16.52.221])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n763Um3o008531
	for <linux-ext4@vger.kernel.org>; Wed, 5 Aug 2009 23:30:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The extent list header gets printed before we fall back to bmap:

# filefrag -v /mnt/test/bar
Filesystem type is: 58465342
File size of /mnt/test/bar is 12288 (3 blocks, blocksize 4096)
 ext logical physical expected length flags <---- HERE
Discontinuity: Block 2 is at 17 (was 16)
/mnt/test/bar: 2 extents found

so delay printing it until we know fiemap is working.

(though ideally it'd be nice to have the same verbose output
regardless of the interface we used, I think).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/misc/filefrag.c b/misc/filefrag.c
index 128a391..de0444c 100644
--- a/misc/filefrag.c
+++ b/misc/filefrag.c
@@ -173,6 +173,7 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	unsigned long flags = 0;
 	unsigned int i;
 	static int fiemap_incompat_printed;
+	int fiemap_header_printed = 0;
 	int tot_extents = 1, n = 0;
 	int last = 0;
 	int rc;
@@ -190,11 +191,6 @@ static int filefrag_fiemap(int fd, int blk_shift, int *num_extents)
 	if (xattr_map)
 		flags |= FIEMAP_FLAG_XATTR;
 
-	if (verbose)
-		printf(" ext %*s %*s %*s length flags\n", logical_width,
-		       "logical", physical_width, "physical",
-		       physical_width, "expected");
