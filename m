From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] libext2fs: When truncating file, punch out blocks at end
Date: Fri, 06 Jan 2012 20:47:37 -0800
Message-ID: <20120107044737.3366.45151.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43760 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084Ab2AGEsZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Jan 2012 23:48:25 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Fri, 6 Jan 2012 23:48:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q074lcRR223680
	for <linux-ext4@vger.kernel.org>; Fri, 6 Jan 2012 23:47:38 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q074lcq6002898
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jan 2012 02:47:38 -0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently, ext2fs_file_set_size2 punches out data blocks between the end of the
file and infinity when truncate_block <= old_truncate (i.e. when you've made
the file longer).  This is not a useful behavior, particularly since it *fails*
to punch out the data blocks when the file is shortened (i.e. truncate_block <
old_truncate).  This seems to be the result of the test being backwards, so fix
the code to punch only when the file is getting shorter.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/fileio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index d56f5b5..8751635 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -389,7 +389,7 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 			return retval;
 	}
 
-	if (truncate_block <= old_truncate)
+	if (truncate_block >= old_truncate)
 		return 0;
 
 	return ext2fs_punch(file->fs, file->ino, &file->inode, 0,

