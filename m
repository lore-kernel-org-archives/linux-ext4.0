From: yi zhang <yi.zhang@huawei.com>
Subject: [PATCH] fs: ext3/ext4: increase the protection of nlink dec and inode destroy
Date: Mon, 6 Feb 2017 20:35:13 +0800
Message-ID: <1486384513-34971-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
        <viro@ZenIV.linux.org.uk>, <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: zhangyi <yi.zhang@huawei.com>

Because of the disk and hardware issue, the ext3/4 filesystem have
many errors, the inode->i_nlink of ext3/4 becomes zero abnormally
but the dentry is still positive, it will cause memory corruption
after the following process:

 1) Due to the inode->i_nlink is 0, this inode will be added into
the orhpan list,
 2) ext4_rename() and ext3_rename() cover this inode, and drop_nlink() 
will reverse the inode->i_nlink to 0xFFFFFFFF,
 3) iput() add this inode to LRU,
 4) evict() will call destroy_inode() to destroy this inode but
skip removing it from the orphan list,
 5) after this, the inode's memory address space will be used by
other module, when the ext3/4 filesystem change the orphan list, it will
trample other module's data and then may cause oops.

Although we cannot avoid hardware and disk errors, we can control the
softwore error in the ext3/4 module, do not affect other modules and
increase the difficulty of locating problems.

This patch avoid inode->i_nlink underflow and remove the inode from the
orphan list when destroy it if the list is not empty.

Signed-off-by: zhangyi <yi.zhang@huawei.com>
---
 fs/ext3/namei.c | 6 ++++++
 fs/ext3/super.c | 1 +
 fs/ext4/namei.c | 6 ++++++
 fs/ext4/super.c | 1 +
 4 files changed, 14 insertions(+)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 4264b9b..a2d5b34 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2500,6 +2500,12 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	}
 
 	if (new_inode) {
+		if (!new_inode->i_nlink) {
+			ext3_warning (new_inode->i_sb, "ext3_rename",
+				"Removing nonexistent file (%lu), %d",
+				new_inode->i_ino, new_inode->i_nlink);
+			set_nlink(new_inode, 1);
+		}
 		drop_nlink(new_inode);
 		new_inode->i_ctime = CURRENT_TIME_SEC;
 	}
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index c2870e5..90985f7 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -520,6 +520,7 @@ static void ext3_destroy_inode(struct inode *inode)
 				EXT3_I(inode), sizeof(struct ext3_inode_info),
 				false);
 		dump_stack();
+		ext3_orphan_del(NULL, inode);
 	}
 	call_rcu(&inode->i_rcu, ext3_i_callback);
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 03482c01..9852b24 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3697,6 +3697,12 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (new.inode) {
+		if (new.inode->i_nlink == 0) {
+			ext4_warning(new.inode->i_sb,
+				"Removing nonexistent file (%lu), %d",
+				new.inode->i_ino, new.inode->i_nlink);
+			set_nlink(new.inode, 1);
+		}
 		ext4_dec_count(handle, new.inode);
 		new.inode->i_ctime = ext4_current_time(new.inode);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 700d520..2772a53 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -934,6 +934,7 @@ static void ext4_destroy_inode(struct inode *inode)
 				EXT4_I(inode), sizeof(struct ext4_inode_info),
 				true);
 		dump_stack();
+		ext4_orphan_del(NULL, inode);
 	}
 	call_rcu(&inode->i_rcu, ext4_i_callback);
 }
-- 
2.5.5
