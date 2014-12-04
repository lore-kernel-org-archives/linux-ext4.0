From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 51/47] e2fsck: force-reread of inode from disk when
 re-checking a checksum error
Date: Thu, 4 Dec 2014 12:39:03 -0800
Message-ID: <20141204203903.GC10059@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24639 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaLDUjM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2014 15:39:12 -0500
Content-Disposition: inline
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're rechecking an inode checksum failure, we need to force the
inode to be re-read from disk so that the verification routine runs,
so drop the stashed inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 82792e4..0073bed 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -671,6 +671,7 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 	 * Reread inode.  If we don't see checksum error, then this inode
 	 * has been fixed elsewhere.
 	 */
+	ctx->stashed_ino = 0;
 	retval = ext2fs_read_inode_full(fs, ino, (struct ext2_inode *)&inode,
 					sizeof(inode));
 	if (retval && retval != EXT2_ET_INODE_CSUM_INVALID)
