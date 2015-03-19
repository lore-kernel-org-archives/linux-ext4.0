From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: don't retry file block mapping on bigalloc fs with
 non-extent file
Date: Thu, 19 Mar 2015 14:25:57 -0700
Message-ID: <20150319212557.GG11031@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28901 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbCSV0D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Mar 2015 17:26:03 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 isn't willing to map clusters to a non-extent file.  Don't signal
this with an out of space error, since the FS will retry the
allocation (which didn't fail) forever.  Instead, return EUCLEAN so
that the operation will fail immediately all the way back to userspace.

(The fix is either to run e2fsck -E bmap2extent, or to chattr +e the file.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/indirect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 45fe924..b46f2b2 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -565,7 +565,7 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				       EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
 		EXT4_ERROR_INODE(inode, "Can't allocate blocks for "
 				 "non-extent mapped inodes with bigalloc");
-		return -ENOSPC;
+		return -EUCLEAN;
 	}
 
 	/* Set up for the direct block allocation */
