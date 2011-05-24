From: Sage Weil <sage@newdream.net>
Subject: [PATCH 14/19] ext3: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Tue, 24 May 2011 13:06:17 -0700
Message-ID: <1306267582-5347-15-git-send-email-sage@newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de,
	Sage Weil <sage@newdream.net>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1306267582-5347-1-git-send-email-sage@newdream.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext3 has no problems with lingering references to unlinked directory
inodes.

CC: Jan Kara <jack@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: linux-ext4@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ext3/namei.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index f89b1d4..32f3b86 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2074,8 +2074,6 @@ static int ext3_rmdir (struct inode * dir, struct dentry *dentry)
 	struct ext3_dir_entry_2 * de;
 	handle_t *handle;
 
-	dentry_unhash(dentry);
-
 	/* Initialize quotas before so that eventual writes go in
 	 * separate transaction */
 	dquot_initialize(dir);
@@ -2298,9 +2296,6 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 	struct ext3_dir_entry_2 * old_de, * new_de;
 	int retval, flush_file = 0;
 
-	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
-		dentry_unhash(new_dentry);
-
 	dquot_initialize(old_dir);
 	dquot_initialize(new_dir);
 
-- 
1.7.0

