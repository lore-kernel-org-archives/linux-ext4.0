From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/6] misc: fix resource leaks in e2fsprogs
Date: Mon, 20 Jan 2014 22:21:45 -0800
Message-ID: <20140121062145.20507.54068.stgit@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20465 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaAUGVu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:21:50 -0500
In-Reply-To: <20140121062138.20507.60259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/icount.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index a3b20f0..7d1b3d5 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -198,6 +198,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	fd = mkstemp(fn);
 	if (fd < 0) {
 		retval = errno;
+		ext2fs_free_mem(&fn);
 		goto errout;
 	}
 	umask(save_umask);
@@ -216,6 +217,7 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs, char *tdb_dir,
 	close(fd);
 	if (icount->tdb == NULL) {
 		retval = errno;
+		ext2fs_free_mem(&fn);
 		goto errout;
 	}
 	*ret = icount;

