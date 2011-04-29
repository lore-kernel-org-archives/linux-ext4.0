From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] ext4: Fix fs corruption when make_indexed_dir() fails
Date: Fri, 29 Apr 2011 23:23:32 +0200
Message-ID: <1304112212-23417-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1D2VXl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Apr 2011 17:23:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has allocated
block for index tree root, we did not properly mark all changed buffers dirty.
This lead to only some of these buffers being written out and thus effectively
corrupting the directory.

Fix the issue by marking all changed data dirty even in the error failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/namei.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 67fd0b0..cadf04b 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1414,9 +1414,19 @@ static int make_indexed_dir(handle_t *handle, struct dentry *dentry,
 	frame->bh = bh;
 	bh = bh2;
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		/*
+		 * Even if the block split failed, we have to properly write
+		 * out all the changes we did so far. Otherwise we can end up
+		 * with corrupted filesystem.
+		 */
+		ext4_mark_inode_dirty(handle, dir);
+		ext4_handle_dirty_metadata(handle, dir, frame->bh);
+		ext4_handle_dirty_metadata(handle, dir, bh);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	retval = add_dirent_to_buf(handle, dentry, inode, de, bh);
 	brelse(bh);
-- 
1.7.1

