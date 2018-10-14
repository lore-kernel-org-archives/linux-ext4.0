From: liusong@tom.com
Subject: [PATCH] ext4: direct return when jinode allocate failed in ext4_inode_attach_jinode
Date: Mon, 15 Oct 2018 00:05:22 +0800
Message-ID: <20181014160522.3395-1-liusong@tom.com>
Cc: liu.song11@zte.com.cn, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Liu Song <liu.song11@zte.com.cn>

Allocating memory for jinode do not need protected by *i_lock*.
Should return directly if memory allocation fails without holding
a spinlock.

Signed-off-by: Liu Song <liu.song11@zte.com.cn>
---
 fs/ext4/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d0dd585add6a..341d84521d11 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4382,12 +4382,11 @@ int ext4_inode_attach_jinode(struct inode *inode)
 		return 0;
 
 	jinode = jbd2_alloc_inode(GFP_KERNEL);
+	if (!jinode)
+		return -ENOMEM;
+
 	spin_lock(&inode->i_lock);
 	if (!ei->jinode) {
-		if (!jinode) {
-			spin_unlock(&inode->i_lock);
-			return -ENOMEM;
-		}
 		ei->jinode = jinode;
 		jbd2_journal_init_jbd_inode(ei->jinode, inode);
 		jinode = NULL;
-- 
2.17.1
