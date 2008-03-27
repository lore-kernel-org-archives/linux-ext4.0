From: akpm@linux-foundation.org
Subject: + ext3-fix-update-of-mtime-and-ctime-on-rename.patch added to -mm tree
Date: Thu, 27 Mar 2008 01:28:56 -0700
Message-ID: <200803270828.m2R8Suvs025755@imap1.linux-foundation.org>
Cc: jack@suse.cz, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk
To: mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758681AbYC0I3a (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Mar 2008 04:29:30 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     ext3: fix update of mtime and ctime on rename
has been added to the -mm tree.  Its filename is
     ext3-fix-update-of-mtime-and-ctime-on-rename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-udf.patch
git-ocfs2.patch
vfs-fix-lock-inversion-in-drop_pagecache_sb.patch
vfs-skip-inodes-without-pages-to-free-in-drop_pagecache_sb.patch
quota-do-not-allow-setting-of-quota-limits-to-too-high-values.patch
quota-remove-superfluous-dquot_off-in-fs-namespacec.patch
quota-various-style-cleanups.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-reiserfs-make-reiserfs-handle-quotaon-on-remount.patch
ext3-fdatasync-should-skip-metadata-writeout-when-overwriting.patch
ext3-fix-update-of-mtime-and-ctime-on-rename.patch
quota-le_add_cpu-conversion.patch
ext4-fix-update-of-mtime-and-ctime-on-rename.patch

