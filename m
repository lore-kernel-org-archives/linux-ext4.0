From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: [PATCH] ext4: avoid deadlock on sync-mounted ext2 FS
Date: Mon, 30 Jan 2012 17:34:52 +0100
Message-ID: <1327941292-3907-1-git-send-email-martin.wilck@ts.fujitsu.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, fmayhar@google.com,
	esandeen@redhat.com, Martin Wilck <martin.wilck@ts.fujitsu.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:14623 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab2A3QqD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jan 2012 11:46:03 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Processes hang forever on a sync-mounted ext2 file system that
is mounted with the ext4 module (default in Fedora 16).

I can reproduce this reliably by mounting an ext2 partition with
"-o sync" and opening a new file an that partition with vim. vim
will hang in "D" state forever.

I am attaching a small patch here that solves this issue for me.
In the sync mounted case, ext4_handle_dirty_metadata() may call
sync_dirty_buffer(), which can't be called with buffer lock held.

My knowledge of locking in ext4 is insufficient to judge if this
patch is correct, but it may serve as starting point for others.

Signed-off-by: Martin.Wilck@ts.fujitsu.com
---
 fs/ext4/xattr.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 93a00d8..eb771ea 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -487,8 +487,10 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		ext4_free_blocks(handle, inode, bh, 0, 1,
 				 EXT4_FREE_BLOCKS_METADATA |
 				 EXT4_FREE_BLOCKS_FORGET);
+		unlock_buffer(bh);
 	} else {
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
+		unlock_buffer(bh);
 		error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
@@ -498,7 +500,6 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 		if (ce)
 			mb_cache_entry_release(ce);
 	}
-	unlock_buffer(bh);
 out:
 	ext4_std_error(inode->i_sb, error);
 	return;
-- 
1.7.7.5

