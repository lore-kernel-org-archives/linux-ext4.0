From: Jan Kara <jack@suse.cz>
Subject: [PATCH 20/26] ext4: Protect extent conversion after DIO with i_dio_count
Date: Fri, 31 May 2013 11:42:53 +0200
Message-ID: <1369993379-13017-21-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3EaJnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:17 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure extent conversion after DIO happens while i_dio_count is still
elevated so that inode_dio_wait() waits until extent conversion is done.
This removes the need for explicit waiting for extent conversion in some
cases.

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1f9a8f9..4273b4d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3028,11 +3028,18 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 
 	BUG_ON(iocb->private == NULL);
 
+	/*
+	 * Make all waiters for direct IO properly wait also for extent
+	 * conversion. This also disallows race between truncate() and
+	 * overwrite DIO as i_dio_count needs to be incremented under i_mutex.
+	 */
+	if (rw == WRITE)
+		atomic_inc(&inode->i_dio_count);
+
 	/* If we do a overwrite dio, i_mutex locking can be released */
 	overwrite = *((int *)iocb->private);
 
 	if (overwrite) {
-		atomic_inc(&inode->i_dio_count);
 		down_read(&EXT4_I(inode)->i_data_sem);
 		mutex_unlock(&inode->i_mutex);
 	}
@@ -3135,9 +3142,10 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retake_lock:
+	if (rw == WRITE)
+		inode_dio_done(inode);
 	/* take i_mutex locking again if we do a ovewrite dio */
 	if (overwrite) {
-		inode_dio_done(inode);
 		up_read(&EXT4_I(inode)->i_data_sem);
 		mutex_lock(&inode->i_mutex);
 	}
-- 
1.8.1.4

