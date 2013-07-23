From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libext2fs: ext2fs_dup_handle should deep copy MMP buffers
Date: Mon, 22 Jul 2013 22:27:37 -0700
Message-ID: <20130723052737.GG5785@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36040 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab3GWF1p (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jul 2013 01:27:45 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It turns out that resize2fs uses ext2fs_dup_handle to duplicate fs handles.  If
MMP is enabled, this causes both handles to share MMP buffers, which is bad
news when it comes time to free both fs handles.  Change the code to provide
each handle with its own separate copy of the MMP buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/dupfs.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/lib/ext2fs/dupfs.c b/lib/ext2fs/dupfs.c
index 64d3124..02721e1 100644
--- a/lib/ext2fs/dupfs.c
+++ b/lib/ext2fs/dupfs.c
@@ -40,6 +40,9 @@ errcode_t ext2fs_dup_handle(ext2_filsys src, ext2_filsys *dest)
 	fs->block_map = 0;
 	fs->badblocks = 0;
 	fs->dblist = 0;
+	fs->mmp_buf = 0;
+	fs->mmp_cmp = 0;
+	fs->mmp_fd = -1;
 
 	io_channel_bumpcount(fs->io);
 	if (fs->icache)
@@ -87,6 +90,28 @@ errcode_t ext2fs_dup_handle(ext2_filsys src, ext2_filsys *dest)
 		if (retval)
 			goto errout;
 	}
+	if (src->mmp_buf) {
+		retval = ext2fs_get_mem(src->blocksize, &fs->mmp_buf);
+		if (retval)
+			goto errout;
+		memcpy(fs->mmp_buf, src->mmp_buf, src->blocksize);
+	}
+	if (src->mmp_fd >= 0) {
+		fs->mmp_fd = dup(src->mmp_fd);
+		if (fs->mmp_fd < 0) {
+			retval = EXT2_ET_MMP_OPEN_DIRECT;
+			goto errout;
+		}
+	}
+	if (src->mmp_cmp) {
+		int align = ext2fs_get_dio_alignment(src->mmp_fd);
+
+		retval = ext2fs_get_memalign(src->blocksize, align,
+					     &fs->mmp_cmp);
+		if (retval)
+			goto errout;
+		memcpy(fs->mmp_cmp, src->mmp_cmp, src->blocksize);
+	}
 	*dest = fs;
 	return 0;
 errout:
