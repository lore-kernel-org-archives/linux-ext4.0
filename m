From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/39] resize2fs: don't exit if shrinking sparse_super2 fs
 to one bg
Date: Sat, 25 Oct 2014 13:57:21 -0700
Message-ID: <20141025205721.532.83169.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43831 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbaJYU5z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:55 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're shrinking a sparse_super2 filesystem to a single block group,
the superblock will be in block 0.  This is perfectly valid (for block
group 0 with a blocksize > 1024) so don't exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index b59f482..ff18817 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2126,7 +2126,7 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 	if (retval)
 		return retval;
 
-	if (!sb) {
+	if (last_bg && !sb) {
 		fputs(_("Should never happen!  No sb in last super_sparse bg?\n"),
 		      stderr);
 		exit(1);

