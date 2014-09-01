From: Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] ext4: fix comments about get_blocks
Date: Mon,  1 Sep 2014 22:16:02 +0900
Message-ID: <1409577362-4045-1-git-send-email-waydi1@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Seunghun Lee <waydi1@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

get_blocks is renamed to get_block.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ext4/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3aa26e9..6c91fb3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -590,7 +590,7 @@ found:
 	/*
 	 * New blocks allocate and/or writing to unwritten extent
 	 * will possibly result in updating i_data, so we take
-	 * the write lock of i_data_sem, and call get_blocks()
+	 * the write lock of i_data_sem, and call get_block()
 	 * with create == 1 flag.
 	 */
 	down_write(&EXT4_I(inode)->i_data_sem);
@@ -1536,7 +1536,7 @@ out_unlock:
 }
 
 /*
- * This is a special get_blocks_t callback which is used by
+ * This is a special get_block_t callback which is used by
  * ext4_da_write_begin().  It will either return mapped block or
  * reserve space for a single block.
  *
-- 
1.7.9.5
