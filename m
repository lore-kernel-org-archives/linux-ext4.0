From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: sync the directory inode in ext4_sync_parent()
Date: Tue,  5 Apr 2011 12:27:43 -0700
Message-ID: <1302031663-13547-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:55144 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1DET1v (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 15:27:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4 has taken the stance that, in the absence of a journal,
when an fsync/fdatasync of an inode is done, the parent
directory should be sync'ed if this inode entry is new.
ext4_sync_parent(), which implements this, does indeed sync
the dirent pages for parent directories, but it does not
sync the directory *inode*.  This patch fixes this.

I tested this using a power fail test, which panics a
machine running a file server getting requests from a
client.  Without this patch, on about every other test run,
the server is missing many, many files that had been synced.
With this patch, on > 6 runs, I see zero files being lost.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/fsync.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 7f74019..a276348 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -128,6 +128,7 @@ extern int ext4_flush_completed_IO(struct inode *inode)
 static void ext4_sync_parent(struct inode *inode)
 {
 	struct dentry *dentry = NULL;
+	int ret;
 
 	while (inode && ext4_test_inode_state(inode, EXT4_STATE_NEWENTRY)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_NEWENTRY);
@@ -136,7 +137,15 @@ static void ext4_sync_parent(struct inode *inode)
 		if (!dentry || !dentry->d_parent || !dentry->d_parent->d_inode)
 			break;
 		inode = dentry->d_parent->d_inode;
-		sync_mapping_buffers(inode->i_mapping);
+		ret = sync_mapping_buffers(inode->i_mapping);
+		if (! ret) {
+			struct writeback_control wbc = {
+				.sync_mode = WB_SYNC_ALL,
+				.nr_to_write = 0, /* metadata-only; caller
+						     takes care of data */
+			};
+			(void)sync_inode(inode, &wbc);
+		}
 	}
 }
 
-- 
1.7.3.1

