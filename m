From: "zhenwei.pi" <zhenwei.pi@youruncloud.com>
Subject: [PATCH] ext4 : fix comments in ext4_swap_extents
Date: Sat, 24 Mar 2018 15:28:24 +0800
Message-ID: <1521876504-18326-1-git-send-email-zhenwei.pi@youruncloud.com>
Cc: zhenwei.pi@youruncloud.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"mark_unwritten" in comment and "unwritten" in variable
argument lists is mismatch.

Signed-off-by: zhenwei.pi <zhenwei.pi@youruncloud.com>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 054416e..2fc4227 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5751,7 +5751,7 @@ int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
  * @lblk1:	Start block for first inode
  * @lblk2:	Start block for second inode
  * @count:	Number of blocks to swap
- * @mark_unwritten: Mark second inode's extents as unwritten after swap
+ * @unwritten: Mark second inode's extents as unwritten after swap
  * @erp:	Pointer to save error value
  *
  * This helper routine does exactly what is promise "swap extents". All other
-- 
2.7.4
