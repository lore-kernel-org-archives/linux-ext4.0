From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: avoid trying to kfree an ERR_PTR pointer
Date: Wed,  3 Sep 2014 09:38:12 -0400
Message-ID: <1409751492-18095-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>, stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks to Dan Carpenter for extending smatch to find bugs like this.
(This was found using a development version of smatch.)

Fixes: 36de928641ee48b2078d3fe9514242aaa2f92013
Reported-by: Dan Carpenter <dan.carpenter@oracle.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/namei.c  | 2 ++
 fs/ext4/resize.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 90a3cdc..603e4eb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3240,6 +3240,7 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
+		new.bh = NULL;
 		goto end_rename;
 	}
 	if (new.bh) {
@@ -3386,6 +3387,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 				 &new.de, &new.inlined);
 	if (IS_ERR(new.bh)) {
 		retval = PTR_ERR(new.bh);
+		new.bh = NULL;
 		goto end_rename;
 	}
 
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index bb0e80f..1e43b90 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -575,6 +575,7 @@ handle_bb:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 		overhead = ext4_group_overhead_blocks(sb, group);
@@ -603,6 +604,7 @@ handle_ib:
 		bh = bclean(handle, sb, block);
 		if (IS_ERR(bh)) {
 			err = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 
-- 
2.1.0
