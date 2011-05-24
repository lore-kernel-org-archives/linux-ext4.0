From: Sage Weil <sage@newdream.net>
Subject: [PATCH 13/19] ext4: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Tue, 24 May 2011 13:06:16 -0700
Message-ID: <1306267582-5347-14-git-send-email-sage@newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de,
	Sage Weil <sage@newdream.net>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1306267582-5347-1-git-send-email-sage@newdream.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4 has no problems with lingering references to unlinked directory
inodes.

CC: "Theodore Ts'o" <tytso@mit.edu>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ext4/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 792d06e..67fd0b0 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2123,8 +2123,6 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	struct ext4_dir_entry_2 *de;
 	handle_t *handle;
 
-	dentry_unhash(dentry);
-
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	dquot_initialize(dir);
@@ -2352,9 +2350,6 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ext4_dir_entry_2 *old_de, *new_de;
 	int retval, force_da_alloc = 0;
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
-- 
1.7.0

