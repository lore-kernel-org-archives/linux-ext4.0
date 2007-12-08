From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ext[234]: fix comment for nonexistent variable
Date: Sun, 9 Dec 2007 00:33:37 +0900
Message-ID: <20071208153337.GB4878@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	adilger@clusterfs.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:17944 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXLHPe2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Dec 2007 10:34:28 -0500
Received: by py-out-1112.google.com with SMTP id u77so2285028pyb
        for <linux-ext4@vger.kernel.org>; Sat, 08 Dec 2007 07:34:27 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The comment in ext[234]_new_blocks() describes about "i".
But there is no local variable called "i" in that scope.
I guess it has been renamed to group_no.

Cc: Stephen Tweedie <sct@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: adilger@clusterfs.com
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 fs/ext2/balloc.c |    4 ++--
 fs/ext3/balloc.c |    2 +-
 fs/ext4/balloc.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: 2.6-git/fs/ext2/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext2/balloc.c
+++ 2.6-git/fs/ext2/balloc.c
@@ -1250,8 +1250,8 @@ retry_alloc:
 	smp_rmb();
 
 	/*
-	 * Now search the rest of the groups.  We assume that 
-	 * i and gdp correctly point to the last group visited.
+	 * Now search the rest of the groups.  We assume that
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
Index: 2.6-git/fs/ext3/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext3/balloc.c
+++ 2.6-git/fs/ext3/balloc.c
@@ -1508,7 +1508,7 @@ retry_alloc:
 
 	/*
 	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
Index: 2.6-git/fs/ext4/balloc.c
===================================================================
--- 2.6-git.orig/fs/ext4/balloc.c
+++ 2.6-git/fs/ext4/balloc.c
@@ -1625,7 +1625,7 @@ retry_alloc:
 
 	/*
 	 * Now search the rest of the groups.  We assume that
-	 * i and gdp correctly point to the last group visited.
+	 * group_no and gdp correctly point to the last group visited.
 	 */
 	for (bgi = 0; bgi < ngroups; bgi++) {
 		group_no++;
