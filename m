From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] libext2fs: Micro-optimization in inode scan code
Date: Mon, 31 Mar 2008 19:36:28 -0400
Message-ID: <1207006592-13980-7-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
 <1207006592-13980-4-git-send-email-tytso@mit.edu>
 <1207006592-13980-5-git-send-email-tytso@mit.edu>
 <1207006592-13980-6-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61477 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbYCaXjS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:18 -0400
In-Reply-To: <1207006592-13980-6-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/inode.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index b4a445d..bd568b3 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -239,9 +239,8 @@ static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 		scan->inodes_left -=
 			fs->group_desc[scan->current_group].bg_itable_unused;
 		scan->blocks_left =
-			(EXT2_INODES_PER_GROUP(fs->super) -
-			 fs->group_desc[scan->current_group].bg_itable_unused +
-			 fs->blocksize / scan->inode_size - 1) *
+			(scan->inodes_left +
+			 (fs->blocksize / scan->inode_size - 1)) *
 			scan->inode_size / fs->blocksize;
 	}
 
-- 
1.5.4.1.144.gdfee-dirty

