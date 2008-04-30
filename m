From: akpm@linux-foundation.org
Subject: - ext4-fix-update-of-mtime-and-ctime-on-rename.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:52:19 -0700
Message-ID: <200804300552.m3U5qJ4W030309@imap1.linux-foundation.org>
To: jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756315AbYD3GBc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Apr 2008 02:01:32 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext4: fix update of mtime and ctime on rename
has been removed from the -mm tree.  Its filename was
     ext4-fix-update-of-mtime-and-ctime-on-rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext4: fix update of mtime and ctime on rename
From: Jan Kara <jack@suse.cz>

Make ext4 update mtime and ctime of the directory into which we move file even
if the directory entry already exists.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/namei.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/ext4/namei.c~ext4-fix-update-of-mtime-and-ctime-on-rename fs/ext4/namei.c
--- a/fs/ext4/namei.c~ext4-fix-update-of-mtime-and-ctime-on-rename
+++ a/fs/ext4/namei.c
@@ -2354,6 +2354,9 @@ static int ext4_rename (struct inode * o
 					      EXT4_FEATURE_INCOMPAT_FILETYPE))
 			new_de->file_type = old_de->file_type;
 		new_dir->i_version++;
+		new_dir->i_ctime = new_dir->i_mtime =
+					ext4_current_time(new_dir);
+		ext4_mark_inode_dirty(handle, new_dir);
 		BUFFER_TRACE(new_bh, "call ext4_journal_dirty_metadata");
 		ext4_journal_dirty_metadata(handle, new_bh);
 		brelse(new_bh);
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
isofs-fix-access-to-unallocated-memory-when-reading-corrupted-filesystem.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch

