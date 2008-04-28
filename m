From: akpm@linux-foundation.org
Subject: - ext3-fix-update-of-mtime-and-ctime-on-rename.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:00:51 -0700
Message-ID: <200804282200.m3SM0pZV018779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
To: jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk,
	mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     ext3: fix update of mtime and ctime on rename
has been removed from the -mm tree.  Its filename was
     ext3-fix-update-of-mtime-and-ctime-on-rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: fix update of mtime and ctime on rename
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

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch
ext4-fix-hang-on-umount-with-quotas-when-journal-is-aborted.patch
ext4-fix-mount-messages-when-quota-disabled.patch
quota-le_add_cpu-conversion.patch
isofs-use-get-put_unaligned_-helpers.patch

