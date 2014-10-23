From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Bail out from make_indexed_dir() on first error
Date: Thu, 23 Oct 2014 17:18:53 +0200
Message-ID: <1414077533-2133-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaJWPS5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 11:18:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When ext4_handle_dirty_dx_node() or ext4_handle_dirty_dirent_node()
fail, there's really something wrong with the fs and there's no point in
continuing further. Just return error from make_indexed_dir() in that
case. Also initialize frames array so that if we return early due to
error, dx_release() doesn't try to dereference uninitialized memory
(which could happen also due to error in do_split()).

Coverity-id: 741300
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index adb559de23c1..cec7257aa74a 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1816,31 +1816,39 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 		hinfo.hash_version += EXT4_SB(dir->i_sb)->s_hash_unsigned;
 	hinfo.seed = EXT4_SB(dir->i_sb)->s_hash_seed;
 	ext4fs_dirhash(name, namelen, &hinfo);
+	memset(frames, 0, sizeof(frames));
 	frame = frames;
 	frame->entries = entries;
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
 
-	ext4_handle_dirty_dx_node(handle, dir, frame->bh);
-	ext4_handle_dirty_dirent_node(handle, dir, bh);
+	retval = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
+	if (retval)
+		goto out_frames;	
+	retval = ext4_handle_dirty_dirent_node(handle, dir, bh);
+	if (retval)
+		goto out_frames;	
 
 	de = do_split(handle,dir, &bh, frame, &hinfo);
 	if (IS_ERR(de)) {
-		/*
-		 * Even if the block split failed, we have to properly write
-		 * out all the changes we did so far. Otherwise we can end up
-		 * with corrupted filesystem.
-		 */
-		ext4_mark_inode_dirty(handle, dir);
-		dx_release(frames);
-		return PTR_ERR(de);
+		retval = PTR_ERR(de);
+		goto out_frames;
 	}
 	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
 	return retval;
+out_frames:
+	/*
+	 * Even if the block split failed, we have to properly write
+	 * out all the changes we did so far. Otherwise we can end up
+	 * with corrupted filesystem.
+	 */
+	ext4_mark_inode_dirty(handle, dir);
+	dx_release(frames);
+	return retval;
 }
 
 /*
-- 
1.8.1.4

