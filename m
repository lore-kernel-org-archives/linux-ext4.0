From: Ali Gholami Rudi <ali@rudi.ir>
Subject: [PATCH][TRIVIAL] ext2: fix a typo in ext2.h
Date: Mon, 30 Mar 2009 16:49:27 +0430
Message-ID: <20090330121927.GA2237@lilem.mirepesht>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757468AbZC3MUi@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Signed-off-by: Ali Gholami Rudi <ali@rudi.ir>
---
 fs/ext2/ext2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 3203042..6888b2d 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -27,7 +27,7 @@ struct ext2_inode_info {
 	/*
 	 * i_block_group is the number of the block group which contains
 	 * this file's inode.  Constant across the lifetime of the inode,
-	 * it is ued for making block allocation decisions - we try to
+	 * it is used for making block allocation decisions - we try to
 	 * place a file's data blocks near its inode block, and new inodes
 	 * near to their parent directory's inode.
 	 */
