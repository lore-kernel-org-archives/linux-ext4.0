From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] ext4: use dget_parent() in ext4_file_open()
Date: Sat, 26 Mar 2016 17:09:58 -0400
Message-ID: <1459026600-9232-4-git-send-email-tytso@mit.edu>
References: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
	Linux Filesystem Development List
	<linux-fsdevel@vger.kernel.org>, jaegeuk@kernel.org,
	Miklos Szeredi <mszeredi@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>, <stable@vger.kernel.org>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1459026600-9232-1-git-send-email-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

In f_op->open() lock on parent is not held, so there's no guarantee that
parent dentry won't go away at any time.

Even after this patch there's no guarantee that 'dir' will stay the parent
of 'inode', but at least it won't be freed while being used.

Fixes: ff978b09f973 ("ext4 crypto: move context consistency check to ext4_file_open()")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: <stable@vger.kernel.org> # v4.5
---
 fs/ext4/file.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6659e21..257118d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -329,7 +329,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	struct super_block *sb = inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	struct vfsmount *mnt = filp->f_path.mnt;
-	struct inode *dir = filp->f_path.dentry->d_parent->d_inode;
+	struct dentry *dir;
 	struct path path;
 	char buf[64], *cp;
 	int ret;
@@ -373,14 +373,18 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 		if (ext4_encryption_info(inode) == NULL)
 			return -ENOKEY;
 	}
-	if (ext4_encrypted_inode(dir) &&
-	    !ext4_is_child_context_consistent_with_parent(dir, inode)) {
+
+	dir = dget_parent(filp->f_path.dentry);
+	if (ext4_encrypted_inode(d_inode(dir)) &&
+	    !ext4_is_child_context_consistent_with_parent(d_inode(dir), inode)) {
 		ext4_warning(inode->i_sb,
 			     "Inconsistent encryption contexts: %lu/%lu\n",
-			     (unsigned long) dir->i_ino,
+			     (unsigned long) d_inode(dir)->i_ino,
 			     (unsigned long) inode->i_ino);
+		dput(dir);
 		return -EPERM;
 	}
+	dput(dir);
 	/*
 	 * Set up the jbd2_inode if we are opening the inode for
 	 * writing and the journal is present
-- 
2.5.0
