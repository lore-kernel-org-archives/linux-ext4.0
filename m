From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] debugfs: Fix sprintf stack overflow
Date: Tue, 11 Oct 2011 18:02:21 -0700
Message-ID: <20111012010221.GN12447@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:45647 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JLBCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Oct 2011 21:02:14 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Tue, 11 Oct 2011 19:02:14 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p9C12BTj133662
	for <linux-ext4@vger.kernel.org>; Tue, 11 Oct 2011 19:02:11 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p9C12AWZ014125
	for <linux-ext4@vger.kernel.org>; Tue, 11 Oct 2011 19:02:11 -0600
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The htree dump code overflows a char buffer if the directory has a long
filename because the buffer is not large enough to hold the characters that are
not part of the filename.  Make the buffer larger and use snprintf instead.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 debugfs/htree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/debugfs/htree.c b/debugfs/htree.c
index 06e7737..05745eb 100644
--- a/debugfs/htree.c
+++ b/debugfs/htree.c
@@ -39,7 +39,7 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 	int		thislen, col = 0;
 	unsigned int	offset = 0;
 	char		name[EXT2_NAME_LEN + 1];
-	char		tmp[EXT2_NAME_LEN + 16];
+	char		tmp[EXT2_NAME_LEN + 64];
 	blk64_t		pblk;
 	ext2_dirhash_t 	hash, minor_hash;
 	unsigned int	rec_len;
@@ -91,8 +91,8 @@ static void htree_dump_leaf_node(ext2_filsys fs, ext2_ino_t ino,
 		if (errcode)
 			com_err("htree_dump_leaf_node", errcode,
 				"while calculating hash");
-		sprintf(tmp, "%u 0x%08x-%08x (%d) %s   ", dirent->inode,
-			hash, minor_hash, rec_len, name);
+		snprintf(tmp, EXT2_NAME_LEN + 64, "%u 0x%08x-%08x (%d) %s   ",
+			dirent->inode, hash, minor_hash, rec_len, name);
 		thislen = strlen(tmp);
 		if (col + thislen > 80) {
 			fprintf(pager, "\n");

