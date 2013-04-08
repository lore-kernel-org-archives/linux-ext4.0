From: Jan Kara <jack@suse.cz>
Subject: [PATCH 26/29] ext4: Remove i_mutex from ext4_file_sync()
Date: Mon,  8 Apr 2013 23:32:31 +0200
Message-ID: <1365456754-29373-27-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936370Ab3DHVdI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:08 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After removal of ext4_flush_unwritten_io() call, ext4_file_sync()
doesn't need i_mutex anymore. Forcing of transaction commits doesn't
need i_mutex as there's nothing inode specific in that code apart from
grabbing transaction ids from the inode. So remove the lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 1c08780..9040faa 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -99,7 +99,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trace_ext4_sync_file_enter(file, datasync);
 
 	if (inode->i_sb->s_flags & MS_RDONLY)
-		goto out_trace;
+		goto out;
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
@@ -111,8 +111,6 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
-	mutex_lock(&inode->i_mutex);
