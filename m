From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/25] libext2fs: stop iterating dirents when done linking
Date: Thu, 17 Oct 2013 21:49:01 -0700
Message-ID: <20131018044901.7339.55731.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47300 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3JREtH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:49:07 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we've succesfully linked an inode into a directory, we can stop
iterating the directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/link.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 2a44575..09e6cb4 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -45,7 +45,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	struct ext2_dir_entry_tail *t;
 
 	if (ls->done)
-		return 0;
+		return DIRENT_ABORT;
 
 	rec_len = EXT2_DIR_REC_LEN(ls->namelen);
 

