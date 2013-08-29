From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/6] libext2fs: ext2fs_dup_handle should not alias MMP buffers
Date: Wed, 28 Aug 2013 17:43:51 -0700
Message-ID: <20130829004350.3190.12494.stgit@blackbox.djwong.org>
References: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3H2An6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Aug 2013 20:43:58 -0400
In-Reply-To: <20130829004344.3190.28053.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It turns out that resize2fs uses ext2fs_dup_handle to duplicate fs handles.  If
MMP is enabled, this causes both handles to share MMP buffers, which is bad
news when it comes time to free both handles.  Change the code to (we hope) fix
this.  This prevents resize2fs from failing with a double-free error when
handed a MMP filesystem.

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

