From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] ext4: fix bh leak on error paths in ext4_rename() and
 ext4_cross_rename()
Date: Tue, 03 Mar 2015 14:17:19 +0300
Message-ID: <20150303111719.26916.92177.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Release references to buffer-heads if ext4_journal_start() fails.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Fixes: 5b61de757535 ("ext4: start handle at least possible moment when renaming files")
---
 fs/ext4/namei.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 28fe71a2904c..8110dd20ad3f 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3264,12 +3264,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		   EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2);
 	if (!(flags & RENAME_WHITEOUT)) {
 		handle = ext4_journal_start(old.dir, EXT4_HT_DIR, credits);
-		if (IS_ERR(handle))
-			return PTR_ERR(handle);
+		if (IS_ERR(handle)) {
+			retval = PTR_ERR(handle);
+			handle = NULL;
+			goto end_rename;
+		}
 	} else {
 		whiteout = ext4_whiteout_for_rename(&old, credits, &handle);
-		if (IS_ERR(whiteout))
-			return PTR_ERR(whiteout);
+		if (IS_ERR(whiteout)) {
+			retval = PTR_ERR(whiteout);
+			whiteout = NULL;
+			goto end_rename;
+		}
 	}
 
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
@@ -3433,8 +3439,11 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	handle = ext4_journal_start(old.dir, EXT4_HT_DIR,
 		(2 * EXT4_DATA_TRANS_BLOCKS(old.dir->i_sb) +
 		 2 * EXT4_INDEX_EXTRA_TRANS_BLOCKS + 2));
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		handle = NULL;
+		goto end_rename;
+	}
 
 	if (IS_DIRSYNC(old.dir) || IS_DIRSYNC(new.dir))
 		ext4_handle_sync(handle);
