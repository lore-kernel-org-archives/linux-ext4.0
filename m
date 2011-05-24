From: Sage Weil <sage@newdream.net>
Subject: [PATCH 15/19] ext2: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Tue, 24 May 2011 13:06:18 -0700
Message-ID: <1306267582-5347-16-git-send-email-sage@newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de,
	Sage Weil <sage@newdream.net>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1306267582-5347-1-git-send-email-sage@newdream.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext2 has no problems with lingering references to unlinked directory
inodes.

CC: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ext2/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 516c31d..ed5c5d4 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -296,8 +296,6 @@ static int ext2_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err = -ENOTEMPTY;
 
-	dentry_unhash(dentry);
-
 	if (ext2_empty_dir(inode)) {
 		err = ext2_unlink(dir, dentry);
 		if (!err) {
@@ -320,9 +318,6 @@ static int ext2_rename (struct inode * old_dir, struct dentry * old_dentry,
 	struct ext2_dir_entry_2 * old_de;
 	int err = -ENOENT;
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
-- 
1.7.0

