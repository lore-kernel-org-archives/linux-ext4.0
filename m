From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/49] e2fsck: don't rehash inline directories
Date: Mon, 10 Mar 2014 23:54:49 -0700
Message-ID: <20140311065449.30585.54020.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21215 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaCKGyy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:54:54 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a directory's contents are stored entirely inside the inode,
there's no index to rebuild and no dirblock checksum to recompute.
As far as I know these are the only two reasons to call dir rehash.

Therefore, we can move on to the next dir instead of what we do right
now, which is try to iterate the dir blocks (which of course fails due
to the inline_data iflag being set) and then flood stdout with useless
messages that aren't even failures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/rehash.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 8a99453..3b05715 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -794,6 +794,11 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino)
 	outdir.hashes = 0;
 	e2fsck_read_inode(ctx, ino, &inode, "rehash_dir");
 
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	   (inode.i_flags & EXT4_INLINE_DATA_FL))
+		return 0;
+
 	retval = ENOMEM;
 	fd.harray = 0;
 	dir_buf = malloc(inode.i_size);
@@ -822,8 +827,6 @@ retry_nohash:
 	/* Read in the entire directory into memory */
 	retval = ext2fs_block_iterate3(fs, ino, 0, 0,
 				       fill_dir_block, &fd);
-	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE)
-		goto errout;
 	if (fd.err) {
 		retval = fd.err;
 		goto errout;

