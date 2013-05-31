From: Jan Kara <jack@suse.cz>
Subject: [PATCH 23/26] ext4: Remove i_mutex from ext4_file_sync()
Date: Fri, 31 May 2013 11:42:56 +0200
Message-ID: <1369993379-13017-24-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab3EaJnW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:22 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After removal of ext4_flush_unwritten_io() call, ext4_file_sync()
doesn't need i_mutex anymore. Forcing of transaction commits doesn't
need i_mutex as there's nothing inode specific in that code apart from
grabbing transaction ids from the inode. So remove the lock.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 6019bd4..fc938eb 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -99,20 +99,18 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	trace_ext4_sync_file_enter(file, datasync);
 
 	if (inode->i_sb->s_flags & MS_RDONLY)
-		goto out_trace;
+		goto out;
 
 	if (!journal) {
 		ret = generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
-		goto out_trace;
+		goto out;
 	}
 
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
-	mutex_lock(&inode->i_mutex);
