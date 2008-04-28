From: akpm@linux-foundation.org
Subject: [patch 277/307] ext3: fix update of mtime and ctime on rename
Date: Mon, 28 Apr 2008 02:16:12 -0700
Message-ID: <200804280916.m3S9GCdB019161@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, jack@suse.cz,
	linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762375AbYD1JVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:21:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

Make ext3 update mtime and ctime of the directory into which we move file even
if the directory entry already exists.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/namei.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/ext3/namei.c~ext3-fix-update-of-mtime-and-ctime-on-rename fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-fix-update-of-mtime-and-ctime-on-rename
+++ a/fs/ext3/namei.c
@@ -2323,6 +2323,8 @@ static int ext3_rename (struct inode * o
 					      EXT3_FEATURE_INCOMPAT_FILETYPE))
 			new_de->file_type = old_de->file_type;
 		new_dir->i_version++;
+		new_dir->i_ctime = new_dir->i_mtime = CURRENT_TIME_SEC;
+		ext3_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext3_journal_dirty_metadata");
 		ext3_journal_dirty_metadata(handle, new_bh);
 		brelse(new_bh);
_
