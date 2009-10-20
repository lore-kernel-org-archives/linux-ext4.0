From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] ext4: Avoid issuing barriers on error recovery path
Date: Tue, 20 Oct 2009 09:24:36 +0200
Message-ID: <1256023478-746-3-git-send-email-jack@suse.cz>
References: <1256023478-746-1-git-send-email-jack@suse.cz>
Cc: tytso@mit.edu, chris.mason@oracle.com, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47522 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021AbZJTH0A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Oct 2009 03:26:00 -0400
In-Reply-To: <1256023478-746-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There is no reason why we should issue IO barriers when we
just hit an error in ext4_sync_file. So move out: label to
just return and introduce flush: label to those places which
really need it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/fsync.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 2b15312..2bf9413 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -88,7 +88,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		ret = sync_mapping_buffers(inode->i_mapping);
 
 	if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
-		goto out;
+		goto flush;
 
 	/*
 	 * The VFS has written the file data.  If the inode is unaltered
@@ -103,8 +103,9 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		if (ret == 0)
 			ret = err;
 	}
-out:
+flush:
 	if (journal && (journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+out:
 	return ret;
 }
-- 
1.6.0.2

