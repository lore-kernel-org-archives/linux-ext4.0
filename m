From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/37] resize2fs: fix check for collision between old GDT
 and superblock on sparse_super2 fs
Date: Thu, 01 May 2014 16:13:08 -0700
Message-ID: <20140501231308.31890.72322.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28368 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaEAXNO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:14 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In reserve_sparse_super2_last_group, the old_desc check should only be
performed if ext2fs_super_and_bgd_loc2() gave us a location -- a
return value of 0 means that there is no old-style GDT block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index f5f1337..a81a1c3 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2121,7 +2121,7 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 		      stderr);
 		exit(1);
 	}
-	if (old_desc != sb+1) {
+	if (old_desc && old_desc != sb+1) {
 		fputs(_("Should never happen!  Unexpected old_desc in "
 			"super_sparse bg?\n"),
 		      stderr);

