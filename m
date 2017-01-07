From: yi zhang <yi.zhang@huawei.com>
Subject: [PATCH v3] ext4: increase the protection of nlink dec and ext4 inode destroy
Date: Sat, 7 Jan 2017 11:22:38 +0800
Message-ID: <1483759358-7188-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <yi.zhang@huawei.com>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Because of the disk and hardware issue, the ext4 filesystem have
many errors, the inode->i_nlink of ext4 becomes zero abnormally
but the dentry is still positive, it will cause memory corruption
after the following process:

 1) Due to the inode->i_nlink is 0, this inode will be added into
the orhpan list,
 2) ext4_rename() cover this inode, and drop_nlink() will reverse
the inode->i_nlink to 0xFFFFFFFF,
 3) iput() add this inode to LRU,
 4) evict() will call destroy_inode() to destroy this inode but
skip removing it from the orphan list,
 5) after this, the inode's memory address space will be used by
other module, when the ext4 filesystem change the orphan list, it will
trample other module's data and then may cause oops.

Although we cannot avoid hardware and disk errors, we can control the
softwore error in the ext4 module, do not affect other modules and
increase the difficulty of locating problems.

This patch avoid inode->i_nlink reverse and remove the inode from the
orphan list when destroy it if the list is not empty.

changes since: RFC Patch v2
 - move the protection from drop_nlink() to ext4_rename()

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/ext4/namei.c | 7 +++++++
 fs/ext4/super.c | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba91..e0718cd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3662,6 +3662,13 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (new.inode) {
+		if (new.inode->i_nlink == 0) {
+			ext4_warning_inode(new.inode,
+					   "Removing file '%.*s' with no links",
+					   new.dentry->d_name.len,
+					   new.dentry->d_name.name);
+			set_nlink(new.inode, 1);
+		}
 		ext4_dec_count(handle, new.inode);
 		new.inode->i_ctime = current_time(new.inode);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 66845a0..ad5ad42 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -975,6 +975,7 @@ static void ext4_destroy_inode(struct inode *inode)
 				EXT4_I(inode), sizeof(struct ext4_inode_info),
 				true);
 		dump_stack();
+		ext4_orphan_del(NULL, inode);
 	}
 	call_rcu(&inode->i_rcu, ext4_i_callback);
 }
-- 
2.5.0

