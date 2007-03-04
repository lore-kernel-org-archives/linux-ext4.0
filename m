From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: [PATCH] ext3: dirindex error pointer issues
Date: Sun, 04 Mar 2007 17:18:15 +0300
Message-ID: <87lkidf5y0.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:15648 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694AbXCDORy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 4 Mar 2007 09:17:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 - ext3_dx_find_entry() exit with out setting proper error pointer
 - do_split() exit with out setting proper error pointer
   it is realy painful because many callers contain folowing code:
           de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
           if (!(de))
                        return retval;
           <<< WOW retval wasn't changed by do_split(), so caller failed
           <<< but return SUCCESS :)
 - Rearrange do_split() error path. Current error path is realy ugly, all
   this up and down jump stuff doesn't make code easy to understand.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
---
 fs/ext3/namei.c |   26 +++++++++++++++-----------
 fs/ext4/namei.c |   26 +++++++++++++++-----------
 2 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 49159f1..1a52586 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -969,6 +969,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
 				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
 					  +((char *)de - bh->b_data))) {
 				brelse (bh);
+				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
 			*res_dir = de;
@@ -1134,9 +1135,9 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	char *data1 = (*bh)->b_data, *data2;
 	unsigned split;
 	struct ext3_dir_entry_2 *de = NULL, *de2;
-	int	err;
+	int	err = 0;
 
-	bh2 = ext3_append (handle, dir, &newblock, error);
+	bh2 = ext3_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1145,14 +1146,9 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, *bh);
-	if (err) {
-	journal_error:
-		brelse(*bh);
-		brelse(bh2);
-		*bh = NULL;
-		ext3_std_error(dir->i_sb, err);
-		goto errout;
-	}
+	if (err)
+		goto journal_error;
+
 	BUFFER_TRACE(frame->bh, "get_write_access");
 	err = ext3_journal_get_write_access(handle, frame->bh);
 	if (err)
@@ -1195,8 +1191,16 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		goto journal_error;
 	brelse (bh2);
 	dxtrace(dx_show_index ("frame", frame->entries));
-errout:
 	return de;
+
+journal_error:
+	brelse(*bh);
+	brelse(bh2);
+	*bh = NULL;
+errout:
+	ext3_std_error(dir->i_sb, err);
+	*error = err;
+	return NULL;
 }
 #endif
 
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index e7e1d79..682a3d7 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -967,6 +967,7 @@ static struct buffer_head * ext4_dx_find_entry(struct dentry *dentry,
 				  (block<<EXT4_BLOCK_SIZE_BITS(sb))
 					  +((char *)de - bh->b_data))) {
 				brelse (bh);
+				*err = ERR_BAD_DX_DIR;
 				goto errout;
 			}
 			*res_dir = de;
@@ -1132,9 +1133,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 	char *data1 = (*bh)->b_data, *data2;
 	unsigned split;
 	struct ext4_dir_entry_2 *de = NULL, *de2;
-	int	err;
+	int	err = 0;
 
-	bh2 = ext4_append (handle, dir, &newblock, error);
+	bh2 = ext4_append (handle, dir, &newblock, &err);
 	if (!(bh2)) {
 		brelse(*bh);
 		*bh = NULL;
@@ -1143,14 +1144,9 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 
 	BUFFER_TRACE(*bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, *bh);
-	if (err) {
-	journal_error:
-		brelse(*bh);
-		brelse(bh2);
-		*bh = NULL;
-		ext4_std_error(dir->i_sb, err);
-		goto errout;
-	}
+	if (err)
+		goto journal_error;
+
 	BUFFER_TRACE(frame->bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, frame->bh);
 	if (err)
@@ -1193,8 +1189,16 @@ static struct ext4_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
 		goto journal_error;
 	brelse (bh2);
 	dxtrace(dx_show_index ("frame", frame->entries));
-errout:
 	return de;
+
+journal_error:
+	brelse(*bh);
+	brelse(bh2);
+	*bh = NULL;
+errout:
+	ext4_std_error(dir->i_sb, err);
+	*error = err;
+	return NULL;
 }
 #endif
 
-- 
1.5.0.1
