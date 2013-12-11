From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 30/74] libext2fs: fix a broken close() test
Date: Tue, 10 Dec 2013 17:21:41 -0800
Message-ID: <20131211012141.30655.33189.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26608 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3LKBVq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:21:46 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zero is a valid file descriptor, so close it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/mkjournal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 09ca412..69ac135 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -595,7 +595,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks, int flags)
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 errout:
-	if (fd > 0)
+	if (fd >= 0)
 		close(fd);
 	return retval;
 }

