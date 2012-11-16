From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH RFC] ext4: remove calls to ext4_jbd2_file_inode() from delalloc write path
Date: Fri, 16 Nov 2012 12:49:13 -0500
Message-ID: <1353088153-16249-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33218 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab2KPRtU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Nov 2012 12:49:20 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The calls to ext4_jbd2_file_inode() are needed to guarantee that we do
not expose stale data in the data=ordered mode.  However, they are not
necessary because in all of the cases where we have newly allocated
blocks in the delayed allocation write path, we immediately submit the
dirty pages for I/O.  Hence, we can avoid the overhead of adding the
inode to the list of inodes whose data pages will be to be flushed out
to disk completely during the next commit operation.

This will reduce the pressure on the j_list_lock and improve CPU
utilizations and reduce the number of page-level locks needed by the
jbd2 thread while doing a commit.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 52f7ff2..cf5d30a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1636,15 +1636,6 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 
 		for (i = 0; i < map.m_len; i++)
 			unmap_underlying_metadata(bdev, map.m_pblk + i);
-
-		if (ext4_should_order_data(mpd->inode)) {
-			err = ext4_jbd2_file_inode(handle, mpd->inode);
-			if (err) {
-				/* Only if the journal is aborted */
-				mpd->retval = err;
-				goto submit_io;
-			}
-		}
 	}
 
 	/*
@@ -2592,17 +2583,8 @@ static int ext4_da_write_end(struct file *file,
 	if (copied && new_i_size > EXT4_I(inode)->i_disksize) {
 		if (ext4_da_should_update_i_disksize(page, end)) {
 			down_write(&EXT4_I(inode)->i_data_sem);
-			if (new_i_size > EXT4_I(inode)->i_disksize) {
-				/*
-				 * Updating i_disksize when extending file
-				 * without needing block allocation
-				 */
-				if (ext4_should_order_data(inode))
-					ret = ext4_jbd2_file_inode(handle,
-								   inode);
